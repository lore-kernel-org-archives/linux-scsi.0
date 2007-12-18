From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] block layer varlen-cdb
Date: Tue, 18 Dec 2007 15:42:18 +0200
Message-ID: <4767CE3A.3010501@panasas.com>
References: <4767CC3E.8000309@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27055 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754919AbXLRNnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 08:43:11 -0500
In-Reply-To: <4767CC3E.8000309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Benny Halevy <bhalevy@panasas.com>, Matthew Wilcox <matthew@wil.cx>


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
 block/ll_rw_blk.c      |    2 ++
 include/linux/blkdev.h |   27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..e80179b 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -261,6 +261,8 @@ static void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
 	rq->next_rq = NULL;
+	rq->varlen_cdb_len = 0;
+	rq->varlen_cdb = NULL;
 }
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..aa3090c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -287,8 +287,15 @@ struct request {
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
@@ -550,6 +557,22 @@ enum {
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


