From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/41] block: rename barrier/ordered to flush
Date: Fri,  3 Sep 2010 12:29:24 +0200
Message-ID: <1283509796-1510-10-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:35619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab0ICKbG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:06 -0400
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.co
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>

With ordering requirements dropped, barrier and ordered are misnomers.
Now all block layer does is sequencing FLUSH and FUA.  Rename them to
flush.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-core.c       |   21 +++++-----
 block/blk-flush.c      |   98 +++++++++++++++++++++++------------------------
 block/blk.h            |    4 +-
 include/linux/blkdev.h |   24 ++++++------
 4 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d316662..8870ae4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -136,7 +136,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 {
 	struct request_queue *q = rq->q;
 
-	if (&q->bar_rq != rq) {
+	if (&q->flush_rq != rq) {
 		if (error)
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
@@ -160,13 +160,12 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		if (bio->bi_size == 0)
 			bio_endio(bio, error);
 	} else {
-
 		/*
-		 * Okay, this is the barrier request in progress, just
-		 * record the error;
+		 * Okay, this is the sequenced flush request in
+		 * progress, just record the error;
 		 */
-		if (error && !q->orderr)
-			q->orderr = error;
+		if (error && !q->flush_err)
+			q->flush_err = error;
 	}
 }
 
@@ -520,7 +519,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
-	INIT_LIST_HEAD(&q->pending_barriers);
+	INIT_LIST_HEAD(&q->pending_flushes);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -1764,11 +1763,11 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 static void blk_account_io_done(struct request *req)
 {
 	/*
-	 * Account IO completion.  bar_rq isn't accounted as a normal
-	 * IO on queueing nor completion.  Accounting the containing
-	 * request is enough.
+	 * Account IO completion.  flush_rq isn't accounted as a
+	 * normal IO on queueing nor completion.  Accounting the
+	 * containing request is enough.
 	 */
-	if (blk_do_io_stat(req) && req != &req->q->bar_rq) {
+	if (blk_do_io_stat(req) && req != &req->q->flush_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index e8b2e5c..dd87322 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -9,41 +9,38 @@
 
 #include "blk.h"
 
-static struct request *queue_next_ordseq(struct request_queue *q);
+static struct request *queue_next_fseq(struct request_queue *q);
 
-/*
- * Cache flushing for ordered writes handling
- */
-unsigned blk_ordered_cur_seq(struct request_queue *q)
+unsigned blk_flush_cur_seq(struct request_queue *q)
 {
-	if (!q->ordseq)
+	if (!q->flush_seq)
 		return 0;
-	return 1 << ffz(q->ordseq);
+	return 1 << ffz(q->flush_seq);
 }
 
-static struct request *blk_ordered_complete_seq(struct request_queue *q,
-						unsigned seq, int error)
+static struct request *blk_flush_complete_seq(struct request_queue *q,
+					      unsigned seq, int error)
 {
 	struct request *next_rq = NULL;
 
-	if (error && !q->orderr)
-		q->orderr = error;
+	if (error && !q->flush_err)
+		q->flush_err = error;
 
-	BUG_ON(q->ordseq & seq);
-	q->ordseq |= seq;
+	BUG_ON(q->flush_seq & seq);
+	q->flush_seq |= seq;
 
-	if (blk_ordered_cur_seq(q) != QUEUE_ORDSEQ_DONE) {
-		/* not complete yet, queue the next ordered sequence */
-		next_rq = queue_next_ordseq(q);
+	if (blk_flush_cur_seq(q) != QUEUE_FSEQ_DONE) {
+		/* not complete yet, queue the next flush sequence */
+		next_rq = queue_next_fseq(q);
 	} else {
-		/* complete this barrier request */
-		__blk_end_request_all(q->orig_bar_rq, q->orderr);
-		q->orig_bar_rq = NULL;
-		q->ordseq = 0;
-
-		/* dispatch the next barrier if there's one */
-		if (!list_empty(&q->pending_barriers)) {
-			next_rq = list_entry_rq(q->pending_barriers.next);
+		/* complete this flush request */
+		__blk_end_request_all(q->orig_flush_rq, q->flush_err);
+		q->orig_flush_rq = NULL;
+		q->flush_seq = 0;
+
+		/* dispatch the next flush if there's one */
+		if (!list_empty(&q->pending_flushes)) {
+			next_rq = list_entry_rq(q->pending_flushes.next);
 			list_move(&next_rq->queuelist, &q->queue_head);
 		}
 	}
@@ -53,19 +50,19 @@ static struct request *blk_ordered_complete_seq(struct request_queue *q,
 static void pre_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_PREFLUSH, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error);
 }
 
-static void bar_end_io(struct request *rq, int error)
+static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_BAR, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error);
 }
 
 static void post_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_POSTFLUSH, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }
 
 static void queue_flush(struct request_queue *q, struct request *rq,
@@ -74,34 +71,34 @@ static void queue_flush(struct request_queue *q, struct request *rq,
 	blk_rq_init(q, rq);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_FLUSH;
-	rq->rq_disk = q->orig_bar_rq->rq_disk;
+	rq->rq_disk = q->orig_flush_rq->rq_disk;
 	rq->end_io = end_io;
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
 
-static struct request *queue_next_ordseq(struct request_queue *q)
+static struct request *queue_next_fseq(struct request_queue *q)
 {
-	struct request *rq = &q->bar_rq;
+	struct request *rq = &q->flush_rq;
 
-	switch (blk_ordered_cur_seq(q)) {
-	case QUEUE_ORDSEQ_PREFLUSH:
+	switch (blk_flush_cur_seq(q)) {
+	case QUEUE_FSEQ_PREFLUSH:
 		queue_flush(q, rq, pre_flush_end_io);
 		break;
 
-	case QUEUE_ORDSEQ_BAR:
+	case QUEUE_FSEQ_DATA:
 		/* initialize proxy request and queue it */
 		blk_rq_init(q, rq);
-		init_request_from_bio(rq, q->orig_bar_rq->bio);
+		init_request_from_bio(rq, q->orig_flush_rq->bio);
 		rq->cmd_flags &= ~REQ_HARDBARRIER;
 		if (q->ordered & QUEUE_ORDERED_DO_FUA)
 			rq->cmd_flags |= REQ_FUA;
-		rq->end_io = bar_end_io;
+		rq->end_io = flush_data_end_io;
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 		break;
 
-	case QUEUE_ORDSEQ_POSTFLUSH:
+	case QUEUE_FSEQ_POSTFLUSH:
 		queue_flush(q, rq, post_flush_end_io);
 		break;
 
@@ -111,19 +108,20 @@ static struct request *queue_next_ordseq(struct request_queue *q)
 	return rq;
 }
 
-struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
+struct request *blk_do_flush(struct request_queue *q, struct request *rq)
 {
 	unsigned skip = 0;
 
 	if (!(rq->cmd_flags & REQ_HARDBARRIER))
 		return rq;
 
-	if (q->ordseq) {
+	if (q->flush_seq) {
 		/*
-		 * Barrier is already in progress and they can't be
-		 * processed in parallel.  Queue for later processing.
+		 * Sequenced flush is already in progress and they
+		 * can't be processed in parallel.  Queue for later
+		 * processing.
 		 */
-		list_move_tail(&rq->queuelist, &q->pending_barriers);
+		list_move_tail(&rq->queuelist, &q->pending_flushes);
 		return NULL;
 	}
 
@@ -138,11 +136,11 @@ struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
 	}
 
 	/*
-	 * Start a new ordered sequence
+	 * Start a new flush sequence
 	 */
-	q->orderr = 0;
+	q->flush_err = 0;
 	q->ordered = q->next_ordered;
-	q->ordseq |= QUEUE_ORDSEQ_STARTED;
+	q->flush_seq |= QUEUE_FSEQ_STARTED;
 
 	/*
 	 * For an empty barrier, there's no actual BAR request, which
@@ -154,19 +152,19 @@ struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
 
 	/* stash away the original request */
 	blk_dequeue_request(rq);
-	q->orig_bar_rq = rq;
+	q->orig_flush_rq = rq;
 
 	if (!(q->ordered & QUEUE_ORDERED_DO_PREFLUSH))
-		skip |= QUEUE_ORDSEQ_PREFLUSH;
+		skip |= QUEUE_FSEQ_PREFLUSH;
 
 	if (!(q->ordered & QUEUE_ORDERED_DO_BAR))
-		skip |= QUEUE_ORDSEQ_BAR;
+		skip |= QUEUE_FSEQ_DATA;
 
 	if (!(q->ordered & QUEUE_ORDERED_DO_POSTFLUSH))
-		skip |= QUEUE_ORDSEQ_POSTFLUSH;
+		skip |= QUEUE_FSEQ_POSTFLUSH;
 
 	/* complete skipped sequences and return the first sequence */
-	return blk_ordered_complete_seq(q, skip, 0);
+	return blk_flush_complete_seq(q, skip, 0);
 }
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
diff --git a/block/blk.h b/block/blk.h
index 08081e4..24b92bd 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -51,7 +51,7 @@ static inline void blk_clear_rq_complete(struct request *rq)
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
-struct request *blk_do_ordered(struct request_queue *q, struct request *rq);
+struct request *blk_do_flush(struct request_queue *q, struct request *rq);
 
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
@@ -60,7 +60,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 	while (1) {
 		while (!list_empty(&q->queue_head)) {
 			rq = list_entry_rq(q->queue_head.next);
-			rq = blk_do_ordered(q, rq);
+			rq = blk_do_flush(q, rq);
 			if (rq)
 				return rq;
 		}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 20a3710..1cd83ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -357,13 +357,13 @@ struct request_queue
 	/*
 	 * for flush operations
 	 */
+	unsigned int		ordered, next_ordered;
 	unsigned int		flush_flags;
-
-	unsigned int		ordered, next_ordered, ordseq;
-	int			orderr;
-	struct request		bar_rq;
-	struct request		*orig_bar_rq;
-	struct list_head	pending_barriers;
+	unsigned int		flush_seq;
+	int			flush_err;
+	struct request		flush_rq;
+	struct request		*orig_flush_rq;
+	struct list_head	pending_flushes;
 
 	struct mutex		sysfs_lock;
 
@@ -490,13 +490,13 @@ enum {
 					  QUEUE_ORDERED_DO_FUA,
 
 	/*
-	 * Ordered operation sequence
+	 * FLUSH/FUA sequences.
 	 */
-	QUEUE_ORDSEQ_STARTED	= (1 << 0), /* flushing in progress */
-	QUEUE_ORDSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
-	QUEUE_ORDSEQ_BAR	= (1 << 2), /* barrier write in progress */
-	QUEUE_ORDSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
-	QUEUE_ORDSEQ_DONE	= (1 << 4),
+	QUEUE_FSEQ_STARTED	= (1 << 0), /* flushing in progress */
+	QUEUE_FSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
+	QUEUE_FSEQ_DATA		= (1 << 2), /* data write in progress */
+	QUEUE_FSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
+	QUEUE_FSEQ_DONE		= (1 << 4),
 };
 
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
-- 
1.7.1

