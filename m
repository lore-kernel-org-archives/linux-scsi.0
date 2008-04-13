From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] block layer extended-cdb support
Date: Sun, 13 Apr 2008 19:39:01 +0300
Message-ID: <48023725.8010408@panasas.com>
References: <47E92672.1040208@panasas.com> <48023526.5050709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56814 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbYDMQji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2008 12:39:38 -0400
In-Reply-To: <48023526.5050709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mike


  - add ext_cdb and ext_cdb_len to hold a large external cdb
    if needed. They start as empty. Allocation of buffer must
    be done by user and held until request execution is done.
  - Since there can be either a fix_length command up to 16 bytes
    or an external extended command but never both, we hold the two
    types in a union to save space. The presence of ext_cdb_len!=0
    and cmd_len==0 signals an ext_cdb mode.
  - Use new rq_set_cdb() to set everything up in a way that will
    not confuse drivers that do not support extended cdb's.
  - Use rq_get_cdb()/rq_get_cdb_len() to retrieve command and length
    in a generic way.
  - Once all drivers and users convert to the new accessors the cmd[]
    16 bytes buffer can be discarded.
  - Note that this patch does not add any size to struct request
    since the unsigned cmd_len is split here to 2 ushorts, which
    is more then enough.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |    2 ++
 include/linux/blkdev.h |   41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..cc9a790 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -141,6 +141,8 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
+	rq->ext_cdb_len = 0;
+	rq->ext_cdb = NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..2f87c9d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -213,8 +213,15 @@ struct request {
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	unsigned short cmd_len;
+	unsigned short ext_cdb_len;  /* length of ext_cdb buffer */
+	union {
+		unsigned char cmd[BLK_MAX_CDB];
+		unsigned char *ext_cdb;/* an optional extended cdb.
+	                                   * points to a user buffer that must
+	                                   * be valid until end of request
+	                                   */
+	};
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
@@ -484,6 +491,36 @@ enum {
 #define rq_is_sync(rq)		(rq_data_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
 #define rq_is_meta(rq)		((rq)->cmd_flags & REQ_RW_META)
 
+static inline void rq_set_cdb(struct request *rq, u8 *cdb, short cdb_len)
+{
+	if (cdb_len <= BLK_MAX_CDB) {
+		memcpy(rq->cmd, cdb, cdb_len);
+		rq->cmd_len = cdb_len;
+		rq->ext_cdb_len = 0;
+	}
+	else {
+		rq->cmd_len = 0; /* Make sure legacy drivers don't get confused */
+		rq->ext_cdb_len = cdb_len;
+		rq->ext_cdb = cdb;
+	}
+}
+
+static inline u8 *rq_get_cdb(struct request *rq)
+{
+	if (!rq->cmd_len && rq->ext_cdb_len)
+		return rq->ext_cdb;
+	else
+		return rq->cmd;
+}
+
+static inline unsigned short rq_get_cdb_len(struct request *rq)
+{
+	if (!rq->cmd_len && rq->ext_cdb_len)
+		return rq->ext_cdb_len;
+	else
+		return rq->cmd_len;
+}
+
 static inline int blk_queue_full(struct request_queue *q, int rw)
 {
 	if (rw == READ)
-- 
1.5.3.3


