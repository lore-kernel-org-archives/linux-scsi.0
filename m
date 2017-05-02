From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v6 1/5] Split scsi_internal_device_block()
Date: Tue, 2 May 2017 11:00:39 -0700
Message-ID: <20170502180043.14734-2-bart.vanassche@sandisk.com>
References: <20170502180043.14734-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42055 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdEBSAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 14:00:55 -0400
In-Reply-To: <20170502180043.14734-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

Instead of passing a "wait" argument to scsi_internal_device_block(),
split this function into a function that waits and a function that
doesn't wait. This will make it easier to serialize SCSI device state
changes through a mutex.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 +-
 drivers/scsi/scsi_lib.c              | 73 +++++++++++++++++++++++-------------
 include/scsi/scsi_device.h           |  2 +-
 3 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 919ba2bb15f1..25e89cfe4417 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2859,7 +2859,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
 
-	r = scsi_internal_device_block(sdev, false);
+	r = scsi_internal_device_block_nowait(sdev);
 	if (r == -EINVAL)
 		sdev_printk(KERN_WARNING, sdev,
 		    "device_block failed with return(%d) for handle(0x%04x)\n",
@@ -2895,7 +2895,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 		    "performing a block followed by an unblock\n",
 		    r, sas_device_priv_data->sas_target->handle);
 		sas_device_priv_data->block = 1;
-		r = scsi_internal_device_block(sdev, false);
+		r = scsi_internal_device_block_nowait(sdev);
 		if (r)
 			sdev_printk(KERN_WARNING, sdev, "retried device_block "
 			    "failed with return(%d) for handle(0x%04x)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7b340c494ab..ca20d3702b45 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2937,28 +2937,20 @@ scsi_target_resume(struct scsi_target *starget)
 EXPORT_SYMBOL(scsi_target_resume);
 
 /**
- * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
- * @sdev:	device to block
- * @wait:	Whether or not to wait until ongoing .queuecommand() /
- *		.queue_rq() calls have finished.
+ * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
+ * @sdev: device to block
  *
- * Block request made by scsi lld's to temporarily stop all
- * scsi commands on the specified device. May sleep.
+ * Pause SCSI command processing on the specified device. Does not sleep.
  *
- * Returns zero if successful or error if not
+ * Returns zero if successful or a negative error code upon failure.
  *
- * Notes:       
- *	This routine transitions the device to the SDEV_BLOCK state
- *	(which must be a legal transition).  When the device is in this
- *	state, all commands are deferred until the scsi lld reenables
- *	the device with scsi_device_unblock or device_block_tmo fires.
- *
- * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
- * scsi_internal_device_block() has blocked a SCSI device and also
- * remove the rport mutex lock and unlock calls from srp_queuecommand().
+ * Notes:
+ * This routine transitions the device to the SDEV_BLOCK state (which must be
+ * a legal transition). When the device is in this state, command processing
+ * is paused until the device leaves the SDEV_BLOCK state. See also
+ * scsi_internal_device_unblock_nowait().
  */
-int
-scsi_internal_device_block(struct scsi_device *sdev, bool wait)
+int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 {
 	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
@@ -2978,21 +2970,50 @@ scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 	 * request queue. 
 	 */
 	if (q->mq_ops) {
-		if (wait)
-			blk_mq_quiesce_queue(q);
-		else
-			blk_mq_stop_hw_queues(q);
+		blk_mq_stop_hw_queues(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		if (wait)
-			scsi_wait_for_queuecommand(sdev);
 	}
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(scsi_internal_device_block);
+EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
+
+/**
+ * scsi_internal_device_block - try to transition to the SDEV_BLOCK state
+ * @sdev: device to block
+ *
+ * Pause SCSI command processing on the specified device and wait until all
+ * ongoing scsi_request_fn() / scsi_queue_rq() calls have finished. May sleep.
+ *
+ * Returns zero if successful or a negative error code upon failure.
+ *
+ * Note:
+ * This routine transitions the device to the SDEV_BLOCK state (which must be
+ * a legal transition). When the device is in this state, command processing
+ * is paused until the device leaves the SDEV_BLOCK state. See also
+ * scsi_internal_device_unblock().
+ *
+ * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
+ * scsi_internal_device_block() has blocked a SCSI device and also
+ * remove the rport mutex lock and unlock calls from srp_queuecommand().
+ */
+static int scsi_internal_device_block(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+	int err;
+
+	err = scsi_internal_device_block_nowait(sdev);
+	if (err == 0) {
+		if (q->mq_ops)
+			blk_mq_quiesce_queue(q);
+		else
+			scsi_wait_for_queuecommand(sdev);
+	}
+	return err;
+}
  
 /**
  * scsi_internal_device_unblock - resume a device after a block request
@@ -3049,7 +3070,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
 static void
 device_block(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_block(sdev, true);
+	scsi_internal_device_block(sdev);
 }
 
 static int
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 080c7ce9bae8..e2f43ae3e264 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -472,7 +472,7 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 
-int scsi_internal_device_block(struct scsi_device *sdev, bool wait);
+int scsi_internal_device_block_nowait(struct scsi_device *sdev);
 int scsi_internal_device_unblock(struct scsi_device *sdev,
 				 enum scsi_device_state new_state);
 
-- 
2.12.2
