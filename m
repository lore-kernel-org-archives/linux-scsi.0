From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] Add EVPD page 0x83 to sysfs
Date: Sat, 15 Mar 2014 09:51:49 +0100
Message-ID: <1394873512-102073-4-git-send-email-hare@suse.de>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbaCOIv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 04:51:57 -0400
In-Reply-To: <1394873512-102073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

EVPD page 0x83 is used to uniquely identify the device.
So instead of having each and every program issue a separate
SG_IO call to retrieve this information it does make far more
sense to display it in sysfs.

Cc: Jeremy Linton <jlinton@tributary.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Kai Makisara <kai.makisara@kolumbus.fi>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   |  3 +++
 drivers/scsi/scsi_sysfs.c  | 31 ++++++++++++++++++++++-
 include/scsi/scsi_device.h |  3 +++
 4 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9e08d3d..0aa1925 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1042,6 +1042,68 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
 /**
+ * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
+ * @sdev: The device to ask
+ *
+ * Attach the 'Device Identification' VPD page (0x83) to a SCSI device
+ * structure. This information can be used to identify the device
+ * uniquely.
+ */
+void scsi_attach_vpd(struct scsi_device *sdev)
+{
+	int result, i;
+	int vpd_len = 255;
+	int pg83_supported = 0;
+	unsigned char *vpd_buf;
+
+	if (sdev->skip_vpd_pages)
+		return;
+retry_pg0:
+	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
+	if (!vpd_buf)
+		return;
+
+	/* Ask for all the pages supported by this device */
+	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
+	if (result < 0) {
+		kfree(vpd_buf);
+		return;
+	}
+	if (result > vpd_len) {
+		vpd_len = result;
+		kfree(vpd_buf);
+		goto retry_pg0;
+	}
+
+	for (i = 4; i < result; i++) {
+		if (vpd_buf[i] == 0x83) {
+			pg83_supported = 1;
+		}
+	}
+	kfree(vpd_buf);
+
+	if (pg83_supported) {
+retry_pg83:
+		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
+		if (!vpd_buf)
+			return;
+
+		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
+		if (result < 0) {
+			kfree(vpd_buf);
+			return;
+		}
+		if (result > vpd_len) {
+			vpd_len = result;
+			kfree(vpd_buf);
+			goto retry_pg83;
+		}
+		sdev->vpd_pg83_len = result;
+		sdev->vpd_pg83 = vpd_buf;
+	}
+}
+
+/**
  * scsi_report_opcode - Find out if a given command opcode is supported
  * @sdev:	scsi device to query
  * @buffer:	scratch buffer (must be at least 20 bytes long)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..154bb5e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -929,6 +929,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
+	if (sdev->scsi_level >= SCSI_3)
+		scsi_attach_vpd(sdev);
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 196e59a..a11bead 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -415,6 +415,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	scsi_target_reap(scsi_target(sdev));
 
+	kfree(sdev->vpd_pg83);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -754,8 +755,31 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 		   store_queue_type_field);
 
+#define sdev_vpd_pg_attr(_page)						\
+static ssize_t							\
+show_vpd_##_page(struct file *filp, struct kobject *kobj,	\
+		 struct bin_attribute *bin_attr,			\
+		 char *buf, loff_t off, size_t count)			\
+{									\
+	struct device *dev = container_of(kobj, struct device, kobj);	\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	if (!sdev->vpd_##_page)						\
+		return -EINVAL;						\
+	return memory_read_from_buffer(buf, count, &off,		\
+				       sdev->vpd_##_page,		\
+				       sdev->vpd_##_page##_len);	\
+}									\
+static struct bin_attribute dev_attr_vpd_##_page = {		\
+	.attr =	{.name = __stringify(vpd_##_page), .mode = S_IRUGO },	\
+	.size = 0,							\
+	.read = show_vpd_##_page,					\
+};
+
+sdev_vpd_pg_attr(pg83);
+
 static ssize_t
-show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
+show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
 }
@@ -939,8 +963,13 @@ static struct attribute *scsi_sdev_attrs[] = {
 	NULL
 };
 
+static struct bin_attribute *scsi_sdev_bin_attrs[] = {
+	&dev_attr_vpd_pg83,
+	NULL
+};
 static struct attribute_group scsi_sdev_attr_group = {
 	.attrs =	scsi_sdev_attrs,
+	.bin_attrs =	scsi_sdev_bin_attrs,
 	.is_visible =	scsi_sdev_attr_is_visible,
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..d209f04 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -113,6 +113,8 @@ struct scsi_device {
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
+	unsigned char vpd_pg83_len;
+	unsigned char *vpd_pg83;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
@@ -309,6 +311,7 @@ extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
+void scsi_attach_vpd(struct scsi_device *sdev);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
-- 
1.7.12.4

