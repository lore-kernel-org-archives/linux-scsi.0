From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] block: implement mixed merge of different failfast requests
Date: Fri,  3 Jul 2009 17:48:17 +0900
Message-ID: <1246610898-22350-4-git-send-email-tj@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44649 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZGCIs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2009 04:48:29 -0400
In-Reply-To: <1246610898-22350-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Niel Lambrechts <niel.lambrechts@gmail.com>

Failfast has characteristics from other attributes.  When issuing,
executing and successuflly completing requests, failfast doesn't make
any difference.  It only affects how a request is handled on failure.
Allowing requests with different failfast settings to be merged cause
normal IOs to fail prematurely while not allowing has performance
penalties as failfast is used for read aheads which are likely to be
located near in-flight or to-be-issued normal IOs.

This patch introduces the concept of 'mixed merge'.  A request is a
mixed merge if it is merge of segments which require different
handling on failure.  Currently the only mixable attributes are
failfast ones (or lack thereof).

When a bio with different failfast settings is added to an existing
request or requests of different failfast settings are merged, the
merged request is marked mixed.  Each bio carries failfast settings
and the request always tracks failfast state of the first bio.  When
the request fails, blk_rq_err_bytes() can be used to determine how
many bytes can be safely failed without crossing into an area which
requires further retrials.

This allows request merging regardless of failfast settings while
keeping the failure handling correct.

This patch only implements mixed merge but doesn't enable it.  The
next one will update SCSI to make use of mixed merge.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>
---
 block/blk-core.c       |   99 ++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c      |   43 +++++++++++++++++++++
 block/blk.h            |    1 +
 include/linux/blkdev.h |   23 +++++++++--
 4 files changed, 161 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cd3b265..0214837 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1165,6 +1165,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
 	const int unplug = bio_unplug(bio);
+	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 	int rw_flags;
 
 	if (bio_barrier(bio) && bio_has_data(bio) &&
@@ -1194,6 +1195,9 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 		trace_block_bio_backmerge(q, bio);
 
+		if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
+			blk_rq_set_mixed_merge(req);
+
 		req->biotail->bi_next = bio;
 		req->biotail = bio;
 		req->__data_len += bytes;
@@ -1213,6 +1217,12 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 		trace_block_bio_frontmerge(q, bio);
 
+		if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff) {
+			blk_rq_set_mixed_merge(req);
+			req->cmd_flags &= ~REQ_FAILFAST_MASK;
+			req->cmd_flags |= ff;
+		}
+
 		bio->bi_next = req->bio;
 		req->bio = bio;
 
@@ -1657,6 +1667,50 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
+/**
+ * blk_rq_err_bytes - determine number of bytes till the next failure boundary
+ * @rq: request to examine
+ *
+ * Description:
+ *     A request could be merge of IOs which require different failure
+ *     handling.  This function determines the number of bytes which
+ *     can be failed from the beginning of the request without
+ *     crossing into area which need to be retried further.
+ *
+ * Return:
+ *     The number of bytes to fail.
+ *
+ * Context:
+ *     queue_lock must be held.
+ */
+unsigned int blk_rq_err_bytes(const struct request *rq)
+{
+	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
+	unsigned int bytes = 0;
+	struct bio *bio;
+
+	if (!(rq->cmd_flags & REQ_MIXED_MERGE))
+		return blk_rq_bytes(rq);
+
+	/*
+	 * Currently the only 'mixing' which can happen is between
+	 * different fastfail types.  We can safely fail portions
+	 * which have all the failfast bits that the first one has -
+	 * the ones which are at least as eager to fail as the first
+	 * one.
+	 */
+	for (bio = rq->bio; bio; bio = bio->bi_next) {
+		if ((bio->bi_rw & ff) != ff)
+			break;
+		bytes += bio->bi_size;
+	}
+
+	/* this could lead to infinite loop */
+	BUG_ON(blk_rq_bytes(rq) && !bytes);
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(blk_rq_err_bytes);
+
 static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
 	if (blk_do_io_stat(req)) {
@@ -2003,6 +2057,12 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	if (blk_fs_request(req) || blk_discard_rq(req))
 		req->__sector += total_bytes >> 9;
 
+	/* mixed attributes always follow the first bio */
+	if (req->cmd_flags & REQ_MIXED_MERGE) {
+		req->cmd_flags &= ~REQ_FAILFAST_MASK;
+		req->cmd_flags |= req->bio->bi_rw & REQ_FAILFAST_MASK;
+	}
+
 	/*
 	 * If total number of sectors is less than the first segment
 	 * size, something has gone terribly wrong.
@@ -2182,6 +2242,25 @@ bool blk_end_request_cur(struct request *rq, int error)
 EXPORT_SYMBOL_GPL(blk_end_request_cur);
 
 /**
+ * blk_end_request_err - Finish a request till the next failure boundary.
+ * @rq: the request to finish till the next failure boundary for
+ * @error: must be negative errno
+ *
+ * Description:
+ *     Complete @rq till the next failure boundary.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ */
+bool blk_end_request_err(struct request *rq, int error)
+{
+	WARN_ON(error >= 0);
+	return blk_end_request(rq, error, blk_rq_err_bytes(rq));
+}
+EXPORT_SYMBOL_GPL(blk_end_request_err);
+
+/**
  * __blk_end_request - Helper function for drivers to complete the request.
  * @rq:       the request being processed
  * @error:    %0 for success, < %0 for error
@@ -2240,6 +2319,26 @@ bool __blk_end_request_cur(struct request *rq, int error)
 }
 EXPORT_SYMBOL_GPL(__blk_end_request_cur);
 
+/**
+ * __blk_end_request_err - Finish a request till the next failure boundary.
+ * @rq: the request to finish till the next failure boundary for
+ * @error: must be negative errno
+ *
+ * Description:
+ *     Complete @rq till the next failure boundary.  Must be called
+ *     with queue lock held.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ */
+bool __blk_end_request_err(struct request *rq, int error)
+{
+	WARN_ON(error >= 0);
+	return __blk_end_request(rq, error, blk_rq_err_bytes(rq));
+}
+EXPORT_SYMBOL_GPL(__blk_end_request_err);
+
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e199967..7c9ca01 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -311,6 +311,36 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	return 1;
 }
 
+/**
+ * blk_rq_set_mixed_merge - mark a request as mixed merge
+ * @rq: request to mark as mixed merge
+ *
+ * Description:
+ *     @rq is about to be mixed merged.  Make sure the attributes
+ *     which can be mixed are set in each bio and mark @rq as mixed
+ *     merged.
+ */
+void blk_rq_set_mixed_merge(struct request *rq)
+{
+	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
+	struct bio *bio;
+
+	if (rq->cmd_flags & REQ_MIXED_MERGE)
+		return;
+
+	/*
+	 * @rq will no longer represent mixable attributes for all the
+	 * contained bios.  It will just track those of the first one.
+	 * Distributes the attributs to each bio.
+	 */
+	for (bio = rq->bio; bio; bio = bio->bi_next) {
+		WARN_ON_ONCE((bio->bi_rw & REQ_FAILFAST_MASK) &&
+			     (bio->bi_rw & REQ_FAILFAST_MASK) != ff);
+		bio->bi_rw |= ff;
+	}
+	rq->cmd_flags |= REQ_MIXED_MERGE;
+}
+
 static void blk_account_io_merge(struct request *req)
 {
 	if (blk_do_io_stat(req)) {
@@ -366,6 +396,19 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		return 0;
 
 	/*
+	 * If failfast settings disagree or any of the two is already
+	 * a mixed merge, mark both as mixed before proceeding.  This
+	 * makes sure that all involved bios have mixable attributes
+	 * set properly.
+	 */
+	if ((req->cmd_flags | next->cmd_flags) & REQ_MIXED_MERGE ||
+	    (req->cmd_flags & REQ_FAILFAST_MASK) !=
+	    (next->cmd_flags & REQ_FAILFAST_MASK)) {
+		blk_rq_set_mixed_merge(req);
+		blk_rq_set_mixed_merge(next);
+	}
+
+	/*
 	 * At this point we have either done a back merge
 	 * or front merge. We need the smaller start_time of
 	 * the merged requests to be the current request
diff --git a/block/blk.h b/block/blk.h
index 3fae6ad..5ee3d7e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -104,6 +104,7 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 int attempt_back_merge(struct request_queue *q, struct request *rq);
 int attempt_front_merge(struct request_queue *q, struct request *rq);
 void blk_recalc_rq_segments(struct request *rq);
+void blk_rq_set_mixed_merge(struct request *rq);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a0e5ce1..e58079f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -120,6 +120,7 @@ enum rq_flag_bits {
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_IO_STAT,		/* account I/O stat */
+	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -148,6 +149,7 @@ enum rq_flag_bits {
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 #define REQ_IO_STAT	(1 << __REQ_IO_STAT)
+#define REQ_MIXED_MERGE	(1 << __REQ_MIXED_MERGE)
 
 #define REQ_FAILFAST_MASK	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | \
 				 REQ_FAILFAST_DRIVER)
@@ -836,11 +838,13 @@ static inline void blk_run_address_space(struct address_space *mapping)
 }
 
 /*
- * blk_rq_pos()		: the current sector
- * blk_rq_bytes()	: bytes left in the entire request
- * blk_rq_cur_bytes()	: bytes left in the current segment
- * blk_rq_sectors()	: sectors left in the entire request
- * blk_rq_cur_sectors()	: sectors left in the current segment
+ * blk_rq_pos()			: the current sector
+ * blk_rq_bytes()		: bytes left in the entire request
+ * blk_rq_cur_bytes()		: bytes left in the current segment
+ * blk_rq_err_bytes()		: bytes left till the next error boundary
+ * blk_rq_sectors()		: sectors left in the entire request
+ * blk_rq_cur_sectors()		: sectors left in the current segment
+ * blk_rq_err_sectors()		: sectors left till the next error boundary
  */
 static inline sector_t blk_rq_pos(const struct request *rq)
 {
@@ -857,6 +861,8 @@ static inline int blk_rq_cur_bytes(const struct request *rq)
 	return rq->bio ? bio_cur_bytes(rq->bio) : 0;
 }
 
+extern unsigned int blk_rq_err_bytes(const struct request *rq);
+
 static inline unsigned int blk_rq_sectors(const struct request *rq)
 {
 	return blk_rq_bytes(rq) >> 9;
@@ -867,6 +873,11 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 	return blk_rq_cur_bytes(rq) >> 9;
 }
 
+static inline unsigned int blk_rq_err_sectors(const struct request *rq)
+{
+	return blk_rq_err_bytes(rq) >> 9;
+}
+
 /*
  * Request issue related functions.
  */
@@ -893,10 +904,12 @@ extern bool blk_end_request(struct request *rq, int error,
 			    unsigned int nr_bytes);
 extern void blk_end_request_all(struct request *rq, int error);
 extern bool blk_end_request_cur(struct request *rq, int error);
+extern bool blk_end_request_err(struct request *rq, int error);
 extern bool __blk_end_request(struct request *rq, int error,
 			      unsigned int nr_bytes);
 extern void __blk_end_request_all(struct request *rq, int error);
 extern bool __blk_end_request_cur(struct request *rq, int error);
+extern bool __blk_end_request_err(struct request *rq, int error);
 
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
-- 
1.6.0.2

