From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3] block layer varlen-cdb
Date: Tue, 25 Mar 2008 18:32:52 +0200
Message-ID: <47E92934.6040903@panasas.com>
References: <47E92672.1040208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24277 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbYCYQeO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 12:34:14 -0400
In-Reply-To: <47E92672.1040208@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew


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
index 2a438a9..70d32f7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -141,6 +141,8 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
+	rq->varlen_cdb_len = 0;
+	rq->varlen_cdb = NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..f829571 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -213,8 +213,15 @@ struct request {
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
 	unsigned int extra_len;	/* length of alignment and padding */
@@ -484,6 +491,22 @@ enum {
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


