From: Jeremy Higdon <jeremy@sgi.com>
Subject: [RFC PATCH 2.6.9-rc2] add ability to set device queue depth to mptfusion
Date: Tue, 28 Sep 2004 00:58:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928075846.GA190230@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:52432 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267648AbUI1IHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 04:07:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com, linux-scsi@vger.kernel.org

This patch lets you override the default queue depth for SCSI devices
attached through the mptfusion driver.

I moved some common code that I needed out of mpt_slave_configure()
into its own function.

signed-off-by: Jeremy Higdon <jeremy@sgi.com>


===== drivers/message/fusion/mptscsih.c 1.47 vs edited =====
--- 1.47/drivers/message/fusion/mptscsih.c	2004-09-03 02:08:35 -07:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-09-28 00:51:07 -07:00
@@ -2887,6 +2887,40 @@
 	return;
 }
 
+static void
+mptscsih_set_queue_depth(struct scsi_device *device, MPT_SCSI_HOST *hd, VirtDevice *pTarget, int qdepth)
+{
+	int	max_depth;
+	int	tagged;
+
+	if ( hd->is_spi ) {
+		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
+			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))
+				max_depth = 1;
+			else if (((pTarget->inq_data[0] & 0x1f) == 0x00)
+			  && (pTarget->minSyncFactor <= MPT_ULTRA160 ))
+				max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+			else
+				max_depth = MPT_SCSI_CMD_PER_DEV_LOW;
+		} else {
+			/* error case - No Inq. Data */
+			max_depth = 1;
+		}
+	}
+	else
+		max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+
+	if (qdepth > max_depth)
+		qdepth = max_depth;
+	if (qdepth == 1)
+		tagged = 0;
+	else
+		tagged = MSG_SIMPLE_TAG;
+
+	scsi_adjust_queue_depth(device, tagged, qdepth);
+}
+
+
 /*
  *	OS entry point to adjust the queue_depths on a per-device basis.
  *	Called once per device the bus scan. Use it to force the queue_depth
@@ -2936,24 +2970,7 @@
 
 	mptscsih_initTarget(hd, device->channel, device->id, device->lun,
 		device->inquiry, device->inquiry_len );
-	scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
-		MPT_SCSI_CMD_PER_DEV_HIGH);
-	if ( hd->is_spi ) {
-		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
-			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))
-				scsi_adjust_queue_depth(device, 0, 1);
-			else if (((pTarget->inq_data[0] & 0x1f) == 0x00)
-			  && (pTarget->minSyncFactor <= MPT_ULTRA160 ))
-				scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
-					MPT_SCSI_CMD_PER_DEV_HIGH);
-			else
-				scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
-					MPT_SCSI_CMD_PER_DEV_LOW);
-		} else {
-			/* error case - No Inq. Data */
-			scsi_adjust_queue_depth(device, 0, 1);
-		}
-	}
+	mptscsih_set_queue_depth(device, hd, pTarget, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
 		"Queue depth=%d, tflags=%x\n",
@@ -2973,6 +2990,25 @@
 	return 0;
 }
 
+static ssize_t
+mptscsih_store_queue_depth(struct device *dev, const char *buf, size_t count)
+{
+	int			 depth;
+	struct scsi_device	*sdev = to_scsi_device(dev);
+	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *) sdev->host->hostdata;
+	VirtDevice		*pTarget;
+
+	depth = simple_strtoul(buf, NULL, 0);
+	if (depth == 0)
+		return -EINVAL;
+	pTarget = hd->Targets[sdev->id];
+	if (pTarget == NULL)
+		return -EINVAL;
+	mptscsih_set_queue_depth(sdev, (MPT_SCSI_HOST *) sdev->host->hostdata,
+		pTarget, depth);
+	return count;
+}
+
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -3302,6 +3338,19 @@
 	return 1;		/* currently means nothing really */
 }
 
+static struct device_attribute mptscsih_queue_depth_attr = {
+	.attr = {
+		.name = 	"queue_depth",
+		.mode =		S_IWUSR,
+	},
+	.store = mptscsih_store_queue_depth,
+};
+
+static struct device_attribute *mptscsih_dev_attrs[] = {
+	&mptscsih_queue_depth_attr,
+	NULL,
+};
+
 static struct scsi_host_template driver_template = {
 	.proc_name			= "mptscsih",
 	.proc_info			= mptscsih_proc_info,
@@ -3322,6 +3371,7 @@
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.sdev_attrs			= mptscsih_dev_attrs,
 };
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
