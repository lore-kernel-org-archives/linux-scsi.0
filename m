From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/9] block/scsi: safe SCSI quiescing
Date: Fri, 1 Sep 2017 11:45:33 +0800
Message-ID: <20170901034532.GD16525@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <1576539.niWZoWEnd8@natalenko.name>
 <20170831173833.GC5928@ming.t460p>
 <14328863.IIXMb7O2AM@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14328863.IIXMb7O2AM@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 31, 2017 at 08:31:54PM +0200, Oleksandr Natalenko wrote:
> Tested against v4.13-rc7. With this patchset it looks like I/O doesn't hang, 
> but once (just once, not each time) I've got the following stacktrace on 
> resume:

That looks not bad, and thanks for your test!

Could you try the following patch against this patchset to see
if there is still the warning?


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b9ad8aeb456f..bbd85ddad18c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -243,11 +243,12 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct request *req;
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
+	unsigned flag = sdev->sdev_state == SDEV_QUIESCE ? BLK_REQ_PREEMPT : 0;
 
 	req = __blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM,
-			BLK_REQ_PREEMPT);
+			flag);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -2931,11 +2932,6 @@ EXPORT_SYMBOL(scsi_device_quiesce);
  */
 void scsi_device_resume(struct scsi_device *sdev)
 {
-	/* wait for completion of IO issued during SCSI quiese */
-	blk_freeze_queue_wait(sdev->request_queue);
-
-	blk_unfreeze_queue(sdev->request_queue);
-
 	/* check if the device state was mutated prior to resume, and if
 	 * so assume the state is being managed elsewhere (for example
 	 * device deleted during suspend)
@@ -2945,6 +2941,11 @@ void scsi_device_resume(struct scsi_device *sdev)
 	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
 		scsi_run_queue(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
+
+	/* wait for completion of IO issued during SCSI quiese */
+	blk_freeze_queue_wait(sdev->request_queue);
+
+	blk_unfreeze_queue(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
-- 
Ming
