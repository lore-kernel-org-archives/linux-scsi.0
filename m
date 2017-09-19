From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 10/10] SCSI: preempt freeze block queue when SCSI device is put into quiesce
Date: Tue, 19 Sep 2017 11:49:25 +0800
Message-ID: <20170919034925.9894-11-ming.lei@redhat.com>
References: <20170919034925.9894-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdISDvj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Sep 2017 23:51:39 -0400
In-Reply-To: <20170919034925.9894-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>

Simply quiesing SCSI device and waiting for completeion of IO
dispatched to SCSI queue isn't safe, it is easy to use up
request pool because all allocated requests before can't
be dispatched when device is put in QIUESCE. Then no request
can be allocated for RQF_PREEMPT, and system may hang somewhere,
such as When sending commands of sync_cache or start_stop during
system suspend path.

Before quiesing SCSI, this patch freezes block queue in preempt
mode first, so no new normal request can enter queue any more,
and all pending requests are drained too once blk_freeze_queue_preempt
is returned. Then RQF_PREEMPT can be allocated successfully duirng
preempt freeze.

Tested-by: Cathy Avery <cavery@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..751a956b7b2b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -252,9 +252,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
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
@@ -2928,12 +2929,28 @@ scsi_device_quiesce(struct scsi_device *sdev)
 {
 	int err;
 
+	/*
+	 * Simply quiesing SCSI device isn't safe, it is easy
+	 * to use up requests because all these allocated requests
+	 * can't be dispatched when device is put in QIUESCE.
+	 * Then no request can be allocated and we may hang
+	 * somewhere, such as system suspend/resume.
+	 *
+	 * So we freeze block queue in preempt mode first, no new
+	 * normal request can enter queue any more, and all pending
+	 * requests are drained once blk_freeze_queue_preempt()
+	 * is returned. Only RQF_PREEMPT is allowed in preempt freeze.
+	 */
+	blk_freeze_queue_preempt(sdev->request_queue);
+
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
 	mutex_unlock(&sdev->state_mutex);
 
-	if (err)
+	if (err) {
+		blk_unfreeze_queue_preempt(sdev->request_queue);
 		return err;
+	}
 
 	scsi_run_queue(sdev->request_queue);
 	while (atomic_read(&sdev->device_busy)) {
@@ -2964,6 +2981,8 @@ void scsi_device_resume(struct scsi_device *sdev)
 	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
 		scsi_run_queue(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
+
+	blk_unfreeze_queue_preempt(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
-- 
2.9.5
