From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 25/39] blk-mq: add async paramter to blk_mq_start_stopped_hw_queues
Date: Mon, 17 Mar 2014 06:27:58 -0700
Message-ID: <20140317133135.117680200@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0025-blk-mq-add-async-paramter-to-blk_mq_start_stopped_hw.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             |    4 ++--
 drivers/block/virtio_blk.c |    4 ++--
 include/linux/blk-mq.h     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9e13761..6f04dda 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -671,7 +671,7 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
 
-void blk_mq_start_stopped_hw_queues(struct request_queue *q)
+void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 {
 	struct blk_mq_hw_ctx *hctx;
 	int i;
@@ -681,7 +681,7 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q)
 			continue;
 
 		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
-		blk_mq_run_hw_queue(hctx, true);
+		blk_mq_run_hw_queue(hctx, async);
 	}
 }
 EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a2e925b..3232b83 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -148,7 +148,7 @@ static void virtblk_done(struct virtqueue *vq)
 
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
-		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -734,7 +734,7 @@ static int virtblk_restore(struct virtio_device *vdev)
 	vblk->config_enable = true;
 	ret = init_vq(vdev->priv);
 	if (!ret)
-		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
 
 	return ret;
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 6325a24..4d34957 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -155,7 +155,7 @@ void blk_mq_complete_request(struct request *rq);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
-void blk_mq_start_stopped_hw_queues(struct request_queue *q);
+void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 
 /*
  * Driver command data is immediately after the request. So subtract request
-- 
1.7.10.4
