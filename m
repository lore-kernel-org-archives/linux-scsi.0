From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT when queue is preempt frozen
Date: Sat,  2 Sep 2017 21:08:39 +0800
Message-ID: <20170902130840.24609-8-ming.lei@redhat.com>
References: <20170902130840.24609-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170902130840.24609-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

REQF_PREEMPT is a bit special because the request is required
to be dispatched to lld even when SCSI device is quiesced.

So this patch introduces __blk_get_request() to allow block
layer to allocate request when queue is preempt frozen, since we
will preempt freeze queue before quiescing SCSI device in the
following patch for supporting safe SCSI quiescing.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 28 ++++++++++++++++++++--------
 block/blk-mq.c         | 14 ++++++++++++--
 include/linux/blk-mq.h |  7 ++++---
 include/linux/blkdev.h | 17 +++++++++++++++--
 4 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2549b0a0535d..f7a6fbb87dea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1404,7 +1404,8 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 }
 
 static struct request *blk_old_get_request(struct request_queue *q,
-					   unsigned int op, gfp_t gfp_mask)
+					   unsigned int op, gfp_t gfp_mask,
+					   unsigned int flags)
 {
 	struct request *rq;
 	int ret = 0;
@@ -1414,9 +1415,20 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
+	/*
+	 * We need to allocate req of REQF_PREEMPT in preempt freezing.
+	 * No normal freezing can be started when preempt freezing
+	 * is in-progress, and queue dying is checked before starting
+	 * preempt freezing, so it is safe to use blk_queue_enter_live()
+	 * in case of preempt freezing.
+	 */
+	if ((flags & BLK_MQ_REQ_PREEMPT) && blk_queue_is_preempt_frozen(q))
+		blk_queue_enter_live(q);
+	else
+		ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
 	if (ret)
 		return ERR_PTR(ret);
+
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, op, NULL, gfp_mask);
 	if (IS_ERR(rq)) {
@@ -1432,26 +1444,26 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_get_request(struct request_queue *q, unsigned int op,
-				gfp_t gfp_mask)
+struct request *__blk_get_request(struct request_queue *q, unsigned int op,
+				  gfp_t gfp_mask, unsigned int flags)
 {
 	struct request *req;
 
 	if (q->mq_ops) {
 		req = blk_mq_alloc_request(q, op,
-			(gfp_mask & __GFP_DIRECT_RECLAIM) ?
-				0 : BLK_MQ_REQ_NOWAIT);
+			flags | ((gfp_mask & __GFP_DIRECT_RECLAIM) ?
+				0 : BLK_MQ_REQ_NOWAIT));
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
index 54b8d8b9f40e..e81001d1da27 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -496,9 +496,19 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 {
 	struct blk_mq_alloc_data alloc_data = { .flags = flags };
 	struct request *rq;
-	int ret;
+	int ret = 0;
 
-	ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
+	/*
+	 * We need to allocate req of REQF_PREEMPT in preempt freezing.
+	 * No normal freezing can be started when preempt freezing
+	 * is in-progress, and queue dying is checked before starting
+	 * preempt freezing, so it is safe to use blk_queue_enter_live()
+	 * in case of preempt freezing.
+	 */
+	if ((flags & BLK_MQ_REQ_PREEMPT) && blk_queue_is_preempt_frozen(q))
+		blk_queue_enter_live(q);
+	else
+		ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 5ae8c82d6273..596f433eb54c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -200,9 +200,10 @@ void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 
 enum {
-	BLK_MQ_REQ_NOWAIT	= (1 << 0), /* return when out of requests */
-	BLK_MQ_REQ_RESERVED	= (1 << 1), /* allocate from reserved pool */
-	BLK_MQ_REQ_INTERNAL	= (1 << 2), /* allocate internal/sched tag */
+	BLK_MQ_REQ_PREEMPT	= BLK_REQ_PREEMPT, /* allocate for RQF_PREEMPT */
+	BLK_MQ_REQ_NOWAIT	= (1 << 8), /* return when out of requests */
+	BLK_MQ_REQ_RESERVED	= (1 << 9), /* allocate from reserved pool */
+	BLK_MQ_REQ_INTERNAL	= (1 << 10), /* allocate internal/sched tag */
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5618d174100a..ff371c42eb3f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -862,6 +862,11 @@ enum {
 	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
 };
 
+/* passed to __blk_get_request */
+enum {
+	BLK_REQ_PREEMPT	= (1 << 0), /* allocate for RQF_PREEMPT */
+};
+
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
 
 /*
@@ -944,8 +949,9 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
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
@@ -996,6 +1002,13 @@ blk_status_t errno_to_blk_status(int errno);
 
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
