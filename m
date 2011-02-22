From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
	problem
Date: Tue, 22 Feb 2011 11:45:38 -0800
Message-ID: <20110222194538.GU27190@tux1.beaverton.ibm.com>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2011 at 09:13:49AM -0700, Andreas Dilger wrote:
> On 2011-02-21, at 19:00, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
> > write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
> > discussion about how to deal with the situation where one program tells the
> > kernel to write a block to disk, the kernel computes the checksum of that data,
> > and then a second program begins writing to that same block before the disk HBA
> > can DMA the memory block, thereby causing the disk to complain about being sent
> > invalid checksums.
> > 
> > I was able to write a
> > trivial program to trigger the write problem, I'm pretty sure that this has not
> > been fixed upstream.  (FYI, using O_DIRECT still seems fine.)
> 
> Can you please attach your reproducer? IIRC it needed mmap() to hit this
> problem?  Did you measure CPU usage during your testing?

I didn't need mmap; a lot of threads using write() was enough.  (The reproducer
program does have a mmap mode though).  Basically it creates a lot of threads
to write small blobs to random offsets in a file, with optional mmap, dio, and
sync options.

CPU usage was 100% the entire time since there were 64 threads running on 4
CPUs. With just write() mode about half that was userspace and the other half
was kernel.  With write and mmap the balance became closer to 80/20.

The program is attached below.  It can be built with a simple "cc -o wac wac.c".

The invocation that I was using to produce the errors was:

./wac -l65536 -n64 -r /mnt/junk

This creates a file that is 64K (16 pages) long and starts 64 threads that will
write() a small buffer and then call sync_file_range to force IO to happen.
With that I get a steady stream of DIF checksum errors on the console.  If -r
is omitted they happen about once every commit= seconds.

> > Below is a simple if naive solution: (ab)use the bounce buffering code to copy
> > the memory page just prior to calculating the checksum, and send the copy and
> > the checksum to the disk controller.  With this patch applied, the invalid
> > guard tag messages go away.  An optimization would be to perform the copy only
> > when memory contents change, but I wanted to ask peoples' opinions before
> > continuing.  I don't imagine bounce buffering is particularly speedy, though I
> > haven't noticed any corruption errors or weirdness yet.
> 
> I don't like adding a data copy in the IO path at all. We are just looking to
> enable T10 DIF for Lustre and this would definitely hurt performance
> significantly, even though it isn't needed there at all (since the server
> side has proper locking of the pages to prevent multiple writers to the same
> page).
> 
> > Anyway, I'm mostly wondering: what do people think of this as a starting point
> > to fixing the DIF checksum problem?
> 
> I'd definitely prefer that the filesystem be in charge of deciding whether
> this is needed or not. If the use of the data copy can be constrained to only
> the minimum required cases (e.g. if fs checks for rewrite on page that is
> marked as Writeback and either copies or blocks until writeback is complete,
> as a mount option) that would be better. At that point we can compare on
> different hardware whether copying or blocking should be the default. 

Agreed.  I too am curious to study which circumstances favor copying vs
blocking.

> Cheers, Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

/*
 * Write-After-Checksum reproducer(?) program
 * Copyright (C) 2011 IBM.  All rights reserved.
 * This program is licensed under the GPLv2.
 */
#define _XOPEN_SOURCE 600
#define _FILE_OFFSET_BITS 64
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <string.h>
#define __USE_GNU
#include <fcntl.h>
#include <errno.h>
#include <inttypes.h>

#define SYNC_RANGE	1
#define SYNC_FILE	2

#define DEFAULT_BUFSIZE	4096
static uint32_t bufsize = DEFAULT_BUFSIZE;

void help(const char *pname)
{
	printf("Usage: %s [-n threads] [-m threads] [-d] [-b blocksize] [-r] [-f] -l filesize filename\n", pname);
	printf("-b	Size of a memory page.\n");
	printf("-d	Use direct I/O.\n");
	printf("-l	Desired file size.\n");
	printf("-n	Use this many write() threads.\n");
	printf("-m	Use this many mmap write threads.\n");
	printf("-s	Synchronous disk writes.\n");
	printf("-r	Use sync_file_range after write.\n");
	printf("-f	fsync after write.\n");
}

int seed_random(void) {
	int fp;
	long seed;

	fp = open("/dev/urandom", O_RDONLY);
	if (fp < 0) {
		perror("/dev/urandom");
		return 0;
	}

	if (read(fp, &seed, sizeof(seed)) != sizeof(seed)) {
		perror("read random seed");
		return 0;
	}

	close(fp);
	srand(seed);

	return 1;
}

uint64_t get_randnum(uint64_t min, uint64_t max) {
	return (min + (uint64_t)((double)(max - min) * (rand() / (RAND_MAX + 1.0))));
}

static uint64_t get_randnum_align(uint64_t min, uint64_t max, uint64_t align) {
	return (min + (uint64_t)((double)(max - min) * (rand() / (RAND_MAX + 1.0)))) &
		~(align - 1);
}

int write_junk(const char *fname, int flags, int sync_options, uint64_t file_size)
{
	int fd, len;
	uint64_t offset, generation = 0;
	char *buf;

	len = posix_memalign((void **)&buf, bufsize, bufsize);
	if (len) {
		errno = len;
		perror("alloc");
		return 66;
	}

	fd = open(fname, flags | O_WRONLY);
	if (fd < 1) {
		perror(fname);
		return 64;
	}

	while (1) {
		len = snprintf(buf, bufsize - 1, "%d - %"PRIu64, getpid(), generation++);
		if (flags & O_DIRECT) {
			len = bufsize;
			offset = get_randnum_align(0, file_size - len, bufsize);
		} else {
			offset = get_randnum(0, file_size - len);
		}

		if (pwrite(fd, buf, len, offset) < 0) {
			perror("pwrite");
			close(fd);
			free(buf);
			return 65;
		}
		if ((sync_options & SYNC_RANGE) && sync_file_range(fd, offset, len, SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER) < 0) {
			perror("sync_file_range");
			close(fd);
			free(buf);
			return 67;
		}
		if ((sync_options & SYNC_FILE) && fsync(fd)) {
			perror("fsync");
			close(fd);
			free(buf);
			return 68;
		}
	}

	return 0;
}

int mmap_junk(const char *fname, int flags, int sync_options, uint64_t file_size)
{
	int fd, len;
	uint64_t offset, generation = 0;
	char *buf, *map;
	long page_size;

	page_size = sysconf(_SC_PAGESIZE);
	if (page_size < 0) {
		perror("_SC_PAGESIZE");
		return 101;
	}

	fd = open(fname, flags | O_RDWR);
	if (fd < 1) {
		perror(fname);
		return 96;
	}

	len = posix_memalign((void **)&buf, bufsize, bufsize);
	if (len) {
		errno = len;
		perror("alloc");
		return 102;
	}

	map = mmap(NULL, file_size, PROT_WRITE, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED) {
		perror(fname);
		return 97;
	}

	while (1) {
		len = snprintf(buf, bufsize - 1, "%d - %"PRIu64, getpid(), generation++);
		if (flags & O_DIRECT) {
			len = bufsize;
			offset = get_randnum_align(0, file_size - len, bufsize);
		} else {
			offset = get_randnum(0, file_size - len);
		}

		memcpy(map + offset, buf, len);
		len += offset & (page_size - 1);
		offset &= ~(page_size - 1);
		if ((sync_options & SYNC_RANGE) && msync(map + offset, len, MS_SYNC | MS_INVALIDATE)) {
			perror("msync");
			munmap(map, file_size);
			close(fd);
			free(buf);
			return 99;
		}
		if ((sync_options & SYNC_FILE) && fsync(fd)) {
			perror("fsync");
			munmap(map, file_size);
			close(fd);
			free(buf);
			return 100;
		}
	}

	return 0;
}

int main(int argc, char *argv[])
{
	int opt, fd;
	unsigned long i, mthreads = 0, nthreads = 1;
	char *fname = NULL;
	int flags = 0, sync_options = 0;
	uint64_t file_size = 0;
	pid_t pid;
	int status;

	while ((opt = getopt(argc, argv, "b:dn:l:srfm:")) != -1) {
		switch (opt) {
		case 'd':
			flags |= O_DIRECT;
			break;
		case 'n':
			nthreads = strtoul(optarg, NULL, 0);
			break;
		case 'm':
			mthreads = strtoul(optarg, NULL, 0);
			break;
		case 'l':
			file_size = strtoull(optarg, NULL, 0);
			break;
		case 's':
			flags |= O_SYNC;
			break;
		case 'b':
			bufsize = strtoul(optarg, NULL, 0);
			break;
		case 'r':
			sync_options |= SYNC_RANGE;
			break;
		case 'f':
			sync_options |= SYNC_FILE;
			break;
		default:
			help(argv[0]);
			return 4;
		}
	}

	if (optind != argc - 1 || file_size < 1) {
		help(argv[0]);
		return 1;
	}

	fname = argv[optind];

	if (!seed_random())
		return 2;

	// truncate first
	fd = open(fname, flags | O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
	if (fd < 0) {
		perror(fname);
		return 3;
	}
	close(fd);

	// spawn threads and go to town
	if (nthreads == 1)
		return write_junk(fname, flags, sync_options, file_size);

	for (i = 0; i < nthreads; i++) {
		pid = fork();
		if (!pid)
			return write_junk(fname, flags, sync_options, file_size);
	}

	for (i = 0; i < mthreads; i++) {
		pid = fork();
		if (!pid)
			return mmap_junk(fname, flags, sync_options, file_size);
	}

	for (i = 0; i < mthreads + nthreads; i++) {
		pid = wait(&status);
		if (WIFEXITED(status))
			printf("Child %d exited with status %d\n", pid, WEXITSTATUS(status));
	}

	return 0;
}
