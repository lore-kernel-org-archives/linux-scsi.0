From: Jeremy Higdon <jeremy@sgi.com>
Subject: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Sun, 26 Sep 2004 23:10:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927061003.GA182890@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:61598 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S266169AbUI0GSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 02:18:37 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com, James.Bottomley@steeleye.com

This patch is to QLA2xxx version 8.00.00b15-k, and it allows users
to override the default driver queue depth for a target by making
the queue_depth sysfs attribute writeable.

I based this on the code in the 53c700 driver.

Andrew, please apply if it looks correct to you and James.

Let me know if you'd like me to regenerate against a different qla2xxx
version.

thanks

Jeremy


===== drivers/scsi/qla2xxx/qla_os.c 1.41 vs edited =====
--- 1.41/drivers/scsi/qla2xxx/qla_os.c	2004-08-09 16:48:29 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-09-22 00:12:41 -07:00
@@ -159,6 +159,20 @@
 
 static int qla2x00_proc_info(struct Scsi_Host *, char *, char **,
     off_t, int, int);
+static ssize_t qla2xxx_store_queue_depth(struct device *dev, const char *buf, size_t count);
+
+static struct device_attribute qla2xxx_queue_depth_attr = {
+	.attr = {
+		.name =		"queue_depth",
+		.mode =		S_IWUSR,
+	},
+	.store = qla2xxx_store_queue_depth,
+};
+
+static struct device_attribute *qla2xxx_dev_attrs[] = {
+	&qla2xxx_queue_depth_attr,
+	NULL,
+};
 
 static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
@@ -184,6 +198,8 @@
 	 * which equates to 0x800000 sectors.
 	 */
 	.max_sectors		= 0xFFFF,
+
+	.sdev_attrs		= qla2xxx_dev_attrs,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -1797,6 +1813,22 @@
 	}
 
 	return (0);
+}
+
+static ssize_t
+qla2xxx_store_queue_depth(struct device *dev, const char *buf, size_t count)
+{
+	int			 depth;
+	struct scsi_device	*sdev = to_scsi_device(dev);
+
+	if (sdev->tagged_supported) {
+		depth = simple_strtoul(buf, NULL, 0);
+		if (depth > ql2xmaxqdepth)
+			return -EINVAL;
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+		return count;
+	}
+	return 1;
 }
 
 /**
