From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] tmscsim: scsi device attributes
Date: Thu, 21 Oct 2004 22:31:25 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410212223120.7042@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:53657 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S270807AbUJUUpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 16:45:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

A write method to adjust per-device queue-depth

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	Wed Oct 20 21:49:46 2004
+++ b/drivers/scsi/tmscsim.c	Thu Oct 21 22:03:35 2004
@@ -2275,6 +2275,33 @@
 	return 0;
 }
 
+static ssize_t dc390_store_queue_depth(struct device *dev, const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct dc390_acb *acb = (struct dc390_acb *)sdev->host->hostdata;
+	int queue_depth = simple_strtoul(buf, NULL, 0);
+
+	if (queue_depth > acb->TagMaxNum || !sdev->tagged_supported)
+		return -EINVAL;
+
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
+
+	return count;
+}
+
+static struct device_attribute dc390_queue_depth_attr = {
+	.attr = {
+		.name =		"queue_depth",
+		.mode =		S_IRUSR | S_IWUSR,
+	},
+	.store = dc390_store_queue_depth
+};
+
+static struct device_attribute *dc390_dev_attrs[] = {
+	&dc390_queue_depth_attr,
+	NULL,
+};
+
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "tmscsim", 
@@ -2290,6 +2317,7 @@
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.sdev_attrs		= dc390_dev_attrs,
 };
 
 /***********************************************************************

Thanks
Guennadi
---
Guennadi Liakhovetski
