From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] Add EVPD page 0x80 to sysfs
Date: Sat, 15 Mar 2014 09:51:50 +0100
Message-ID: <1394873512-102073-5-git-send-email-hare@suse.de>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaCOIv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 04:51:57 -0400
In-Reply-To: <1394873512-102073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Doug Gilbert <dgilbert@interlog.com>, Jeremy Linton <jlinton@tributary.com>

Some older devices (most notably tapes) will only report reliable
information in page 0x80 (Unit Serial Number). So export this
in the sysfs attribute 'vpd_pg80'.

Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Jeremy Linton <jlinton@tributary.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 27 ++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  |  3 +++
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0aa1925..2669cb8 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1045,7 +1045,8 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
  * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
  * @sdev: The device to ask
  *
- * Attach the 'Device Identification' VPD page (0x83) to a SCSI device
+ * Attach the 'Device Identification' VPD page (0x83) and the
+ * 'Unit Serial Number' VPD page (0x80) to a SCSI device
  * structure. This information can be used to identify the device
  * uniquely.
  */
@@ -1053,6 +1054,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 {
 	int result, i;
 	int vpd_len = 255;
+	int pg80_supported = 0;
 	int pg83_supported = 0;
 	unsigned char *vpd_buf;
 
@@ -1076,12 +1078,35 @@ retry_pg0:
 	}
 
 	for (i = 4; i < result; i++) {
+		if (vpd_buf[i] == 0x80) {
+			pg80_supported = 1;
+		}
 		if (vpd_buf[i] == 0x83) {
 			pg83_supported = 1;
 		}
 	}
 	kfree(vpd_buf);
 
+	if (pg80_supported) {
+retry_pg80:
+		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
+		if (!vpd_buf)
+			return;
+
+		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
+		if (result < 0) {
+			kfree(vpd_buf);
+			return;
+		}
+		if (result > vpd_len) {
+			vpd_len = result;
+			kfree(vpd_buf);
+			goto retry_pg80;
+		}
+		sdev->vpd_pg80_len = result;
+		sdev->vpd_pg80 = vpd_buf;
+	}
+
 	if (pg83_supported) {
 retry_pg83:
 		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a11bead..8c916d0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -416,6 +416,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	scsi_target_reap(scsi_target(sdev));
 
 	kfree(sdev->vpd_pg83);
+	kfree(sdev->vpd_pg80);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -776,6 +777,7 @@ static struct bin_attribute dev_attr_vpd_##_page = {		\
 };
 
 sdev_vpd_pg_attr(pg83);
+sdev_vpd_pg_attr(pg80);
 
 static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
@@ -965,6 +967,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 
 static struct bin_attribute *scsi_sdev_bin_attrs[] = {
 	&dev_attr_vpd_pg83,
+	&dev_attr_vpd_pg80,
 	NULL
 };
 static struct attribute_group scsi_sdev_attr_group = {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d209f04..2ea8212 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -115,6 +115,8 @@ struct scsi_device {
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 	unsigned char vpd_pg83_len;
 	unsigned char *vpd_pg83;
+	unsigned char vpd_pg80_len;
+	unsigned char *vpd_pg80;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-- 
1.7.12.4

