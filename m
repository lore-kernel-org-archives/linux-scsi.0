From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] block: use the same failfast bits for bio and request
Date: Fri,  3 Jul 2009 17:48:16 +0900
Message-ID: <1246610898-22350-3-git-send-email-tj@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZGCIsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2009 04:48:42 -0400
In-Reply-To: <1246610898-22350-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Nie
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>

bio and request use the same set of failfast bits.  This patch makes
the following changes to simplify things.

* enumify BIO_RW* bits and reorder bits such that BIOS_RW_FAILFAST_*
  bits coincide with __REQ_FAILFAST_* bits.

* The above pushes BIO_RW_AHEAD out of sync with __REQ_FAILFAST_DEV
  but the matching is useless anyway.  init_request_from_bio() is
  responsible for setting FAILFAST bits on FS requests and non-FS
  requests never use BIO_RW_AHEAD.  Drop the code and comment from
  blk_rq_bio_prep().

* Define REQ_FAILFAST_MASK which is OR of all FAILFAST bits and
  simplify FAILFAST flags handling in init_request_from_bio().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       |   19 +++++++------------
 include/linux/bio.h    |   43 +++++++++++++++++++++++--------------------
 include/linux/blkdev.h |    4 ++++
 3 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8f4b9e0..cd3b265 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1119,17 +1119,13 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	req->cmd_type = REQ_TYPE_FS;
 
 	/*
-	 * inherit FAILFAST from bio (for read-ahead, and explicit FAILFAST)
+	 * Inherit FAILFAST from bio (for read-ahead, and explicit
+	 * FAILFAST).  FAILFAST flags are identical for req and bio.
 	 */
 	if (bio_rw_ahead(bio))
-		req->cmd_flags |= (REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-				   REQ_FAILFAST_DRIVER);
-	if (bio_failfast_dev(bio))
-		req->cmd_flags |= REQ_FAILFAST_DEV;
-	if (bio_failfast_transport(bio))
-		req->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	if (bio_failfast_driver(bio))
-		req->cmd_flags |= REQ_FAILFAST_DRIVER;
+		req->cmd_flags |= REQ_FAILFAST_MASK;
+	else
+		req->cmd_flags |= bio->bi_rw & REQ_FAILFAST_MASK;
 
 	if (unlikely(bio_discard(bio))) {
 		req->cmd_flags |= REQ_DISCARD;
@@ -2247,9 +2243,8 @@ EXPORT_SYMBOL_GPL(__blk_end_request_cur);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
-	/* Bit 0 (R/W) is identical in rq->cmd_flags and bio->bi_rw, and
-	   we want BIO_RW_AHEAD (bit 1) to imply REQ_FAILFAST (bit 1). */
-	rq->cmd_flags |= (bio->bi_rw & 3);
+	/* Bit 0 (R/W) is identical in rq->cmd_flags and bio->bi_rw */
+	rq->cmd_flags |= bio->bi_rw & REQ_RW;
 
 	if (bio_has_data(bio)) {
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2892b71..a299ed3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -142,37 +142,40 @@ struct bio {
  *
  * bit 0 -- data direction
  *	If not set, bio is a read from device. If set, it's a write to device.
- * bit 1 -- rw-ahead when set
- * bit 2 -- barrier
+ * bit 1 -- fail fast device errors
+ * bit 2 -- fail fast transport errors
+ * bit 3 -- fail fast driver errors
+ * bit 4 -- rw-ahead when set
+ * bit 5 -- barrier
  *	Insert a serialization point in the IO queue, forcing previously
  *	submitted IO to be completed before this one is issued.
- * bit 3 -- synchronous I/O hint.
- * bit 4 -- Unplug the device immediately after submitting this bio.
- * bit 5 -- metadata request
+ * bit 6 -- synchronous I/O hint.
+ * bit 7 -- Unplug the device immediately after submitting this bio.
+ * bit 8 -- metadata request
  *	Used for tracing to differentiate metadata and data IO. May also
  *	get some preferential treatment in the IO scheduler
- * bit 6 -- discard sectors
+ * bit 9 -- discard sectors
  *	Informs the lower level device that this range of sectors is no longer
  *	used by the file system and may thus be freed by the device. Used
  *	for flash based storage.
- * bit 7 -- fail fast device errors
- * bit 8 -- fail fast transport errors
- * bit 9 -- fail fast driver errors
  *	Don't want driver retries for any fast fail whatever the reason.
  * bit 10 -- Tell the IO scheduler not to wait for more requests after this
 	one has been submitted, even if it is a SYNC request.
  */
-#define BIO_RW		0	/* Must match RW in req flags (blkdev.h) */
-#define BIO_RW_AHEAD	1	/* Must match FAILFAST in req flags */
-#define BIO_RW_BARRIER	2
-#define BIO_RW_SYNCIO	3
-#define BIO_RW_UNPLUG	4
-#define BIO_RW_META	5
-#define BIO_RW_DISCARD	6
-#define BIO_RW_FAILFAST_DEV		7
-#define BIO_RW_FAILFAST_TRANSPORT	8
-#define BIO_RW_FAILFAST_DRIVER		9
-#define BIO_RW_NOIDLE	10
+enum bio_rw_flags {
+	BIO_RW,
+	BIO_RW_FAILFAST_DEV,
+	BIO_RW_FAILFAST_TRANSPORT,
+	BIO_RW_FAILFAST_DRIVER,
+	/* above flags must match REQ_* */
+	BIO_RW_AHEAD,
+	BIO_RW_BARRIER,
+	BIO_RW_SYNCIO,
+	BIO_RW_UNPLUG,
+	BIO_RW_META,
+	BIO_RW_DISCARD,
+	BIO_RW_NOIDLE,
+};
 
 #define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 49ae079..a0e5ce1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -98,6 +98,7 @@ enum rq_flag_bits {
 	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
 	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
 	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
+	/* above flags must match BIO_RW_* */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SORTED,		/* elevator knows about this request */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
@@ -148,6 +149,9 @@ enum rq_flag_bits {
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 #define REQ_IO_STAT	(1 << __REQ_IO_STAT)
 
+#define REQ_FAILFAST_MASK	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | \
+				 REQ_FAILFAST_DRIVER)
+
 #define BLK_MAX_CDB	16
 
 /*
-- 
1.6.0.2

