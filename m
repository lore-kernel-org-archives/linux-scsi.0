From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [8/11]   qla2xxx: SYSFS queue-depth override
Date: Wed, 8 Dec 2004 23:39:39 -0800
Message-ID: <20041209073939.GA22137@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:41710 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261476AbULIHjn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:39:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2242 04/12/08 16:48:25 andrew.vasquez@qlogic.com +1 -0
  Add sysfs queue depth override to qla2xxx.
  
Signed-off-by: Jeremy Higdon  <jeremy@sgi.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_os.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+)

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:16:12 -08:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:16:12 -08:00
@@ -162,6 +162,20 @@
 
 static int qla2x00_proc_info(struct Scsi_Host *, char *, char **,
     off_t, int, int);
+static ssize_t qla2xxx_store_queue_depth(struct device *, const char *, size_t);
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
@@ -187,6 +201,8 @@
 	 * which equates to 0x800000 sectors.
 	 */
 	.max_sectors		= 0xFFFF,
+
+	.sdev_attrs		= qla2xxx_dev_attrs,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -1787,6 +1803,21 @@
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
+		if (depth > UINT_MAX)
+			depth = UINT_MAX;
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
+	}
+	return count;
 }
 
 /**
