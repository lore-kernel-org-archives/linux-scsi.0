From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/18] qla2xxx: Retrieve board serial-number and description from VPD.
Date: Thu, 10 Jul 2008 16:55:53 -0700
Message-ID: <1215734163-40825-8-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbYGJX4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:18 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Recent ISPs have this information written at manufacturing time,
so use the information.  This also reduces future churn of the
qla_devtbl.h file contents, as the driver can now depend on the
information to be present in VPD.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++-
 drivers/scsi/qla2xxx/qla_def.h  |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   11 +++++++-
 drivers/scsi/qla2xxx/qla_sup.c  |   45 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2775413..fbae98c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -532,8 +532,10 @@ qla2x00_serial_num_show(struct device *dev, struct device_attribute *attr,
 	scsi_qla_host_t *ha = shost_priv(class_to_shost(dev));
 	uint32_t sn;
 
-	if (IS_FWI2_CAPABLE(ha))
-		return snprintf(buf, PAGE_SIZE, "\n");
+	if (IS_FWI2_CAPABLE(ha)) {
+		qla2xxx_get_vpd_field(ha, "SN", buf, PAGE_SIZE);
+		return snprintf(buf, PAGE_SIZE, "%s\n", buf);
+	}
 
 	sn = ((ha->serial0 & 0x1f) << 16) | (ha->serial2 << 8) | ha->serial1;
 	return snprintf(buf, PAGE_SIZE, "%c%05d\n", 'A' + sn / 100000,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 00c7052..6da31ba 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2518,7 +2518,7 @@ typedef struct scsi_qla_host {
 
 	uint8_t		model_number[16+1];
 #define BINZERO		"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
-	char		*model_desc;
+	char		model_desc[80];
 	uint8_t		adapter_id[16+1];
 
 	uint8_t		*node_name;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f921ccd..0b15673 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -314,6 +314,7 @@ extern int qla2xxx_hw_event_log(scsi_qla_host_t *, uint16_t , uint16_t,
     uint16_t, uint16_t);
 
 extern void qla2xxx_get_flash_info(scsi_qla_host_t *);
+extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
 
 /*
  * Global Function Prototypes in qla_dbg.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f4cd2cd..08bdba5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1501,18 +1501,25 @@ qla2x00_set_model_info(scsi_qla_host_t *ha, uint8_t *model, size_t len, char *de
 		index = (ha->pdev->subsystem_device & 0xff);
 		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES)
-			ha->model_desc = qla2x00_model_name[index * 2 + 1];
+			strncpy(ha->model_desc,
+			    qla2x00_model_name[index * 2 + 1],
+			    sizeof(ha->model_desc) - 1);
 	} else {
 		index = (ha->pdev->subsystem_device & 0xff);
 		if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_QLOGIC &&
 		    index < QLA_MODEL_NAMES) {
 			strcpy(ha->model_number,
 			    qla2x00_model_name[index * 2]);
-			ha->model_desc = qla2x00_model_name[index * 2 + 1];
+			strncpy(ha->model_desc,
+			    qla2x00_model_name[index * 2 + 1],
+			    sizeof(ha->model_desc) - 1);
 		} else {
 			strcpy(ha->model_number, def);
 		}
 	}
+	if (IS_FWI2_CAPABLE(ha))
+		qla2xxx_get_vpd_field(ha, "\x82", ha->model_desc,
+		    sizeof(ha->model_desc));
 }
 
 /* On sparc systems, obtain port and node WWN from firmware
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ebea622..1bca744 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2303,6 +2303,51 @@ qla24xx_get_flash_version(scsi_qla_host_t *ha, void *mbuf)
 }
 
 static int
+qla2xxx_is_vpd_valid(uint8_t *pos, uint8_t *end)
+{
+	if (pos >= end || *pos != 0x82)
+		return 0;
+
+	pos += 3 + pos[1];
+	if (pos >= end || *pos != 0x90)
+		return 0;
+
+	pos += 3 + pos[1];
+	if (pos >= end || *pos != 0x78)
+		return 0;
+
+	return 1;
+}
+
+int
+qla2xxx_get_vpd_field(scsi_qla_host_t *ha, char *key, char *str, size_t size)
+{
+	uint8_t *pos = ha->vpd;
+	uint8_t *end = pos + ha->vpd_size;
+	int len = 0;
+
+	if (!IS_FWI2_CAPABLE(ha) || !qla2xxx_is_vpd_valid(pos, end))
+		return 0;
+
+	while (pos < end && *pos != 0x78) {
+		len = (*pos == 0x82) ? pos[1] : pos[2];
+
+		if (!strncmp(pos, key, strlen(key)))
+			break;
+
+		if (*pos != 0x90 && *pos != 0x91)
+			pos += len;
+
+		pos += 3;
+	}
+
+	if (pos < end - len && *pos != 0x78)
+		return snprintf(str, size, "%.*s", len, pos + 3);
+
+	return 0;
+}
+
+static int
 qla2xxx_hw_event_store(scsi_qla_host_t *ha, uint32_t *fdata)
 {
 	uint32_t d[2], faddr;
-- 
1.5.6.2.292.ga9a3

