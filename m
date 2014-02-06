From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RFC] Add EVPD page 0x83 entries to sysfs
Date: Thu,  6 Feb 2014 14:04:38 +0100
Message-ID: <1391691878-61265-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaBFNEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 08:04:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>, Hannes Reinecke <hare@suse.de>, Jeremy Linton <jlinton@tributary.com>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

EVPD page 0x83 is used to uniquely identify the device.
So instead of having each and every program issue a separate
SG_IO call to retrieve this information it does make far more
sense to display it in sysfs.

Cc: Jeremy Linton <jlinton@tributary.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Kai Makisara <kai.makisara@kolumbus.fi>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |   3 +
 drivers/scsi/scsi_sysfs.c  | 166 ++++++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_device.h |   3 +
 3 files changed, 171 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..073fb84 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -929,6 +929,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
+	if (sdev->scsi_level >= SCSI_3)
+		scsi_attach_vpd_ident(sdev);
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9117d0b..ffe7cb5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -725,8 +725,170 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
 
+void scsi_attach_vpd_ident(struct scsi_device *sdev)
+{
+	int ret;
+	int vpd_len = 255;
+	unsigned char *buffer;
+retry:
+	buffer = kmalloc(vpd_len, GFP_KERNEL);
+	if (buffer) {
+		ret = scsi_get_vpd_page(sdev, 0x83, buffer, vpd_len);
+		if (ret == 0) {
+			vpd_len = (buffer[2] << 8) + buffer[3];
+			if (vpd_len > 255) {
+				kfree(buffer);
+				goto retry;
+			}
+			sdev->vpd_ident_len = vpd_len;
+			sdev->vpd_ident = buffer;
+		}
+	}
+}
+
+#define SCSI_VPD_ASSOC_lun 0x0
+#define SCSI_VPD_ASSOC_port 0x10
+#define SCSI_VPD_ASSOC_target 0x20
+
+#define SCSI_VPD_DESIG_vendor 0x0
+#define SCSI_VPD_DESIG_t10 0x1
+#define SCSI_VPD_DESIG_eui 0x2
+#define SCSI_VPD_DESIG_naa 0x3
+#define SCSI_VPD_DESIG_relport 0x4
+#define SCSI_VPD_DESIG_tpgrp 0x5
+#define SCSI_VPD_DESIG_lugrp 0x6
+#define SCSI_VPD_DESIG_md5 0x7
+#define SCSI_VPD_DESIG_scsi_name 0x8
+
+int scsi_parse_vpd_ident(struct scsi_device *sdev,
+			 int assoc, int desig, char *buf)
+{
+	unsigned char *d;
+	int len = 0;
+
+	if (!sdev->vpd_ident)
+		return -EINVAL;
+
+	d = sdev->vpd_ident + 4;
+	while (d < sdev->vpd_ident + sdev->vpd_ident_len) {
+		if ((d[1] & 0x30) == assoc &&
+		    (d[1] & 0xf) == desig) {
+			switch (d[1] & 0xf) {
+			case SCSI_VPD_DESIG_eui:
+			case SCSI_VPD_DESIG_naa:
+			case SCSI_VPD_DESIG_md5:
+				switch (d[3]) {
+				case 8:
+					len += sprintf(buf + len,
+						      "%8phN\n", d + 4);
+					break;
+				case 12:
+					len += sprintf(buf + len,
+						      "%12phN\n", d + 4);
+					break;
+				case 16:
+					len += sprintf(buf + len,
+						      "%16phN\n", d + 4);
+					break;
+				}
+				break;
+			case SCSI_VPD_DESIG_relport:
+			case SCSI_VPD_DESIG_tpgrp:
+			case SCSI_VPD_DESIG_lugrp:
+				len += sprintf(buf + len, "%d\n",
+					      (int)(d[6] << 8) + d[7]);
+				break;
+			case SCSI_VPD_DESIG_vendor:
+			case SCSI_VPD_DESIG_t10:
+			case SCSI_VPD_DESIG_scsi_name:
+				len += snprintf(buf + len, d[3] + 2, "%s\n",
+						d + 4);
+				break;
+			}
+		}
+		d += d[3] + 4;
+	}
+
+	return len ? len : -EINVAL;
+}
+
+#define sdev_evpd_ident(assoc,desig)				\
+static ssize_t							\
+sdev_show_evpd_ident_##assoc##_##desig (struct device *dev,		\
+					struct device_attribute *attr,	\
+					char * buf)			\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	return scsi_parse_vpd_ident(sdev, SCSI_VPD_ASSOC_##assoc,	\
+				    SCSI_VPD_DESIG_##desig, buf);	\
+}
+
+#define sdev_evpd_attr(assoc, desig)					\
+	sdev_evpd_ident(assoc, desig)					\
+static DEVICE_ATTR(ident_##assoc##_##desig, S_IRUGO,			\
+		   sdev_show_evpd_ident_##assoc##_##desig, NULL);
+
+sdev_evpd_attr(lun, vendor);
+sdev_evpd_attr(lun, t10);
+sdev_evpd_attr(lun, eui);
+sdev_evpd_attr(lun, naa);
+sdev_evpd_attr(lun, lugrp);
+sdev_evpd_attr(lun, md5);
+sdev_evpd_attr(lun, scsi_name);
+sdev_evpd_attr(port, relport);
+sdev_evpd_attr(port, tpgrp);
+sdev_evpd_attr(port, eui);
+sdev_evpd_attr(port, naa);
+sdev_evpd_attr(port, scsi_name);
+sdev_evpd_attr(target, eui);
+sdev_evpd_attr(target, naa);
+sdev_evpd_attr(target, scsi_name);
+
+#define sdev_evpd_test_and_add_attr(sdev, assoc, desig, valid)	\
+	if (test_bit(SCSI_VPD_DESIG_##desig, (valid))) \
+		device_create_file(&(sdev)->sdev_gendev, \
+				   &dev_attr_ident_##assoc##_##desig)
+
+static void scsi_sysfs_filter_vpd_ident(struct scsi_device *sdev)
+{
+	unsigned char *d;
+	unsigned long desig = 0, assoc = 0;
+
+	if (!sdev->vpd_ident)
+		return;
+
+	d = sdev->vpd_ident + 4;
+	while (d < sdev->vpd_ident + sdev->vpd_ident_len) {
+		set_bit((d[1] >> 4) & 3, &assoc);
+		set_bit(d[1] & 0xf, &desig);
+		d += d[3] + 4;
+	}
+	if (test_bit(SCSI_VPD_ASSOC_lun, &assoc)) {
+		sdev_evpd_test_and_add_attr(sdev, lun, vendor, &desig);
+		sdev_evpd_test_and_add_attr(sdev, lun, t10, &desig);
+		sdev_evpd_test_and_add_attr(sdev, lun, eui, &desig);
+		sdev_evpd_test_and_add_attr(sdev, lun, naa, &desig);
+		sdev_evpd_test_and_add_attr(sdev, lun, lugrp, &desig);
+		sdev_evpd_test_and_add_attr(sdev, lun, md5, &desig);
+		sdev_evpd_test_and_add_attr(sdev, lun, scsi_name, &desig);
+	}
+	if (test_bit(SCSI_VPD_ASSOC_port, &assoc)) {
+		sdev_evpd_test_and_add_attr(sdev, port, eui, &desig);
+		sdev_evpd_test_and_add_attr(sdev, port, naa, &desig);
+		sdev_evpd_test_and_add_attr(sdev, port, relport, &desig);
+		sdev_evpd_test_and_add_attr(sdev, port, tpgrp, &desig);
+		sdev_evpd_test_and_add_attr(sdev, port, scsi_name, &desig);
+	}
+	if (test_bit(SCSI_VPD_ASSOC_target, &assoc)) {
+		sdev_evpd_test_and_add_attr(sdev, target, eui, &desig);
+		sdev_evpd_test_and_add_attr(sdev, target, naa, &desig);
+		sdev_evpd_test_and_add_attr(sdev, target, scsi_name, &desig);
+	}
+}
+
 static ssize_t
-show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
+show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
 }
@@ -1003,6 +1165,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	scsi_sysfs_filter_vpd_ident(sdev);
+
 	/* create queue files, which may be writable, depending on the host */
 	if (sdev->host->hostt->change_queue_depth) {
 		error = device_create_file(&sdev->sdev_gendev,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d65fbec..ea2a64f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -113,6 +113,8 @@ struct scsi_device {
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
+	unsigned char vpd_ident_len;
+	unsigned char *vpd_ident;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
@@ -309,6 +311,7 @@ extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
+void scsi_attach_vpd_ident(struct scsi_device *sdev);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
-- 
1.7.12.4

