From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/39] blk-mq: add a exit_request method
Date: Mon, 17 Mar 2014 06:27:39 -0700
Message-ID: <20140317133132.233681888@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0006-blk-mq-add-a-exit_request-method.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This gives drivers an easy way to free any ressources allocated in
->init_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c2ce99b..c7e723e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1000,6 +1000,16 @@ static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
 {
 	struct page *page;
 
+	if (hctx->rqs && hctx->queue->mq_ops->exit_request) {
+		int i;
+
+		for (i = 0; i < hctx->queue_depth; i++) {
+			if (!hctx->rqs[i])
+				continue;
+			hctx->queue->mq_ops->exit_request(hctx, hctx->rqs[i]);
+		}
+	}
+
 	while (!list_empty(&hctx->page_list)) {
 		page = list_first_entry(&hctx->page_list, struct page, lru);
 		list_del_init(&page->lru);
@@ -1332,7 +1342,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	}
 
 	if (blk_mq_init_hw_queues(q, reg, driver_data))
-		goto err_flush_rq;
+		goto err_flush_rq_init;
 
 	blk_mq_map_swqueue(q);
 
@@ -1342,6 +1352,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 
 	return q;
 
+err_flush_rq_init:
+	if (reg->ops->exit_request)
+		reg->ops->exit_request(NULL, q->flush_rq);
 err_flush_rq:
 	kfree(q->flush_rq);
 err_hw:
@@ -1387,6 +1400,9 @@ void blk_mq_free_queue(struct request_queue *q)
 	mutex_lock(&all_q_mutex);
 	list_del_init(&q->all_q_node);
 	mutex_unlock(&all_q_mutex);
+
+	if (q->mq_ops->exit_request)
+		q->mq_ops->exit_request(NULL, q->flush_rq);
 }
 
 /* Basically redo blk_mq_init_queue with queue frozen */
-- 
1.7.10.4
