.PHONY: default deps clean format build  validate test coverage

export GO111MODULE=on

default: build

deps:
	go mod tidy
	go mod download

clean:
	go clean -i
	rm -f coverage.out

format:
	goimports -l -w -local github.com/ybt195/defaults ./

build: deps format
	go build ./...

validate: build
	go mod verify
	golangci-lint run

test: validate
	go test -race -v ./...

coverage: build
	go test -v -coverprofile=coverage.out -covermode count -cover ./...
	go tool cover -html=coverage.out
	rm coverage.out
