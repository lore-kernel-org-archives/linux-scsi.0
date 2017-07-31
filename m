From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 05/14] blk-mq-sched: don't dequeue request until all in ->dispatch are flushed
Date: Tue,  1 Aug 2017 00:51:02 +0800
Message-ID: <20170731165111.11536-7-ming.lei@redhat.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170731165111.11536-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

During dispatch, we moved all requests from hctx->dispatch to
one temporary list, then dispatch them one by one from this list.
Unfortunately duirng this period, run queue from other contexts
may think the queue is idle and start to dequeue from sw/scheduler
queue and try to dispatch because ->dispatch is empty.

This way will hurt sequential I/O performance because requests are
dequeued when queue is busy.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c   | 24 ++++++++++++++++++------
 include/linux/blk-mq.h |  1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 3510c01cb17b..eb638063673f 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -112,8 +112,15 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 	 */
 	if (!list_empty_careful(&hctx->dispatch)) {
 		spin_lock(&hctx->lock);
-		if (!list_empty(&hctx->dispatch))
+		if (!list_empty(&hctx->dispatch)) {
 			list_splice_init(&hctx->dispatch, &rq_list);
+
+			/*
+			 * BUSY won't be cleared until all requests
+			 * in hctx->dispatch are dispatched successfully
+			 */
+			set_bit(BLK_MQ_S_BUSY, &hctx->state);
+		}
 		spin_unlock(&hctx->lock);
 	}
 
@@ -129,15 +136,20 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 	if (!list_empty(&rq_list)) {
 		blk_mq_sched_mark_restart_hctx(hctx);
 		can_go = blk_mq_dispatch_rq_list(q, &rq_list);
-	} else if (!has_sched_dispatch && !q->queue_depth) {
-		blk_mq_flush_busy_ctxs(hctx, &rq_list);
-		blk_mq_dispatch_rq_list(q, &rq_list);
-		can_go = false;
+		if (can_go)
+			clear_bit(BLK_MQ_S_BUSY, &hctx->state);
 	}
 
-	if (!can_go)
+	/* can't go until ->dispatch is flushed */
+	if (!can_go || test_bit(BLK_MQ_S_BUSY, &hctx->state))
 		return;
 
+	if (!has_sched_dispatch && !q->queue_depth) {
+		blk_mq_flush_busy_ctxs(hctx, &rq_list);
+		blk_mq_dispatch_rq_list(q, &rq_list);
+		return;
+	}
+
 	/*
 	 * We want to dispatch from the scheduler if we had no work left
 	 * on the dispatch list, OR if we did have work but weren't able
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 14542308d25b..6d44b242b495 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -172,6 +172,7 @@ enum {
 	BLK_MQ_S_SCHED_RESTART	= 2,
 	BLK_MQ_S_TAG_WAITING	= 3,
 	BLK_MQ_S_START_ON_RUN	= 4,
+	BLK_MQ_S_BUSY		= 5,
 
 	BLK_MQ_MAX_DEPTH	= 10240,
 
-- 
2.9.4
