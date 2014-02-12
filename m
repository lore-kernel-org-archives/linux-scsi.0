From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] Add EVPD page 0x80 to sysfs
Date: Wed, 12 Feb 2014 11:24:31 +0100
Message-ID: <1392200671-35624-4-git-send-email-hare@suse.de>
References: <1392200671-35624-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBLKYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 05:24:37 -0500
In-Reply-To: <1392200671-35624-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Doug Gilbert <dgilbert@interlog.com>, Jeremy Linton <jlinton@tributary.com>

Some older devices (most notably tapes) will only report reliable
information in page 0x80 (Unit Serial Number). So export this
in the sysfs attribute 'serial'.

Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Jeremy Linton <jlinton@tributary.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |  4 ++-
 drivers/scsi/scsi_sysfs.c  | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  3 +++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 073fb84..d8f5036 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -929,8 +929,10 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
-	if (sdev->scsi_level >= SCSI_3)
+	if (sdev->scsi_level >= SCSI_3) {
+		scsi_attach_serial(sdev);
 		scsi_attach_vpd_ident(sdev);
+	}
 
 	transport_configure_device(&sdev->sdev_gendev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ec8f037..3a96e80 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -445,6 +445,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	scsi_target_reap(scsi_target(sdev));
 
+	kfree(sdev->serial);
 	kfree(sdev->vpd_ident);
 	kfree(sdev->inquiry);
 	kfree(sdev);
@@ -785,6 +786,61 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 		   store_queue_type_field);
 
+void scsi_attach_serial(struct scsi_device *sdev)
+{
+	int ret;
+	int serial_len = 64;
+	unsigned char *buffer;
+retry:
+	buffer = kmalloc(serial_len, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	ret = scsi_get_vpd_page(sdev, 0x80, buffer, serial_len);
+	if (ret) {
+		kfree(buffer);
+		return;
+	}
+	if (buffer[1] != 0x80) {
+		kfree(buffer);
+		return;
+	}
+	if ((buffer[2] << 8) + buffer[3] + 4 > serial_len) {
+		serial_len = (buffer[2] << 8) + buffer[3] + 4;
+		kfree(buffer);
+		goto retry;
+	}
+	sdev->serial_len = (buffer[2] << 8) + buffer[3] + 4;
+	sdev->serial = buffer;
+}
+
+static ssize_t
+show_vpd_pg80(struct device *dev, struct device_attribute *attr,
+		   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int len = 0;
+	unsigned char *d;
+
+	if (!sdev->serial || sdev->serial_len < 4)
+		return -EINVAL;
+
+	len = sdev->serial_len - 4;
+	d = sdev->serial + 4;
+	while (d < sdev->serial + sdev->serial_len && *d == ' ') {
+		d++;
+		len--;
+	}
+
+	if (len) {
+		snprintf(buf, len + 2, "%s", (char *)d);
+		len += sprintf(buf + len, "\n");
+	}
+
+	return len;
+}
+static DEVICE_ATTR(serial, S_IRUGO, show_vpd_pg80, NULL);
+
 void scsi_attach_vpd_ident(struct scsi_device *sdev)
 {
 	int ret;
@@ -1169,6 +1225,10 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	    !sdev->host->hostt->change_queue_type)
 		return S_IRUGO;
 
+	if (attr == &dev_attr_serial.attr &&
+	    !sdev->serial)
+		return 0;
+
 	if (attr == &dev_attr_vpd_pg83.attr &&
 	    !sdev->vpd_ident)
 		return 0;
@@ -1221,6 +1281,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
 	&dev_attr_queue_ramp_up_period.attr,
+	&dev_attr_serial.attr,
 	&dev_attr_vpd_pg83.attr,
 	&dev_attr_ident_lun_vendor.attr,
 	&dev_attr_ident_lun_t10.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 81c7900..054a321 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -115,6 +115,8 @@ struct scsi_device {
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 	unsigned char vpd_ident_len;
 	unsigned char *vpd_ident;
+	unsigned char serial_len;
+	unsigned char *serial;
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
 	unsigned int	sdev_bflags; /* black/white flags as also found in
@@ -311,6 +313,7 @@ extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd_ident(struct scsi_device *sdev);
+void scsi_attach_serial(struct scsi_device *sdev);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
-- 
1.7.12.4

