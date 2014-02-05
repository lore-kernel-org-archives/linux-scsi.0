From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/15] blk-mq: support at_head inserations for blk_execute_rq
Date: Wed, 05 Feb 2014 04:41:20 -0800
Message-ID: <20140205124152.477413324@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBEMlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:53 -0500
Content-Disposition: inline; filename=0002-blk-mq-support-at_head-inserations-for-blk_execute_r.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

This is neede for proper SG_IO operation as well as various uses of
blk_execute_rq from the SCSI midlayer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c       |    4 ++--
 block/blk-mq.c         |   17 ++++++++++-------
 block/blk-mq.h         |    2 ++
 include/linux/blk-mq.h |    1 -
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index bbfc072..16abf91 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -5,10 +5,10 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/blk-mq.h>
 #include <linux/sched/sysctl.h>
 
 #include "blk.h"
+#include "blk-mq.h"
 
 /*
  * for max sense size
@@ -65,7 +65,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	 * be resued after dying flag is set
 	 */
 	if (q->mq_ops) {
-		blk_mq_insert_request(q, rq, true);
+		blk_mq_insert_request(q, rq, at_head, true);
 		return;
 	}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5c3073f..6838fe8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -692,13 +692,16 @@ static void blk_mq_work_fn(struct work_struct *work)
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
@@ -708,7 +711,7 @@ static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
 }
 
 void blk_mq_insert_request(struct request_queue *q, struct request *rq,
-			   bool run_queue)
+			   bool at_head, bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx, *current_ctx;
@@ -727,7 +730,7 @@ void blk_mq_insert_request(struct request_queue *q, struct request *rq,
 			rq->mq_ctx = ctx;
 		}
 		spin_lock(&ctx->lock);
-		__blk_mq_insert_request(hctx, rq);
+		__blk_mq_insert_request(hctx, rq, at_head);
 		spin_unlock(&ctx->lock);
 
 		blk_mq_put_ctx(current_ctx);
@@ -759,7 +762,7 @@ void blk_mq_run_request(struct request *rq, bool run_queue, bool async)
 
 	/* ctx->cpu might be offline */
 	spin_lock(&ctx->lock);
-	__blk_mq_insert_request(hctx, rq);
+	__blk_mq_insert_request(hctx, rq, false);
 	spin_unlock(&ctx->lock);
 
 	blk_mq_put_ctx(current_ctx);
@@ -797,7 +800,7 @@ static void blk_mq_insert_requests(struct request_queue *q,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		rq->mq_ctx = ctx;
-		__blk_mq_insert_request(hctx, rq);
+		__blk_mq_insert_request(hctx, rq, false);
 	}
 	spin_unlock(&ctx->lock);
 
@@ -949,7 +952,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		__blk_mq_free_request(hctx, ctx, rq);
 	else {
 		blk_mq_bio_to_request(rq, bio);
-		__blk_mq_insert_request(hctx, rq);
+		__blk_mq_insert_request(hctx, rq, false);
 	}
 
 	spin_unlock(&ctx->lock);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index b771080..88a2366 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -30,6 +30,8 @@ void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq);
+void blk_mq_insert_request(struct request_queue *, struct request *,
+		bool, bool);
 
 /*
  * CPU hotplug helpers
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c1684ec..8cfdca6 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -119,7 +119,6 @@ void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struc
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
 
-void blk_mq_insert_request(struct request_queue *, struct request *, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-- 
1.7.10.4


