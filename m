From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 13/14] blk-mq: pass 'request_queue *' to several helpers of operating BUSY
Date: Tue,  1 Aug 2017 00:51:10 +0800
Message-ID: <20170731165111.11536-15-ming.lei@redhat.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170731165111.11536-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

We need to support per-request_queue dispatch list for avoiding
early dispatch in case of shared queue depth.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c |  6 +++---
 block/blk-mq.h       | 15 +++++++++------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 8ff74efe4172..37702786c6d1 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -132,7 +132,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 	 * more fair dispatch.
 	 */
 	if (blk_mq_has_dispatch_rqs(hctx))
-		blk_mq_take_list_from_dispatch(hctx, &rq_list);
+		blk_mq_take_list_from_dispatch(q, hctx, &rq_list);
 
 	/*
 	 * Only ask the scheduler for requests, if we didn't have residual
@@ -147,11 +147,11 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 		blk_mq_sched_mark_restart_hctx(hctx);
 		can_go = blk_mq_dispatch_rq_list(q, &rq_list);
 		if (can_go)
-			blk_mq_hctx_clear_busy(hctx);
+			blk_mq_hctx_clear_busy(q, hctx);
 	}
 
 	/* can't go until ->dispatch is flushed */
-	if (!can_go || blk_mq_hctx_is_busy(hctx))
+	if (!can_go || blk_mq_hctx_is_busy(q, hctx))
 		return;
 
 	/*
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d9795cbba1bb..a8788058da56 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -135,17 +135,20 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
-static inline bool blk_mq_hctx_is_busy(struct blk_mq_hw_ctx *hctx)
+static inline bool blk_mq_hctx_is_busy(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx)
 {
 	return test_bit(BLK_MQ_S_BUSY, &hctx->state);
 }
 
-static inline void blk_mq_hctx_set_busy(struct blk_mq_hw_ctx *hctx)
+static inline void blk_mq_hctx_set_busy(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx)
 {
 	set_bit(BLK_MQ_S_BUSY, &hctx->state);
 }
 
-static inline void blk_mq_hctx_clear_busy(struct blk_mq_hw_ctx *hctx)
+static inline void blk_mq_hctx_clear_busy(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx)
 {
 	clear_bit(BLK_MQ_S_BUSY, &hctx->state);
 }
@@ -179,8 +182,8 @@ static inline void blk_mq_add_list_to_dispatch_tail(struct blk_mq_hw_ctx *hctx,
 	spin_unlock(hctx->dispatch_lock);
 }
 
-static inline void blk_mq_take_list_from_dispatch(struct blk_mq_hw_ctx *hctx,
-		struct list_head *list)
+static inline void blk_mq_take_list_from_dispatch(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, struct list_head *list)
 {
 	spin_lock(hctx->dispatch_lock);
 	list_splice_init(hctx->dispatch_list, list);
@@ -190,7 +193,7 @@ static inline void blk_mq_take_list_from_dispatch(struct blk_mq_hw_ctx *hctx,
 	 * in hctx->dispatch are dispatched successfully
 	 */
 	if (!list_empty(list))
-		blk_mq_hctx_set_busy(hctx);
+		blk_mq_hctx_set_busy(q, hctx);
 	spin_unlock(hctx->dispatch_lock);
 }
 
-- 
2.9.4
