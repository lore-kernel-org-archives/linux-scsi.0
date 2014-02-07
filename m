From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] blk-mq: support at_head inserations for blk_execute_rq
Date: Fri, 07 Feb 2014 10:22:36 -0800
Message-ID: <20140207182319.643123149@bombadil.infradead.org>
References: <20140207182235.659185141@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0001-blk-mq-support-at_head-inserations-for-blk_execute_r.patch
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is neede for proper SG_IO operation as well as various uses of
blk_execute_rq from the SCSI midlayer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c       |    2 +-
 block/blk-mq.c         |   17 ++++++++++-------
 include/linux/blk-mq.h |    3 ++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index bbfc072..c68613b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -65,7 +65,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	 * be resued after dying flag is set
 	 */
 	if (q->mq_ops) {
-		blk_mq_insert_request(q, rq, true);
+		blk_mq_insert_request(q, rq, at_head, true);
 		return;
 	}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 57039fc..40fc4dd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -693,13 +693,16 @@ static void blk_mq_work_fn(struct work_struct *work)
 }
 
 static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
-				    struct request *rq)
+				    struct request *rq, bool at_head)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 
 	trace_block_rq_insert(hctx->queue, rq);
 
-	list_add_tail(&rq->queuelist, &ctx->rq_list);
+	if (at_head)
+		list_add(&rq->queuelist, &ctx->rq_list);
+	else
+		list_add_tail(&rq->queuelist, &ctx->rq_list);
 	blk_mq_hctx_mark_pending(hctx, ctx);
 
 	/*
@@ -709,7 +712,7 @@ static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
 }
 
 void blk_mq_insert_request(struct request_queue *q, struct request *rq,
-			   bool run_queue)
+			   bool at_head, bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx, *current_ctx;
@@ -728,7 +731,7 @@ void blk_mq_insert_request(struct request_queue *q, struct request *rq,
 			rq->mq_ctx = ctx;
 		}
 		spin_lock(&ctx->lock);
-		__blk_mq_insert_request(hctx, rq);
+		__blk_mq_insert_request(hctx, rq, at_head);
 		spin_unlock(&ctx->lock);
 
 		blk_mq_put_ctx(current_ctx);
@@ -760,7 +763,7 @@ void blk_mq_run_request(struct request *rq, bool run_queue, bool async)
 
 	/* ctx->cpu might be offline */
 	spin_lock(&ctx->lock);
-	__blk_mq_insert_request(hctx, rq);
+	__blk_mq_insert_request(hctx, rq, false);
 	spin_unlock(&ctx->lock);
 
 	blk_mq_put_ctx(current_ctx);
@@ -798,7 +801,7 @@ static void blk_mq_insert_requests(struct request_queue *q,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		rq->mq_ctx = ctx;
-		__blk_mq_insert_request(hctx, rq);
+		__blk_mq_insert_request(hctx, rq, false);
 	}
 	spin_unlock(&ctx->lock);
 
@@ -950,7 +953,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		__blk_mq_free_request(hctx, ctx, rq);
 	else {
 		blk_mq_bio_to_request(rq, bio);
-		__blk_mq_insert_request(hctx, rq);
+		__blk_mq_insert_request(hctx, rq, false);
 	}
 
 	spin_unlock(&ctx->lock);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 161b231..8e6e710 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -119,7 +119,8 @@ void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struc
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-void blk_mq_insert_request(struct request_queue *, struct request *, bool);
+void blk_mq_insert_request(struct request_queue *, struct request *,
+		bool, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-- 
1.7.10.4
