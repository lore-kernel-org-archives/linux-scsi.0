From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/11] block: implement REQ_FLUSH/FUA based interface for FLUSH/FUA requests
Date: Thu, 12 Aug 2010 14:41:29 +0200
Message-ID: <1281616891-5691-10-git-send-email-tj@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Now that the backend conversion is complete, export sequenced
FLUSH/FUA capability through REQ_FLUSH/FUA flags.  REQ_FLUSH means the
device cache should be flushed before executing the request.  REQ_FUA
means that the data in the request should be on non-volatile media on
completion.

Block layer will choose the correct way of implementing the semantics
and execute it.  The request may be passed to the device directly if
the device can handle it; otherwise, it will be sequenced using one or
more proxy requests.  Devices will never see REQ_FLUSH and/or FUA
which it doesn't support.

* QUEUE_ORDERED_* are removed and QUEUE_FSEQ_* are moved into
  blk-flush.c.

* REQ_FLUSH w/o data can also be directly passed to drivers without
  sequencing but some drivers assume that zero length requests don't
  have rq->bio which isn't true for these requests requiring the use
  of proxy requests.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-core.c       |    2 +-
 block/blk-flush.c      |   85 ++++++++++++++++++++++++++----------------------
 block/blk.h            |    3 ++
 include/linux/blkdev.h |   38 +--------------------
 4 files changed, 52 insertions(+), 76 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index efe391b..c00ace2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1204,7 +1204,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 	spin_lock_irq(q->queue_lock);
 
-	if (bio->bi_rw & REQ_HARDBARRIER) {
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
 		where = ELEVATOR_INSERT_FRONT;
 		goto get_rq;
 	}
diff --git a/block/blk-flush.c b/block/blk-flush.c
index dd87322..452c552 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -1,5 +1,5 @@
 /*
- * Functions related to barrier IO handling
+ * Functions to sequence FLUSH and FUA writes.
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -9,6 +9,15 @@
 
 #include "blk.h"
 
+/* FLUSH/FUA sequences */
+enum {
+	QUEUE_FSEQ_STARTED	= (1 << 0), /* flushing in progress */
+	QUEUE_FSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
+	QUEUE_FSEQ_DATA		= (1 << 2), /* data write in progress */
+	QUEUE_FSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
+	QUEUE_FSEQ_DONE		= (1 << 4),
+};
+
 static struct request *queue_next_fseq(struct request_queue *q);
 
 unsigned blk_flush_cur_seq(struct request_queue *q)
@@ -79,6 +88,7 @@ static void queue_flush(struct request_queue *q, struct request *rq,
 
 static struct request *queue_next_fseq(struct request_queue *q)
 {
+	struct request *orig_rq = q->orig_flush_rq;
 	struct request *rq = &q->flush_rq;
 
 	switch (blk_flush_cur_seq(q)) {
@@ -87,12 +97,11 @@ static struct request *queue_next_fseq(struct request_queue *q)
 		break;
 
 	case QUEUE_FSEQ_DATA:
-		/* initialize proxy request and queue it */
+		/* initialize proxy request, inherit FLUSH/FUA and queue it */
 		blk_rq_init(q, rq);
-		init_request_from_bio(rq, q->orig_flush_rq->bio);
-		rq->cmd_flags &= ~REQ_HARDBARRIER;
-		if (q->ordered & QUEUE_ORDERED_DO_FUA)
-			rq->cmd_flags |= REQ_FUA;
+		init_request_from_bio(rq, orig_rq->bio);
+		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
+		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
@@ -110,60 +119,58 @@ static struct request *queue_next_fseq(struct request_queue *q)
 
 struct request *blk_do_flush(struct request_queue *q, struct request *rq)
 {
+	unsigned int fflags = q->flush_flags; /* may change, cache it */
+	bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
+	bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
+	bool do_postflush = has_flush && !has_fua && (rq->cmd_flags & REQ_FUA);
 	unsigned skip = 0;
 
-	if (!(rq->cmd_flags & REQ_HARDBARRIER))
+	/*
+	 * Special case.  If there's data but flush is not necessary,
+	 * the request can be issued directly.
+	 *
+	 * Flush w/o data should be able to be issued directly too but
+	 * currently some drivers assume that rq->bio contains
+	 * non-zero data if it isn't NULL and empty FLUSH requests
+	 * getting here usually have bio's without data.
+	 */
+	if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
+		rq->cmd_flags &= ~REQ_FLUSH;
+		if (!has_fua)
+			rq->cmd_flags &= ~REQ_FUA;
 		return rq;
+	}
 
+	/*
+	 * Sequenced flushes can't be processed in parallel.  If
+	 * another one is already in progress, queue for later
+	 * processing.
+	 */
 	if (q->flush_seq) {
-		/*
-		 * Sequenced flush is already in progress and they
-		 * can't be processed in parallel.  Queue for later
-		 * processing.
-		 */
 		list_move_tail(&rq->queuelist, &q->pending_flushes);
 		return NULL;
 	}
 
-	if (unlikely(q->next_ordered == QUEUE_ORDERED_NONE)) {
-		/*
-		 * Queue ordering not supported.  Terminate
-		 * with prejudice.
-		 */
-		blk_dequeue_request(rq);
-		__blk_end_request_all(rq, -EOPNOTSUPP);
-		return NULL;
-	}
-
 	/*
 	 * Start a new flush sequence
 	 */
 	q->flush_err = 0;
-	q->ordered = q->next_ordered;
 	q->flush_seq |= QUEUE_FSEQ_STARTED;
 
-	/*
-	 * For an empty barrier, there's no actual BAR request, which
-	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
-	 */
-	if (!blk_rq_sectors(rq))
-		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
-				QUEUE_ORDERED_DO_POSTFLUSH);
-
-	/* stash away the original request */
+	/* adjust FLUSH/FUA of the original request and stash it away */
+	rq->cmd_flags &= ~REQ_FLUSH;
+	if (!has_fua)
+		rq->cmd_flags &= ~REQ_FUA;
 	blk_dequeue_request(rq);
 	q->orig_flush_rq = rq;
 
-	if (!(q->ordered & QUEUE_ORDERED_DO_PREFLUSH))
+	/* skip unneded sequences and return the first one */
+	if (!do_preflush)
 		skip |= QUEUE_FSEQ_PREFLUSH;
-
-	if (!(q->ordered & QUEUE_ORDERED_DO_BAR))
+	if (!blk_rq_sectors(rq))
 		skip |= QUEUE_FSEQ_DATA;
-
-	if (!(q->ordered & QUEUE_ORDERED_DO_POSTFLUSH))
+	if (!do_postflush)
 		skip |= QUEUE_FSEQ_POSTFLUSH;
-
-	/* complete skipped sequences and return the first sequence */
 	return blk_flush_complete_seq(q, skip, 0);
 }
 
diff --git a/block/blk.h b/block/blk.h
index 24b92bd..a09c18b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -60,6 +60,9 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 	while (1) {
 		while (!list_empty(&q->queue_head)) {
 			rq = list_entry_rq(q->queue_head.next);
+			if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
+			    rq == &q->flush_rq)
+				return rq;
 			rq = blk_do_flush(q, rq);
 			if (rq)
 				return rq;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 87e58f0..5ce0696 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -357,7 +357,6 @@ struct request_queue
 	/*
 	 * for flush operations
 	 */
-	unsigned int		ordered, next_ordered;
 	unsigned int		flush_flags;
 	unsigned int		flush_seq;
 	int			flush_err;
@@ -464,40 +463,6 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	__clear_bit(flag, &q->queue_flags);
 }
 
-enum {
-	/*
-	 * Hardbarrier is supported with one of the following methods.
-	 *
-	 * NONE		: hardbarrier unsupported
-	 * DRAIN	: ordering by draining is enough
-	 * DRAIN_FLUSH	: ordering by draining w/ pre and post flushes
-	 * DRAIN_FUA	: ordering by draining w/ pre flush and FUA write
-	 */
-	QUEUE_ORDERED_DO_PREFLUSH	= 0x10,
-	QUEUE_ORDERED_DO_BAR		= 0x20,
-	QUEUE_ORDERED_DO_POSTFLUSH	= 0x40,
-	QUEUE_ORDERED_DO_FUA		= 0x80,
-
-	QUEUE_ORDERED_NONE		= 0x00,
-
-	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_DO_BAR,
-	QUEUE_ORDERED_DRAIN_FLUSH	= QUEUE_ORDERED_DRAIN |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_POSTFLUSH,
-	QUEUE_ORDERED_DRAIN_FUA		= QUEUE_ORDERED_DRAIN |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_FUA,
-
-	/*
-	 * FLUSH/FUA sequences.
-	 */
-	QUEUE_FSEQ_STARTED	= (1 << 0), /* flushing in progress */
-	QUEUE_FSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
-	QUEUE_FSEQ_DATA		= (1 << 2), /* data write in progress */
-	QUEUE_FSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
-	QUEUE_FSEQ_DONE		= (1 << 4),
-};
-
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
@@ -576,7 +541,8 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
+	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER | \
+	 REQ_FLUSH | REQ_FUA)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (((rq)->cmd_flags & REQ_DISCARD) || \
-- 
1.7.1

