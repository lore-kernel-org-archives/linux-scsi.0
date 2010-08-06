From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH, RFC] relaxed barriers
Date: Fri, 06 Aug 2010 18:04:23 +0200
Message-ID: <4C5C3287.1010404@kernel.org>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100803184939.GA12198@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

So, here's my shot at it.  After this patch, barrier no longer
dictates the ordering of other requests.  The block layer sequences
the barrier request without interfering with other requests (not even
elevator draining).  Multiple pending barriers are handled by saving
those in a separate queue and servicing them one by one.  Basically,
barrier sequences form a separate FIFO command stream independent of
other requests and all the ordering between the two streams is
filesystem's responsibility.

Ordered tag support is dropped as no one seems to be making any
meaningful use of it.  I'm fairly skeptical about its usefulness
anyway.  The only thing ordered tag saves is latencies between command
completions and issues in barrier sequences, which isn't much to begin
with and puts additional ordering restrictions compared to ordering in
software (ordered tag commands will unnecessary affect processing of
simple tag commands).

Lightly tested for all three BAR (!WC), FLUSH and FUA cases.  The
multiple pending barrier code path isn't tested yet.

Christoph, does this look like something the filesystems can use or
have I misunderstood something?

Thanks.

NOT_SIGNED_OFF_YET
---
 block/blk-barrier.c          |  253 +++++++++++++++----------------------------
 block/blk-core.c             |   31 ++---
 block/blk.h                  |    5
 block/elevator.c             |   80 +------------
 drivers/block/brd.c          |    2
 drivers/block/loop.c         |    2
 drivers/block/osdblk.c       |    2
 drivers/block/pktcdvd.c      |    1
 drivers/block/ps3disk.c      |    3
 drivers/block/virtio_blk.c   |    4
 drivers/block/xen-blkfront.c |    2
 drivers/ide/ide-disk.c       |    4
 drivers/md/dm.c              |    3
 drivers/mmc/card/queue.c     |    2
 drivers/s390/block/dasd.c    |    2
 drivers/scsi/sd.c            |    8 -
 include/linux/blkdev.h       |   59 +++-------
 include/linux/elevator.h     |    6 -
 18 files changed, 154 insertions(+), 315 deletions(-)

Index: work/block/blk-barrier.c
===================================================================
--- work.orig/block/blk-barrier.c
+++ work/block/blk-barrier.c
@@ -9,6 +9,8 @@

 #include "blk.h"

+static struct request *queue_next_ordseq(struct request_queue *q);
+
 /**
  * blk_queue_ordered - does this queue support ordered writes
  * @q:        the request queue
@@ -31,13 +33,8 @@ int blk_queue_ordered(struct request_que
 		return -EINVAL;
 	}

-	if (ordered != QUEUE_ORDERED_NONE &&
-	    ordered != QUEUE_ORDERED_DRAIN &&
-	    ordered != QUEUE_ORDERED_DRAIN_FLUSH &&
-	    ordered != QUEUE_ORDERED_DRAIN_FUA &&
-	    ordered != QUEUE_ORDERED_TAG &&
-	    ordered != QUEUE_ORDERED_TAG_FLUSH &&
-	    ordered != QUEUE_ORDERED_TAG_FUA) {
+	if (ordered != QUEUE_ORDERED_NONE && ordered != QUEUE_ORDERED_BAR &&
+	    ordered != QUEUE_ORDERED_FLUSH && ordered != QUEUE_ORDERED_FUA) {
 		printk(KERN_ERR "blk_queue_ordered: bad value %d\n", ordered);
 		return -EINVAL;
 	}
@@ -60,38 +57,10 @@ unsigned blk_ordered_cur_seq(struct requ
 	return 1 << ffz(q->ordseq);
 }

-unsigned blk_ordered_req_seq(struct request *rq)
+static struct request *blk_ordered_complete_seq(struct request_queue *q,
+						unsigned seq, int error)
 {
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
-	if (!blk_fs_request(rq))
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
-{
-	struct request *rq;
+	struct request *rq = NULL;

 	if (error && !q->orderr)
 		q->orderr = error;
@@ -99,16 +68,22 @@ bool blk_ordered_complete_seq(struct req
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
+		rq = queue_next_ordseq(q);
+	} else {
+		/* complete this barrier request */
+		__blk_end_request_all(q->orig_bar_rq, q->orderr);
+		q->orig_bar_rq = NULL;
+		q->ordseq = 0;
+
+		/* dispatch the next barrier if there's one */
+		if (!list_empty(&q->pending_barriers)) {
+			rq = list_entry_rq(q->pending_barriers.next);
+			list_move(&rq->queuelist, &q->queue_head);
+		}
+	}
+	return rq;
 }

 static void pre_flush_end_io(struct request *rq, int error)
@@ -129,21 +104,10 @@ static void post_flush_end_io(struct req
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
-	rq->cmd_flags = REQ_HARDBARRIER;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
 	q->prepare_flush_fn(q, rq);
@@ -151,130 +115,93 @@ static void queue_flush(struct request_q
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }

-static inline bool start_ordered(struct request_queue *q, struct request **rqp)
+static struct request *queue_next_ordseq(struct request_queue *q)
 {
-	struct request *rq = *rqp;
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
-	if (!blk_rq_sectors(rq)) {
-		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
-				QUEUE_ORDERED_DO_POSTFLUSH);
-		/*
-		 * Empty barrier on a write-through device w/ ordered
-		 * tag has no command to issue and without any command
-		 * to issue, ordering by tag can't be used.  Drain
-		 * instead.
-		 */
-		if ((q->ordered & QUEUE_ORDERED_BY_TAG) &&
-		    !(q->ordered & QUEUE_ORDERED_DO_PREFLUSH))
-			q->ordered &= ~QUEUE_ORDERED_BY_TAG;
-	}
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
-		if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
-			rq->cmd_flags |= REQ_RW;
+		init_request_from_bio(rq, q->orig_bar_rq->bio);
+		rq->cmd_flags &= ~REQ_HARDBARRIER;
 		if (q->ordered & QUEUE_ORDERED_DO_FUA)
 			rq->cmd_flags |= REQ_FUA;
-		init_request_from_bio(rq, q->orig_bar_rq->bio);
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

-	if (!(q->ordered & QUEUE_ORDERED_BY_TAG) && queue_in_flight(q))
-		rq = NULL;
-	else
-		skip |= QUEUE_ORDSEQ_DRAIN;
-
-	*rqp = rq;
-
-	/*
-	 * Complete skipped sequences.  If whole sequence is complete,
-	 * return false to tell elevator that this request is gone.
-	 */
-	return !blk_ordered_complete_seq(q, skip, 0);
+	default:
+		BUG();
+	}
+	return rq;
 }

-bool blk_do_ordered(struct request_queue *q, struct request **rqp)
+struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
 {
-	struct request *rq = *rqp;
-	const int is_barrier = blk_fs_request(rq) && blk_barrier_rq(rq);
+	unsigned skip = 0;

-	if (!q->ordseq) {
-		if (!is_barrier)
-			return true;
-
-		if (q->next_ordered != QUEUE_ORDERED_NONE)
-			return start_ordered(q, rqp);
-		else {
-			/*
-			 * Queue ordering not supported.  Terminate
-			 * with prejudice.
-			 */
-			blk_dequeue_request(rq);
-			__blk_end_request_all(rq, -EOPNOTSUPP);
-			*rqp = NULL;
-			return false;
-		}
+	if (!blk_barrier_rq(rq))
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
-	if (!blk_fs_request(rq) &&
-	    rq != &q->pre_flush_rq && rq != &q->post_flush_rq)
-		return true;
-
-	if (q->ordered & QUEUE_ORDERED_BY_TAG) {
-		/* Ordered by tag.  Blocking the next barrier is enough. */
-		if (is_barrier && rq != &q->bar_rq)
-			*rqp = NULL;
-	} else {
-		/* Ordered by draining.  Wait for turn. */
-		WARN_ON(blk_ordered_req_seq(rq) < blk_ordered_cur_seq(q));
-		if (blk_ordered_req_seq(rq) > blk_ordered_cur_seq(q))
-			*rqp = NULL;
-	}
+	/*
+	 * For an empty barrier, there's no actual BAR request, which
+	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
+	 */
+	if (!blk_rq_sectors(rq))
+		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
+				QUEUE_ORDERED_DO_POSTFLUSH);
+
+	/* stash away the original request */
+	blk_dequeue_request(rq);
+	q->orig_bar_rq = rq;
+
+	if (!(q->ordered & QUEUE_ORDERED_DO_PREFLUSH))
+		skip |= QUEUE_ORDSEQ_PREFLUSH;
+
+	if (!(q->ordered & QUEUE_ORDERED_DO_BAR))
+		skip |= QUEUE_ORDSEQ_BAR;
+
+	if (!(q->ordered & QUEUE_ORDERED_DO_POSTFLUSH))
+		skip |= QUEUE_ORDSEQ_POSTFLUSH;

-	return true;
+	/* complete skipped sequences and return the first sequence */
+	return blk_ordered_complete_seq(q, skip, 0);
 }

 static void bio_end_empty_barrier(struct bio *bio, int err)
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -106,7 +106,6 @@ enum rq_flag_bits {
 	__REQ_FAILED,		/* set if the request failed */
 	__REQ_QUIET,		/* don't worry about errors */
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
-	__REQ_ORDERED_COLOR,	/* is before or after barrier */
 	__REQ_RW_SYNC,		/* request is sync (sync write or read) */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
@@ -135,7 +134,6 @@ enum rq_flag_bits {
 #define REQ_FAILED	(1 << __REQ_FAILED)
 #define REQ_QUIET	(1 << __REQ_QUIET)
 #define REQ_PREEMPT	(1 << __REQ_PREEMPT)
-#define REQ_ORDERED_COLOR	(1 << __REQ_ORDERED_COLOR)
 #define REQ_RW_SYNC	(1 << __REQ_RW_SYNC)
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
@@ -437,9 +435,10 @@ struct request_queue
 	 * reserved for flush operations
 	 */
 	unsigned int		ordered, next_ordered, ordseq;
-	int			orderr, ordcolor;
-	struct request		pre_flush_rq, bar_rq, post_flush_rq;
-	struct request		*orig_bar_rq;
+	int			orderr;
+	struct request		bar_rq;
+	struct request          *orig_bar_rq;
+	struct list_head	pending_barriers;

 	struct mutex		sysfs_lock;

@@ -543,47 +542,33 @@ enum {
 	 * Hardbarrier is supported with one of the following methods.
 	 *
 	 * NONE		: hardbarrier unsupported
-	 * DRAIN	: ordering by draining is enough
-	 * DRAIN_FLUSH	: ordering by draining w/ pre and post flushes
-	 * DRAIN_FUA	: ordering by draining w/ pre flush and FUA write
-	 * TAG		: ordering by tag is enough
-	 * TAG_FLUSH	: ordering by tag w/ pre and post flushes
-	 * TAG_FUA	: ordering by tag w/ pre flush and FUA write
-	 */
-	QUEUE_ORDERED_BY_TAG		= 0x02,
-	QUEUE_ORDERED_DO_PREFLUSH	= 0x10,
-	QUEUE_ORDERED_DO_BAR		= 0x20,
-	QUEUE_ORDERED_DO_POSTFLUSH	= 0x40,
-	QUEUE_ORDERED_DO_FUA		= 0x80,
+	 * BAR		: writing out barrier is enough
+	 * FLUSH	: barrier and surrounding pre and post flushes
+	 * FUA		: FUA barrier w/ pre flush
+	 */
+	QUEUE_ORDERED_DO_PREFLUSH	= 1 << 0,
+	QUEUE_ORDERED_DO_BAR		= 1 << 1,
+	QUEUE_ORDERED_DO_POSTFLUSH	= 1 << 2,
+	QUEUE_ORDERED_DO_FUA		= 1 << 3,

-	QUEUE_ORDERED_NONE		= 0x00,
+	QUEUE_ORDERED_NONE		= 0,

-	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_DO_BAR,
-	QUEUE_ORDERED_DRAIN_FLUSH	= QUEUE_ORDERED_DRAIN |
+	QUEUE_ORDERED_BAR		= QUEUE_ORDERED_DO_BAR,
+	QUEUE_ORDERED_FLUSH		= QUEUE_ORDERED_DO_BAR |
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_POSTFLUSH,
-	QUEUE_ORDERED_DRAIN_FUA		= QUEUE_ORDERED_DRAIN |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_FUA,
-
-	QUEUE_ORDERED_TAG		= QUEUE_ORDERED_BY_TAG |
-					  QUEUE_ORDERED_DO_BAR,
-	QUEUE_ORDERED_TAG_FLUSH		= QUEUE_ORDERED_TAG |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_POSTFLUSH,
-	QUEUE_ORDERED_TAG_FUA		= QUEUE_ORDERED_TAG |
+	QUEUE_ORDERED_FUA		= QUEUE_ORDERED_DO_BAR |
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_FUA,

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
@@ -965,10 +950,8 @@ extern void blk_queue_rq_timed_out(struc
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
-extern bool blk_do_ordered(struct request_queue *, struct request **);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
 extern unsigned blk_ordered_req_seq(struct request *);
-extern bool blk_ordered_complete_seq(struct request_queue *, unsigned, int);

 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
Index: work/drivers/block/brd.c
===================================================================
--- work.orig/drivers/block/brd.c
+++ work/drivers/block/brd.c
@@ -479,7 +479,7 @@ static struct brd_device *brd_alloc(int
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
-	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG, NULL);
+	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_BAR, NULL);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);

Index: work/drivers/block/virtio_blk.c
===================================================================
--- work.orig/drivers/block/virtio_blk.c
+++ work/drivers/block/virtio_blk.c
@@ -368,10 +368,10 @@ static int __devinit virtblk_probe(struc

 	/* If barriers are supported, tell block layer that queue is ordered */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH,
+		blk_queue_ordered(q, QUEUE_ORDERED_FLUSH,
 				  virtblk_prepare_flush);
 	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
-		blk_queue_ordered(q, QUEUE_ORDERED_TAG, NULL);
+		blk_queue_ordered(q, QUEUE_ORDERED_BAR, NULL);

 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
Index: work/drivers/scsi/sd.c
===================================================================
--- work.orig/drivers/scsi/sd.c
+++ work/drivers/scsi/sd.c
@@ -2103,15 +2103,13 @@ static int sd_revalidate_disk(struct gen

 	/*
 	 * We now have all cache related info, determine how we deal
-	 * with ordered requests.  Note that as the current SCSI
-	 * dispatch function can alter request order, we cannot use
-	 * QUEUE_ORDERED_TAG_* even when ordered tag is supported.
+	 * with ordered requests.
 	 */
 	if (sdkp->WCE)
 		ordered = sdkp->DPOFUA
-			? QUEUE_ORDERED_DRAIN_FUA : QUEUE_ORDERED_DRAIN_FLUSH;
+			? QUEUE_ORDERED_FUA : QUEUE_ORDERED_FLUSH;
 	else
-		ordered = QUEUE_ORDERED_DRAIN;
+		ordered = QUEUE_ORDERED_BAR;

 	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -520,6 +520,7 @@ struct request_queue *blk_alloc_queue_no
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
+	INIT_LIST_HEAD(&q->pending_barriers);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);

 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -1036,22 +1037,6 @@ void blk_insert_request(struct request_q
 }
 EXPORT_SYMBOL(blk_insert_request);

-/*
- * add-request adds a request to the linked list.
- * queue lock is held and interrupts disabled, as we muck with the
- * request queue list.
- */
-static inline void add_request(struct request_queue *q, struct request *req)
-{
-	drive_stat_acct(req, 1);
-
-	/*
-	 * elevator indicated where it wants this request to be
-	 * inserted at elevator_merge time
-	 */
-	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
-}
-
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
@@ -1184,6 +1169,7 @@ static int __make_request(struct request
 	const bool sync = bio_rw_flagged(bio, BIO_RW_SYNCIO);
 	const bool unplug = bio_rw_flagged(bio, BIO_RW_UNPLUG);
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+	int where = ELEVATOR_INSERT_SORT;
 	int rw_flags;

 	if (bio_rw_flagged(bio, BIO_RW_BARRIER) &&
@@ -1191,6 +1177,7 @@ static int __make_request(struct request
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
+
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1200,7 +1187,12 @@ static int __make_request(struct request

 	spin_lock_irq(q->queue_lock);

-	if (unlikely(bio_rw_flagged(bio, BIO_RW_BARRIER)) || elv_queue_empty(q))
+	if (bio_rw_flagged(bio, BIO_RW_BARRIER)) {
+		where = ELEVATOR_INSERT_ORDERED;
+		goto get_rq;
+	}
+
+	if (elv_queue_empty(q))
 		goto get_rq;

 	el_ret = elv_merge(q, &req, bio);
@@ -1297,7 +1289,10 @@ get_rq:
 		req->cpu = blk_cpu_to_group(smp_processor_id());
 	if (queue_should_plug(q) && elv_queue_empty(q))
 		blk_plug_device(q);
-	add_request(q, req);
+
+	/* insert the request into the elevator */
+	drive_stat_acct(req, 1);
+	__elv_add_request(q, req, where, 0);
 out:
 	if (unplug || !queue_should_plug(q))
 		__generic_unplug_device(q);
Index: work/block/elevator.c
===================================================================
--- work.orig/block/elevator.c
+++ work/block/elevator.c
@@ -564,7 +564,7 @@ void elv_requeue_request(struct request_

 	rq->cmd_flags &= ~REQ_STARTED;

-	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
+	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }

 void elv_drain_elevator(struct request_queue *q)
@@ -611,8 +611,6 @@ void elv_quiesce_end(struct request_queu

 void elv_insert(struct request_queue *q, struct request *rq, int where)
 {
-	struct list_head *pos;
-	unsigned ordseq;
 	int unplug_it = 1;

 	trace_block_rq_insert(q, rq);
@@ -622,10 +620,14 @@ void elv_insert(struct request_queue *q,
 	switch (where) {
 	case ELEVATOR_INSERT_FRONT:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
-
 		list_add(&rq->queuelist, &q->queue_head);
 		break;

+	case ELEVATOR_INSERT_ORDERED:
+		rq->cmd_flags |= REQ_SOFTBARRIER;
+		list_add_tail(&rq->queuelist, &q->queue_head);
+		break;
+
 	case ELEVATOR_INSERT_BACK:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
 		elv_drain_elevator(q);
@@ -661,36 +663,6 @@ void elv_insert(struct request_queue *q,
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
@@ -709,32 +681,14 @@ void elv_insert(struct request_queue *q,
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
-		if (blk_barrier_rq(rq))
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
 		if (blk_fs_request(rq) || blk_discard_rq(rq)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
 	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
-		    where == ELEVATOR_INSERT_SORT)
+		   where == ELEVATOR_INSERT_SORT)
 		where = ELEVATOR_INSERT_BACK;

 	if (plug)
@@ -846,24 +800,6 @@ void elv_completed_request(struct reques
 		if (blk_sorted_rq(rq) && e->ops->elevator_completed_req_fn)
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
Index: work/block/blk.h
===================================================================
--- work.orig/block/blk.h
+++ work/block/blk.h
@@ -51,6 +51,8 @@ static inline void blk_clear_rq_complete
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))

+struct request *blk_do_ordered(struct request_queue *q, struct request *rq);
+
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
@@ -58,7 +60,8 @@ static inline struct request *__elv_next
 	while (1) {
 		while (!list_empty(&q->queue_head)) {
 			rq = list_entry_rq(q->queue_head.next);
-			if (blk_do_ordered(q, &rq))
+			rq = blk_do_ordered(q, rq);
+			if (rq)
 				return rq;
 		}

Index: work/drivers/block/loop.c
===================================================================
--- work.orig/drivers/block/loop.c
+++ work/drivers/block/loop.c
@@ -831,7 +831,7 @@ static int loop_set_fd(struct loop_devic
 	lo->lo_queue->unplug_fn = loop_unplug;

 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_BAR, NULL);

 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
Index: work/drivers/block/osdblk.c
===================================================================
--- work.orig/drivers/block/osdblk.c
+++ work/drivers/block/osdblk.c
@@ -446,7 +446,7 @@ static int osdblk_init_disk(struct osdbl
 	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));

 	blk_queue_prep_rq(q, blk_queue_start_tag);
-	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);
+	blk_queue_ordered(q, QUEUE_ORDERED_FLUSH, osdblk_prepare_flush);

 	disk->queue = q;

Index: work/drivers/block/ps3disk.c
===================================================================
--- work.orig/drivers/block/ps3disk.c
+++ work/drivers/block/ps3disk.c
@@ -480,8 +480,7 @@ static int __devinit ps3disk_probe(struc
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);

-	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH,
-			  ps3disk_prepare_flush);
+	blk_queue_ordered(queue, QUEUE_ORDERED_FLUSH, ps3disk_prepare_flush);

 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
Index: work/drivers/block/xen-blkfront.c
===================================================================
--- work.orig/drivers/block/xen-blkfront.c
+++ work/drivers/block/xen-blkfront.c
@@ -373,7 +373,7 @@ static int xlvbd_barrier(struct blkfront
 	int err;

 	err = blk_queue_ordered(info->rq,
-				info->feature_barrier ? QUEUE_ORDERED_DRAIN : QUEUE_ORDERED_NONE,
+				info->feature_barrier ? QUEUE_ORDERED_BAR : QUEUE_ORDERED_NONE,
 				NULL);

 	if (err)
Index: work/drivers/ide/ide-disk.c
===================================================================
--- work.orig/drivers/ide/ide-disk.c
+++ work/drivers/ide/ide-disk.c
@@ -537,11 +537,11 @@ static void update_ordered(ide_drive_t *
 		       drive->name, barrier ? "" : "not ");

 		if (barrier) {
-			ordered = QUEUE_ORDERED_DRAIN_FLUSH;
+			ordered = QUEUE_ORDERED_FLUSH;
 			prep_fn = idedisk_prepare_flush;
 		}
 	} else
-		ordered = QUEUE_ORDERED_DRAIN;
+		ordered = QUEUE_ORDERED_BAR;

 	blk_queue_ordered(drive->queue, ordered, prep_fn);
 }
Index: work/drivers/md/dm.c
===================================================================
--- work.orig/drivers/md/dm.c
+++ work/drivers/md/dm.c
@@ -1912,8 +1912,7 @@ static struct mapped_device *alloc_dev(i
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
-			  dm_rq_prepare_flush);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_FLUSH, dm_rq_prepare_flush);

 	md->disk = alloc_disk(1);
 	if (!md->disk)
Index: work/drivers/mmc/card/queue.c
===================================================================
--- work.orig/drivers/mmc/card/queue.c
+++ work/drivers/mmc/card/queue.c
@@ -128,7 +128,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 	mq->req = NULL;

 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
+	blk_queue_ordered(mq->queue, QUEUE_ORDERED_BAR, NULL);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);

 #ifdef CONFIG_MMC_BLOCK_BOUNCE
Index: work/drivers/s390/block/dasd.c
===================================================================
--- work.orig/drivers/s390/block/dasd.c
+++ work/drivers/s390/block/dasd.c
@@ -2196,7 +2196,7 @@ static void dasd_setup_queue(struct dasd
 	 */
 	blk_queue_max_segment_size(block->request_queue, PAGE_SIZE);
 	blk_queue_segment_boundary(block->request_queue, PAGE_SIZE - 1);
-	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN, NULL);
+	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_BAR, NULL);
 }

 /*
Index: work/include/linux/elevator.h
===================================================================
--- work.orig/include/linux/elevator.h
+++ work/include/linux/elevator.h
@@ -162,9 +162,9 @@ extern struct request *elv_rb_find(struc
  * Insertion selection
  */
 #define ELEVATOR_INSERT_FRONT	1
-#define ELEVATOR_INSERT_BACK	2
-#define ELEVATOR_INSERT_SORT	3
-#define ELEVATOR_INSERT_REQUEUE	4
+#define ELEVATOR_INSERT_ORDERED	2
+#define ELEVATOR_INSERT_BACK	3
+#define ELEVATOR_INSERT_SORT	4

 /*
  * return values from elevator_may_queue_fn
Index: work/drivers/block/pktcdvd.c
===================================================================
--- work.orig/drivers/block/pktcdvd.c
+++ work/drivers/block/pktcdvd.c
@@ -752,7 +752,6 @@ static int pkt_generic_packet(struct pkt

 	rq->timeout = 60*HZ;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_HARDBARRIER;
 	if (cgc->quiet)
 		rq->cmd_flags |= REQ_QUIET;

