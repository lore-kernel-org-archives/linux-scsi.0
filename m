From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 1/2] - mptfusion - convert to new change_queue_depth API
Date: Fri, 24 Jun 2005 12:18:57 -0600
Message-ID: <200506241218.57505.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44738 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263213AbVFXSRz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 14:17:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

Convert driver to use new change_queue_depth API.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2005-06-24 09:20:08.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2005-06-23 15:09:00.000000000 -0600
@@ -83,19 +83,6 @@
 static int	mptfcTaskCtx = -1;
 static int	mptfcInternalCtx = -1; /* Used only for internal commands */
 
-static struct device_attribute mptfc_queue_depth_attr = {
-	.attr = {
-		.name = 	"queue_depth",
-		.mode =		S_IWUSR,
-	},
-	.store = mptscsih_store_queue_depth,
-};
-
-static struct device_attribute *mptfc_dev_attrs[] = {
-	&mptfc_queue_depth_attr,
-	NULL,
-};
-
 static struct scsi_host_template mptfc_driver_template = {
 	.proc_name			= "mptfc",
 	.proc_info			= mptscsih_proc_info,
@@ -105,6 +92,7 @@
 	.slave_alloc			= mptscsih_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
 	.slave_destroy			= mptscsih_slave_destroy,
+	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
@@ -116,7 +104,6 @@
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.sdev_attrs			= mptfc_dev_attrs,
 };
 
 /****************************************************************************
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-06-24 09:20:08.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2005-06-24 11:55:06.000000000 -0600
@@ -2234,13 +2234,27 @@
 	}
 }
 
-static void
-mptscsih_set_queue_depth(struct scsi_device *device, MPT_SCSI_HOST *hd,
-	VirtDevice *pTarget, int qdepth)
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *	mptscsih_change_queue_depth - This function will set a devices queue depth
+ *	@sdev: per scsi_device pointer
+ *	@qdepth: requested queue depth
+ *
+ *	Adding support for new 'change_queue_depth' api.
+*/
+int
+mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
+	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
+	VirtDevice *pTarget;
 	int	max_depth;
 	int	tagged;
 
+	if (hd == NULL)
+		return 0;
+	if (!(pTarget = hd->Targets[sdev->id]))
+		return 0;
+
 	if (hd->ioc->bus_type == SCSI) {
 		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {
 			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))
@@ -2264,10 +2278,10 @@
 	else
 		tagged = MSG_SIMPLE_TAG;
 
-	scsi_adjust_queue_depth(device, tagged, qdepth);
+	scsi_adjust_queue_depth(sdev, tagged, qdepth);
+	return sdev->queue_depth;
 }
 
-
 /*
  *	OS entry point to adjust the queue_depths on a per-device basis.
  *	Called once per device the bus scan. Use it to force the queue_depth
@@ -2317,7 +2331,7 @@
 
 	mptscsih_initTarget(hd, device->channel, device->id, device->lun,
 		device->inquiry, device->inquiry_len );
-	mptscsih_set_queue_depth(device, hd, pTarget, MPT_SCSI_CMD_PER_DEV_HIGH);
+	mptscsih_change_queue_depth(device, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
 		"Queue depth=%d, tflags=%x\n",
@@ -2337,25 +2351,6 @@
 	return 0;
 }
 
-ssize_t
-mptscsih_store_queue_depth(struct device *dev, const char *buf, size_t count)
-{
-	int			 depth;
-	struct scsi_device	*sdev = to_scsi_device(dev);
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *) sdev->host->hostdata;
-	VirtDevice		*pTarget;
-
-	depth = simple_strtoul(buf, NULL, 0);
-	if (depth == 0)
-		return -EINVAL;
-	pTarget = hd->Targets[sdev->id];
-	if (pTarget == NULL)
-		return -EINVAL;
-	mptscsih_set_queue_depth(sdev, (MPT_SCSI_HOST *) sdev->host->hostdata,
-		pTarget, depth);
-	return count;
-}
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *  Private routines...
@@ -5586,7 +5581,7 @@
 EXPORT_SYMBOL(mptscsih_scandv_complete);
 EXPORT_SYMBOL(mptscsih_event_process);
 EXPORT_SYMBOL(mptscsih_ioc_reset);
-EXPORT_SYMBOL(mptscsih_store_queue_depth);
+EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2005-06-24 09:20:08.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.h	2005-06-23 14:50:34.000000000 -0600
@@ -103,5 +103,5 @@
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
-extern ssize_t mptscsih_store_queue_depth(struct device *dev, const char *buf, size_t count);
+extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2005-06-24 09:20:08.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2005-06-23 15:09:02.000000000 -0600
@@ -102,19 +102,6 @@
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
-static struct device_attribute mptspi_queue_depth_attr = {
-	.attr = {
-		.name = 	"queue_depth",
-		.mode =		S_IWUSR,
-	},
-	.store = mptscsih_store_queue_depth,
-};
-
-static struct device_attribute *mptspi_dev_attrs[] = {
-	&mptspi_queue_depth_attr,
-	NULL,
-};
-
 static struct scsi_host_template mptspi_driver_template = {
 	.proc_name			= "mptspi",
 	.proc_info			= mptscsih_proc_info,
@@ -124,6 +111,7 @@
 	.slave_alloc			= mptscsih_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
 	.slave_destroy			= mptscsih_slave_destroy,
+	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
@@ -135,7 +123,6 @@
 	.max_sectors			= 8192,
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.sdev_attrs			= mptspi_dev_attrs,
 };
 
 
