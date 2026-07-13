#!/usr/bin/env bash

set -euo pipefail

REPO="https://github.com/xkostix/docker-practice.git"
DIR="/opt/docker-practice"

echo "=== Проверка зависимостей ==="

command -v git >/dev/null || {
    echo "Ошибка: git не установлен."
    exit 1
}

command -v docker >/dev/null || {
    echo "Ошибка: docker не установлен."
    exit 1
}

if ! docker compose version >/dev/null 2>&1; then
    echo "Ошибка: Docker Compose не найден."
    exit 1
fi

echo "=== Получение проекта ==="

if [[ -d "$DIR/.git" ]]; then
    echo "Репозиторий уже существует. Обновляю..."
    git -C "$DIR" pull
else
    echo "Клонирую репозиторий..."
    git clone "$REPO" "$DIR"
fi

cd "$DIR"

echo "=== Запуск проекта ==="

docker compose pull
docker compose up -d --build

echo
echo "=== Контейнеры ==="
docker compose ps

echo
echo "Проект успешно запущен."
