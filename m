From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case of BLK_STS_RESOURCE
Date: Sat, 16 Sep 2017 00:44:52 +0800
Message-ID: <20170915164456.9803-2-ming.lei@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If .queue_rq() returns BLK_STS_RESOURCE, blk-mq will rerun
the queue in the three situations:

1) if BLK_MQ_S_SCHED_RESTART is set
- queue is rerun after one rq is completed, see blk_mq_sched_restart()
which is run from blk_mq_free_request()

2) BLK_MQ_S_TAG_WAITING is set
- queue is rerun after one tag is freed

3) otherwise
- queue is run immediately in blk_mq_dispatch_rq_list()

So calling blk_mq_delay_run_hw_queue() inside .queue_rq() doesn't make
sense because no matter it is called or not, the queue still will be
rerun soon in above three situations, and the busy req can be dispatched
again.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c      | 1 -
 drivers/nvme/host/fc.c  | 3 ---
 drivers/scsi/scsi_lib.c | 4 ----
 3 files changed, 8 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c6ebc5b1e00e..71422cea1c4a 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -761,7 +761,6 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
-		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
 		return BLK_STS_RESOURCE;
 	}
 
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index d2e882c0f496..17727eee5d5f 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2041,9 +2041,6 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 	return BLK_STS_OK;
 
 busy:
-	if (!(op->flags & FCOP_FLAGS_AEN) && queue->hctx)
-		blk_mq_delay_run_hw_queue(queue->hctx, NVMEFC_QUEUE_DELAY);
-
 	return BLK_STS_RESOURCE;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..71d5bf1345c9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2010,11 +2010,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out:
 	switch (ret) {
 	case BLK_STS_OK:
-		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) == 0 &&
-		    !scsi_device_blocked(sdev))
-			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
 		break;
 	default:
 		/*
-- 
2.9.5
