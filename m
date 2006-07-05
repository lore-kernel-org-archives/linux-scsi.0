From: brking@charter.net
Subject: [patch 1/1] megaraid: Add support for change_queue_depth
Date: Wed, 05 Jul 2006 17:00:01 -0500
Message-ID: <52v207$18p343h@mxip28a.cluster1.charter.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf38.cluster1.charter.net ([209.225.28.165]:18660 "EHLO
	mxsf38.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S965009AbWGEWAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jul 2006 18:00:06 -0400
Received: from mxip28a.cluster1.charter.net (mxip28a.cluster1.charter.net [209.225.28.187])
	by mxsf38.cluster1.charter.net (8.12.11/8.12.11) with ESMTP id k65M03JI012203
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jul 2006 18:00:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela.Kolli@engenio.com
Cc: seokmann.ju@lsil.com, linux-scsi@vger.kernel.org, brking@charter.net


Adds support for change_queue_depth so that device
queue depth can be changed at runtime through sysfs.

Signed-off-by: <brking@charter.net>
---


diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid_change_queue_depth drivers/scsi/megaraid/megaraid_mbox.c
--- linux-2.6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_change_queue_depth	2006-07-05 14:00:04.000000000 -0500
+++ linux-2.6-brking/drivers/scsi/megaraid/megaraid_mbox.c	2006-07-05 16:53:36.000000000 -0500
@@ -330,6 +330,21 @@ static struct device_attribute *megaraid
 	NULL,
 };
 
+/**
+ * megaraid_change_queue_depth - Change the device's queue depth
+ * @sdev:	scsi device struct
+ * @qdepth:	depth to set
+ *
+ * Return value:
+ * 	actual depth set
+ **/
+static int megaraid_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	if (qdepth > MBOX_MAX_SCSI_CMDS)
+		qdepth = MBOX_MAX_SCSI_CMDS;
+	scsi_adjust_queue_depth(sdev, 0, qdepth);
+	return sdev->queue_depth;
+}
 
 /*
  * Scsi host template for megaraid unified driver
@@ -343,6 +358,7 @@ static struct scsi_host_template megarai
 	.eh_device_reset_handler	= megaraid_reset_handler,
 	.eh_bus_reset_handler		= megaraid_reset_handler,
 	.eh_host_reset_handler		= megaraid_reset_handler,
+	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.sdev_attrs			= megaraid_sdev_attrs,
 	.shost_attrs			= megaraid_shost_attrs,
_
