From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] blk-mq: merge blk_mq_insert_request and blk_mq_run_request
Date: Thu, 20 Feb 2014 15:32:37 -0800
Message-ID: <20140220233352.426573699@bombadil.infradead.org>
References: <20140220233235.443299098@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0002-blk-mq-merge-blk_mq_insert_request-and-blk_mq_run_re.patch
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It's almost identical to blk_mq_insert_request, so fold the two into one
slightly more generic function by making the flush special case a bit
smarted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c       |    2 +-
 block/blk-flush.c      |    4 ++--
 block/blk-mq.c         |   53 +++++++++---------------------------------------
 block/blk-mq.h         |    1 -
 include/linux/blk-mq.h |    3 +--
 5 files changed, 14 insertions(+), 49 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index c68613b..dbf4502 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -65,7 +65,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	 * be resued after dying flag is set
 	 */
 	if (q->mq_ops) {
-		blk_mq_insert_request(q, rq, at_head, true);
+		blk_mq_insert_request(rq, at_head, true, false);
 		return;
 	}
 
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 66e2b69..f598f79 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -137,7 +137,7 @@ static void mq_flush_run(struct work_struct *work)
 	rq = container_of(work, struct request, mq_flush_work);
 
 	memset(&rq->csd, 0, sizeof(rq->csd));
-	blk_mq_run_request(rq, true, false);
+	blk_mq_insert_request(rq, false, true, false);
 }
 
 static bool blk_flush_queue_rq(struct request *rq)
@@ -411,7 +411,7 @@ void blk_insert_flush(struct request *rq)
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
 		if (q->mq_ops) {
-			blk_mq_run_request(rq, false, true);
+			blk_mq_insert_request(rq, false, false, true);
 		} else
 			list_add_tail(&rq->queuelist, &q->queue_head);
 		return;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1e585e3..2af8405 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -724,61 +724,28 @@ static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
 	blk_mq_add_timer(rq);
 }
 
-void blk_mq_insert_request(struct request_queue *q, struct request *rq,
-			   bool at_head, bool run_queue)
+void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
+		bool async)
 {
+	struct request_queue *q = rq->q;
 	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx, *current_ctx;
+	struct blk_mq_ctx *ctx = rq->mq_ctx, *current_ctx;
+
+	current_ctx = blk_mq_get_ctx(q);
+	if (!cpu_online(ctx->cpu))
+		rq->mq_ctx = ctx = current_ctx;
 
-	ctx = rq->mq_ctx;
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
+	if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA) &&
+	    !(rq->cmd_flags & (REQ_FLUSH_SEQ))) {
 		blk_insert_flush(rq);
 	} else {
-		current_ctx = blk_mq_get_ctx(q);
-
-		if (!cpu_online(ctx->cpu)) {
-			ctx = current_ctx;
-			hctx = q->mq_ops->map_queue(q, ctx->cpu);
-			rq->mq_ctx = ctx;
-		}
 		spin_lock(&ctx->lock);
 		__blk_mq_insert_request(hctx, rq, at_head);
 		spin_unlock(&ctx->lock);
-
-		blk_mq_put_ctx(current_ctx);
 	}
 
-	if (run_queue)
-		__blk_mq_run_hw_queue(hctx);
-}
-EXPORT_SYMBOL(blk_mq_insert_request);
-
-/*
- * This is a special version of blk_mq_insert_request to bypass FLUSH request
- * check. Should only be used internally.
- */
-void blk_mq_run_request(struct request *rq, bool run_queue, bool async)
-{
-	struct request_queue *q = rq->q;
-	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx, *current_ctx;
-
-	current_ctx = blk_mq_get_ctx(q);
-
-	ctx = rq->mq_ctx;
-	if (!cpu_online(ctx->cpu)) {
-		ctx = current_ctx;
-		rq->mq_ctx = ctx;
-	}
-	hctx = q->mq_ops->map_queue(q, ctx->cpu);
-
-	/* ctx->cpu might be offline */
-	spin_lock(&ctx->lock);
-	__blk_mq_insert_request(hctx, rq, false);
-	spin_unlock(&ctx->lock);
-
 	blk_mq_put_ctx(current_ctx);
 
 	if (run_queue)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index ed0035c..72beba1 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -23,7 +23,6 @@ struct blk_mq_ctx {
 };
 
 void __blk_mq_complete_request(struct request *rq);
-void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18ba8a6..ff28fe3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -121,8 +121,7 @@ void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struc
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-void blk_mq_insert_request(struct request_queue *, struct request *,
-		bool, bool);
+void blk_mq_insert_request(struct request *, bool, bool, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-- 
1.7.10.4
