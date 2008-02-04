From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 23/24][RFC] block: Minor changes to sense handling
Date: Mon,  4 Feb 2008 19:59:27 +0200
Message-ID: <1202147967-5460-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33336 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYBDSEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:04:42 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - It is no longer allowed to call blk_execute_rq_nowait() with out
    a req->senes buffer. This is not a problem because greping all users shows
    that this does not happen.

  - Add a sense_max_len which indicate the buffer size at req->sense. If zero
    then SCSI_SENSE_BUFFERSIZE is assumed. (As before)

  - SCSI_SENSE_BUFFERSIZE is moved to scsi.h (from scsi_cmnd.h)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c         |    1 +
 block/blk-exec.c         |    5 +++++
 block/scsi_ioctl.c       |    1 -
 include/linux/blkdev.h   |    3 ++-
 include/scsi/scsi.h      |    6 ++++++
 include/scsi/scsi_cmnd.h |    1 -
 include/scsi/scsi_eh.h   |    1 +
 7 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1c5cfa7..de973ab 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -120,6 +120,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->data = NULL;
 	rq->nr_phys_segments = 0;
 	rq->sense = NULL;
+	rq->sense_max_len = 0;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 391dd62..3c14a7b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -51,6 +51,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
+	BUG_ON(!rq->sense);
+	if (!rq->sense_max_len)
+		rq->sense_max_len = SCSI_SENSE_BUFFERSIZE;
+
 	rq->rq_disk = bd_disk;
 	rq->cmd_flags |= REQ_NOMERGE;
 	rq->end_io = done;
@@ -90,6 +94,7 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 		memset(sense, 0, sizeof(sense));
 		rq->sense = sense;
 		rq->sense_len = 0;
+		rq->sense_max_len = SCSI_SENSE_BUFFERSIZE;
 	}
 
 	rq->end_io_data = &wait;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a1d7070..9da2505 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -30,7 +30,6 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_cmnd.h>
 
 /* Command group 3 is reserved and should never be used.  */
 const unsigned char scsi_command_size_tbl[8] =
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a8a6c20..29fb039 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -222,7 +222,8 @@ struct request {
 	};
 
 	unsigned int data_len;
-	unsigned int sense_len;
+	unsigned short sense_len;
+	unsigned short sense_max_len;
 	void *data;
 	void *sense;
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 9c36800..91e65cf 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -415,6 +415,12 @@ struct scsi_lun {
 #define sense_valid(sense)  ((sense) & 0x80);
 
 /*
+ * Some scsi sense constants
+ */
+#define SCSI_SENSE_BUFFERSIZE 	96
+#define SCSI_SENSE_MAX_SIZE 	260
+
+/*
  * default timeouts
 */
 #define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c32d0da..000a544 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -88,7 +88,6 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
-#define SCSI_SENSE_BUFFERSIZE 	96
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index ce84330..97a6180 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -4,6 +4,7 @@
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi.h>
 struct scsi_device;
 struct Scsi_Host;
 
-- 
1.5.3.3

