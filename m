From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 5/6] scsi: Avoid that SCSI queues get stuck
Date: Fri, 7 Apr 2017 11:16:53 -0700
Message-ID: <20170407181654.27836-6-bart.vanassche@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Long Li <longli@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

If a .queue_rq() function returns BLK_MQ_RQ_QUEUE_BUSY then the block
driver that implements that function is responsible for rerunning the
hardware queue once requests can be queued again successfully.

commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped
queues") removed the blk_mq_stop_hw_queue() call from scsi_queue_rq()
for the BLK_MQ_RQ_QUEUE_BUSY case. Hence change all calls to functions
that are intended to rerun a busy queue such that these examine all
hardware queues instead of only stopped queues.

Since no other functions than scsi_internal_device_block() and
scsi_internal_device_unblock() should ever stop or restart a SCSI
queue, change the blk_mq_delay_queue() call into a
blk_mq_delay_run_hw_queue() call.

Fixes: commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped queues")
Fixes: commit 7e79dadce222 ("blk-mq: stop hardware queue in blk_mq_delay_queue()")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Long Li <longli@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/scsi_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 11972d1075f1..7bc4513bf4e4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -496,7 +496,7 @@ static void scsi_run_queue(struct request_queue *q)
 		scsi_starved_list_run(sdev->host);
 
 	if (q->mq_ops)
-		blk_mq_start_stopped_hw_queues(q, false);
+		blk_mq_run_hw_queues(q, false);
 	else
 		blk_run_queue(q);
 }
@@ -667,7 +667,7 @@ static bool scsi_end_request(struct request *req, int error,
 		    !list_empty(&sdev->host->starved_list))
 			kblockd_schedule_work(&sdev->requeue_work);
 		else
-			blk_mq_start_stopped_hw_queues(q, true);
+			blk_mq_run_hw_queues(q, true);
 	} else {
 		unsigned long flags;
 
@@ -1974,7 +1974,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_MQ_RQ_QUEUE_BUSY:
 		if (atomic_read(&sdev->device_busy) == 0 &&
 		    !scsi_device_blocked(sdev))
-			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
+			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
 		break;
 	case BLK_MQ_RQ_QUEUE_ERROR:
 		/*
-- 
2.12.0
