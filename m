From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] blk-mq: rename blk_mq_end_io to blk_mq_end_request
Date: Sat, 13 Sep 2014 16:40:10 -0700
Message-ID: <1410651613-1993-4-git-send-email-hch@lst.de>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that we've changed the driver API on the submission side use the
opportunity to fix up the name on the completion side to fit into the
general scheme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c                 |  4 ++--
 block/blk-mq.c                    | 16 ++++++++--------
 drivers/block/mtip32xx/mtip32xx.c |  4 ++--
 drivers/block/null_blk.c          |  2 +-
 drivers/block/virtio_blk.c        |  2 +-
 drivers/scsi/scsi_lib.c           |  4 ++--
 include/linux/blk-mq.h            |  4 ++--
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3cb5e9e..698e692 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -202,7 +202,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		list_del_init(&rq->flush.list);
 		blk_flush_restore_request(rq);
 		if (q->mq_ops)
-			blk_mq_end_io(rq, error);
+			blk_mq_end_request(rq, error);
 		else
 			__blk_end_request_all(rq, error);
 		break;
@@ -378,7 +378,7 @@ void blk_insert_flush(struct request *rq)
 	 */
 	if (!policy) {
 		if (q->mq_ops)
-			blk_mq_end_io(rq, 0);
+			blk_mq_end_request(rq, 0);
 		else
 			__blk_end_bidi_request(rq, 0, 0, 0);
 		return;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c3333ab..d1230ea 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -296,7 +296,7 @@ void blk_mq_clone_flush_request(struct request *flush_rq,
 		hctx->cmd_size);
 }
 
-inline void __blk_mq_end_io(struct request *rq, int error)
+inline void __blk_mq_end_request(struct request *rq, int error)
 {
 	blk_account_io_done(rq);
 
@@ -308,15 +308,15 @@ inline void __blk_mq_end_io(struct request *rq, int error)
 		blk_mq_free_request(rq);
 	}
 }
-EXPORT_SYMBOL(__blk_mq_end_io);
+EXPORT_SYMBOL(__blk_mq_end_request);
 
-void blk_mq_end_io(struct request *rq, int error)
+void blk_mq_end_request(struct request *rq, int error)
 {
 	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
 		BUG();
-	__blk_mq_end_io(rq, error);
+	__blk_mq_end_request(rq, error);
 }
-EXPORT_SYMBOL(blk_mq_end_io);
+EXPORT_SYMBOL(blk_mq_end_request);
 
 static void __blk_mq_complete_request_remote(void *data)
 {
@@ -356,7 +356,7 @@ void __blk_mq_complete_request(struct request *rq)
 	struct request_queue *q = rq->q;
 
 	if (!q->softirq_done_fn)
-		blk_mq_end_io(rq, rq->errors);
+		blk_mq_end_request(rq, rq->errors);
 	else
 		blk_mq_ipi_complete_request(rq);
 }
@@ -744,7 +744,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
 		case BLK_MQ_RQ_QUEUE_ERROR:
 			rq->errors = -EIO;
-			blk_mq_end_io(rq, rq->errors);
+			blk_mq_end_request(rq, rq->errors);
 			break;
 		}
 
@@ -1191,7 +1191,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 			if (ret == BLK_MQ_RQ_QUEUE_ERROR) {
 				rq->errors = -EIO;
-				blk_mq_end_io(rq, rq->errors);
+				blk_mq_end_request(rq, rq->errors);
 				goto done;
 			}
 		}
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 4042440..6b7e8d0 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -247,7 +247,7 @@ static void mtip_async_complete(struct mtip_port *port,
 	if (unlikely(cmd->unaligned))
 		up(&port->cmd_slot_unal);
 
-	blk_mq_end_io(rq, status ? -EIO : 0);
+	blk_mq_end_request(rq, status ? -EIO : 0);
 }
 
 /*
@@ -3739,7 +3739,7 @@ static int mtip_submit_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
 		int err;
 
 		err = mtip_send_trim(dd, blk_rq_pos(rq), blk_rq_sectors(rq));
-		blk_mq_end_io(rq, err);
+		blk_mq_end_request(rq, err);
 		return 0;
 	}
 
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 332ce20..ac50a29 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -177,7 +177,7 @@ static void end_cmd(struct nullb_cmd *cmd)
 {
 	switch (queue_mode)  {
 	case NULL_Q_MQ:
-		blk_mq_end_io(cmd->rq, 0);
+		blk_mq_end_request(cmd->rq, 0);
 		return;
 	case NULL_Q_RQ:
 		INIT_LIST_HEAD(&cmd->rq->queuelist);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 83816bf..f751fc3 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -135,7 +135,7 @@ static inline void virtblk_request_done(struct request *req)
 		req->errors = (error != 0);
 	}
 
-	blk_mq_end_io(req, error);
+	blk_mq_end_request(req, error);
 }
 
 static void virtblk_done(struct virtqueue *vq)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b06a355..e95adaa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -713,7 +713,7 @@ static bool scsi_end_request(struct request *req, int error,
 
 	if (req->mq_ctx) {
 		/*
-		 * In the MQ case the command gets freed by __blk_mq_end_io,
+		 * In the MQ case the command gets freed by __blk_mq_end_request,
 		 * so we have to do all cleanup that depends on it earlier.
 		 *
 		 * We also can't kick the queues from irq context, so we
@@ -721,7 +721,7 @@ static bool scsi_end_request(struct request *req, int error,
 		 */
 		scsi_mq_uninit_cmd(cmd);
 
-		__blk_mq_end_io(req, error);
+		__blk_mq_end_request(req, error);
 
 		if (scsi_target(sdev)->single_lun ||
 		    !list_empty(&sdev->host->starved_list))
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 878b6f7..cb217c1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -160,8 +160,8 @@ struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_ind
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
 
 void blk_mq_start_request(struct request *rq);
-void blk_mq_end_io(struct request *rq, int error);
-void __blk_mq_end_io(struct request *rq, int error);
+void blk_mq_end_request(struct request *rq, int error);
+void __blk_mq_end_request(struct request *rq, int error);
 
 void blk_mq_requeue_request(struct request *rq);
 void blk_mq_add_to_requeue_list(struct request *rq, bool at_head);
-- 
1.9.1
