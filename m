From: vikas.chaudhary@qlogic.com
Subject: [PATCH 09/10] qla4xxx: Added vendor specific sysfs attributes
Date: Tue, 17 May 2011 23:17:11 -0700
Message-ID: <1305699432-13225-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50946 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754359Ab1ERGXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:47 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Added fw_version, serial_num, iscsi version and boot loader version
sysfs attributes.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/Makefile   |    2 +-
 drivers/scsi/qla4xxx/ql4_attr.c |   69 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_def.h  |    8 ++++
 drivers/scsi/qla4xxx/ql4_fw.h   |   23 +++++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |    3 +-
 drivers/scsi/qla4xxx/ql4_init.c |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |   63 +++++++++++++++++++++++++----------
 drivers/scsi/qla4xxx/ql4_os.c   |    1 +
 8 files changed, 150 insertions(+), 21 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_attr.c

diff --git a/drivers/scsi/qla4xxx/Makefile b/drivers/scsi/qla4xxx/Makefile
index 0339ff0..252523d 100644
--- a/drivers/scsi/qla4xxx/Makefile
+++ b/drivers/scsi/qla4xxx/Makefile
@@ -1,5 +1,5 @@
 qla4xxx-y := ql4_os.o ql4_init.o ql4_mbx.o ql4_iocb.o ql4_isr.o \
-		ql4_nx.o ql4_nvram.o ql4_dbg.o
+		ql4_nx.o ql4_nvram.o ql4_dbg.o ql4_attr.o
 
 obj-$(CONFIG_SCSI_QLA_ISCSI) += qla4xxx.o
 
diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
new file mode 100644
index 0000000..864d018
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -0,0 +1,69 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2011 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+
+/* Scsi_Host attributes. */
+static ssize_t
+qla4xxx_fw_version_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+
+	if (is_qla8022(ha))
+		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
+				ha->firmware_version[0],
+				ha->firmware_version[1],
+				ha->patch_number, ha->build_number);
+	else
+		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
+				ha->firmware_version[0],
+				ha->firmware_version[1],
+				ha->patch_number, ha->build_number);
+}
+
+static ssize_t
+qla4xxx_serial_num_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%s\n", ha->serial_number);
+}
+
+static ssize_t
+qla4xxx_iscsi_version_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->iscsi_major,
+			ha->iscsi_minor);
+}
+
+static ssize_t
+qla4xxx_optrom_version_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
+			ha->bootload_major, ha->bootload_minor,
+			ha->bootload_patch, ha->bootload_build);
+}
+
+static DEVICE_ATTR(fw_version, S_IRUGO, qla4xxx_fw_version_show, NULL);
+static DEVICE_ATTR(serial_num, S_IRUGO, qla4xxx_serial_num_show, NULL);
+static DEVICE_ATTR(iscsi_version, S_IRUGO, qla4xxx_iscsi_version_show, NULL);
+static DEVICE_ATTR(optrom_version, S_IRUGO, qla4xxx_optrom_version_show, NULL);
+
+struct device_attribute *qla4xxx_host_attrs[] = {
+	&dev_attr_fw_version,
+	&dev_attr_serial_num,
+	&dev_attr_iscsi_version,
+	&dev_attr_optrom_version,
+	NULL,
+};
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8e3a28e..473c5c8 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -583,6 +583,14 @@ struct scsi_qla_host {
 	uint32_t nx_reset_timeout;
 
 	struct completion mbx_intr_comp;
+
+	/* --- From About Firmware --- */
+	uint16_t iscsi_major;
+	uint16_t iscsi_minor;
+	uint16_t bootload_major;
+	uint16_t bootload_minor;
+	uint16_t bootload_patch;
+	uint16_t bootload_build;
 };
 
 static inline int is_ipv4_enabled(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 31e2bf9..01082aa 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -690,6 +690,29 @@ struct mbx_sys_info {
 	uint8_t reserved[12];		  /* 34-3f */
 };
 
+struct about_fw_info {
+	uint16_t fw_major;		/* 00 - 01 */
+	uint16_t fw_minor;		/* 02 - 03 */
+	uint16_t fw_patch;		/* 04 - 05 */
+	uint16_t fw_build;		/* 06 - 07 */
+	uint8_t fw_build_date[16];	/* 08 - 17 ASCII String */
+	uint8_t fw_build_time[16];	/* 18 - 27 ASCII String */
+	uint8_t fw_build_user[16];	/* 28 - 37 ASCII String */
+	uint16_t fw_load_source;	/* 38 - 39 */
+					/* 1 = Flash Primary,
+					   2 = Flash Secondary,
+					   3 = Host Download
+					*/
+	uint8_t reserved1[6];		/* 3A - 3F */
+	uint16_t iscsi_major;		/* 40 - 41 */
+	uint16_t iscsi_minor;		/* 42 - 43 */
+	uint16_t bootload_major;	/* 44 - 45 */
+	uint16_t bootload_minor;	/* 46 - 47 */
+	uint16_t bootload_patch;	/* 48 - 49 */
+	uint16_t bootload_build;	/* 4A - 4B */
+	uint8_t reserved2[180];		/* 4C - FF */
+};
+
 struct crash_record {
 	uint16_t fw_major_version;	/* 00 - 01 */
 	uint16_t fw_minor_version;	/* 02 - 03 */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index cc53e3f..a53a256 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -61,7 +61,7 @@ struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha);
 int qla4xxx_add_sess(struct ddb_entry *);
 void qla4xxx_destroy_sess(struct ddb_entry *ddb_entry);
 int qla4xxx_is_nvram_configuration_valid(struct scsi_qla_host *ha);
-int qla4xxx_get_fw_version(struct scsi_qla_host * ha);
+int qla4xxx_about_firmware(struct scsi_qla_host *ha);
 void qla4xxx_interrupt_service_routine(struct scsi_qla_host *ha,
 				       uint32_t intr_status);
 int qla4xxx_init_rings(struct scsi_qla_host *ha);
@@ -139,4 +139,5 @@ extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
 extern int ql4xenablemsix;
 
+extern struct device_attribute *qla4xxx_host_attrs[];
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 48e2241..42ed5db 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1275,7 +1275,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha,
 	if (ha->isp_ops->start_firmware(ha) == QLA_ERROR)
 		goto exit_init_hba;
 
-	if (qla4xxx_get_fw_version(ha) == QLA_ERROR)
+	if (qla4xxx_about_firmware(ha) == QLA_ERROR)
 		goto exit_init_hba;
 
 	if (ha->isp_ops->get_sys_info(ha) == QLA_ERROR)
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a1df53c..b9c2819 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1043,38 +1043,65 @@ int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 }
 
 /**
- * qla4xxx_get_fw_version - gets firmware version
+ * qla4xxx_about_firmware - gets FW, iscsi draft and boot loader version
  * @ha: Pointer to host adapter structure.
  *
- * Retrieves the firmware version on HBA. In QLA4010, mailboxes 2 & 3 may
- * hold an address for data.  Make sure that we write 0 to those mailboxes,
- * if unused.
+ * Retrieves the FW version, iSCSI draft version & bootloader version of HBA.
+ * Mailboxes 2 & 3 may hold an address for data. Make sure that we write 0 to
+ * those mailboxes, if unused.
  **/
-int qla4xxx_get_fw_version(struct scsi_qla_host * ha)
+int qla4xxx_about_firmware(struct scsi_qla_host *ha)
 {
+	struct about_fw_info *about_fw = NULL;
+	dma_addr_t about_fw_dma;
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_ERROR;
+
+	about_fw = dma_alloc_coherent(&ha->pdev->dev,
+				      sizeof(struct about_fw_info),
+				      &about_fw_dma, GFP_KERNEL);
+	if (!about_fw) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: Unable to alloc memory "
+				  "for about_fw\n", __func__));
+		return status;
+	}
 
-	/* Get firmware version. */
+	memset(about_fw, 0, sizeof(struct about_fw_info));
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
 
 	mbox_cmd[0] = MBOX_CMD_ABOUT_FW;
-
-	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_ABOUT_FW failed w/ "
-		    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
-		return QLA_ERROR;
+	mbox_cmd[2] = LSDW(about_fw_dma);
+	mbox_cmd[3] = MSDW(about_fw_dma);
+	mbox_cmd[4] = sizeof(struct about_fw_info);
+
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, MBOX_REG_COUNT,
+					 &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_ABOUT_FW "
+				  "failed w/ status %04X\n", __func__,
+				  mbox_sts[0]));
+		goto exit_about_fw;
 	}
 
-	/* Save firmware version information. */
-	ha->firmware_version[0] = mbox_sts[1];
-	ha->firmware_version[1] = mbox_sts[2];
-	ha->patch_number = mbox_sts[3];
-	ha->build_number = mbox_sts[4];
+	/* Save version information. */
+	ha->firmware_version[0] = le16_to_cpu(about_fw->fw_major);
+	ha->firmware_version[1] = le16_to_cpu(about_fw->fw_minor);
+	ha->patch_number = le16_to_cpu(about_fw->fw_patch);
+	ha->build_number = le16_to_cpu(about_fw->fw_build);
+	ha->iscsi_major = le16_to_cpu(about_fw->iscsi_major);
+	ha->iscsi_minor = le16_to_cpu(about_fw->iscsi_minor);
+	ha->bootload_major = le16_to_cpu(about_fw->bootload_major);
+	ha->bootload_minor = le16_to_cpu(about_fw->bootload_minor);
+	ha->bootload_patch = le16_to_cpu(about_fw->bootload_patch);
+	ha->bootload_build = le16_to_cpu(about_fw->bootload_build);
+	status = QLA_SUCCESS;
 
-	return QLA_SUCCESS;
+exit_about_fw:
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct about_fw_info),
+			  about_fw, about_fw_dma);
+	return status;
 }
 
 static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9bfe9ce..f2364ec 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -124,6 +124,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
+	.shost_attrs		= qla4xxx_host_attrs,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
-- 
1.7.3.2

