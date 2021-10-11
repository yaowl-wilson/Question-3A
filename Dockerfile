#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS base
WORKDIR /app
EXPOSE 8000
ENV ASPNETCORE_URLS=http://+:8000
ENV ASPNETCORE_ENVIRONMENT=Development

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build
WORKDIR /src
COPY ["MessagingConsumerAPI.csproj", ""]
RUN dotnet restore "./MessagingConsumerAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MessagingConsumerAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MessagingConsumerAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MessagingConsumerAPI.dll"]