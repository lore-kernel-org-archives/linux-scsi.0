From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Thu, 13 Feb 2014 11:28:00 +0100
Message-ID: <1392287281-75002-3-git-send-email-hare@suse.de>
References: <1392287281-75002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaBMK2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Feb 2014 05:28:04 -0500
In-Reply-To: <1392287281-75002-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

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
 drivers/scsi/scsi.c        | 79 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_scan.c   |  3 ++
 drivers/scsi/scsi_sysfs.c  | 39 ++++++++++++++++++++++-
 include/scsi/scsi_device.h |  3 ++
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..57105e0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -954,7 +954,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
  * This is an internal helper function.  You probably want to use
  * scsi_get_vpd_page instead.
  *
- * Returns 0 on success or a negative error number.
+ * Returns size of the vpg page on success or a negative error number.
  */
 static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 							u8 page, unsigned len)
@@ -962,6 +962,9 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	int result;
 	unsigned char cmd[16];
 
+	if (len < 4)
+		return -EINVAL;
+
 	cmd[0] = INQUIRY;
 	cmd[1] = 1;		/* EVPD */
 	cmd[2] = page;
@@ -982,7 +985,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	if (buffer[1] != page)
 		return -EIO;
 
-	return 0;
+	return (buffer[2] << 8) + buffer[3] + 4;
 }
 
 /**
@@ -1009,18 +1012,18 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
-	if (result)
+	if (result < 4)
 		goto fail;
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
 		return 0;
 
-	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
-		if (buf[i + 4] == page)
+	for (i = 4; i < min(result, buf_len); i++)
+		if (buf[i] == page)
 			goto found;
 
-	if (i < buf[3] && i >= buf_len - 4)
+	if (i < result && i >= buf_len)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
 	/* The device claims it doesn't support the requested page */
@@ -1028,7 +1031,7 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
  found:
 	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
-	if (result)
+	if (result < 0)
 		goto fail;
 
 	return 0;
@@ -1039,6 +1042,68 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
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
index 196e59a..ca19448 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -415,6 +415,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	scsi_target_reap(scsi_target(sdev));
 
+	kfree(sdev->vpd_pg83);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -755,7 +756,38 @@ static DEVICE_ATTR(queue_type, S_IRUGO | S_IWUSR, show_queue_type_field,
 		   store_queue_type_field);
 
 static ssize_t
-show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
+show_vpd_pg(const unsigned char *pg_buf, int pg_len, char *buf)
+{
+	int len = 0, i;
+
+	if (!pg_buf)
+		return -EINVAL;
+
+	len = 0;
+	for (i = 0; i < pg_len; i += 16) {
+		hex_dump_to_buffer(pg_buf + i, pg_len, 16, 1,
+				   buf + len, PAGE_SIZE, false);
+		strcat(buf + len, "\n");
+		len += strlen(buf + len);
+	}
+	return len;
+}
+
+#define sdev_vpd_pg_attr(page) \
+static ssize_t						   \
+show_vpd_##page(struct device *dev, struct device_attribute *attr, \
+		char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	return show_vpd_pg(sdev->vpd_##page, sdev->vpd_##page##_len, buf); \
+}									\
+static DEVICE_ATTR(vpd_##page, S_IRUGO, show_vpd_##page, NULL);
+
+sdev_vpd_pg_attr(pg83);
+
+static ssize_t
+show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
 }
@@ -905,6 +937,10 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	    !sdev->host->hostt->change_queue_type)
 		return S_IRUGO;
 
+	if (attr == &dev_attr_vpd_pg83.attr &&
+	    !sdev->vpd_pg83)
+		return 0;
+
 	return attr->mode;
 }
 
@@ -930,6 +966,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
 	&dev_attr_queue_ramp_up_period.attr,
+	&dev_attr_vpd_pg83.attr,
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
 	REF_EVT(capacity_change_reported),
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

