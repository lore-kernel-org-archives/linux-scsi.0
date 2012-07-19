From: <sreekanth.reddy@lsi.com>
Subject: [RESEND] [PATCH] [SCSI] mptfusion: Fix for issue - The device is
 removed in blocked state
Date: Thu, 19 Jul 2012 09:13:21 +0530
Message-ID: <20120719034321.GA3543@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:46126 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab2GSJyr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2012 05:54:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, jejb@kernel.org, stable@vger.kernel.org
Cc: sreekanth.reddy@lsi.com

Fix for issue - The device is removed in blocked state.

The device is set to blocked state when I/Os running and the cable is pulled.
Also if the device missing delay timer is started. When the device missing
delay timer expires, the device is removed but the device state is not set to
unblocked state. This will cause problems  if there are commands in block
queue.

To fix this issue, added code to unblock the device before removing it.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Cc: <stable@kernel.org>
---

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 551262e..4d02d5d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1088,7 +1088,13 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 static void
 mptsas_block_io_sdev(struct scsi_device *sdev, void *data)
 {
-	scsi_device_set_state(sdev, SDEV_BLOCK);
+	scsi_internal_device_block(sdev);
+}
+
+static void
+mptsas_ublock_io_sdev(struct scsi_device *sdev, void *data)
+{
+	scsi_internal_device_unblock(sdev);
 }
 
 static void
@@ -1098,6 +1104,13 @@ mptsas_block_io_starget(struct scsi_target *starget)
 		starget_for_each_device(starget, NULL, mptsas_block_io_sdev);
 }
 
+static void
+mptsas_ublock_io_starget(struct scsi_target *starget)
+{
+	if (starget)
+		starget_for_each_device(starget, NULL, mptsas_ublock_io_sdev);
+}
+
 /**
  * mptsas_target_reset_queue
  *
@@ -1502,6 +1515,7 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 	char *ds = NULL;
 	u8 fw_id;
 	u64 sas_address;
+	VirtTarget	*vtarget;
 
 	if (!phy_info)
 		return;
@@ -1545,6 +1559,13 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 	    phy_info->attached.id, phy_info->attached.phy_id,
 	    (unsigned long long) sas_address);
 
+	vtarget = mptsas_find_vtarget(ioc,
+			 phy_info->attached.channel, phy_info->attached.id);
+	if (vtarget && vtarget->deleted == 1) {
+		mptsas_ublock_io_starget(vtarget->starget);
+		vtarget->deleted = 0; /* unblock IO */
+	}
+
 	port = mptsas_get_port(phy_info);
 	if (!port) {
 		dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 57e86ab..1567f57 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -189,4 +189,7 @@ struct mptsas_enclosure {
 };
 
 /*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev);
 #endif
