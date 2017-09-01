From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 8/8] SCSI: freeze block queue when SCSI device is put into quiesce
Date: Sat,  2 Sep 2017 02:49:58 +0800
Message-ID: <20170901184958.19452-10-ming.lei@redhat.com>
References: <20170901184958.19452-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901184958.19452-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
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
 drivers/scsi/scsi_lib.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6097b89d5d3..a59544012b68 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -243,10 +243,12 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct request *req;
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
+	unsigned flag = sdev->sdev_state == SDEV_QUIESCE ? BLK_REQ_PREEMPT : 0;
 
-	req = blk_get_request(sdev->request_queue,
+	req = __blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM,
+			flag);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -2890,6 +2892,19 @@ scsi_device_quiesce(struct scsi_device *sdev)
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
+	blk_freeze_queue_preempt(sdev->request_queue);
+
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
 	mutex_unlock(&sdev->state_mutex);
@@ -2926,6 +2941,8 @@ void scsi_device_resume(struct scsi_device *sdev)
 	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
 		scsi_run_queue(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
+
+	blk_unfreeze_queue_preempt(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
-- 
2.9.5
