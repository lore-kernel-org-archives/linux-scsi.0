From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/8] block: Clean up special command handling logic
Date: Tue, 18 Sep 2012 12:19:25 -0400
Message-ID: <1347985172-2495-2-git-send-email-martin.petersen@oracle.com>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27675 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2IRQTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2012 12:19:54 -0400
In-Reply-To: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, shli@kernel.org, snitzer@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Remove special-casing of non-rw fs style requests (discard). The nomerge
flags are consolidated in blk_types.h, and rq_mergeable() and
bio_mergeable() have been modified to use them.

bio_is_rw() is used in place of bio_has_data() a few places. This is
done to to distinguish true reads and writes from other fs type requests
that carry a payload (e.g. write same).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c          |   13 ++++++-------
 block/blk-merge.c         |   22 +---------------------
 block/blk.h               |    5 ++---
 block/elevator.c          |    6 ++----
 include/linux/bio.h       |   23 +++++++++++++++++++++--
 include/linux/blk_types.h |    4 ++++
 include/linux/blkdev.h    |   22 ++++++++++------------
 7 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2d739ca..5cc2929 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1657,8 +1657,8 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
-		     nr_sectors > queue_max_hw_sectors(q))) {
+	if (likely(bio_is_rw(bio) &&
+		   nr_sectors > queue_max_hw_sectors(q))) {
 		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
 		       bdevname(bio->bi_bdev, b),
 		       bio_sectors(bio),
@@ -1699,8 +1699,7 @@ generic_make_request_checks(struct bio *bio)
 
 	if ((bio->bi_rw & REQ_DISCARD) &&
 	    (!blk_queue_discard(q) ||
-	     ((bio->bi_rw & REQ_SECURE) &&
-	      !blk_queue_secdiscard(q)))) {
+	     ((bio->bi_rw & REQ_SECURE) && !blk_queue_secdiscard(q)))) {
 		err = -EOPNOTSUPP;
 		goto end_io;
 	}
@@ -1818,7 +1817,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio)) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
@@ -1864,7 +1863,7 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (!rq_mergeable(rq))
 		return 0;
 
 	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
@@ -2338,7 +2337,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	req->buffer = bio_data(req->bio);
 
 	/* update sector only for requests with clear definition of sector */
-	if (req->cmd_type == REQ_TYPE_FS || (req->cmd_flags & REQ_DISCARD))
+	if (req->cmd_type == REQ_TYPE_FS)
 		req->__sector += total_bytes >> 9;
 
 	/* mixed attributes always follow the first bio */
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e76279e..86710ca 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -418,18 +418,6 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		return 0;
 
 	/*
-	 * Don't merge file system requests and discard requests
-	 */
-	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
-		return 0;
-
-	/*
-	 * Don't merge discard requests and secure discard requests
-	 */
-	if ((req->cmd_flags & REQ_SECURE) != (next->cmd_flags & REQ_SECURE))
-		return 0;
-
-	/*
 	 * not contiguous
 	 */
 	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))
@@ -521,15 +509,7 @@ int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
 
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 {
-	if (!rq_mergeable(rq))
-		return false;
-
-	/* don't merge file system requests and discard requests */
-	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
-		return false;
-
-	/* don't merge discard requests and secure discard requests */
-	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
+	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
 	/* different data direction or already started, don't merge */
diff --git a/block/blk.h b/block/blk.h
index 2a0ea32..ca51543 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -171,14 +171,13 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
  *
  *	a) it's attached to a gendisk, and
  *	b) the queue had IO stats enabled when this request was started, and
- *	c) it's a file system request or a discard request
+ *	c) it's a file system request
  */
 static inline int blk_do_io_stat(struct request *rq)
 {
 	return rq->rq_disk &&
 	       (rq->cmd_flags & REQ_IO_STAT) &&
-	       (rq->cmd_type == REQ_TYPE_FS ||
-	        (rq->cmd_flags & REQ_DISCARD));
+		(rq->cmd_type == REQ_TYPE_FS);
 }
 
 /*
diff --git a/block/elevator.c b/block/elevator.c
index 6a55d41..9b1d42b 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -562,8 +562,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
-		if (rq->cmd_type == REQ_TYPE_FS ||
-		    (rq->cmd_flags & REQ_DISCARD)) {
+		if (rq->cmd_type == REQ_TYPE_FS) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
@@ -605,8 +604,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 		if (elv_attempt_insert_merge(q, rq))
 			break;
 	case ELEVATOR_INSERT_SORT:
-		BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
-		       !(rq->cmd_flags & REQ_DISCARD));
+		BUG_ON(rq->cmd_type != REQ_TYPE_FS);
 		rq->cmd_flags |= REQ_SORTED;
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 52b9cbc..e54305c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -386,9 +386,28 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 /*
  * Check whether this bio carries any data or not. A NULL bio is allowed.
  */
-static inline int bio_has_data(struct bio *bio)
+static inline bool bio_has_data(struct bio *bio)
 {
-	return bio && bio->bi_io_vec != NULL;
+	if (bio && bio->bi_vcnt)
+		return true;
+
+	return false;
+}
+
+static inline bool bio_is_rw(struct bio *bio)
+{
+	if (!bio_has_data(bio))
+		return false;
+
+	return true;
+}
+
+static inline bool bio_mergeable(struct bio *bio)
+{
+	if (bio->bi_rw & REQ_NOMERGE_FLAGS)
+		return false;
+
+	return true;
 }
 
 /*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 3eefbb2..1b22966 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -194,6 +194,10 @@ enum rq_flag_bits {
 	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
+/* This mask is used for both bio and request merge checking */
+#define REQ_NOMERGE_FLAGS \
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4a2ab7c..3a6fea7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -540,8 +540,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define blk_account_rq(rq) \
 	(((rq)->cmd_flags & REQ_STARTED) && \
-	 ((rq)->cmd_type == REQ_TYPE_FS || \
-	  ((rq)->cmd_flags & REQ_DISCARD)))
+	 ((rq)->cmd_type == REQ_TYPE_FS))
 
 #define blk_pm_request(rq)	\
 	((rq)->cmd_type == REQ_TYPE_PM_SUSPEND || \
@@ -595,17 +594,16 @@ static inline void blk_clear_rl_full(struct request_list *rl, bool sync)
 	rl->flags &= ~flag;
 }
 
+static inline bool rq_mergeable(struct request *rq)
+{
+	if (rq->cmd_type != REQ_TYPE_FS)
+		return false;
 
-/*
- * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may
- * it already be started by driver.
- */
-#define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_DISCARD)
-#define rq_mergeable(rq)	\
-	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
-	 (((rq)->cmd_flags & REQ_DISCARD) || \
-	  (rq)->cmd_type == REQ_TYPE_FS))
+	if (rq->cmd_flags & REQ_NOMERGE_FLAGS)
+		return false;
+
+	return true;
+}
 
 /*
  * q->prep_rq_fn return values
-- 
1.7.7.6

