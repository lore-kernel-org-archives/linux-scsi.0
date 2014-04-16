From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/8] blk-mq: add async paramter to blk_mq_start_stopped_hw_queues
Date: Wed, 16 Apr 2014 09:44:54 +0200
Message-ID: <1397634299-7466-4-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             |    4 ++--
 drivers/block/virtio_blk.c |    4 ++--
 include/linux/blk-mq.h     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index afdab13..8a080c2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -698,7 +698,7 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
 
-void blk_mq_start_stopped_hw_queues(struct request_queue *q)
+void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 {
 	struct blk_mq_hw_ctx *hctx;
 	int i;
@@ -709,7 +709,7 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q)
 
 		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
 		preempt_disable();
-		blk_mq_run_hw_queue(hctx, true);
+		blk_mq_run_hw_queue(hctx, async);
 		preempt_enable();
 	}
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index f909a88..7a51f06 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -151,7 +151,7 @@ static void virtblk_done(struct virtqueue *vq)
 
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
-		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
 }
 
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
@@ -762,7 +762,7 @@ static int virtblk_restore(struct virtio_device *vdev)
 	vblk->config_enable = true;
 	ret = init_vq(vdev->priv);
 	if (!ret)
-		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+		blk_mq_start_stopped_hw_queues(vblk->disk->queue, true);
 
 	return ret;
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a81b474..9ecfab9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -157,7 +157,7 @@ void blk_mq_complete_request(struct request *rq);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
-void blk_mq_start_stopped_hw_queues(struct request_queue *q);
+void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 
 /*
  * Driver command data is immediately after the request. So subtract request
-- 
1.7.10.4
