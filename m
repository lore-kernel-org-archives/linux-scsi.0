From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/7][RFC] qla4xxx: added Add host attributes to export host
	information to sysfs.
Date: Tue, 11 May 2010 13:27:56 +0530
Message-ID: <20100511075756.GA30505@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:60026
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755952Ab0EKIB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 04:01:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/Makefile   |    2 +-
 drivers/scsi/qla4xxx/ql4_attr.c |  168 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |    8 ++-
 drivers/scsi/qla4xxx/ql4_init.c |    8 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |   76 +++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |    3 +-
 6 files changed, 255 insertions(+), 10 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_attr.c

diff --git a/drivers/scsi/qla4xxx/Makefile b/drivers/scsi/qla4xxx/Makefile
index 86ea37b..f0b6566 100644
--- a/drivers/scsi/qla4xxx/Makefile
+++ b/drivers/scsi/qla4xxx/Makefile
@@ -1,5 +1,5 @@
 qla4xxx-y := ql4_os.o ql4_init.o ql4_mbx.o ql4_iocb.o ql4_isr.o \
-		ql4_nvram.o ql4_dbg.o
+		ql4_nvram.o ql4_dbg.o ql4_attr.o
 
 obj-$(CONFIG_SCSI_QLA_ISCSI) += qla4xxx.o
 
diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
new file mode 100644
index 0000000..d14882e
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -0,0 +1,168 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+#include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+
+/* Scsi_Host attributes. */
+
+static ssize_t
+qla4xxx_drvr_version_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+        return snprintf(buf, PAGE_SIZE, "%s\n", qla4xxx_version_str);
+}
+
+static ssize_t
+qla4xxx_fw_version_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+
+	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
+		ha->firmware_version[0], ha->firmware_version[1],
+		ha->patch_number, ha->build_number);
+}
+
+static ssize_t
+qla4xxx_serial_num_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", ha->serial_number);
+}
+
+static ssize_t
+qla4xxx_isp_name_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "ISP%04X\n", ha->pdev->device);
+}
+
+static ssize_t
+qla4xxx_fw_state_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	int rval = QLA_ERROR;
+	uint32_t state[5];
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+
+	if (!test_bit(AF_ONLINE, &ha->flags))
+		rval = qla4xxx_get_firmware_state(ha, state);
+	else
+		DEBUG2(printk("%s:(%ld): Adapter is not online.\n",
+		    __func__, ha->host_no));
+
+	if (rval != QLA_SUCCESS)
+		memset(state, -1, sizeof(state));
+
+	return snprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x\n", state[0],
+	    state[1], state[2], state[3], state[4]);
+}
+
+static ssize_t
+qla4xxx_board_id_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+	return snprintf(buf, PAGE_SIZE, "0x%08X\n", ha->board_id);
+}
+
+static ssize_t
+qla4xxx_hba_reset_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+
+	return snprintf(buf, PAGE_SIZE, "%x\n",
+	    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags));
+}
+
+static ssize_t
+qla4xxx_hba_reset_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+	int val = 0;
+
+	sscanf(buf, "%d", &val);
+
+	if (val != 0x4000)
+		return -ERANGE;
+
+	set_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags);
+	queue_work(ha->dpc_thread, &ha->dpc_work);
+
+	return strlen(buf);
+}
+
+static ssize_t
+qla4xxx_ip_state_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	if (test_bit(AF_ONLINE, &ha->flags))
+		qla4xxx_get_ip_state(ha, mbox_sts);
+	else
+		DEBUG2(printk("%s:(%ld): Adapter is not online.\n",
+		    __func__, ha->host_no));
+
+	return snprintf(buf, PAGE_SIZE, "0x%08X 0x%08X 0x%08X "
+			"0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
+			mbox_sts[0], mbox_sts[1], mbox_sts[2],
+			mbox_sts[3], mbox_sts[4], mbox_sts[5],
+			mbox_sts[6], mbox_sts[7]);
+}
+
+static ssize_t
+qla4xxx_ddb_info_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	if (test_bit(AF_ONLINE, &ha->flags))
+		qla4xxx_get_ddb_info(ha, mbox_sts);
+	else
+		DEBUG2(printk("%s:(%ld): Adapter is not online.\n",
+		    __func__, ha->host_no));
+
+	return snprintf(buf, PAGE_SIZE, "0x%08X 0x%08X 0x%08X "
+			"0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
+			mbox_sts[0], mbox_sts[1], mbox_sts[2],
+			mbox_sts[3], mbox_sts[4], mbox_sts[5],
+			mbox_sts[6], mbox_sts[7]);
+}
+
+static DEVICE_ATTR(driver_version, S_IRUGO, qla4xxx_drvr_version_show, NULL);
+static DEVICE_ATTR(fw_version, S_IRUGO, qla4xxx_fw_version_show, NULL);
+static DEVICE_ATTR(serial_num, S_IRUGO, qla4xxx_serial_num_show, NULL);
+static DEVICE_ATTR(isp_name, S_IRUGO, qla4xxx_isp_name_show, NULL);
+static DEVICE_ATTR(fw_state, S_IRUGO, qla4xxx_fw_state_show, NULL);
+static DEVICE_ATTR(board_id, S_IRUGO, qla4xxx_board_id_show, NULL);
+static DEVICE_ATTR(hba_reset, S_IRUGO | S_IWUSR,
+    qla4xxx_hba_reset_show, qla4xxx_hba_reset_store);
+static DEVICE_ATTR(ip_state, S_IRUGO, qla4xxx_ip_state_show, NULL);
+static DEVICE_ATTR(ddb_info, S_IRUGO, qla4xxx_ddb_info_show, NULL);
+
+struct device_attribute *qla4xxx_host_attrs[] = {
+	&dev_attr_driver_version,
+	&dev_attr_fw_version,
+	&dev_attr_serial_num,
+	&dev_attr_isp_name,
+	&dev_attr_fw_state,
+	&dev_attr_board_id,
+	&dev_attr_hba_reset,
+	&dev_attr_ip_state,
+	&dev_attr_ddb_info,
+	NULL,
+};
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 0d153ef..ef112ce 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -33,7 +33,7 @@ int qla4xxx_reset_target(struct scsi_qla_host * ha,
 int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t len);
 int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
-int qla4xxx_get_firmware_state(struct scsi_qla_host * ha);
+int qla4xxx_get_firmware_state(struct scsi_qla_host *ha, uint32_t *status);
 int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha);
 int qla4xxx_get_default_ddb(struct scsi_qla_host *ha,
 		dma_addr_t dma_addr);
@@ -55,6 +55,9 @@ int qla4xxx_disable_acb(struct iscsi_bsg_job *bsg_job,
 		struct qla4xxx_bsg_cmd *qla4xxx_cmd);
 int qla4xxx_ping(struct iscsi_bsg_job *bsg_job);
 
+int qla4xxx_get_ip_state(struct scsi_qla_host *ha, uint32_t *mbox_status);
+int qla4xxx_get_ddb_info(struct scsi_qla_host *ha, uint32_t *mbox_status);
+
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
 int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
@@ -98,4 +101,7 @@ extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
 extern int ql4_mod_unload;
+extern char qla4xxx_version_str[40];
+
+extern struct device_attribute *qla4xxx_host_attrs[];
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 5510df8..0636819 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -273,7 +273,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 			qla4xxx_get_dhcp_ip_address(ha);
 
 		/* Get firmware state. */
-		if (qla4xxx_get_firmware_state(ha) != QLA_SUCCESS) {
+		if (qla4xxx_get_firmware_state(ha, NULL) != QLA_SUCCESS) {
 			DEBUG2(printk("scsi%ld: %s: unable to get firmware "
 				      "state\n", ha->host_no, __func__));
 			break;
@@ -884,7 +884,7 @@ static int qla4xxx_devices_ready(struct scsi_qla_host *ha)
 	DEBUG(printk("Waiting (%d) for devices ...\n", ql4xdiscoverywait));
 	do {
 		/* poll for AEN. */
-		qla4xxx_get_firmware_state(ha);
+		qla4xxx_get_firmware_state(ha, NULL);
 		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags)) {
 			/* Set time-between-relogin timer */
 			qla4xxx_process_aen(ha, RELOGIN_DDB_CHANGED_AENS);
@@ -922,7 +922,7 @@ static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
 	 */
 	wtime = jiffies + (2 * HZ);
 	do {
-		if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS)
+		if (qla4xxx_get_firmware_state(ha, NULL) == QLA_SUCCESS)
 			if (ha->firmware_state & (BIT_2 | BIT_0))
 				return;
 
@@ -1246,7 +1246,7 @@ static int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 			       &ha->reg->ctrl_status);
 			readl(&ha->reg->ctrl_status);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS) {
+			if (qla4xxx_get_firmware_state(ha, NULL) == QLA_SUCCESS) {
 				DEBUG2(printk("scsi%ld: %s: Get firmware "
 					      "state -- state = 0x%x\n",
 					      ha->host_no,
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c092fc1..19c7d52 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -421,7 +421,7 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
  * qla4xxx_get_firmware_state - gets firmware state of HBA
  * @ha: Pointer to host adapter structure.
  **/
-int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
+int qla4xxx_get_firmware_state(struct scsi_qla_host *ha, uint32_t *status)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
@@ -432,7 +432,7 @@ int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
 
 	mbox_cmd[0] = MBOX_CMD_GET_FW_STATE;
 
-	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 4, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_FW_STATE failed w/ "
 			      "status %04X\n", ha->host_no, __func__,
@@ -445,7 +445,10 @@ int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
 	DEBUG2(printk("scsi%ld: %s firmware_state=0x%x\n",
 		      ha->host_no, __func__, ha->firmware_state);)
 
-		return QLA_SUCCESS;
+	if (status)
+		memcpy(status, mbox_sts, (sizeof(uint32_t) * 5));
+
+	return QLA_SUCCESS;
 }
 
 /**
@@ -1359,3 +1362,70 @@ int qla4xxx_ping(struct iscsi_bsg_job *job)
 
 	return QLA_SUCCESS;
 }
+
+/**
+ * qla4xxx_get_ip_state - get ip state.
+ * @ha: Pointer to host adapter structure.
+ **/
+int qla4xxx_get_ip_state(struct scsi_qla_host *ha, uint32_t *mbox_status)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_ERROR;
+
+	/* Get firmware version */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_IP_ADDR_STATE;
+	mbox_cmd[1] = 0;        /* primary ACB */
+	mbox_cmd[2] = 0;        /* 0 = IPv4 TODO: Add support for IPv6*/
+
+	if (qla4xxx_mailbox_command(ha, 3, 8, &mbox_cmd[0], &mbox_sts[0]) !=
+	    QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_IP_ADDR_STATE "
+		    "failed w/ status %04X\n",
+		    ha->host_no, __func__, mbox_sts[0]));
+		goto exit_ip_state;
+	}
+	status = QLA_SUCCESS;
+
+exit_ip_state:
+	memcpy(mbox_status, mbox_sts, sizeof(mbox_sts));
+	return status;
+}
+
+/**
+ * qla4xxx_get_ddb_info - get ddb info.
+ * @ha: Pointer to host adapter structure.
+ * @status: return mailbox status.
+ **/
+int qla4xxx_get_ddb_info(struct scsi_qla_host *ha, uint32_t *mbox_status)
+{
+	int status = QLA_ERROR;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY;
+	mbox_cmd[1] = 0;
+	mbox_cmd[2] = 0;
+	mbox_cmd[3] = 0;
+	mbox_cmd[4] = sizeof(struct dev_db_entry);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 7, &mbox_cmd[0], &mbox_sts[0]) ==
+	    QLA_ERROR) {
+		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_DATABASE_ENTRY failed"
+		    " with status 0x%04X\n", ha->host_no, __func__,
+		    mbox_sts[0]));
+		goto exit_ddb_info;
+	}
+
+	status = QLA_SUCCESS;
+
+exit_ddb_info:
+	memcpy(mbox_status, mbox_sts, sizeof(mbox_sts));
+	return status;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index daf862d..6bc6571 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -21,7 +21,7 @@
 /*
  * Driver version
  */
-static char qla4xxx_version_str[40];
+char qla4xxx_version_str[40];
 
 /*
  * SRB allocation cache
@@ -112,6 +112,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 
 	.max_sectors		= 0xFFFF,
 	.vendor_id              = SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
+	.shost_attrs		= qla4xxx_host_attrs,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
-- 
1.7.0.5

