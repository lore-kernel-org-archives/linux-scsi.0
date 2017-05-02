From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v6 2/5] Create two versions of scsi_internal_device_unblock()
Date: Tue, 2 May 2017 11:00:40 -0700
Message-ID: <20170502180043.14734-3-bart.vanassche@sandisk.com>
References: <20170502180043.14734-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22856 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdEBSA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 14:00:58 -0400
In-Reply-To: <20170502180043.14734-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

This will make it easier to serialize SCSI device state changes
through a mutex.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 ++--
 drivers/scsi/scsi_lib.c              | 46 +++++++++++++++++++++++++-----------
 include/scsi/scsi_device.h           |  4 ++--
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 25e89cfe4417..d671f6e6062c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2883,7 +2883,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running, "
 	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 0;
-	r = scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+	r = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
 	if (r == -EINVAL) {
 		/* The device has been set to SDEV_RUNNING by SD layer during
 		 * device addition but the request queue is still stopped by
@@ -2902,7 +2902,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 			    r, sas_device_priv_data->sas_target->handle);
 
 		sas_device_priv_data->block = 0;
-		r = scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+		r = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
 		if (r)
 			sdev_printk(KERN_WARNING, sdev, "retried device_unblock"
 			    " failed with return(%d) for handle(0x%04x)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ca20d3702b45..79bb05fa09d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3016,24 +3016,22 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 }
  
 /**
- * scsi_internal_device_unblock - resume a device after a block request
+ * scsi_internal_device_unblock_nowait - resume a device after a block request
  * @sdev:	device to resume
- * @new_state:	state to set devices to after unblocking
+ * @new_state:	state to set the device to after unblocking
  *
- * Called by scsi lld's or the midlayer to restart the device queue
- * for the previously suspended scsi device.  Called from interrupt or
- * normal process context.
+ * Restart the device queue for a previously suspended SCSI device. Does not
+ * sleep.
  *
- * Returns zero if successful or error if not.
+ * Returns zero if successful or a negative error code upon failure.
  *
- * Notes:       
- *	This routine transitions the device to the SDEV_RUNNING state
- *	or to one of the offline states (which must be a legal transition)
- *	allowing the midlayer to goose the queue for this device.
+ * Notes:
+ * This routine transitions the device to the SDEV_RUNNING state or to one of
+ * the offline states (which must be a legal transition) allowing the midlayer
+ * to goose the queue for this device.
  */
-int
-scsi_internal_device_unblock(struct scsi_device *sdev,
-			     enum scsi_device_state new_state)
+int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
+					enum scsi_device_state new_state)
 {
 	struct request_queue *q = sdev->request_queue; 
 	unsigned long flags;
@@ -3065,7 +3063,27 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
+EXPORT_SYMBOL_GPL(scsi_internal_device_unblock_nowait);
+
+/**
+ * scsi_internal_device_unblock - resume a device after a block request
+ * @sdev:	device to resume
+ * @new_state:	state to set the device to after unblocking
+ *
+ * Restart the device queue for a previously suspended SCSI device. May sleep.
+ *
+ * Returns zero if successful or a negative error code upon failure.
+ *
+ * Notes:
+ * This routine transitions the device to the SDEV_RUNNING state or to one of
+ * the offline states (which must be a legal transition) allowing the midlayer
+ * to goose the queue for this device.
+ */
+static int scsi_internal_device_unblock(struct scsi_device *sdev,
+					enum scsi_device_state new_state)
+{
+	return scsi_internal_device_unblock_nowait(sdev, new_state);
+}
 
 static void
 device_block(struct scsi_device *sdev, void *data)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e2f43ae3e264..bb784045ba71 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -473,8 +473,8 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 }
 
 int scsi_internal_device_block_nowait(struct scsi_device *sdev);
-int scsi_internal_device_unblock(struct scsi_device *sdev,
-				 enum scsi_device_state new_state);
+int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
+					enum scsi_device_state new_state);
 
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
-- 
2.12.2
