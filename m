From: Andrei Warkentin <andrey.warkentin@gmail.com>
Subject: [PATCH] VMW_PVSCSI: Allow TCQ depth change through sysfs.
Date: Fri, 24 Feb 2012 21:51:58 -0500
Message-ID: <1330138318-5306-1-git-send-email-andrey.warkentin@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49778 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2BYDwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2012 22:52:12 -0500
Received: by qaeb19 with SMTP id b19so12601qae.19
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2012 19:52:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andreiw@vmware.com

From: Andrei Warkentin <andreiw@vmware.com>

Lets pvscsi be like all the other SCSI drivers, with
an adjustable at runtime queue depth.

Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 7264116..450850f 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -32,6 +32,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_tcq.h>
 
 #include "vmw_pvscsi.h"
 
@@ -721,6 +722,43 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 
 static DEF_SCSI_QCMD(pvscsi_queue)
 
+/**
+ * pvscsi_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * (see include/scsi/scsi_host.h for definition)
+ *
+ * Returns queue depth.
+ */
+static int pvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	int max_depth;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (reason == SCSI_QDEPTH_DEFAULT ||
+	    reason == SCSI_QDEPTH_RAMP_UP) {
+		max_depth = shost->can_queue;
+		if (!sdev->tagged_supported)
+			max_depth = 1;
+
+		if (qdepth > max_depth)
+			qdepth = max_depth;
+
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	} else if (reason == SCSI_QDEPTH_QFULL)
+		scsi_track_queue_full(sdev, qdepth);
+
+	if (sdev->inquiry_len > 7)
+		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
+			    "simple(%d), ordered(%d), scsi_level(%d), cmd_que(%d)\n",
+			    sdev->queue_depth, sdev->tagged_supported, sdev->simple_tags,
+			    sdev->ordered_tags, sdev->scsi_level,
+			    (sdev->inquiry[7] & 2) >> 1);
+
+       return sdev->queue_depth;
+}
+
 static int pvscsi_abort(struct scsi_cmnd *cmd)
 {
 	struct pvscsi_adapter *adapter = shost_priv(cmd->device->host);
@@ -911,6 +949,7 @@ static struct scsi_host_template pvscsi_template = {
 	.dma_boundary			= UINT_MAX,
 	.max_sectors			= 0xffff,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.change_queue_depth             = pvscsi_change_queue_depth,
 	.eh_abort_handler		= pvscsi_abort,
 	.eh_device_reset_handler	= pvscsi_device_reset,
 	.eh_bus_reset_handler		= pvscsi_bus_reset,
-- 
1.7.8.3

