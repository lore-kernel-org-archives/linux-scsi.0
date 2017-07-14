From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/6] block: don't call blk_mq_delay_run_hw_queue() in case of BLK_STS_RESOURCE
Date: Sat, 15 Jul 2017 07:15:58 +0800
Message-ID: <20170714231601.14444-4-ming.lei@redhat.com>
References: <20170714231601.14444-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdGNXSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jul 2017 19:18:09 -0400
In-Reply-To: <20170714231601.14444-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

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

Also delay a while radomly is also like a workaround.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org
Cc: "James E.J. Bottomley"
Cc: "Martin K. Petersen"
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
index d666ada39a9b..3155bbcd26a2 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1967,9 +1967,6 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 		if (ret != -EBUSY)
 			return BLK_STS_IOERR;
 
-		if (op->rq)
-			blk_mq_delay_run_hw_queue(queue->hctx, NVMEFC_QUEUE_DELAY);
-
 		return BLK_STS_RESOURCE;
 	}
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 91d890356b78..03a7d7953df2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1974,11 +1974,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
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
2.9.4
