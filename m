From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Mon, 10 Feb 2014 12:11:39 +0100
Message-ID: <1392030699-105348-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaBJLLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Feb 2014 06:11:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Jeremy Linton <jlinton@tributary.com>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

EVPD page 0x83 is used to uniquely identify the device.
So instead of having each and every program issue a separate
SG_IO call to retrieve this information it does make far more
sense to display it in sysfs.

Cc: Jeremy Linton <jlinton@tributary.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Kai Makisara <kai.makisara@kolumbus.fi>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |   3 +
 drivers/scsi/scsi_sysfs.c  | 258 ++++++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h        |   2 +
 include/scsi/scsi_device.h |   3 +
 4 files changed, 265 insertions(+), 1 deletion(-)

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
index 9117d0b..5cb0dc1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -415,6 +415,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	scsi_target_reap(scsi_target(sdev));
 
+	kfree(sdev->vpd_ident);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -725,8 +726,261 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
 
+void scsi_attach_vpd_ident(struct scsi_device *sdev)
+{
+	int ret;
+	int vpd_len = 255;
+	unsigned char *buffer;
+retry:
+	buffer = kmalloc(vpd_len, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	ret = scsi_get_vpd_page(sdev, 0x83, buffer, vpd_len);
+	if (ret) {
+		kfree(buffer);
+		return;
+	}
+
+	vpd_len = (buffer[2] << 8) + buffer[3];
+	if (vpd_len > 255) {
+		kfree(buffer);
+		goto retry;
+	}
+	sdev->vpd_ident_len = vpd_len;
+	sdev->vpd_ident = buffer;
+}
+
+#define SCSI_VPD_ASSOC_lun 0x0
+#define SCSI_VPD_ASSOC_port 0x1
+#define SCSI_VPD_ASSOC_target 0x2
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
+#define SCSI_VPD_DESIG_proto 0x9
+
+int scsi_parse_vpd_ident(struct scsi_device *sdev,
+			 int assoc, int desig, char *buf)
+{
+	unsigned char *d;
+	int len = 0, j;
+
+	if (!sdev->vpd_ident)
+		return -EINVAL;
+
+	d = sdev->vpd_ident + 4;
+	while (d < sdev->vpd_ident + sdev->vpd_ident_len) {
+		const char *proto = NULL;
+
+		if (((d[1] >> 4) & 0x3) == assoc &&
+		    (d[1] & 0xf) == desig) {
+			if (d[1] & 0x80) {
+				switch (d[0] >> 4) {
+				case SCSI_PROTOCOL_FCP:
+					proto = "fcp";
+					break;
+				case SCSI_PROTOCOL_SPI:
+					proto = "spi";
+					break;
+				case SCSI_PROTOCOL_SSA:
+					proto = "ssa";
+					break;
+				case SCSI_PROTOCOL_SBP:
+					proto = "sbp";
+					break;
+				case SCSI_PROTOCOL_SRP:
+					proto = "srp";
+					break;
+				case SCSI_PROTOCOL_ISCSI:
+					proto = "iscsi";
+					break;
+				case SCSI_PROTOCOL_SAS:
+					proto = "sas";
+					break;
+				case SCSI_PROTOCOL_ADT:
+					proto = "adt";
+					break;
+				case SCSI_PROTOCOL_ATA:
+					proto = "ata";
+					break;
+				case SCSI_PROTOCOL_UAS:
+					proto = "usb";
+					break;
+				case SCSI_PROTOCOL_SOP:
+					proto = "pcie";
+					break;
+				}
+				if (proto)
+					len += sprintf(buf + len, "%s:",
+						       proto);
+			}
+			switch (d[1] & 0xf) {
+			case SCSI_VPD_DESIG_eui:
+			case SCSI_VPD_DESIG_naa:
+			case SCSI_VPD_DESIG_md5:
+				switch (d[3]) {
+				case 8:
+					len += sprintf(buf + len, "%8phN\n",
+						       d + 4);
+					break;
+				case 12:
+					len += sprintf(buf + len, "%12phN\n",
+						       d + 4);
+					break;
+				case 16:
+					len += sprintf(buf + len, "%16phN\n",
+						       d + 4);
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
+				if ((d[0] & 0xf) == 1) {
+					for (j = 0; j < d[3]; j++) {
+						len += sprintf(buf + len,
+							       "%02x",
+							       d[4 + j]);
+					}
+				} else {
+					snprintf(buf + len, d[3] + 1,
+						 "%s", d + 4);
+					len += d[3];
+				}
+				len += sprintf(buf + len, "\n");
+				break;
+			case SCSI_VPD_DESIG_t10:
+				/* T10 Vendor is always ASCII */
+				snprintf(buf + len, 9, "%s ", d + 4);
+				len += 8;
+				if ((d[0] & 0xf) == 1) {
+					for (j = 0; j < d[3] - 8; j++) {
+						len += sprintf(buf + len,
+							       "%02x",
+							       d[12 + j]);
+					}
+				} else {
+					snprintf(buf + len, d[3] - 7,
+						 "%s", d + 12);
+					len += d[3] - 8;
+				}
+				len += sprintf(buf + len, "\n");
+				break;
+			case SCSI_VPD_DESIG_scsi_name:
+				snprintf(buf + len, d[3] + 2, "%s\n", d + 4);
+				len += d[3] + 1;
+				break;
+			case SCSI_VPD_DESIG_proto:
+				if (d[1] & 80) {
+					if ((d[0] >> 4) == 0x9)
+						len += sprintf(buf + len,
+							       "%d-%d\n",
+							       d[4], d[6]);
+					else if ((d[0] >> 4) == 0xa) {
+						j = (d[4] << 8) + d[5];
+						len += sprintf(buf + len,
+							       "%d\n", j);
+					}
+				}
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
+sdev_evpd_attr(port, proto);
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
+		sdev_evpd_test_and_add_attr(sdev, port, proto, &desig);
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
@@ -1003,6 +1257,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	scsi_sysfs_filter_vpd_ident(sdev);
+
 	/* create queue files, which may be writable, depending on the host */
 	if (sdev->host->hostt->change_queue_depth) {
 		error = device_create_file(&sdev->sdev_gendev,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 0a4edfe..0f1e6bd 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -345,6 +345,8 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_SAS = 6,
 	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
 	SCSI_PROTOCOL_ATA = 8,
+	SCSI_PROTOCOL_UAS = 9,
+	SCSI_PROTOCOL_SOP = 0xa,
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index dcb2b73..81c7900 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -113,6 +113,8 @@ struct scsi_device {
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
+	unsigned char vpd_ident_len;
+	unsigned char *vpd_ident;
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
 	unsigned int	sdev_bflags; /* black/white flags as also found in
@@ -308,6 +310,7 @@ extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
+void scsi_attach_vpd_ident(struct scsi_device *sdev);
 
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
-- 
1.7.12.4

