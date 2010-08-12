From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] block: kill QUEUE_ORDERED_BY_TAG
Date: Thu, 12 Aug 2010 14:41:22 +0200
Message-ID: <1281616891-5691-3-git-send-email-tj@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Jeremy Fitzhardinge <jeremy@xensource.com>, Chris Wright <chrisw@sous-sol.org>
List-Id: linux-scsi@vger.kernel.org

Nobody is making meaningful use of ORDERED_BY_TAG now and queue
draining for barrier requests will be removed soon which will render
the advantage of tag ordering moot.  Kill ORDERED_BY_TAG.  The
following users are affected.

* brd: converted to ORDERED_DRAIN.
* virtio_blk: ORDERED_TAG path was already marked deprecated.  Removed.
* xen-blkfront: ORDERED_TAG case dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
---
 block/blk-barrier.c          |   35 +++++++----------------------------
 drivers/block/brd.c          |    2 +-
 drivers/block/virtio_blk.c   |    9 ---------
 drivers/block/xen-blkfront.c |    8 +++-----
 drivers/scsi/sd.c            |    4 +---
 include/linux/blkdev.h       |   17 +----------------
 6 files changed, 13 insertions(+), 62 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f0faefc..c807e9c 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -26,10 +26,7 @@ int blk_queue_ordered(struct request_queue *q, unsigned ordered)
 	if (ordered != QUEUE_ORDERED_NONE &&
 	    ordered != QUEUE_ORDERED_DRAIN &&
 	    ordered != QUEUE_ORDERED_DRAIN_FLUSH &&
-	    ordered != QUEUE_ORDERED_DRAIN_FUA &&
-	    ordered != QUEUE_ORDERED_TAG &&
-	    ordered != QUEUE_ORDERED_TAG_FLUSH &&
-	    ordered != QUEUE_ORDERED_TAG_FUA) {
+	    ordered != QUEUE_ORDERED_DRAIN_FUA) {
 		printk(KERN_ERR "blk_queue_ordered: bad value %d\n", ordered);
 		return -EINVAL;
 	}
@@ -155,21 +152,9 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	 * For an empty barrier, there's no actual BAR request, which
 	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
 	 */
-	if (!blk_rq_sectors(rq)) {
+	if (!blk_rq_sectors(rq))
 		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
 				QUEUE_ORDERED_DO_POSTFLUSH);
-		/*
-		 * Empty barrier on a write-through device w/ ordered
-		 * tag has no command to issue and without any command
-		 * to issue, ordering by tag can't be used.  Drain
-		 * instead.
-		 */
-		if ((q->ordered & QUEUE_ORDERED_BY_TAG) &&
-		    !(q->ordered & QUEUE_ORDERED_DO_PREFLUSH)) {
-			q->ordered &= ~QUEUE_ORDERED_BY_TAG;
-			q->ordered |= QUEUE_ORDERED_BY_DRAIN;
-		}
-	}
 
 	/* stash away the original request */
 	blk_dequeue_request(rq);
@@ -210,7 +195,7 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	} else
 		skip |= QUEUE_ORDSEQ_PREFLUSH;
 
-	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q))
+	if (queue_in_flight(q))
 		rq = NULL;
 	else
 		skip |= QUEUE_ORDSEQ_DRAIN;
@@ -257,16 +242,10 @@ bool blk_do_ordered(struct request_queue *q, struct request **rqp)
 	    rq != &q->pre_flush_rq && rq != &q->post_flush_rq)
 		return true;
 
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
+	/* Ordered by draining.  Wait for turn. */
+	WARN_ON(blk_ordered_req_seq(rq) < blk_ordered_cur_seq(q));
+	if (blk_ordered_req_seq(rq) > blk_ordered_cur_seq(q))
+		*rqp = NULL;
 
 	return true;
 }
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1c7f637..47a4127 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -482,7 +482,7 @@ static struct brd_device *brd_alloc(int i)
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
-	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG);
+	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_DRAIN);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2aafafc..7965280 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -395,15 +395,6 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 		 * to implement write barrier support.
 		 */
 		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
-	} else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER)) {
-		/*
-		 * If the BARRIER feature is supported the host expects us
-		 * to order request by tags.  This implies there is not
-		 * volatile write cache on the host, and that the host
-		 * never re-orders outstanding I/O.  This feature is not
-		 * useful for real life scenarious and deprecated.
-		 */
-		blk_queue_ordered(q, QUEUE_ORDERED_TAG);
 	} else {
 		/*
 		 * If the FLUSH feature is not supported we must assume that
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 510ab86..25ffbf9 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -424,8 +424,7 @@ static int xlvbd_barrier(struct blkfront_info *info)
 	const char *barrier;
 
 	switch (info->feature_barrier) {
-	case QUEUE_ORDERED_DRAIN:	barrier = "enabled (drain)"; break;
-	case QUEUE_ORDERED_TAG:		barrier = "enabled (tag)"; break;
+	case QUEUE_ORDERED_DRAIN:	barrier = "enabled"; break;
 	case QUEUE_ORDERED_NONE:	barrier = "disabled"; break;
 	default:			return -EINVAL;
 	}
@@ -1078,8 +1077,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	 * we're dealing with a very old backend which writes
 	 * synchronously; draining will do what needs to get done.
 	 *
-	 * If there are barriers, then we can do full queued writes
-	 * with tagged barriers.
+	 * If there are barriers, then we use flush.
 	 *
 	 * If barriers are not supported, then there's no much we can
 	 * do, so just set ordering to NONE.
@@ -1087,7 +1085,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	if (err)
 		info->feature_barrier = QUEUE_ORDERED_DRAIN;
 	else if (barrier)
-		info->feature_barrier = QUEUE_ORDERED_TAG;
+		info->feature_barrier = QUEUE_ORDERED_DRAIN_FLUSH;
 	else
 		info->feature_barrier = QUEUE_ORDERED_NONE;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8e2e893..05a15b0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2151,9 +2151,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	/*
 	 * We now have all cache related info, determine how we deal
-	 * with ordered requests.  Note that as the current SCSI
-	 * dispatch function can alter request order, we cannot use
-	 * QUEUE_ORDERED_TAG_* even when ordered tag is supported.
+	 * with ordered requests.
 	 */
 	if (sdkp->WCE)
 		ordered = sdkp->DPOFUA
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 89c855c..96ef5f1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -469,12 +469,7 @@ enum {
 	 * DRAIN	: ordering by draining is enough
 	 * DRAIN_FLUSH	: ordering by draining w/ pre and post flushes
 	 * DRAIN_FUA	: ordering by draining w/ pre flush and FUA write
-	 * TAG		: ordering by tag is enough
-	 * TAG_FLUSH	: ordering by tag w/ pre and post flushes
-	 * TAG_FUA	: ordering by tag w/ pre flush and FUA write
 	 */
-	QUEUE_ORDERED_BY_DRAIN		= 0x01,
-	QUEUE_ORDERED_BY_TAG		= 0x02,
 	QUEUE_ORDERED_DO_PREFLUSH	= 0x10,
 	QUEUE_ORDERED_DO_BAR		= 0x20,
 	QUEUE_ORDERED_DO_POSTFLUSH	= 0x40,
@@ -482,8 +477,7 @@ enum {
 
 	QUEUE_ORDERED_NONE		= 0x00,
 
-	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_BY_DRAIN |
-					  QUEUE_ORDERED_DO_BAR,
+	QUEUE_ORDERED_DRAIN		= QUEUE_ORDERED_DO_BAR,
 	QUEUE_ORDERED_DRAIN_FLUSH	= QUEUE_ORDERED_DRAIN |
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_POSTFLUSH,
@@ -491,15 +485,6 @@ enum {
 					  QUEUE_ORDERED_DO_PREFLUSH |
 					  QUEUE_ORDERED_DO_FUA,
 
-	QUEUE_ORDERED_TAG		= QUEUE_ORDERED_BY_TAG |
-					  QUEUE_ORDERED_DO_BAR,
-	QUEUE_ORDERED_TAG_FLUSH		= QUEUE_ORDERED_TAG |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_POSTFLUSH,
-	QUEUE_ORDERED_TAG_FUA		= QUEUE_ORDERED_TAG |
-					  QUEUE_ORDERED_DO_PREFLUSH |
-					  QUEUE_ORDERED_DO_FUA,
-
 	/*
 	 * Ordered operation sequence
 	 */
-- 
1.7.1

