From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 19/20] [SCSI] mpt3sas: When device is blocked  followed by unblock fails, unfreeze the I/Os
Date: Tue, 30 Jun 2015 12:25:05 +0530
Message-ID: <1435647306-36956-20-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33592 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbF3G4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:56:47 -0400
Received: by pdjd13 with SMTP id d13so828472pdj.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:56:46 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Issue: When the disks are getting discovered and assigned device
handles by the kernel, a device block followed by an unblock
(due to broadcast primitives) issued by the driver is
interspersed by the kernel changing the state of the device.
Therefore the unblock by the driver results in a no operation
within the kernel API.

To fix this one, the below patch checks the return of the unblock API
and performs a block followed by an unblock to unfreeze the block
layer's I/O queue. Sufficient checks and prints are also added in the
driver to identify this condition caused by the kernel.

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 89 ++++++++++++++++++++++++++++++------
 1 file changed, 75 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a136ec8..7e5926c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2605,6 +2605,75 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
+ * _scsih_internal_device_block - block the sdev device
+ * @sdev: per device object
+ * @sas_device_priv_data : per device driver private data
+ *
+ * make sure device is blocked without error, if not
+ * print an error
+ */
+static void
+_scsih_internal_device_block(struct scsi_device *sdev,
+			struct MPT3SAS_DEVICE *sas_device_priv_data)
+{
+	int r = 0;
+
+	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
+	    sas_device_priv_data->sas_target->handle);
+	sas_device_priv_data->block = 1;
+
+	r = scsi_internal_device_block(sdev);
+	if (r == -EINVAL)
+		sdev_printk(KERN_WARNING, sdev,
+		    "device_block failed with return(%d) for handle(0x%04x)\n",
+		    sas_device_priv_data->sas_target->handle, r);
+}
+
+/**
+ * _scsih_internal_device_unblock - unblock the sdev device
+ * @sdev: per device object
+ * @sas_device_priv_data : per device driver private data
+ * make sure device is unblocked without error, if not retry
+ * by blocking and then unblocking
+ */
+
+static void
+_scsih_internal_device_unblock(struct scsi_device *sdev,
+			struct MPT3SAS_DEVICE *sas_device_priv_data)
+{
+	int r = 0;
+
+	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running, "
+	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
+	sas_device_priv_data->block = 0;
+	r = scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+	if (r == -EINVAL) {
+		/* The device has been set to SDEV_RUNNING by SD layer during
+		 * device addition but the request queue is still stopped by
+		 * our earlier block call. We need to perform a block again
+		 * to get the device to SDEV_BLOCK and then to SDEV_RUNNING */
+
+		sdev_printk(KERN_WARNING, sdev,
+		    "device_unblock failed with return(%d) for handle(0x%04x) "
+		    "performing a block followed by an unblock\n",
+		    sas_device_priv_data->sas_target->handle, r);
+		sas_device_priv_data->block = 1;
+		r = scsi_internal_device_block(sdev);
+		if (r)
+			sdev_printk(KERN_WARNING, sdev, "retried device_block "
+			    "failed with return(%d) for handle(0x%04x)\n",
+			    sas_device_priv_data->sas_target->handle, r);
+
+		sas_device_priv_data->block = 0;
+		r = scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+		if (r)
+			sdev_printk(KERN_WARNING, sdev, "retried device_unblock"
+			    " failed with return(%d) for handle(0x%04x)\n",
+			    sas_device_priv_data->sas_target->handle, r);
+	}
+}
+
+/**
  * _scsih_ublock_io_all_device - unblock every device
  * @ioc: per adapter object
  *
@@ -2623,11 +2692,10 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 		if (!sas_device_priv_data->block)
 			continue;
 
-		sas_device_priv_data->block = 0;
 		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
 			"device_running, handle(0x%04x)\n",
 		    sas_device_priv_data->sas_target->handle));
-		scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
 	}
 }
 
@@ -2652,10 +2720,9 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
 			continue;
-		if (sas_device_priv_data->block) {
-			sas_device_priv_data->block = 0;
-			scsi_internal_device_unblock(sdev, SDEV_RUNNING);
-		}
+		if (sas_device_priv_data->block)
+			_scsih_internal_device_unblock(sdev,
+				sas_device_priv_data);
 	}
 }
 
@@ -2678,10 +2745,7 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		if (sas_device_priv_data->block)
 			continue;
-		sas_device_priv_data->block = 1;
-		scsi_internal_device_block(sdev);
-		sdev_printk(KERN_INFO, sdev, "device_blocked, handle(0x%04x)\n",
-		    sas_device_priv_data->sas_target->handle);
+		_scsih_internal_device_block(sdev, sas_device_priv_data);
 	}
 }
 
@@ -2713,10 +2777,7 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		if (sas_device->pend_sas_rphy_add)
 			continue;
-		sas_device_priv_data->block = 1;
-		scsi_internal_device_block(sdev);
-		sdev_printk(KERN_INFO, sdev,
-			"device_blocked, handle(0x%04x)\n", handle);
+		_scsih_internal_device_block(sdev, sas_device_priv_data);
 	}
 }
 
-- 
2.0.2

