From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V7 6/6] SCSI: set block queue at preempt only when SCSI device is put into quiesce
Date: Sat, 30 Sep 2017 14:12:14 +0800
Message-ID: <20170930061214.10622-7-ming.lei@redhat.com>
References: <20170930061214.10622-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930061214.10622-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Simply quiesing SCSI device and waiting for completeion of IO
dispatched to SCSI queue isn't safe, it is easy to use up
request pool because all allocated requests before can't
be dispatched when device is put in QIUESCE. Then no request
can be allocated for RQF_PREEMPT, and system may hang somewhere,
such as When sending commands of sync_cache or start_stop during
system suspend path.

Before quiesing SCSI, this patch sets block queue in preempt
mode first, so no new normal request can enter queue any more,
and all pending requests are drained too once blk_set_preempt_only(true)
is returned. Then RQF_PREEMPT can be allocated successfully duirng
SCSI quiescing.

This patch fixes one long term issue of IO hang, in either block legacy
and blk-mq.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: stable@vger.kernel.org
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..82c51619f1b7 100644
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
+	 * So we set block queue in preempt only first, no new
+	 * normal request can enter queue any more, and all pending
+	 * requests are drained once blk_set_preempt_only()
+	 * returns. Only RQF_PREEMPT is allowed in preempt only mode.
+	 */
+	blk_set_preempt_only(sdev->request_queue, true);
+
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
 	mutex_unlock(&sdev->state_mutex);
 
-	if (err)
+	if (err) {
+		blk_set_preempt_only(sdev->request_queue, false);
 		return err;
+	}
 
 	scsi_run_queue(sdev->request_queue);
 	while (atomic_read(&sdev->device_busy)) {
@@ -2964,6 +2981,8 @@ void scsi_device_resume(struct scsi_device *sdev)
 	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
 		scsi_run_queue(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
+
+	blk_set_preempt_only(sdev->request_queue, false);
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
-- 
2.9.5
