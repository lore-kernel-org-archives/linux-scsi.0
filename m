From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3] block layer varlen-cdb
Date: Sun, 10 Feb 2008 21:09:41 +0200
Message-ID: <47AF4BF5.90807@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com> <47AF4974.9010200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:59055 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYBJTLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 14:11:18 -0500
In-Reply-To: <47AF4974.9010200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org


- add varlen_cdb and varlen_cdb_len to hold a large user cdb
  if needed. They start as empty. Allocation of buffer must
  be done by user and held until request execution is done.
- Since there can be either a fix_length command up to 16 bytes
  or a variable_length, larger then 16 bytes, commands but never
  both, we hold the two types in a union to save space. The
  presence of varlen_cdb_len and cmd_len==0 signals a varlen_cdb
  mode.
- Please use added rq_{set,get}_varlen_cdb() to set every thing
  up in a way that will not confuse drivers that do not support
  varlen_cdb's.
- Note that this patch does not add any size to struct request
  since the unsigned cmd_len is split here to 2 ushorts, which
  is more then enough.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |    2 ++
 include/linux/blkdev.h |   27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4afb39c..1c5cfa7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -124,6 +124,8 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
 	rq->next_rq = NULL;
+	rq->varlen_cdb_len = 0;
+	rq->varlen_cdb = NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 90392a9..a8a6c20 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -211,8 +211,15 @@ struct request {
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	unsigned short cmd_len;
+	unsigned short varlen_cdb_len;  /* length of varlen_cdb buffer */
+	union {
+		unsigned char cmd[BLK_MAX_CDB];
+		unsigned char *varlen_cdb;/* an optional variable-length cdb.
+	                                   * points to a user buffer that must
+	                                   * be valid until end of request
+	                                   */
+	};
 
 	unsigned int data_len;
 	unsigned int sense_len;
@@ -478,6 +485,22 @@ enum {
 #define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
 
+static inline void rq_set_varlen_cdb(struct request *rq, u8 *cdb, short cdb_len)
+{
+	rq->cmd_len = 0; /* Make sure legacy drivers don't get confused */
+	rq->varlen_cdb_len = cdb_len;
+	rq->varlen_cdb = cdb;
+}
+
+/* If ! a varlen_cdb than return NULL */
+static inline u8 *rq_get_varlen_cdb(struct request *rq)
+{
+	if (!rq->cmd_len && rq->varlen_cdb_len)
+		return rq->varlen_cdb;
+	else
+		return NULL;
+}
+
 static inline int blk_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-- 
1.5.3.3


