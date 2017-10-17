From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/2] SCSI: run idle hctx after delay in scsi_mq_get_budget()
Date: Tue, 17 Oct 2017 13:04:17 +0800
Message-ID: <20171017050418.22555-2-ming.lei@redhat.com>
References: <20171017050418.22555-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171017050418.22555-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

If there isn't any outstanding request in this queue, both
blk-mq's RESTART and SCSI's builtin RESTART can't work,
so we have to deal with this case by running this queue
after delay.

Fixes: d04b6d97d0a1(scsi: implement .get_budget and .put_budget for blk-mq)
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6f10afaca25b..08c495364b28 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1959,6 +1959,14 @@ static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
 	put_device(&sdev->sdev_gendev);
 }
 
+static void scsi_mq_run_idle_hctx(struct scsi_device *sdev,
+		struct blk_mq_hw_ctx *hctx)
+{
+	if (atomic_read(&sdev->device_busy) == 0 &&
+	    !scsi_device_blocked(sdev))
+		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
+}
+
 static blk_status_t scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
@@ -1989,6 +1997,7 @@ static blk_status_t scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 out_put_device:
 	put_device(&sdev->sdev_gendev);
 out:
+	scsi_mq_run_idle_hctx(sdev, hctx);
 	return BLK_STS_RESOURCE;
 }
 
@@ -2039,9 +2048,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) == 0 &&
-		    !scsi_device_blocked(sdev))
-			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
+		scsi_mq_run_idle_hctx(sdev, hctx);
 		break;
 	default:
 		/*
-- 
2.9.5
