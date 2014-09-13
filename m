From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] blk-mq: call blk_mq_start_request from ->queue_rq
Date: Sat, 13 Sep 2014 16:40:09 -0700
Message-ID: <1410651613-1993-3-git-send-email-hch@lst.de>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When we call blk_mq_start_request from the core blk-mq code before calling into
->queue_rq there is a racy window where the timeout handler can hit before we've
fully set up the driver specific part of the command.

Move the call to blk_mq_start_request into the driver so the driver can start
the request only once it is fully set up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c                    | 13 ++++++-------
 drivers/block/mtip32xx/mtip32xx.c |  2 ++
 drivers/block/null_blk.c          |  2 ++
 drivers/block/virtio_blk.c        |  2 ++
 drivers/scsi/scsi_lib.c           |  1 +
 include/linux/blk-mq.h            |  1 +
 6 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 42c94c8..c3333ab 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -380,7 +380,7 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-static void blk_mq_start_request(struct request *rq)
+void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
@@ -412,16 +412,18 @@ static void blk_mq_start_request(struct request *rq)
 		rq->nr_phys_segments++;
 	}
 }
+EXPORT_SYMBOL(blk_mq_start_request);
 
 static void __blk_mq_requeue_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
 	trace_block_rq_requeue(q, rq);
-	clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags);
 
-	if (q->dma_drain_size && blk_rq_bytes(rq))
-		rq->nr_phys_segments--;
+	if (test_and_clear_bit(REQ_ATOM_STARTED, &rq->atomic_flags)) {
+		if (q->dma_drain_size && blk_rq_bytes(rq))
+			rq->nr_phys_segments--;
+	}
 }
 
 void blk_mq_requeue_request(struct request *rq)
@@ -729,8 +731,6 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		rq = list_first_entry(&rq_list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 
-		blk_mq_start_request(rq);
-
 		ret = q->mq_ops->queue_rq(hctx, rq, list_empty(&rq_list));
 		switch (ret) {
 		case BLK_MQ_RQ_QUEUE_OK:
@@ -1177,7 +1177,6 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		int ret;
 
 		blk_mq_bio_to_request(rq, bio);
-		blk_mq_start_request(rq);
 
 		/*
 		 * For OK queue, we are done. For error, kill it. Any other
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 0e2084f..4042440 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3783,6 +3783,8 @@ static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	if (unlikely(mtip_check_unal_depth(hctx, rq)))
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
+	blk_mq_start_request(rq);
+
 	ret = mtip_submit_request(hctx, rq);
 	if (likely(!ret))
 		return BLK_MQ_RQ_QUEUE_OK;
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index c5b7315..332ce20 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -321,6 +321,8 @@ static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	cmd->rq = rq;
 	cmd->nq = hctx->driver_data;
 
+	blk_mq_start_request(rq);
+
 	null_handle_cmd(cmd);
 	return BLK_MQ_RQ_QUEUE_OK;
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 13756e0..83816bf 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -205,6 +205,8 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 		}
 	}
 
+	blk_mq_start_request(req);
+
 	num = blk_rq_map_sg(hctx->queue, vbr->req, vbr->sg);
 	if (num) {
 		if (rq_data_dir(vbr->req) == WRITE)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1ec00ba..b06a355 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1890,6 +1890,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
+	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 9c4e306..878b6f7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -159,6 +159,7 @@ struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
 
+void blk_mq_start_request(struct request *rq);
 void blk_mq_end_io(struct request *rq, int error);
 void __blk_mq_end_io(struct request *rq, int error);
 
-- 
1.9.1
