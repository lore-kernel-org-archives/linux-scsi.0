From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 8/8] SCSI: preempt freeze block queue when SCSI device is put into quiesce
Date: Sat,  2 Sep 2017 21:08:40 +0800
Message-ID: <20170902130840.24609-9-ming.lei@redhat.com>
References: <20170902130840.24609-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdIBNKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Sep 2017 09:10:22 -0400
In-Reply-To: <20170902130840.24609-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>

Simply quiesing SCSI device and waiting for completeion of IO
dispatched to SCSI queue isn't safe, it is easy to use up
requests because all these allocated requests can't be dispatched
when device is put in QIUESCE. Then no request can be allocated
for RQF_PREEMPT, and system may hang somewhere, such as
When sending commands of sync_cache or start_stop during
system suspend path.

Before quiesing SCSI, this patch freezes block queue in preempt
mode first, so no new normal request can enter queue any more,
and all pending requests are drained too once blk_freeze_queue_preempt
is returned. And only RQF_PREEMPT can be allocated in preempt freeze.

This patch also uses __blk_get_request() for allocating
request with RQF_PREEMPT, so that the allocation can
succeed even though block queue is preempt frozen.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6097b89d5d3..e1ad135cb209 100644
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
@@ -2890,6 +2892,20 @@ scsi_device_quiesce(struct scsi_device *sdev)
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
+	 * requests are drained once blk_freeze_queue is returned.
+	 * Only RQF_PREEMPT is allowed in preempt freeze.
+	 */
+	blk_freeze_queue_preempt(sdev->request_queue);
+
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
 	mutex_unlock(&sdev->state_mutex);
@@ -2926,6 +2942,8 @@ void scsi_device_resume(struct scsi_device *sdev)
 	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
 		scsi_run_queue(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
+
+	blk_unfreeze_queue_preempt(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
-- 
2.9.5
