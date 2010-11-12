From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 08/11] mpt2sas: change queue depth with reason argument more appropriately
Date: Sat, 13 Nov 2010 04:39:11 +0530
Message-ID: <20101112230904.GJ853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39072 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933178Ab0KLXvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:51:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

change_queue_depth callback API changed
The change_queue_depth callback changed where there is now an additional
parameter called reason, with SCSI_QDEPTH_DEFAULT, SCSI_QDEPTH_QFULL,
and SCSI_QDEPTH_RAMP_UP codes.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index dc10e1c..2b13438 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1102,28 +1102,24 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_change_queue_depth - setting device queue depth
+ * _scsih_adjust_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: calling context
  *
- * Returns queue depth.
+ *
+ * Returns nothing
  */
-static int
-_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+static void
+_scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
-	int tag_type;
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct _sas_device *sas_device;
 	unsigned long flags;
 
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	max_depth = shost->can_queue;
 
 	/* limit max device queue for SATA to 32 */
@@ -1149,8 +1145,27 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 		max_depth = 1;
 	if (qdepth > max_depth)
 		qdepth = max_depth;
-	tag_type = (qdepth == 1) ? 0 : MSG_SIMPLE_TAG;
-	scsi_adjust_queue_depth(sdev, tag_type, qdepth);
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+}
+
+/**
+ * _scsih_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * (see include/scsi/scsi_host.h for definition)
+ *
+ * Returns queue depth.
+ */
+static int
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP)
+		_scsih_adjust_queue_depth(sdev, qdepth);
+	else if (reason == SCSI_QDEPTH_QFULL)
+		scsi_track_queue_full(sdev, qdepth);
+	else
+		return -EOPNOTSUPP;
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
