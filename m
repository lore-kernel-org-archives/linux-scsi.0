From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT when queue is preempt frozen
Date: Mon, 11 Sep 2017 19:10:19 +0800
Message-ID: <20170911111021.25810-9-ming.lei@redhat.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170911111021.25810-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

REQF_PREEMPT is a bit special because the request is required
to be dispatched to lld even when SCSI device is quiesced.

So this patch introduces __blk_get_request() to allow block
layer to allocate request when queue is preempt frozen, since we
will preempt freeze queue before quiescing SCSI device in the
following patch for supporting safe SCSI quiescing.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 48 ++++++++++++++++++++++++++++++++++++++----------
 block/blk-mq.c         |  3 +--
 include/linux/blk-mq.h |  7 ++++---
 include/linux/blkdev.h | 17 ++++++++++++++---
 4 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ade9b5484a6e..1c8e264753f0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -787,6 +787,35 @@ int blk_queue_enter(struct request_queue *q, unsigned flags)
 		if (percpu_ref_tryget_live(&q->q_usage_counter))
 			return 0;
 
+		/*
+		 * If queue is preempt frozen and caller need to allocate
+		 * request for RQF_PREEMPT, we grab the .q_usage_counter
+		 * unconditionally and return successfully.
+		 *
+		 * There isn't race with queue cleanup because:
+		 *
+		 * 1) it is guaranteed that preempt freeze can't be
+		 * started after queue is set as dying
+		 *
+		 * 2) normal freeze runs exclusively with preempt
+		 * freeze, so even after queue is set as dying
+		 * afterwards, blk_queue_cleanup() won't move on
+		 * until preempt freeze is done
+		 *
+		 * 3) blk_queue_dying() needn't to be checked here
+		 * 	- for legacy path, it will be checked in
+		 * 	__get_request()
+		 * 	- blk-mq depends on driver to handle dying well
+		 * 	because it is normal for queue to be set as dying
+		 * 	just between blk_queue_enter() and allocating new
+		 * 	request.
+		 */
+		if ((flags & BLK_REQ_PREEMPT) &&
+				blk_queue_is_preempt_frozen(q)) {
+			blk_queue_enter_live(q);
+			return 0;
+		}
+
 		if (flags & BLK_REQ_NOWAIT)
 			return -EBUSY;
 
@@ -1410,7 +1439,8 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 }
 
 static struct request *blk_old_get_request(struct request_queue *q,
-					   unsigned int op, gfp_t gfp_mask)
+					   unsigned int op, gfp_t gfp_mask,
+					   unsigned int flags)
 {
 	struct request *rq;
 	int ret = 0;
@@ -1420,8 +1450,7 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ?
-			BLK_REQ_NOWAIT : 0);
+	ret = blk_queue_enter(q, flags & BLK_REQ_BITS_MASK);
 	if (ret)
 		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
@@ -1439,26 +1468,25 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_get_request(struct request_queue *q, unsigned int op,
-				gfp_t gfp_mask)
+struct request *__blk_get_request(struct request_queue *q, unsigned int op,
+				  gfp_t gfp_mask, unsigned int flags)
 {
 	struct request *req;
 
+	flags |= gfp_mask & __GFP_DIRECT_RECLAIM ? 0 : BLK_REQ_NOWAIT;
 	if (q->mq_ops) {
-		req = blk_mq_alloc_request(q, op,
-			(gfp_mask & __GFP_DIRECT_RECLAIM) ?
-				0 : BLK_MQ_REQ_NOWAIT);
+		req = blk_mq_alloc_request(q, op, flags);
 		if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
 			q->mq_ops->initialize_rq_fn(req);
 	} else {
-		req = blk_old_get_request(q, op, gfp_mask);
+		req = blk_old_get_request(q, op, gfp_mask, flags);
 		if (!IS_ERR(req) && q->initialize_rq_fn)
 			q->initialize_rq_fn(req);
 	}
 
 	return req;
 }
-EXPORT_SYMBOL(blk_get_request);
+EXPORT_SYMBOL(__blk_get_request);
 
 /**
  * blk_requeue_request - put a request back on queue
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 096c5f0ea518..720559724f97 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -482,8 +482,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 	struct request *rq;
 	int ret;
 
-	ret = blk_queue_enter(q, (flags & BLK_MQ_REQ_NOWAIT) ?
-			BLK_REQ_NOWAIT : 0);
+	ret = blk_queue_enter(q, flags & BLK_REQ_BITS_MASK);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 54b160bcb6a2..3cb3856f83db 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -197,9 +197,10 @@ void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 
 enum {
-	BLK_MQ_REQ_NOWAIT	= (1 << 0), /* return when out of requests */
-	BLK_MQ_REQ_RESERVED	= (1 << 1), /* allocate from reserved pool */
-	BLK_MQ_REQ_INTERNAL	= (1 << 2), /* allocate internal/sched tag */
+	BLK_MQ_REQ_NOWAIT	= BLK_REQ_NOWAIT, /* return when out of requests */
+	BLK_MQ_REQ_PREEMPT	= BLK_REQ_PREEMPT, /* allocate for RQF_PREEMPT */
+	BLK_MQ_REQ_RESERVED	= (1 << BLK_REQ_MQ_START_BIT), /* allocate from reserved pool */
+	BLK_MQ_REQ_INTERNAL	= (1 << (BLK_REQ_MQ_START_BIT + 1)), /* allocate internal/sched tag */
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3c14c9588dcf..99c252bb5361 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,7 +865,10 @@ enum {
 
 /* passed to blk_queue_enter */
 enum {
-	BLK_REQ_NOWAIT = (1 << 0),
+	BLK_REQ_NOWAIT		= (1 << 0),
+	BLK_REQ_PREEMPT		= (1 << 1),
+	BLK_REQ_MQ_START_BIT	= 2,
+	BLK_REQ_BITS_MASK	= (1U << BLK_REQ_MQ_START_BIT) - 1,
 };
 
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
@@ -950,8 +953,9 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_init_request_from_bio(struct request *req, struct bio *bio);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
-extern struct request *blk_get_request(struct request_queue *, unsigned int op,
-				       gfp_t gfp_mask);
+extern struct request *__blk_get_request(struct request_queue *,
+					 unsigned int op, gfp_t gfp_mask,
+					 unsigned int flags);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
@@ -1002,6 +1006,13 @@ blk_status_t errno_to_blk_status(int errno);
 
 bool blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
 
+static inline struct request *blk_get_request(struct request_queue *q,
+					      unsigned int op,
+					      gfp_t gfp_mask)
+{
+	return __blk_get_request(q, op, gfp_mask, 0);
+}
+
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
 	return bdev->bd_disk->queue;	/* this is never NULL */
-- 
2.9.5
