Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788408;
	b=uXuAf1igP9E97BKiy3RigZXo7RWPZCt8jSiJDiE+V+HIVFjnKVLY1ZF6wrIrk7+Ysyh0
	 igMgo9GGc6yfyOh9OMmhsIlffyAKQGhK1J01DpEdA1hTvhrxs1j/UKsWMAfV+txse2vdQ
	 /TGHAcLjMihRiEG6BFehTMIN1SiQyat+439RInr070/IdqEjoIJII5HRqtZpUxCUxwTj4
	 5LhIFg3OzL2E9e7QKWgBa9IwZ3N/+xSWSsYKXjC/RNjAKpqE8eYLg/9dv5kbKV5I22j/R
	 WewRvq48XNhrYeOselA78iIVKqDhIzkkcIlS3XbK4JLlapBUHKTJCvdlGdoaKfL+2mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788408;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=OQJ79KPFQohOoVnOikdrmDCVb0EBCzZiMlHgXuyszI4=;
	b=m51RW3Rwdgzinf2/IY93S0vW28fEjzaF6k23/tgxNm3jnyd7hcG5aQ7NGVlp6phWxdtQ
	 cOYQkHM5hMpjcQ/VJ/jP5PcGo8ybynKYYnrLjFIyp3nevZpESfbrDR2LQ8dJn894ETh6W
	 pfWI0kjgzEsweMWbPgMYXk0Bwm9TA+nCVnXkNrr0PJCopK/fA9MJlgkCu+vi228BsjNOQ
	 6Cg4qSLl8uhhVM7n6gz57FcrV0GV8XUgkSih801e1d8QX/aqyFrVO9hCsMkTsJbaGf1qE
	 2QROG1EeqvjOQgQCogOlhi8vTc4808dp1OTonyCiVuN4lLghcvi/VxEW589+koN4JQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cK2pR7CP;
	arc=none smtp.remote-ip=91.218.175.62
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB81C606A32C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB81C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cK2pR7CP
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8EvCg7CNUuCXDH95sZ6Tyepl2hXygT4WNRWVlkQy0NI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788405; v=1; x=1795393205;
 b=cK2pR7CPprC4SGg7azzilKvwDF1xIAbcgBtqZDFWgouVEPr7wGMyc8ce3BjCz3C+Znz850BV
 8idRSUjtjnhyw63X5l4YXiFaXQE+i+ggRsVfMOaxNSAthCQ5T5AcIcx+sYIgpJUdhRGExH9HXLV
 W18sey4ZqDSyx8waExhQ5hHQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 86c97f2af74bb162;
	Mon, 16 Nov 2026 00:20:04 +0000
X-Mizu-Trace-ID: 86c97f2af74bb162
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:09 -0500
Subject: [PATCH RFC 16/18] selftests: target_core_uring: Add a minimal
 server
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-16-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

target_core_uring needs a userspace server to do anything.

There is none to test the backstore with, and no example of how to use
its interface.

Add tcmur_server, which serves a device from a backing file, from
memory or as a null device. It runs one thread and one io_uring per
queue. With -z it registers the data pages of reads and writes as fixed
buffers and does the I/O on the backing file without copying.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 MAINTAINERS                                        |   1 +
 .../testing/selftests/target_core_uring/.gitignore |   1 +
 tools/testing/selftests/target_core_uring/Makefile |   7 +
 .../selftests/target_core_uring/tcmur_server.c     | 310 +++++++++++++++++++++
 4 files changed, 319 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 07148430d9ea6..b3ac53cd7bf97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25331,6 +25331,7 @@ F:	Documentation/target/
 F:	drivers/target/
 F:	include/target/
 F:	include/uapi/linux/target_core_uring.h
+F:	tools/testing/selftests/target_core_uring/
 
 SCTP PROTOCOL
 M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
diff --git a/tools/testing/selftests/target_core_uring/.gitignore b/tools/testing/selftests/target_core_uring/.gitignore
new file mode 100644
index 0000000000000..6e2f9115e1392
--- /dev/null
+++ b/tools/testing/selftests/target_core_uring/.gitignore
@@ -0,0 +1 @@
+tcmur_server
diff --git a/tools/testing/selftests/target_core_uring/Makefile b/tools/testing/selftests/target_core_uring/Makefile
new file mode 100644
index 0000000000000..438628fd1606b
--- /dev/null
+++ b/tools/testing/selftests/target_core_uring/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+CFLAGS += -O2 -Wall -D_GNU_SOURCE $(KHDR_INCLUDES)
+LDLIBS += -luring -lpthread
+
+TEST_GEN_PROGS_EXTENDED := tcmur_server
+
+include ../lib.mk
diff --git a/tools/testing/selftests/target_core_uring/tcmur_server.c b/tools/testing/selftests/target_core_uring/tcmur_server.c
new file mode 100644
index 0000000000000..128a0021e7796
--- /dev/null
+++ b/tools/testing/selftests/target_core_uring/tcmur_server.c
@@ -0,0 +1,310 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Minimal server for target_core_uring devices.
+ *
+ * usage: tcmur_server [-z] <tcmur device> null|ram|<backing file>
+ *
+ * Run one thread per queue. With -z, register the data pages of each read
+ * and write as a fixed buffer and do the I/O on the backing file without
+ * copying.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <liburing.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/falloc.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <linux/target_core_uring.h>
+
+enum { BACKEND_NULL, BACKEND_RAM, BACKEND_FILE };
+enum { UD_FETCH, UD_REG, UD_RW, UD_UNREG };
+
+static struct tcmur_dev_info info;
+static int dev_fd, backing_fd = -1, backend;
+static bool zero_copy;
+static char *ram;
+
+struct queue {
+	pthread_t thread;
+	struct io_uring ring;
+	struct tcmur_io_desc *descs;
+	char *buf;
+	int q_id;
+};
+
+static struct io_uring_sqe *get_sqe(struct queue *q)
+{
+	struct io_uring_sqe *sqe = io_uring_get_sqe(&q->ring);
+
+	if (!sqe) {
+		io_uring_submit(&q->ring);
+		sqe = io_uring_get_sqe(&q->ring);
+	}
+	return sqe;
+}
+
+static struct io_uring_sqe *prep_cmd(struct queue *q, unsigned int op, int tag,
+				     int result, int kind)
+{
+	struct tcmur_io_cmd cmd = {
+		.q_id	= q->q_id,
+		.tag	= tag,
+		.result	= result,
+		.addr	= tag,
+	};
+	struct io_uring_sqe *sqe = get_sqe(q);
+
+	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, dev_fd, NULL, 0, 0);
+	sqe->cmd_op = op;
+	memcpy(sqe->cmd, &cmd, sizeof(cmd));
+	sqe->user_data = (uint64_t)kind << 16 | tag;
+	return sqe;
+}
+
+static int copy_data(struct queue *q, int tag, void *buf, uint32_t len,
+		     bool to_cmd)
+{
+	uint64_t pos = tcmur_buf_pos(q->q_id, tag, 0);
+	ssize_t ret;
+
+	if (to_cmd)
+		ret = pwrite(dev_fd, buf, len, pos);
+	else
+		ret = pread(dev_fd, buf, len, pos);
+	return ret == len ? 0 : -EIO;
+}
+
+static int write_same(struct queue *q, int tag, struct tcmur_io_desc *d)
+{
+	uint64_t off;
+	int ret;
+
+	ret = copy_data(q, tag, q->buf, d->data_len, false);
+	if (ret)
+		return ret;
+
+	for (off = d->offset; off < d->offset + d->len; off += d->data_len) {
+		if (backend == BACKEND_RAM)
+			memcpy(ram + off, q->buf, d->data_len);
+		else if (pwrite(backing_fd, q->buf, d->data_len, off) !=
+			 d->data_len)
+			return -EIO;
+	}
+	return 0;
+}
+
+/* Start the I/O on the data pages of the command, without copying them */
+static void start_zero_copy(struct queue *q, int tag, struct tcmur_io_desc *d)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = prep_cmd(q, TCMUR_IO_REGISTER_BUF, tag, 0, UD_REG);
+	sqe->flags |= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;
+
+	sqe = get_sqe(q);
+	if (d->op == TCMUR_OP_READ)
+		io_uring_prep_read_fixed(sqe, backing_fd, NULL, d->data_len,
+					 d->offset, tag);
+	else
+		io_uring_prep_write_fixed(sqe, backing_fd, NULL, d->data_len,
+					  d->offset, tag);
+	sqe->flags |= IOSQE_IO_HARDLINK;
+	sqe->user_data = (uint64_t)UD_RW << 16 | tag;
+
+	sqe = prep_cmd(q, TCMUR_IO_UNREGISTER_BUF, tag, 0, UD_UNREG);
+	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+}
+
+/* Return true if the command completes later */
+static bool handle(struct queue *q, int tag, int *result)
+{
+	struct tcmur_io_desc *d = &q->descs[tag];
+	bool rd = d->op == TCMUR_OP_READ;
+	int ret = 0;
+
+	switch (d->op) {
+	case TCMUR_OP_READ:
+	case TCMUR_OP_WRITE:
+		if (d->offset + d->len > info.dev_size) {
+			ret = -EINVAL;
+		} else if (backend == BACKEND_RAM) {
+			ret = copy_data(q, tag, ram + d->offset, d->data_len,
+					rd);
+		} else if (backend == BACKEND_FILE && zero_copy) {
+			start_zero_copy(q, tag, d);
+			return true;
+		} else if (backend == BACKEND_FILE && rd) {
+			if (pread(backing_fd, q->buf, d->data_len, d->offset) !=
+			    d->data_len)
+				ret = -EIO;
+			else
+				ret = copy_data(q, tag, q->buf, d->data_len,
+						true);
+		} else if (backend == BACKEND_FILE) {
+			ret = copy_data(q, tag, q->buf, d->data_len, false);
+			if (!ret && pwrite(backing_fd, q->buf, d->data_len,
+					   d->offset) != d->data_len)
+				ret = -EIO;
+		}
+		if (!ret && backend == BACKEND_FILE &&
+		    (d->flags & TCMUR_IO_F_FUA) && fdatasync(backing_fd))
+			ret = -errno;
+		break;
+	case TCMUR_OP_FLUSH:
+		if (backend == BACKEND_FILE && fdatasync(backing_fd))
+			ret = -errno;
+		break;
+	case TCMUR_OP_UNMAP:
+		if (backend == BACKEND_RAM)
+			memset(ram + d->offset, 0, d->len);
+		else if (backend == BACKEND_FILE &&
+			 fallocate(backing_fd, FALLOC_FL_PUNCH_HOLE |
+				   FALLOC_FL_KEEP_SIZE, d->offset, d->len))
+			ret = -errno;
+		break;
+	case TCMUR_OP_WRITE_SAME:
+		if (backend != BACKEND_NULL)
+			ret = write_same(q, tag, d);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	*result = ret;
+	return false;
+}
+
+static void *queue_fn(void *arg)
+{
+	struct io_uring_params p = {
+		.flags = IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN,
+	};
+	struct queue *q = arg;
+	struct io_uring_cqe *cqe;
+	unsigned int head, n;
+	int tag, kind, result;
+
+	/* Create the ring here, as only its creator may submit to it */
+	if (io_uring_queue_init_params(info.queue_depth * 4, &q->ring, &p) ||
+	    (zero_copy &&
+	     io_uring_register_buffers_sparse(&q->ring, info.queue_depth))) {
+		perror("io_uring setup");
+		exit(1);
+	}
+
+	for (tag = 0; tag < info.queue_depth; tag++)
+		prep_cmd(q, TCMUR_IO_FETCH, tag, 0, UD_FETCH);
+
+	for (;;) {
+		if (io_uring_submit_and_wait(&q->ring, 1) < 0) {
+			perror("io_uring_submit_and_wait");
+			exit(1);
+		}
+
+		n = 0;
+		io_uring_for_each_cqe(&q->ring, head, cqe) {
+			n++;
+			tag = cqe->user_data & 0xffff;
+			kind = cqe->user_data >> 16;
+
+			switch (kind) {
+			case UD_FETCH:
+				if (cqe->res < 0)
+					goto out;
+				if (handle(q, tag, &result))
+					continue;
+				break;
+			case UD_RW:
+				result = cqe->res == q->descs[tag].data_len ?
+					 0 : -EIO;
+				break;
+			default:
+				/* Report failures through the I/O that follows */
+				continue;
+			}
+			prep_cmd(q, TCMUR_IO_COMMIT_AND_FETCH, tag, result,
+				 UD_FETCH);
+		}
+		io_uring_cq_advance(&q->ring, n);
+	}
+out:
+	return NULL;
+}
+
+int main(int argc, char **argv)
+{
+	struct queue *queues;
+	size_t desc_size;
+	int i, opt;
+
+	while ((opt = getopt(argc, argv, "z")) != -1) {
+		if (opt == 'z')
+			zero_copy = true;
+		else
+			return 1;
+	}
+	if (argc - optind != 2) {
+		fprintf(stderr, "usage: %s [-z] <tcmur device> null|ram|<backing file>\n",
+			argv[0]);
+		return 1;
+	}
+
+	dev_fd = open(argv[optind], O_RDWR);
+	if (dev_fd < 0 || ioctl(dev_fd, TCMUR_GET_DEV_INFO, &info)) {
+		perror(argv[optind]);
+		return 1;
+	}
+
+	if (!strcmp(argv[optind + 1], "null")) {
+		backend = BACKEND_NULL;
+	} else if (!strcmp(argv[optind + 1], "ram")) {
+		backend = BACKEND_RAM;
+		ram = mmap(NULL, info.dev_size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+		if (ram == MAP_FAILED) {
+			perror("mmap");
+			return 1;
+		}
+	} else {
+		backend = BACKEND_FILE;
+		backing_fd = open(argv[optind + 1], O_RDWR);
+		if (backing_fd < 0) {
+			perror(argv[optind + 1]);
+			return 1;
+		}
+	}
+	if (zero_copy && backend != BACKEND_FILE) {
+		fprintf(stderr, "-z needs a backing file\n");
+		return 1;
+	}
+
+	desc_size = info.queue_depth * sizeof(struct tcmur_io_desc);
+	desc_size = (desc_size + getpagesize() - 1) & ~(getpagesize() - 1);
+	queues = calloc(info.nr_queues, sizeof(*queues));
+	for (i = 0; i < info.nr_queues; i++) {
+		struct queue *q = &queues[i];
+
+		q->q_id = i;
+		q->buf = malloc(info.max_io_size);
+		q->descs = mmap(NULL, desc_size, PROT_READ, MAP_SHARED, dev_fd,
+				(off_t)i * TCMUR_DESC_AREA_SIZE);
+		if (!q->buf || q->descs == MAP_FAILED) {
+			perror("queue setup");
+			return 1;
+		}
+	}
+
+	for (i = 0; i < info.nr_queues; i++)
+		pthread_create(&queues[i].thread, NULL, queue_fn, &queues[i]);
+	for (i = 0; i < info.nr_queues; i++)
+		pthread_join(queues[i].thread, NULL);
+	return 0;
+}

-- 
2.43.0

