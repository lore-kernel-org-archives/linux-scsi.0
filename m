From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 9/9] SCSI: freeze block queue when SCSI device is put into quiesce
Date: Fri,  1 Sep 2017 01:27:28 +0800
Message-ID: <20170831172728.15817-10-ming.lei@redhat.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170831172728.15817-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Simply quiesing SCSI device and waiting for completeion of IO
dispatched to SCSI queue isn't safe, it is easy to use up
requests because all these allocated requests can't be dispatched
when device is put in QIUESCE. Then no request can be allocated
for RQF_PREEMPT, and system may hang somewhere, such as
When sending commands of sync_cache or start_stop during
system suspend path.

Before quiesing SCSI, this patch freezes block queue first,
so no new request can enter queue any more, and all pending
requests are drained too once blk_freeze_queue is returned.

This patch also uses __blk_get_request() for allocating
request with RQF_PREEMPT, so that the allocation can
succeed even though block queue is frozen.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/ide/ide-pm.c    |  3 ++-
 drivers/scsi/scsi_lib.c | 23 +++++++++++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 544f02d673ca..4970e3561b13 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -89,7 +89,8 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
+	rq = __blk_get_request(drive->queue, REQ_OP_DRV_IN,
+			       __GFP_RECLAIM, BLK_REQ_PREEMPT);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	rq->rq_flags |= RQF_PREEMPT;
 	rq->special = &rqpm;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6097b89d5d3..b9ad8aeb456f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -244,9 +244,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
 
-	req = blk_get_request(sdev->request_queue,
+	req = __blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM,
+			BLK_REQ_PREEMPT);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -2890,6 +2891,19 @@ scsi_device_quiesce(struct scsi_device *sdev)
 {
 	int err;
 
+	/*
+	 * Simply quiesing SCSI device isn't safe, it is easy
+	 * to use up requests because all these allocated requests
+	 * can't be dispatched when device is put in QIUESCE.
+	 * Then no request can be allocated and we may hang
+	 * somewhere, such as system suspend/resume.
+	 *
+	 * So we freeze block queue first, no new request can
+	 * enter queue any more, and pending requests are drained
+	 * once blk_freeze_queue is returned.
+	 */
+	blk_freeze_queue(sdev->request_queue);
+
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
 	mutex_unlock(&sdev->state_mutex);
@@ -2917,6 +2931,11 @@ EXPORT_SYMBOL(scsi_device_quiesce);
  */
 void scsi_device_resume(struct scsi_device *sdev)
 {
+	/* wait for completion of IO issued during SCSI quiese */
+	blk_freeze_queue_wait(sdev->request_queue);
+
+	blk_unfreeze_queue(sdev->request_queue);
+
 	/* check if the device state was mutated prior to resume, and if
 	 * so assume the state is being managed elsewhere (for example
 	 * device deleted during suspend)
-- 
2.9.5
