From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] Add EVPD page 0x80 to sysfs
Date: Mon, 10 Mar 2014 15:28:44 +0100
Message-ID: <1394461725-76203-5-git-send-email-hare@suse.de>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbaCJO2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 10:28:48 -0400
In-Reply-To: <1394461725-76203-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Bart van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Doug Gilbert <dgilbert@interlog.com>, Jeremy Linton <jlinton@tributary.com>

Some older devices (most notably tapes) will only report reliable
information in page 0x80 (Unit Serial Number). So export this
in the sysfs attribute 'vpd_pg80'.

Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Jeremy Linton <jlinton@tributary.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 27 ++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  |  6 ++++++
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f753373..de31a82 100644
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
index 5d5e55a..fd7956e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -789,6 +789,7 @@ show_vpd_##page(struct device *dev, struct device_attribute *attr, \
 static DEVICE_ATTR(vpd_##page, S_IRUGO, show_vpd_##page, NULL);
 
 sdev_vpd_pg_attr(pg83);
+sdev_vpd_pg_attr(pg80);
 
 static ssize_t
 show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
@@ -946,6 +947,10 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	    !sdev->vpd_pg83)
 		return 0;
 
+	if (attr == &dev_attr_vpd_pg80.attr &&
+	    !sdev->vpd_pg80)
+		return 0;
+
 	return attr->mode;
 }
 
@@ -971,6 +976,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
 	&dev_attr_queue_ramp_up_period.attr,
+	&dev_attr_vpd_pg80.attr,
 	&dev_attr_vpd_pg83.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
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

