From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH REPOST RFC] relaxed barriers
Date: Sun, 8 Aug 2010 16:31:26 +0200
Message-ID: <20100808143126.GA15531@lst.de>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100803184939.GA12198@lst.de> <4C5C3287.1010404@kernel.org> <4C5D31B2.9080509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58281 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab0HHOb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Aug 2010 10:31:59 -0400
Content-Disposition: inline
In-Reply-To: <4C5D31B2.9080509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <teheo@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, linux-raid@vger.kernel.org

On Sat, Aug 07, 2010 at 12:13:06PM +0200, Tejun Heo wrote:
> The patch was on top of v2.6.35 but was generated against dirty tree
> and wouldn't apply cleanly.  Here's the proper one.

Here's an updated version:

 (a) ported to Jens' current block tree
 (b) optimize barriers on devices not requiring flushes to be no-ops
 (b) redo the blk_queue_ordered interface to just set QUEUE_HAS_FLUSH
     and QUEUE_HAS_FUA flags.

Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2010-08-07 12:53:23.727479189 -0400
+++ linux-2.6/block/blk-barrier.c	2010-08-07 14:52:21.402479191 -0400
@@ -9,37 +9,36 @@
 
 #include "blk.h"
 
+/*
+ * Ordered operation sequence.
+ */
+enum {
+	QUEUE_ORDSEQ_STARTED	= (1 << 0), /* flushing in progress */
+	QUEUE_ORDSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
+	QUEUE_ORDSEQ_BAR	= (1 << 2), /* barrier write in progress */
+	QUEUE_ORDSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
+	QUEUE_ORDSEQ_DONE	= (1 << 4),
+};
+
+static struct request *queue_next_ordseq(struct request_queue *q);
+
 /**
- * blk_queue_ordered - does this queue support ordered writes
- * @q:        the request queue
- * @ordered:  one of QUEUE_ORDERED_*
- *
- * Description:
- *   For journalled file systems, doing ordered writes on a commit
- *   block instead of explicitly doing wait_on_buffer (which is bad
- *   for performance) can be a big win. Block drivers supporting this
- *   feature should call this function and indicate so.
- *
+ * blk_queue_cache_features - set the supported cache control features
+ * @q:        		the request queue
+ * @cache_features:	the support features
  **/
-int blk_queue_ordered(struct request_queue *q, unsigned ordered)
+int blk_queue_cache_features(struct request_queue *q, unsigned cache_features)
 {
-	if (ordered != QUEUE_ORDERED_NONE &&
-	    ordered != QUEUE_ORDERED_DRAIN &&
-	    ordered != QUEUE_ORDERED_DRAIN_FLUSH &&
-	    ordered != QUEUE_ORDERED_DRAIN_FUA &&
-	    ordered != QUEUE_ORDERED_TAG &&
-	    ordered != QUEUE_ORDERED_TAG_FLUSH &&
-	    ordered != QUEUE_ORDERED_TAG_FUA) {
-		printk(KERN_ERR "blk_queue_ordered: bad value %d\n", ordered);
+	if (cache_features & ~(QUEUE_HAS_FLUSH|QUEUE_HAS_FUA)) {
+		printk(KERN_ERR "blk_queue_cache_features: bad value %d\n",
+			cache_features);
 		return -EINVAL;
 	}
 
-	q->ordered = ordered;
-	q->next_ordered = ordered;
-
+	q->cache_features = cache_features;
 	return 0;
 }
-EXPORT_SYMBOL(blk_queue_ordered);
+EXPORT_SYMBOL(blk_queue_cache_features);
 
 /*
  * Cache flushing for ordered writes handling
@@ -51,38 +50,10 @@ unsigned blk_ordered_cur_seq(struct requ
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
+	struct request *rq = NULL;
 
 	if (error && !q->orderr)
 		q->orderr = error;
@@ -90,16 +61,22 @@ bool blk_ordered_complete_seq(struct req
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
@@ -120,155 +97,100 @@ static void post_flush_end_io(struct req
 	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_POSTFLUSH, error);
 }
 
-static void queue_flush(struct request_queue *q, unsigned which)
+static void init_flush_request(struct request_queue *q, struct request *rq)
 {
-	struct request *rq;
-	rq_end_io_fn *end_io;
+	rq->cmd_type = REQ_TYPE_FS;
+	rq->cmd_flags = REQ_FLUSH;
+	rq->rq_disk = q->orig_bar_rq->rq_disk;
+}
 
-	if (which == QUEUE_ORDERED_DO_PREFLUSH) {
-		rq = &q->pre_flush_rq;
-		end_io = pre_flush_end_io;
-	} else {
-		rq = &q->post_flush_rq;
-		end_io = post_flush_end_io;
-	}
+/*
+ * Initialize proxy request and queue it.
+ */
+static struct request *queue_next_ordseq(struct request_queue *q)
+{
+	struct request *rq = &q->bar_rq;
 
 	blk_rq_init(q, rq);
-	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
-	rq->rq_disk = q->orig_bar_rq->rq_disk;
-	rq->end_io = end_io;
+
+	switch (blk_ordered_cur_seq(q)) {
+	case QUEUE_ORDSEQ_PREFLUSH:
+		init_flush_request(q, rq);
+		rq->end_io = pre_flush_end_io;
+		break;
+	case QUEUE_ORDSEQ_BAR:
+		init_request_from_bio(rq, q->orig_bar_rq->bio);
+		rq->cmd_flags &= ~REQ_HARDBARRIER;
+ 		if (q->cache_features & QUEUE_HAS_FUA)
+ 			rq->cmd_flags |= REQ_FUA;
+		rq->end_io = bar_end_io;
+		break;
+	case QUEUE_ORDSEQ_POSTFLUSH:
+		init_flush_request(q, rq);
+		rq->end_io = post_flush_end_io;
+		break;
+	default:
+		BUG();
+	}
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	return rq;
 }
 
-static inline bool start_ordered(struct request_queue *q, struct request **rqp)
+struct request *blk_do_ordered(struct request_queue *q, struct request *rq)
 {
-	struct request *rq = *rqp;
 	unsigned skip = 0;
 
-	q->orderr = 0;
-	q->ordered = q->next_ordered;
-	q->ordseq |= QUEUE_ORDSEQ_STARTED;
+	if (rq->cmd_type != REQ_TYPE_FS)
+		return rq;
+	if (!(rq->cmd_flags & REQ_HARDBARRIER))
+		return rq;
 
-	/*
-	 * For an empty barrier, there's no actual BAR request, which
-	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
-	 */
-	if (!blk_rq_sectors(rq)) {
-		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
-				QUEUE_ORDERED_DO_POSTFLUSH);
+	if (!(q->cache_features & QUEUE_HAS_FLUSH)) {
 		/*
-		 * Empty barrier on a write-through device w/ ordered
-		 * tag has no command to issue and without any command
-		 * to issue, ordering by tag can't be used.  Drain
-		 * instead.
+		 * No flush required.  We can just send on write requests
+		 * and complete cache flush requests ASAP.
 		 */
-		if ((q->ordered & QUEUE_ORDERED_BY_TAG) &&
-		    !(q->ordered & QUEUE_ORDERED_DO_PREFLUSH)) {
-			q->ordered &= ~QUEUE_ORDERED_BY_TAG;
-			q->ordered |= QUEUE_ORDERED_BY_DRAIN;
+		if (blk_rq_sectors(rq)) {
+			rq->cmd_flags &= ~REQ_HARDBARRIER;
+			return rq;
 		}
+		blk_dequeue_request(rq);
+		__blk_end_request_all(rq, 0);
+		return NULL;
 	}
 
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
-
-	if (q->ordered & QUEUE_ORDERED_DO_BAR) {
-		rq = &q->bar_rq;
-
-		/* initialize proxy request and queue it */
-		blk_rq_init(q, rq);
-		if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
-			rq->cmd_flags |= REQ_WRITE;
-		if (q->ordered & QUEUE_ORDERED_DO_FUA)
-			rq->cmd_flags |= REQ_FUA;
-		init_request_from_bio(rq, q->orig_bar_rq->bio);
-		rq->end_io = bar_end_io;
-
-		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
-	} else
-		skip |= QUEUE_ORDSEQ_BAR;
-
-	if (q->ordered & QUEUE_ORDERED_DO_PREFLUSH) {
-		queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH);
-		rq = &q->pre_flush_rq;
-	} else
-		skip |= QUEUE_ORDSEQ_PREFLUSH;
-
-	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q))
-		rq = NULL;
-	else
-		skip |= QUEUE_ORDSEQ_DRAIN;
+	if (q->ordseq) {
+		/*
+		 * Barrier is already in progress and they can't be
+		 * processed in parallel.  Queue for later processing.
+		 */
+		list_move_tail(&rq->queuelist, &q->pending_barriers);
+		return NULL;
+	}
 
-	*rqp = rq;
 
 	/*
-	 * Complete skipped sequences.  If whole sequence is complete,
-	 * return false to tell elevator that this request is gone.
+	 * Start a new ordered sequence
 	 */
-	return !blk_ordered_complete_seq(q, skip, 0);
-}
-
-bool blk_do_ordered(struct request_queue *q, struct request **rqp)
-{
-	struct request *rq = *rqp;
-	const int is_barrier = rq->cmd_type == REQ_TYPE_FS &&
-				(rq->cmd_flags & REQ_HARDBARRIER);
-
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
-	}
+	q->orderr = 0;
+	q->ordseq |= QUEUE_ORDSEQ_STARTED;
 
 	/*
-	 * Ordered sequence in progress
+	 * For an empty barrier, there's no actual BAR request, which
+	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
 	 */
+	if (!blk_rq_sectors(rq))
+		skip |= (QUEUE_ORDSEQ_BAR|QUEUE_ORDSEQ_POSTFLUSH);
+	else if (q->cache_features & QUEUE_HAS_FUA)
+		skip |= QUEUE_ORDSEQ_POSTFLUSH;
 
-	/* Special requests are not subject to ordering rules. */
-	if (rq->cmd_type != REQ_TYPE_FS &&
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
+	/* stash away the original request */
+	blk_dequeue_request(rq);
+	q->orig_bar_rq = rq;
 
-	return true;
+	/* complete skipped sequences and return the first sequence */
+	return blk_ordered_complete_seq(q, skip, 0);
 }
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2010-08-07 12:53:23.774479189 -0400
+++ linux-2.6/include/linux/blkdev.h	2010-08-07 14:51:42.751479190 -0400
@@ -354,13 +354,20 @@ struct request_queue
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace	*blk_trace;
 #endif
+
+	/*
+	 * Features this queue understands.
+	 */
+	unsigned int		cache_features;
+
 	/*
 	 * reserved for flush operations
 	 */
-	unsigned int		ordered, next_ordered, ordseq;
-	int			orderr, ordcolor;
-	struct request		pre_flush_rq, bar_rq, post_flush_rq;
-	struct request		*orig_bar_rq;
+	unsigned int		ordseq;
+	int			orderr;
+	struct request		bar_rq;
+	struct request          *orig_bar_rq;
+	struct list_head	pending_barriers;
 
 	struct mutex		sysfs_lock;
 
@@ -461,54 +468,12 @@ static inline void queue_flag_clear(unsi
 	__clear_bit(flag, &q->queue_flags);
 }
 
+/*
+ * Possible features to control a volatile write cache.
+ */
 enum {
-	/*
-	 * Hardbarrier is supported with one of the following methods.
-	 *
-	 * NONE		: hardbarrier unsupported
-	 * DRAIN	: ordering by draining is enough
-	 * DRAIN_FLUSH	: ordering by draining w/ pre and post flushes
-	 * DRAIN_FUA	: ordering by draining w/ pre flush and FUA write
-	 * TAG		: ordering by tag is enough
-	 * TAG_FLUSH	: ordering by tag w/ pre and post flushes
-	 * TAG_FUA	: ordering by tag w/ pre flush and FUA write
-	 */
-	QUEUE_ORDERED_BY_DRAIN		= 0x01,
-	QUEUE_ORDERED_BY_TAG		= 0x02,
-	QUEUE_ORDERED_DO_PREFLUSH	= 0x10,
-	QUEUE_ORDERED_DO_BAR		= 0x20,
-	QUEUE_ORDERED_DO_POSTFLUSH	= 0x40,
-	QUEUE_ORDERED_DO_FUA		= 0x80,
-
-	QUEUE_ORDERED_NONE		= 0x00,
-
-	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_BY_DRAIN |
-					  QUEUE_ORDERED_DO_BAR,
-	QUEUE_ORDERED_DRAIN_FLUSH	= QUEUE_ORDERED_DRAIN |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_POSTFLUSH,
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
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_FUA,
-
-	/*
-	 * Ordered operation sequence
-	 */
-	QUEUE_ORDSEQ_STARTED	= 0x01,	/* flushing in progress */
-	QUEUE_ORDSEQ_DRAIN	= 0x02,	/* waiting for the queue to be drained */
-	QUEUE_ORDSEQ_PREFLUSH	= 0x04,	/* pre-flushing in progress */
-	QUEUE_ORDSEQ_BAR	= 0x08,	/* original barrier req in progress */
-	QUEUE_ORDSEQ_POSTFLUSH	= 0x10,	/* post-flushing in progress */
-	QUEUE_ORDSEQ_DONE	= 0x20,
+	QUEUE_HAS_FLUSH		= 1 << 0,	/* supports REQ_FLUSH */
+	QUEUE_HAS_FUA		= 1 << 1,	/* supports REQ_FUA */
 };
 
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
@@ -879,11 +844,9 @@ extern void blk_queue_softirq_done(struc
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
-extern int blk_queue_ordered(struct request_queue *, unsigned);
-extern bool blk_do_ordered(struct request_queue *, struct request **);
+extern int blk_queue_cache_features(struct request_queue *, unsigned);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
 extern unsigned blk_ordered_req_seq(struct request *);
-extern bool blk_ordered_complete_seq(struct request_queue *, unsigned, int);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2010-08-07 12:53:23.800479189 -0400
+++ linux-2.6/drivers/block/virtio_blk.c	2010-08-07 14:51:34.198479189 -0400
@@ -388,31 +388,8 @@ static int __devinit virtblk_probe(struc
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH)) {
-		/*
-		 * If the FLUSH feature is supported we do have support for
-		 * flushing a volatile write cache on the host.  Use that
-		 * to implement write barrier support.
-		 */
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
-	} else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER)) {
-		/*
-		 * If the BARRIER feature is supported the host expects us
-		 * to order request by tags.  This implies there is not
-		 * volatile write cache on the host, and that the host
-		 * never re-orders outstanding I/O.  This feature is not
-		 * useful for real life scenarious and deprecated.
-		 */
-		blk_queue_ordered(q, QUEUE_ORDERED_TAG);
-	} else {
-		/*
-		 * If the FLUSH feature is not supported we must assume that
-		 * the host does not perform any kind of volatile write
-		 * caching. We still need to drain the queue to provider
-		 * proper barrier semantics.
-		 */
-		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN);
-	}
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+		blk_queue_cache_features(q, QUEUE_HAS_FLUSH);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c	2010-08-07 12:53:23.872479189 -0400
+++ linux-2.6/drivers/scsi/sd.c	2010-08-07 14:54:47.812479189 -0400
@@ -2109,7 +2109,7 @@ static int sd_revalidate_disk(struct gen
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
-	unsigned ordered;
+	unsigned ordered = 0;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2151,17 +2151,14 @@ static int sd_revalidate_disk(struct gen
 
 	/*
 	 * We now have all cache related info, determine how we deal
-	 * with ordered requests.  Note that as the current SCSI
-	 * dispatch function can alter request order, we cannot use
-	 * QUEUE_ORDERED_TAG_* even when ordered tag is supported.
+	 * with barriers.
 	 */
-	if (sdkp->WCE)
-		ordered = sdkp->DPOFUA
-			? QUEUE_ORDERED_DRAIN_FUA : QUEUE_ORDERED_DRAIN_FLUSH;
-	else
-		ordered = QUEUE_ORDERED_DRAIN;
-
-	blk_queue_ordered(sdkp->disk->queue, ordered);
+	if (sdkp->WCE) {
+		ordered |= QUEUE_HAS_FLUSH;
+		if (sdkp->DPOFUA)
+			ordered |= QUEUE_HAS_FUA;
+	}
+	blk_queue_cache_features(sdkp->disk->queue, ordered);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2010-08-07 12:53:23.744479189 -0400
+++ linux-2.6/block/blk-core.c	2010-08-07 14:56:35.087479189 -0400
@@ -520,6 +520,7 @@ struct request_queue *blk_alloc_queue_no
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
+	INIT_LIST_HEAD(&q->pending_barriers);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -1037,22 +1038,6 @@ void blk_insert_request(struct request_q
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
@@ -1201,13 +1186,9 @@ static int __make_request(struct request
 	const bool sync = (bio->bi_rw & REQ_SYNC);
 	const bool unplug = (bio->bi_rw & REQ_UNPLUG);
 	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+	int where = ELEVATOR_INSERT_SORT;
 	int rw_flags;
 
-	if ((bio->bi_rw & REQ_HARDBARRIER) &&
-	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
-	}
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1217,7 +1198,12 @@ static int __make_request(struct request
 
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely((bio->bi_rw & REQ_HARDBARRIER)) || elv_queue_empty(q))
+	if (bio->bi_rw & REQ_HARDBARRIER) {
+		where = ELEVATOR_INSERT_ORDERED;
+		goto get_rq;
+	}
+
+	if (elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
@@ -1314,7 +1300,10 @@ get_rq:
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
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2010-08-07 12:53:23.752479189 -0400
+++ linux-2.6/block/elevator.c	2010-08-07 12:53:53.162479190 -0400
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
@@ -662,36 +664,6 @@ void elv_insert(struct request_queue *q,
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
@@ -710,33 +682,15 @@ void elv_insert(struct request_queue *q,
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
 			q->boundary_rq = rq;
 		}
 	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
-		    where == ELEVATOR_INSERT_SORT)
+		   where == ELEVATOR_INSERT_SORT)
 		where = ELEVATOR_INSERT_BACK;
 
 	if (plug)
@@ -849,24 +803,6 @@ void elv_completed_request(struct reques
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
Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h	2010-08-07 12:53:23.762479189 -0400
+++ linux-2.6/block/blk.h	2010-08-07 12:53:53.171479190 -0400
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
 
Index: linux-2.6/drivers/block/xen-blkfront.c
===================================================================
--- linux-2.6.orig/drivers/block/xen-blkfront.c	2010-08-07 12:53:23.807479189 -0400
+++ linux-2.6/drivers/block/xen-blkfront.c	2010-08-07 14:44:39.564479189 -0400
@@ -417,30 +417,6 @@ static int xlvbd_init_blk_queue(struct g
 	return 0;
 }
 
-
-static int xlvbd_barrier(struct blkfront_info *info)
-{
-	int err;
-	const char *barrier;
-
-	switch (info->feature_barrier) {
-	case QUEUE_ORDERED_DRAIN:	barrier = "enabled (drain)"; break;
-	case QUEUE_ORDERED_TAG:		barrier = "enabled (tag)"; break;
-	case QUEUE_ORDERED_NONE:	barrier = "disabled"; break;
-	default:			return -EINVAL;
-	}
-
-	err = blk_queue_ordered(info->rq, info->feature_barrier);
-
-	if (err)
-		return err;
-
-	printk(KERN_INFO "blkfront: %s: barriers %s\n",
-	       info->gd->disk_name, barrier);
-	return 0;
-}
-
-
 static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 			       struct blkfront_info *info,
 			       u16 vdisk_info, u16 sector_size)
@@ -516,8 +492,6 @@ static int xlvbd_alloc_gendisk(blkif_sec
 	info->rq = gd->queue;
 	info->gd = gd;
 
-	xlvbd_barrier(info);
-
 	if (vdisk_info & VDISK_READONLY)
 		set_disk_ro(gd, 1);
 
@@ -662,8 +636,6 @@ static irqreturn_t blkif_interrupt(int i
 				printk(KERN_WARNING "blkfront: %s: write barrier op failed\n",
 				       info->gd->disk_name);
 				error = -EOPNOTSUPP;
-				info->feature_barrier = QUEUE_ORDERED_NONE;
-				xlvbd_barrier(info);
 			}
 			/* fall through */
 		case BLKIF_OP_READ:
@@ -1073,24 +1045,6 @@ static void blkfront_connect(struct blkf
 			    "feature-barrier", "%lu", &barrier,
 			    NULL);
 
-	/*
-	 * If there's no "feature-barrier" defined, then it means
-	 * we're dealing with a very old backend which writes
-	 * synchronously; draining will do what needs to get done.
-	 *
-	 * If there are barriers, then we can do full queued writes
-	 * with tagged barriers.
-	 *
-	 * If barriers are not supported, then there's no much we can
-	 * do, so just set ordering to NONE.
-	 */
-	if (err)
-		info->feature_barrier = QUEUE_ORDERED_DRAIN;
-	else if (barrier)
-		info->feature_barrier = QUEUE_ORDERED_TAG;
-	else
-		info->feature_barrier = QUEUE_ORDERED_NONE;
-
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
 		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
Index: linux-2.6/drivers/ide/ide-disk.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-disk.c	2010-08-07 12:53:23.889479189 -0400
+++ linux-2.6/drivers/ide/ide-disk.c	2010-08-07 15:00:30.215479189 -0400
@@ -518,12 +518,13 @@ static int ide_do_setfeature(ide_drive_t
 
 static void update_ordered(ide_drive_t *drive)
 {
-	u16 *id = drive->id;
-	unsigned ordered = QUEUE_ORDERED_NONE;
+	unsigned ordered = 0;
 
 	if (drive->dev_flags & IDE_DFLAG_WCACHE) {
+		u16 *id = drive->id;
 		unsigned long long capacity;
 		int barrier;
+
 		/*
 		 * We must avoid issuing commands a drive does not
 		 * understand or we may crash it. We check flush cache
@@ -543,13 +544,18 @@ static void update_ordered(ide_drive_t *
 		       drive->name, barrier ? "" : "not ");
 
 		if (barrier) {
-			ordered = QUEUE_ORDERED_DRAIN_FLUSH;
+			printk(KERN_INFO "%s: cache flushes supported\n",
+				drive->name);
 			blk_queue_prep_rq(drive->queue, idedisk_prep_fn);
+			ordered |= QUEUE_HAS_FLUSH;
+		} else {
+			printk(KERN_INFO
+				"%s: WARNING: cache flushes not supported\n",
+				drive->name);
 		}
-	} else
-		ordered = QUEUE_ORDERED_DRAIN;
+	}
 
-	blk_queue_ordered(drive->queue, ordered);
+	blk_queue_cache_features(drive->queue, ordered);
 }
 
 ide_devset_get_flag(wcache, IDE_DFLAG_WCACHE);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2010-08-07 12:53:23.905479189 -0400
+++ linux-2.6/drivers/md/dm.c	2010-08-07 14:51:38.240479189 -0400
@@ -1908,7 +1908,7 @@ static struct mapped_device *alloc_dev(i
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_cache_features(md->queue, QUEUE_HAS_FLUSH);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
Index: linux-2.6/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.orig/drivers/mmc/card/queue.c	2010-08-07 12:53:23.927479189 -0400
+++ linux-2.6/drivers/mmc/card/queue.c	2010-08-07 14:30:09.666479189 -0400
@@ -128,7 +128,6 @@ int mmc_init_queue(struct mmc_queue *mq,
 	mq->req = NULL;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-	blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
Index: linux-2.6/drivers/s390/block/dasd.c
===================================================================
--- linux-2.6.orig/drivers/s390/block/dasd.c	2010-08-07 12:53:23.939479189 -0400
+++ linux-2.6/drivers/s390/block/dasd.c	2010-08-07 14:30:13.307479189 -0400
@@ -2197,7 +2197,6 @@ static void dasd_setup_queue(struct dasd
 	 */
 	blk_queue_max_segment_size(block->request_queue, PAGE_SIZE);
 	blk_queue_segment_boundary(block->request_queue, PAGE_SIZE - 1);
-	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN);
 }
 
 /*
Index: linux-2.6/include/linux/elevator.h
===================================================================
--- linux-2.6.orig/include/linux/elevator.h	2010-08-07 12:53:23.781479189 -0400
+++ linux-2.6/include/linux/elevator.h	2010-08-07 12:53:53.208479190 -0400
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
Index: linux-2.6/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.orig/drivers/block/pktcdvd.c	2010-08-07 12:53:23.815479189 -0400
+++ linux-2.6/drivers/block/pktcdvd.c	2010-08-07 12:53:53.211479190 -0400
@@ -753,7 +753,6 @@ static int pkt_generic_packet(struct pkt
 
 	rq->timeout = 60*HZ;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_HARDBARRIER;
 	if (cgc->quiet)
 		rq->cmd_flags |= REQ_QUIET;
 
Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c	2010-08-07 12:53:23.825479189 -0400
+++ linux-2.6/drivers/block/brd.c	2010-08-07 14:26:12.293479191 -0400
@@ -482,7 +482,6 @@ static struct brd_device *brd_alloc(int
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
-	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2010-08-07 12:53:23.836479189 -0400
+++ linux-2.6/drivers/block/loop.c	2010-08-07 14:51:27.937479189 -0400
@@ -831,8 +831,8 @@ static int loop_set_fd(struct loop_devic
 	lo->lo_queue->queuedata = lo;
 	lo->lo_queue->unplug_fn = loop_unplug;
 
-	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
-		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN);
+	/* XXX(hch): loop can't properly deal with flush requests currently */
+//	blk_queue_cache_features(lo->lo_queue, QUEUE_HAS_FLUSH);
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
Index: linux-2.6/drivers/block/osdblk.c
===================================================================
--- linux-2.6.orig/drivers/block/osdblk.c	2010-08-07 12:53:23.843479189 -0400
+++ linux-2.6/drivers/block/osdblk.c	2010-08-07 14:51:30.091479189 -0400
@@ -439,7 +439,7 @@ static int osdblk_init_disk(struct osdbl
 	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
 
 	blk_queue_prep_rq(q, blk_queue_start_tag);
-	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_cache_features(q, QUEUE_HAS_FLUSH);
 
 	disk->queue = q;
 
Index: linux-2.6/drivers/block/ps3disk.c
===================================================================
--- linux-2.6.orig/drivers/block/ps3disk.c	2010-08-07 12:53:23.859479189 -0400
+++ linux-2.6/drivers/block/ps3disk.c	2010-08-07 14:51:32.204479189 -0400
@@ -468,7 +468,7 @@ static int __devinit ps3disk_probe(struc
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
 
-	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_cache_features(queue, QUEUE_HAS_FLUSH);
 
 	blk_queue_max_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
Index: linux-2.6/include/linux/blk_types.h
===================================================================
--- linux-2.6.orig/include/linux/blk_types.h	2010-08-07 12:53:23.793479189 -0400
+++ linux-2.6/include/linux/blk_types.h	2010-08-07 12:53:53.243479190 -0400
@@ -141,7 +141,6 @@ enum rq_flag_bits {
 	__REQ_FAILED,		/* set if the request failed */
 	__REQ_QUIET,		/* don't worry about errors */
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
-	__REQ_ORDERED_COLOR,	/* is before or after barrier */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
@@ -181,7 +180,6 @@ enum rq_flag_bits {
 #define REQ_FAILED		(1 << __REQ_FAILED)
 #define REQ_QUIET		(1 << __REQ_QUIET)
 #define REQ_PREEMPT		(1 << __REQ_PREEMPT)
-#define REQ_ORDERED_COLOR	(1 << __REQ_ORDERED_COLOR)
 #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
