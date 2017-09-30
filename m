From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 4/6] block: prepare for passing RQF_PREEMPT to request allocation
Date: Sat, 30 Sep 2017 14:12:12 +0800
Message-ID: <20170930061214.10622-5-ming.lei@redhat.com>
References: <20170930061214.10622-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930061214.10622-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

REQF_PREEMPT is a bit special because the request is required
to be dispatched to lld even when SCSI device is quiesced.

So this patch introduces __blk_get_request() and allows users to pass
RQF_PREEMPT flag in, then we can allow to allocate request of RQF_PREEMPT
when queue is in mode of PREEMPT ONLY which will be introduced
in the following patch.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 19 +++++++++----------
 block/blk-mq.c         |  3 +--
 include/linux/blk-mq.h |  7 ++++---
 include/linux/blkdev.h | 17 ++++++++++++++---
 4 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7d5040a6d5a4..95b1c5e50be3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1398,7 +1398,8 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 }
 
 static struct request *blk_old_get_request(struct request_queue *q,
-					   unsigned int op, gfp_t gfp_mask)
+					   unsigned int op, gfp_t gfp_mask,
+					   unsigned int flags)
 {
 	struct request *rq;
 	int ret = 0;
@@ -1408,8 +1409,7 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ?
-			BLK_REQ_NOWAIT : 0);
+	ret = blk_queue_enter(q, flags & BLK_REQ_BITS_MASK);
 	if (ret)
 		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
@@ -1427,26 +1427,25 @@ static struct request *blk_old_get_request(struct request_queue *q,
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
index 45bff90e08f7..90b43f607e3c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -384,8 +384,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 	struct request *rq;
 	int ret;
 
-	ret = blk_queue_enter(q, (flags & BLK_MQ_REQ_NOWAIT) ?
-			BLK_REQ_NOWAIT : 0);
+	ret = blk_queue_enter(q, flags & BLK_REQ_BITS_MASK);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 50c6485cb04f..066a676d7749 100644
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
index 127f64c7012c..68445adc8765 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -860,7 +860,10 @@ enum {
 
 /* passed to blk_queue_enter */
 enum {
-	BLK_REQ_NOWAIT = (1 << 0),
+	BLK_REQ_NOWAIT		= (1 << 0),
+	BLK_REQ_PREEMPT		= (1 << 1),
+	BLK_REQ_MQ_START_BIT	= 2,
+	BLK_REQ_BITS_MASK	= (1U << BLK_REQ_MQ_START_BIT) - 1,
 };
 
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
@@ -945,8 +948,9 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
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
@@ -997,6 +1001,13 @@ blk_status_t errno_to_blk_status(int errno);
 
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
