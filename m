From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 8/9] block: allow to allocate req with REQF_PREEMPT when queue is frozen
Date: Fri,  1 Sep 2017 01:27:27 +0800
Message-ID: <20170831172728.15817-9-ming.lei@redhat.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbdHaR3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 13:29:35 -0400
In-Reply-To: <20170831172728.15817-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>

REQF_PREEMPT is a bit special because it is required to be
dispatched to lld even when SCSI device is quiesced.

So this patch introduces __blk_get_request() to allow block
layer to allocate request when queue is frozen, since we
will freeze queue before quiescing SCSI device in the
following patch for supporting safe SCSI quiescing.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 25 +++++++++++++++++--------
 block/blk-mq.c         | 11 +++++++++--
 block/blk.h            |  5 +++++
 include/linux/blk-mq.h |  7 ++++---
 include/linux/blkdev.h | 17 +++++++++++++++--
 5 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a84672f4db32..4e048cbf82e1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1403,7 +1403,8 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 }
 
 static struct request *blk_old_get_request(struct request_queue *q,
-					   unsigned int op, gfp_t gfp_mask)
+					   unsigned int op, gfp_t gfp_mask,
+					   unsigned int flags)
 {
 	struct request *rq;
 	int ret = 0;
@@ -1413,9 +1414,17 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
+	/*
+	 * When queue is frozen, we still need to allocate req for
+	 * REQF_PREEMPT.
+	 */
+	if ((flags & BLK_MQ_REQ_PREEMPT) && blk_queue_is_frozen(q))
+		blk_queue_enter_live(q);
+	else
+		ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
 	if (ret)
 		return ERR_PTR(ret);
+
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, op, NULL, gfp_mask);
 	if (IS_ERR(rq)) {
@@ -1431,26 +1440,26 @@ static struct request *blk_old_get_request(struct request_queue *q,
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
index 24de78afbe9a..bd0a498e04df 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -382,9 +382,16 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 {
 	struct blk_mq_alloc_data alloc_data = { .flags = flags };
 	struct request *rq;
-	int ret;
+	int ret = 0;
 
-	ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
+	/*
+	 * When queue is frozen, we still need to allocate req for
+	 * REQF_PREEMPT.
+	 */
+	if ((flags & BLK_MQ_REQ_PREEMPT) && blk_queue_is_frozen(q))
+		blk_queue_enter_live(q);
+	else
+		ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/block/blk.h b/block/blk.h
index 6847c5435cca..784e487c7bb7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -79,6 +79,11 @@ static inline void blk_queue_enter_live(struct request_queue *q)
 	percpu_ref_get(&q->q_usage_counter);
 }
 
+static inline bool blk_queue_is_frozen(struct request_queue *q)
+{
+	return percpu_ref_is_dead(&q->q_usage_counter);
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f90d78eb85df..0ba5cb043172 100644
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
index 02959ca03b66..10369ba86102 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -858,6 +858,11 @@ enum {
 	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
 };
 
+/* passed to __blk_get_request */
+enum {
+	BLK_REQ_PREEMPT	= (1 << 0), /* allocate for RQF_PREEMPT */
+};
+
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
 
 /*
@@ -940,8 +945,9 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
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
@@ -992,6 +998,13 @@ blk_status_t errno_to_blk_status(int errno);
 
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
