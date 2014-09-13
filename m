From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] blk-mq: remove REQ_END
Date: Sat, 13 Sep 2014 16:40:08 -0700
Message-ID: <1410651613-1993-2-git-send-email-hch@lst.de>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pass an explicit parameter for the last request in a batch to ->queue_rq
instead of using a request flag.  Besides being a cleaner and non-stateful
interface this is also required for the next patch, which fixes the blk-mq
I/O submission code to not start a time too early.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c                    | 22 +++++-----------------
 drivers/block/mtip32xx/mtip32xx.c |  3 ++-
 drivers/block/null_blk.c          |  3 ++-
 drivers/block/virtio_blk.c        |  4 ++--
 drivers/scsi/scsi_lib.c           |  3 ++-
 include/linux/blk-mq.h            |  2 +-
 include/linux/blk_types.h         |  2 --
 7 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383ea0c..42c94c8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -380,7 +380,7 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-static void blk_mq_start_request(struct request *rq, bool last)
+static void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
@@ -411,16 +411,6 @@ static void blk_mq_start_request(struct request *rq, bool last)
 		 */
 		rq->nr_phys_segments++;
 	}
-
-	/*
-	 * Flag the last request in the series so that drivers know when IO
-	 * should be kicked off, if they don't do it on a per-request basis.
-	 *
-	 * Note: the flag isn't the only condition drivers should do kick off.
-	 * If drive is busy, the last request might not have the bit set.
-	 */
-	if (last)
-		rq->cmd_flags |= REQ_END;
 }
 
 static void __blk_mq_requeue_request(struct request *rq)
@@ -430,8 +420,6 @@ static void __blk_mq_requeue_request(struct request *rq)
 	trace_block_rq_requeue(q, rq);
 	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
 
-	rq->cmd_flags &= ~REQ_END;
-
 	if (q->dma_drain_size && blk_rq_bytes(rq))
 		rq->nr_phys_segments--;
 }
@@ -741,9 +729,9 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		rq = list_first_entry(&rq_list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 
-		blk_mq_start_request(rq, list_empty(&rq_list));
+		blk_mq_start_request(rq);
 
-		ret = q->mq_ops->queue_rq(hctx, rq);
+		ret = q->mq_ops->queue_rq(hctx, rq, list_empty(&rq_list));
 		switch (ret) {
 		case BLK_MQ_RQ_QUEUE_OK:
 			queued++;
@@ -1189,14 +1177,14 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		int ret;
 
 		blk_mq_bio_to_request(rq, bio);
-		blk_mq_start_request(rq, true);
+		blk_mq_start_request(rq);
 
 		/*
 		 * For OK queue, we are done. For error, kill it. Any other
 		 * error (busy), just add it to our list as we previously
 		 * would have done
 		 */
-		ret = q->mq_ops->queue_rq(data.hctx, rq);
+		ret = q->mq_ops->queue_rq(data.hctx, rq, true);
 		if (ret == BLK_MQ_RQ_QUEUE_OK)
 			goto done;
 		else {
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5c8e7fe..0e2084f 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3775,7 +3775,8 @@ static bool mtip_check_unal_depth(struct blk_mq_hw_ctx *hctx,
 	return false;
 }
 
-static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq,
+		bool last)
 {
 	int ret;
 
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 00d469c..c5b7315 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -313,7 +313,8 @@ static void null_request_fn(struct request_queue *q)
 	}
 }
 
-static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
+static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq,
+		bool last)
 {
 	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0a58140..13756e0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -164,14 +164,14 @@ static void virtblk_done(struct virtqueue *vq)
 	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
 }
 
-static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
+		bool last)
 {
 	struct virtio_blk *vblk = hctx->queue->queuedata;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
 	unsigned int num;
 	int qid = hctx->queue_num;
-	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
 	bool notify = false;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d837dc1..1ec00ba 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1855,7 +1855,8 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 	blk_mq_complete_request(cmd->request);
 }
 
-static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
+		bool last)
 {
 	struct request_queue *q = req->q;
 	struct scsi_device *sdev = q->queuedata;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a1e31f2..9c4e306 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -77,7 +77,7 @@ struct blk_mq_tag_set {
 	struct list_head	tag_list;
 };
 
-typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
+typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *, bool);
 typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 66c2167..bb7d664 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -188,7 +188,6 @@ enum rq_flag_bits {
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
 	__REQ_PM,		/* runtime pm request */
-	__REQ_END,		/* last of chain of requests */
 	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_MQ_INFLIGHT,	/* track inflight for MQ */
 	__REQ_NR_BITS,		/* stops here */
@@ -242,7 +241,6 @@ enum rq_flag_bits {
 #define REQ_SECURE		(1ULL << __REQ_SECURE)
 #define REQ_KERNEL		(1ULL << __REQ_KERNEL)
 #define REQ_PM			(1ULL << __REQ_PM)
-#define REQ_END			(1ULL << __REQ_END)
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
 
-- 
1.9.1
