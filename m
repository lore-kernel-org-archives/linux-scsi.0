From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/7] block: Clean up merge logic
Date: Thu,  1 Mar 2012 22:22:45 -0500
Message-ID: <1330658571-12958-2-git-send-email-martin.petersen@oracle.com>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31168 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2CBDXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:23:19 -0500
In-Reply-To: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, vgoyal@redhat.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Discards were globally marked as mergeable and as a result we had
several code paths that explicitly disabled merging when discard was
set. Mark discard requests as unmergable and remove special-casing of
REQ_DISCARD. The relevant nomerge flags are consolidated in blk_types.h,
and rq_mergeable() and bio_mergeable() have been modified to use them.

bio_is_rw() is used in place of bio_has_data() a few places. This is
done to to distinguish true reads and writes from other fs type requests
that carry a payload (e.g. WRITE SAME).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c          |   10 +++++-----
 block/blk-merge.c         |   22 +---------------------
 block/elevator.c          |    6 ++----
 include/linux/bio.h       |   23 +++++++++++++++++++++--
 include/linux/blk_types.h |    4 ++++
 include/linux/blkdev.h    |   23 +++++++++++------------
 6 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..5575230 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1545,8 +1545,8 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
-		     nr_sectors > queue_max_hw_sectors(q))) {
+	if (likely(bio_is_rw(bio) &&
+		   nr_sectors > queue_max_hw_sectors(q))) {
 		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
 		       bdevname(bio->bi_bdev, b),
 		       bio_sectors(bio),
@@ -1698,7 +1698,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+	if (bio_has_data(bio)) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
@@ -1744,7 +1744,7 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (!rq_mergeable(rq))
 		return 0;
 
 	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
@@ -2218,7 +2218,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	req->buffer = bio_data(req->bio);
 
 	/* update sector only for requests with clear definition of sector */
-	if (req->cmd_type == REQ_TYPE_FS || (req->cmd_flags & REQ_DISCARD))
+	if (req->cmd_type == REQ_TYPE_FS)
 		req->__sector += total_bytes >> 9;
 
 	/* mixed attributes always follow the first bio */
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..9172606 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -371,18 +371,6 @@ static int attempt_merge(struct request_queue *q, struct request *req,
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
@@ -474,15 +462,7 @@ int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
 
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
diff --git a/block/elevator.c b/block/elevator.c
index f016855..cccfdbf 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -591,8 +591,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
-		if (rq->cmd_type == REQ_TYPE_FS ||
-		    (rq->cmd_flags & REQ_DISCARD)) {
+		if (rq->cmd_type == REQ_TYPE_FS) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
@@ -634,8 +633,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
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
index 129a9c0..cad2a9c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -358,9 +358,28 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 /*
  * Check whether this bio carries any data or not. A NULL bio is allowed.
  */
-static inline int bio_has_data(struct bio *bio)
+static inline bool bio_has_data(struct bio *bio)
 {
-	return bio && bio->bi_io_vec != NULL;
+	if (bio && bio->bi_io_vec)
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
index 4053cbd..1a2727c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -170,6 +170,10 @@ enum rq_flag_bits {
 	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
+#define REQ_NOMERGE_FLAGS \
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | \
+	 REQ_DISCARD)
+
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 606cf33..3943933 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -512,8 +512,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define blk_account_rq(rq) \
 	(((rq)->cmd_flags & REQ_STARTED) && \
-	 ((rq)->cmd_type == REQ_TYPE_FS || \
-	  ((rq)->cmd_flags & REQ_DISCARD)))
+	 ((rq)->cmd_type == REQ_TYPE_FS))
 
 #define blk_pm_request(rq)	\
 	((rq)->cmd_type == REQ_TYPE_PM_SUSPEND || \
@@ -569,17 +568,17 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
 		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
+static inline bool rq_mergeable(struct request *rq)
+{
+	if (rq->cmd_type != REQ_TYPE_FS)
+		return false;
+
+	if (rq->cmd_flags & REQ_NOMERGE_FLAGS)
+		return false;
+
+	return true;
+}
 
-/*
- * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may
- * it already be started by driver.
- */
-#define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
-#define rq_mergeable(rq)	\
-	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
-	 (((rq)->cmd_flags & REQ_DISCARD) || \
-	  (rq)->cmd_type == REQ_TYPE_FS))
 
 /*
  * q->prep_rq_fn return values
-- 
1.7.8.3.21.gab8a7

