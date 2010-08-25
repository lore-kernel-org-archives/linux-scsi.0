From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/30] block: drop barrier ordering by queue
	draining
Date: Wed, 25 Aug 2010 17:47:24 +0200
Message-ID: <1282751267-3530-8-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Filesystems will take all the responsibilities for ordering requests
around commit writes and will only indicate how the commit writes
themselves should be handled by block layers.  This patch drops
barrier ordering by queue draining from block layer.  Ordering by
draining implementation was somewhat invasive to request handling.
List of notable changes follow.

* Each queue has 1 bit color which is flipped on each barrier issue.
  This is used to track whether a given request is issued before the
  current barrier or not.  REQ_ORDERED_COLOR flag and coloring
  implementation in __elv_add_request() are removed.

* Requests which shouldn't be processed yet for draining were stalled
  by returning -EAGAIN from blk_do_ordered() according to the test
  result between blk_ordered_req_seq() and blk_blk_ordered_cur_seq().
  This logic is removed.

* Draining completion logic in elv_completed_request() removed.

* All barrier sequence requests were queued to request queue and then
  trckled to lower layer according to progress and thus maintaining
  request orders during requeue was necessary.  This is replaced by
  queueing the next request in the barrier sequence only after the
  current one is complete from blk_ordered_complete_seq(), which
  removes the need for multiple proxy requests in struct request_queue
  and the request sorting logic in the ELEVATOR_INSERT_REQUEUE path of
  elv_insert().

* As barriers no longer have ordering constraints, there's no need to
  dump the whole elevator onto the dispatch queue on each barrier.
  Insert barriers at the front instead.

* If other barrier requests come to the front of the dispatch queue
  while one is already in progress, they are stored in
  q->pending_barriers and restored to dispatch queue one-by-one after
  each barrier completion from blk_ordered_complete_seq().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-barrier.c       |  220 ++++++++++++++++++---------------------------
 block/blk-core.c          |   11 ++-
 block/blk.h               |    2 +-
 block/elevator.c          |   79 ++--------------
 include/linux/blk_types.h |    2 -
 include/linux/blkdev.h    |   19 ++---
 6 files changed, 113 insertions(+), 220 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f1be85b..e8b2e5c 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -9,6 +9,8 @@
 
 #include "blk.h"
 
+static struct request *queue_next_ordseq(struct request_queue *q);
+
 /*
  * Cache flushing for ordered writes handling
  */
@@ -19,38 +21,10 @@ unsigned blk_ordered_cur_seq(struct request_queue *q)
 	return 1 << ffz(q->ordseq);
 }
 
-unsigned blk_ordered_req_seq(struct request *rq)
-{
-	struct request_queue *q = rq->q;
-
-	BUG_ON(q->ordseq == 0);
-
-	if (rq == &q->pre_flush_rq)
-		return QUEUE_ORDSEQ_PREFLUSH;
-	if (rq == &q->bar_rq)
-		return QUEUE_ORDSEQ_BAR;
-	if (rq == &q->post_flush_rq)
-		return QUEUE_ORDSEQ_POSTFLUSH;
-
-	/*
-	 * !fs requests don't need to follow barrier ordering.  Always
-	 * put them at the front.  This fixes the following deadlock.
-	 *
-	 * http://thread.gmane.org/gmane.linux.kernel/537473
-	 */
-	if (rq->cmd_type != REQ_TYPE_FS)
-		return QUEUE_ORDSEQ_DRAIN;
-
-	if ((rq->cmd_flags & REQ_ORDERED_COLOR) ==
-	    (q->orig_bar_rq->cmd_flags & REQ_ORDERED_COLOR))
-		return QUEUE_ORDSEQ_DRAIN;
-	else
-		return QUEUE_ORDSEQ_DONE;
-}
-
-bool blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
+static struct request *blk_ordered_complete_seq(struct request_queue *q,
+						unsigned seq, int error)
 {
-	struct request *rq;
+	struct request *next_rq = NULL;
 
 	if (error && !q->orderr)
 		q->orderr = error;
@@ -58,16 +32,22 @@ bool blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
 	BUG_ON(q->ordseq & seq);
 	q->ordseq |= seq;
 
-	if (blk_ordered_cur_seq(q) != QUEUE_ORDSEQ_DONE)
-		return false;
-
-	/*
-	 * Okay, sequence complete.
-	 */
-	q->ordseq = 0;
-	rq = q->orig_bar_rq;
-	__blk_end_request_all(rq, q->orderr);
-	return true;
+	if (blk_ordered_cur_seq(q) != QUEUE_ORDSEQ_DONE) {
+		/* not complete yet, queue the next ordered sequence */
+		next_rq = queue_next_ordseq(q);
+	} else {
+		/* complete this barrier request */
+		__blk_end_request_all(q->orig_bar_rq, q->orderr);
+		q->orig_bar_rq = NULL;
+		q->ordseq = 0;
+
+		/* dispatch the next barrier if there's one */
+		if (!list_empty(&q->pending_barriers)) {
+			next_rq = list_entry_rq(q->pending_barriers.next);
+			list_move(&next_rq->queuelist, &q->queue_head);
+		}
+	}
+	return next_rq;
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -88,133 +68,105 @@ static void post_flush_end_io(struct request *rq, int error)
 	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_POSTFLUSH, error);
 }
 
-static void queue_flush(struct request_queue *q, unsigned which)
+static void queue_flush(struct request_queue *q, struct request *rq,
+			rq_end_io_fn *end_io)
 {
-	struct request *rq;
-	rq_end_io_fn *end_io;
-
-	if (which == QUEUE_ORDERED_DO_PREFLUSH) {
-		rq = &q->pre_flush_rq;
-		end_io = pre_flush_end_io;
-	} else {
-		rq = &q->post_flush_rq;
-		end_io = post_flush_end_io;
-	}
-
 	blk_rq_init(q, rq);
 	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
+	rq->cmd_flags = REQ_FLUSH;
 	rq->rq_disk = q->orig_bar_rq->rq_disk;
 	rq->end_io = end_io;
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
 
-static inline struct request *start_ordered(struct request_queue *q,
-					    struct request *rq)
+static struct request *queue_next_ordseq(struct request_queue *q)
 {
-	unsigned skip = 0;
-
-	q->orderr = 0;
-	q->ordered = q->next_ordered;
-	q->ordseq |= QUEUE_ORDSEQ_STARTED;
-
-	/*
-	 * For an empty barrier, there's no actual BAR request, which
-	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
-	 */
-	if (!blk_rq_sectors(rq))
-		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
-				QUEUE_ORDERED_DO_POSTFLUSH);
-
-	/* stash away the original request */
-	blk_dequeue_request(rq);
-	q->orig_bar_rq = rq;
-	rq = NULL;
-
-	/*
-	 * Queue ordered sequence.  As we stack them at the head, we
-	 * need to queue in reverse order.  Note that we rely on that
-	 * no fs request uses ELEVATOR_INSERT_FRONT and thus no fs
-	 * request gets inbetween ordered sequence.
-	 */
-	if (q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) {
-		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH);
-		rq = &q->post_flush_rq;
-	} else
-		skip |= QUEUE_ORDSEQ_POSTFLUSH;
+	struct request *rq = &q->bar_rq;
 
-	if (q->ordered & QUEUE_ORDERED_DO_BAR) {
-		rq = &q->bar_rq;
+	switch (blk_ordered_cur_seq(q)) {
+	case QUEUE_ORDSEQ_PREFLUSH:
+		queue_flush(q, rq, pre_flush_end_io);
+		break;
 
+	case QUEUE_ORDSEQ_BAR:
 		/* initialize proxy request and queue it */
 		blk_rq_init(q, rq);
 		init_request_from_bio(rq, q->orig_bar_rq->bio);
+		rq->cmd_flags &= ~REQ_HARDBARRIER;
 		if (q->ordered & QUEUE_ORDERED_DO_FUA)
 			rq->cmd_flags |= REQ_FUA;
 		rq->end_io = bar_end_io;
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
-	} else
-		skip |= QUEUE_ORDSEQ_BAR;
+		break;
 
-	if (q->ordered & QUEUE_ORDERED_DO_PREFLUSH) {
-		queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH);
-		rq = &q->pre_flush_rq;
-	} else
-		skip |= QUEUE_ORDSEQ_PREFLUSH;
+	case QUEUE_ORDSEQ_POSTFLUSH:
+		queue_flush(q, rq, post_flush_end_io);
+		break;
 
-	if (queue_in_flight(q))
-		rq = NULL;
-	else
-		skip |= QUEUE_ORDSEQ_DRAIN;
-
-	/*
-	 * Complete skipped sequences.  If whole sequence is complete,
-	 * return %NULL to tell elevator that this request is gone.
-	 */
-	if (blk_ordered_complete_seq(q, skip, 0))
-		rq = NULL;
+	default:
+		BUG();
+	}
 	return rq;
 }
 
 struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
 {
-	const int is_barrier = rq->cmd_type == REQ_TYPE_FS &&
-				(rq->cmd_flags & REQ_HARDBARRIER);
-
-	if (!q->ordseq) {
-		if (!is_barrier)
-			return rq;
-
-		if (q->next_ordered != QUEUE_ORDERED_NONE)
-			return start_ordered(q, rq);
-		else {
-			/*
-			 * Queue ordering not supported.  Terminate
-			 * with prejudice.
-			 */
-			blk_dequeue_request(rq);
-			__blk_end_request_all(rq, -EOPNOTSUPP);
-			return NULL;
-		}
+	unsigned skip = 0;
+
+	if (!(rq->cmd_flags & REQ_HARDBARRIER))
+		return rq;
+
+	if (q->ordseq) {
+		/*
+		 * Barrier is already in progress and they can't be
+		 * processed in parallel.  Queue for later processing.
+		 */
+		list_move_tail(&rq->queuelist, &q->pending_barriers);
+		return NULL;
+	}
+
+	if (unlikely(q->next_ordered == QUEUE_ORDERED_NONE)) {
+		/*
+		 * Queue ordering not supported.  Terminate
+		 * with prejudice.
+		 */
+		blk_dequeue_request(rq);
+		__blk_end_request_all(rq, -EOPNOTSUPP);
+		return NULL;
 	}
 
 	/*
-	 * Ordered sequence in progress
+	 * Start a new ordered sequence
 	 */
+	q->orderr = 0;
+	q->ordered = q->next_ordered;
+	q->ordseq |= QUEUE_ORDSEQ_STARTED;
 
-	/* Special requests are not subject to ordering rules. */
-	if (rq->cmd_type != REQ_TYPE_FS &&
-	    rq != &q->pre_flush_rq && rq != &q->post_flush_rq)
-		return rq;
+	/*
+	 * For an empty barrier, there's no actual BAR request, which
+	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
+	 */
+	if (!blk_rq_sectors(rq))
+		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
+				QUEUE_ORDERED_DO_POSTFLUSH);
 
-	/* Ordered by draining.  Wait for turn. */
-	WARN_ON(blk_ordered_req_seq(rq) < blk_ordered_cur_seq(q));
-	if (blk_ordered_req_seq(rq) > blk_ordered_cur_seq(q))
-		rq = ERR_PTR(-EAGAIN);
+	/* stash away the original request */
+	blk_dequeue_request(rq);
+	q->orig_bar_rq = rq;
 
-	return rq;
+	if (!(q->ordered & QUEUE_ORDERED_DO_PREFLUSH))
+		skip |= QUEUE_ORDSEQ_PREFLUSH;
+
+	if (!(q->ordered & QUEUE_ORDERED_DO_BAR))
+		skip |= QUEUE_ORDSEQ_BAR;
+
+	if (!(q->ordered & QUEUE_ORDERED_DO_POSTFLUSH))
+		skip |= QUEUE_ORDSEQ_POSTFLUSH;
+
+	/* complete skipped sequences and return the first sequence */
+	return blk_ordered_complete_seq(q, skip, 0);
 }
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
diff --git a/block/blk-core.c b/block/blk-core.c
index f8d37a8..d316662 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -520,6 +520,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
+	INIT_LIST_HEAD(&q->pending_barriers);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -1185,6 +1186,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const bool sync = (bio->bi_rw & REQ_SYNC);
 	const bool unplug = (bio->bi_rw & REQ_UNPLUG);
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+	int where = ELEVATOR_INSERT_SORT;
 	int rw_flags;
 
 	/* REQ_HARDBARRIER is no more */
@@ -1203,7 +1205,12 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely((bio->bi_rw & REQ_HARDBARRIER)) || elv_queue_empty(q))
+	if (bio->bi_rw & REQ_HARDBARRIER) {
+		where = ELEVATOR_INSERT_FRONT;
+		goto get_rq;
+	}
+
+	if (elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
@@ -1303,7 +1310,7 @@ get_rq:
 
 	/* insert the request into the elevator */
 	drive_stat_acct(req, 1);
-	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
+	__elv_add_request(q, req, where, 0);
 out:
 	if (unplug || !queue_should_plug(q))
 		__generic_unplug_device(q);
diff --git a/block/blk.h b/block/blk.h
index 874eb4e..08081e4 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -62,7 +62,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			rq = list_entry_rq(q->queue_head.next);
 			rq = blk_do_ordered(q, rq);
 			if (rq)
-				return !IS_ERR(rq) ? rq : NULL;
+				return rq;
 		}
 
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
diff --git a/block/elevator.c b/block/elevator.c
index ec585c9..241c69c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -617,8 +617,6 @@ void elv_quiesce_end(struct request_queue *q)
 
 void elv_insert(struct request_queue *q, struct request *rq, int where)
 {
-	struct list_head *pos;
-	unsigned ordseq;
 	int unplug_it = 1;
 
 	trace_block_rq_insert(q, rq);
@@ -626,9 +624,16 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 	rq->q = q;
 
 	switch (where) {
+	case ELEVATOR_INSERT_REQUEUE:
+		/*
+		 * Most requeues happen because of a busy condition,
+		 * don't force unplug of the queue for that case.
+		 * Clear unplug_it and fall through.
+		 */
+		unplug_it = 0;
+
 	case ELEVATOR_INSERT_FRONT:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
-
 		list_add(&rq->queuelist, &q->queue_head);
 		break;
 
@@ -668,36 +673,6 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		q->elevator->ops->elevator_add_req_fn(q, rq);
 		break;
 
-	case ELEVATOR_INSERT_REQUEUE:
-		/*
-		 * If ordered flush isn't in progress, we do front
-		 * insertion; otherwise, requests should be requeued
-		 * in ordseq order.
-		 */
-		rq->cmd_flags |= REQ_SOFTBARRIER;
-
-		/*
-		 * Most requeues happen because of a busy condition,
-		 * don't force unplug of the queue for that case.
-		 */
-		unplug_it = 0;
-
-		if (q->ordseq == 0) {
-			list_add(&rq->queuelist, &q->queue_head);
-			break;
-		}
-
-		ordseq = blk_ordered_req_seq(rq);
-
-		list_for_each(pos, &q->queue_head) {
-			struct request *pos_rq = list_entry_rq(pos);
-			if (ordseq <= blk_ordered_req_seq(pos_rq))
-				break;
-		}
-
-		list_add_tail(&rq->queuelist, pos);
-		break;
-
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
 		       __func__, where);
@@ -716,26 +691,8 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 void __elv_add_request(struct request_queue *q, struct request *rq, int where,
 		       int plug)
 {
-	if (q->ordcolor)
-		rq->cmd_flags |= REQ_ORDERED_COLOR;
-
 	if (rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)) {
-		/*
-		 * toggle ordered color
-		 */
-		if (rq->cmd_flags & REQ_HARDBARRIER)
-			q->ordcolor ^= 1;
-
-		/*
-		 * barriers implicitly indicate back insertion
-		 */
-		if (where == ELEVATOR_INSERT_SORT)
-			where = ELEVATOR_INSERT_BACK;
-
-		/*
-		 * this request is scheduling boundary, update
-		 * end_sector
-		 */
+		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
 		    (rq->cmd_flags & REQ_DISCARD)) {
 			q->end_sector = rq_end_sector(rq);
@@ -855,24 +812,6 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 		    e->ops->elevator_completed_req_fn)
 			e->ops->elevator_completed_req_fn(q, rq);
 	}
-
-	/*
-	 * Check if the queue is waiting for fs requests to be
-	 * drained for flush sequence.
-	 */
-	if (unlikely(q->ordseq)) {
-		struct request *next = NULL;
-
-		if (!list_empty(&q->queue_head))
-			next = list_entry_rq(q->queue_head.next);
-
-		if (!queue_in_flight(q) &&
-		    blk_ordered_cur_seq(q) == QUEUE_ORDSEQ_DRAIN &&
-		    (!next || blk_ordered_req_seq(next) > QUEUE_ORDSEQ_DRAIN)) {
-			blk_ordered_complete_seq(q, QUEUE_ORDSEQ_DRAIN, 0);
-			__blk_run_queue(q);
-		}
-	}
 }
 
 #define to_elv(atr) container_of((atr), struct elv_fs_entry, attr)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ca83a97..9192282 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -143,7 +143,6 @@ enum rq_flag_bits {
 	__REQ_FAILED,		/* set if the request failed */
 	__REQ_QUIET,		/* don't worry about errors */
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
-	__REQ_ORDERED_COLOR,	/* is before or after barrier */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
@@ -184,7 +183,6 @@ enum rq_flag_bits {
 #define REQ_FAILED		(1 << __REQ_FAILED)
 #define REQ_QUIET		(1 << __REQ_QUIET)
 #define REQ_PREEMPT		(1 << __REQ_PREEMPT)
-#define REQ_ORDERED_COLOR	(1 << __REQ_ORDERED_COLOR)
 #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 996549d..20a3710 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -360,9 +360,10 @@ struct request_queue
 	unsigned int		flush_flags;
 
 	unsigned int		ordered, next_ordered, ordseq;
-	int			orderr, ordcolor;
-	struct request		pre_flush_rq, bar_rq, post_flush_rq;
+	int			orderr;
+	struct request		bar_rq;
 	struct request		*orig_bar_rq;
+	struct list_head	pending_barriers;
 
 	struct mutex		sysfs_lock;
 
@@ -491,12 +492,11 @@ enum {
 	/*
 	 * Ordered operation sequence
 	 */
-	QUEUE_ORDSEQ_STARTED	= 0x01,	/* flushing in progress */
-	QUEUE_ORDSEQ_DRAIN	= 0x02,	/* waiting for the queue to be drained */
-	QUEUE_ORDSEQ_PREFLUSH	= 0x04,	/* pre-flushing in progress */
-	QUEUE_ORDSEQ_BAR	= 0x08,	/* original barrier req in progress */
-	QUEUE_ORDSEQ_POSTFLUSH	= 0x10,	/* post-flushing in progress */
-	QUEUE_ORDSEQ_DONE	= 0x20,
+	QUEUE_ORDSEQ_STARTED	= (1 << 0), /* flushing in progress */
+	QUEUE_ORDSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
+	QUEUE_ORDSEQ_BAR	= (1 << 2), /* barrier write in progress */
+	QUEUE_ORDSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
+	QUEUE_ORDSEQ_DONE	= (1 << 4),
 };
 
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
@@ -869,9 +869,6 @@ extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-extern unsigned blk_ordered_cur_seq(struct request_queue *);
-extern unsigned blk_ordered_req_seq(struct request *);
-extern bool blk_ordered_complete_seq(struct request_queue *, unsigned, int);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
-- 
1.7.1
