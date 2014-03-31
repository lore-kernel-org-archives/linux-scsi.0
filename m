From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] blk->mq: stop pre-initializing req->special
Date: Mon, 31 Mar 2014 16:46:12 +0200
Message-ID: <1396277175-21382-2-git-send-email-hch@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396277175-21382-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We can get at the private data easil using pointer arithmetics.  Do so
instead of initializing req->special so that we don't rely on the
request state in various initialization functions and shave off another
few instructions in the fast path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c          |   10 ++--------
 block/blk-mq.c             |   15 ++-------------
 block/blk-mq.h             |    1 -
 drivers/block/null_blk.c   |    4 ++--
 drivers/block/virtio_blk.c |    6 +++---
 5 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 43e6b47..9a0c427 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -306,22 +306,16 @@ static bool blk_kick_flush(struct request_queue *q)
 	 */
 	q->flush_pending_idx ^= 1;
 
+	blk_rq_init(q, q->flush_rq);
 	if (q->mq_ops) {
-		struct blk_mq_ctx *ctx = first_rq->mq_ctx;
-		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
-
-		blk_mq_rq_init(hctx, q->flush_rq);
-		q->flush_rq->mq_ctx = ctx;
-
 		/*
 		 * Reuse the tag value from the fist waiting request,
 		 * with blk-mq the tag is generated during request
 		 * allocation and drivers can rely on it being inside
 		 * the range they asked for.
 		 */
+		q->flush_rq->mq_ctx = first_rq->mq_ctx;
 		q->flush_rq->tag = first_rq->tag;
-	} else {
-		blk_rq_init(q, q->flush_rq);
 	}
 
 	q->flush_rq->cmd_type = REQ_TYPE_FS;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4274ee0..871acd6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -248,24 +248,13 @@ struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
 }
 EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
 
-/*
- * Re-init and set pdu, if we have it
- */
-void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
-{
-	blk_rq_init(hctx->queue, rq);
-
-	if (hctx->cmd_size)
-		rq->special = blk_mq_rq_to_pdu(rq);
-}
-
 static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 				  struct blk_mq_ctx *ctx, struct request *rq)
 {
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
-	blk_mq_rq_init(hctx, rq);
+	blk_rq_init(hctx->queue, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 
 	blk_mq_queue_exit(q);
@@ -1139,7 +1128,7 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
-			blk_mq_rq_init(hctx, hctx->rqs[i]);
+			blk_rq_init(hctx->queue, hctx->rqs[i]);
 			p += rq_size;
 			i++;
 		}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index ebbe6ba..238379a 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,7 +27,6 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
-void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq);
 
 /*
  * CPU hotplug helpers
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 091b9ea..71df69d 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -226,7 +226,7 @@ static void null_cmd_end_timer(struct nullb_cmd *cmd)
 
 static void null_softirq_done_fn(struct request *rq)
 {
-	end_cmd(rq->special);
+	end_cmd(blk_mq_rq_to_pdu(rq));
 }
 
 static inline void null_handle_cmd(struct nullb_cmd *cmd)
@@ -311,7 +311,7 @@ static void null_request_fn(struct request_queue *q)
 
 static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
-	struct nullb_cmd *cmd = rq->special;
+	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
 	cmd->rq = rq;
 	cmd->nq = hctx->driver_data;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0eace43..11e8f4b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -112,7 +112,7 @@ static int __virtblk_add_req(struct virtqueue *vq,
 
 static inline void virtblk_request_done(struct request *req)
 {
-	struct virtblk_req *vbr = req->special;
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	int error = virtblk_result(vbr);
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
@@ -154,7 +154,7 @@ static void virtblk_done(struct virtqueue *vq)
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
-	struct virtblk_req *vbr = req->special;
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
 	unsigned int num;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
@@ -494,7 +494,7 @@ static int virtblk_init_vbr(void *data, struct blk_mq_hw_ctx *hctx,
 			     struct request *rq, unsigned int nr)
 {
 	struct virtio_blk *vblk = data;
-	struct virtblk_req *vbr = rq->special;
+	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
 
 	sg_init_table(vbr->sg, vblk->sg_elems);
 	return 0;
-- 
1.7.10.4
