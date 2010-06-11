From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 12/15] qla4xxx: added host attributes to export host
	information via sysfs.
Date: Fri, 11 Jun 2010 13:18:35 +0530
Message-ID: <20100611074835.GA27818@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:47512
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753432Ab0FKHum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 03:50:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/Makefile   |    2 +-
 drivers/scsi/qla4xxx/ql4_attr.c |  166 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |    6 +-
 drivers/scsi/qla4xxx/ql4_init.c |    8 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |   78 +++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |    3 +-
 6 files changed, 252 insertions(+), 11 deletions(-)
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
index 0000000..a732aa3
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -0,0 +1,166 @@
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
+	if (test_bit(AF_ONLINE, &ha->flags))
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
+static ssize_t
+qla4xxx_hba_reset_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_qla_host *ha = shost_priv(class_to_shost(dev));
+
+	return snprintf(buf, PAGE_SIZE, "%x\n",
+	    test_bit(DPC_RESET_HA, &ha->dpc_flags));
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
+	if (!test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+		if (is_qla8022(ha))
+			set_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags);
+		else
+			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+	}
+
+	qla4xxx_recover_adapter(ha);
+
+	return strlen(buf);
+}
+
+static DEVICE_ATTR(fw_version, S_IRUGO, qla4xxx_fw_version_show, NULL);
+static DEVICE_ATTR(serial_num, S_IRUGO, qla4xxx_serial_num_show, NULL);
+static DEVICE_ATTR(isp_name, S_IRUGO, qla4xxx_isp_name_show, NULL);
+static DEVICE_ATTR(fw_state, S_IRUGO, qla4xxx_fw_state_show, NULL);
+static DEVICE_ATTR(board_id, S_IRUGO, qla4xxx_board_id_show, NULL);
+static DEVICE_ATTR(ip_state, S_IRUGO, qla4xxx_ip_state_show, NULL);
+static DEVICE_ATTR(ddb_info, S_IRUGO, qla4xxx_ddb_info_show, NULL);
+static DEVICE_ATTR(hba_reset, S_IRUGO | S_IWUSR,
+		qla4xxx_hba_reset_show, qla4xxx_hba_reset_store);
+
+
+struct device_attribute *qla4xxx_host_attrs[] = {
+	&dev_attr_fw_version,
+	&dev_attr_serial_num,
+	&dev_attr_isp_name,
+	&dev_attr_fw_state,
+	&dev_attr_board_id,
+	&dev_attr_ip_state,
+	&dev_attr_ddb_info,
+	&dev_attr_hba_reset,
+	NULL,
+};
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index e2114eb..9aecfdf 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -34,8 +34,10 @@ int qla4xxx_reset_target(struct scsi_qla_host *ha,
 int qla4xxx_get_flash(struct scsi_qla_host *ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t len);
 int qla4xxx_get_firmware_status(struct scsi_qla_host *ha);
-int qla4xxx_get_firmware_state(struct scsi_qla_host *ha);
+int qla4xxx_get_firmware_state(struct scsi_qla_host *ha, uint32_t *status);
 int qla4xxx_initialize_fw_cb(struct scsi_qla_host *ha);
+int qla4xxx_get_ip_state(struct scsi_qla_host *ha, uint32_t *mbox_status);
+int qla4xxx_get_ddb_info(struct scsi_qla_host *ha, uint32_t *mbox_status);
 
 /* FIXME: Goodness!  this really wants a small struct to hold the
  * parameters. On x86 the args will get passed on the stack! */
@@ -93,6 +95,7 @@ void qla4xxx_free_irqs(struct scsi_qla_host *ha);
 void qla4xxx_process_response_queue(struct scsi_qla_host *ha);
 void qla4xxx_wake_dpc(struct scsi_qla_host *ha);
 void qla4xxx_get_conn_event_log(struct scsi_qla_host *ha);
+int qla4xxx_recover_adapter(struct scsi_qla_host *ha);
 
 void qla82xx_pci_config(struct scsi_qla_host *);
 int qla82xx_iospace_config(struct scsi_qla_host *ha);
@@ -132,6 +135,7 @@ int qla82xx_device_state_handler(struct scsi_qla_host *ha);
 void qla82xx_need_qsnt_handler(struct scsi_qla_host *ha);
 void qla82xx_clear_drv_active(struct scsi_qla_host *ha);
 
+extern struct device_attribute *qla4xxx_host_attrs[];
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cf91f97..c7b6486 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -303,7 +303,7 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 			qla4xxx_get_dhcp_ip_address(ha);
 
 		/* Get firmware state. */
-		if (qla4xxx_get_firmware_state(ha) != QLA_SUCCESS) {
+		if (qla4xxx_get_firmware_state(ha, NULL) != QLA_SUCCESS) {
 			DEBUG2(printk("scsi%ld: %s: unable to get firmware "
 				      "state\n", ha->host_no, __func__));
 			break;
@@ -925,7 +925,7 @@ static int qla4xxx_devices_ready(struct scsi_qla_host *ha)
 	DEBUG(printk("Waiting (%d) for devices ...\n", ql4xdiscoverywait));
 	do {
 		/* poll for AEN. */
-		qla4xxx_get_firmware_state(ha);
+		qla4xxx_get_firmware_state(ha, NULL);
 		if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags)) {
 			/* Set time-between-relogin timer */
 			qla4xxx_process_aen(ha, RELOGIN_DDB_CHANGED_AENS);
@@ -963,7 +963,7 @@ static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
 	 */
 	wtime = jiffies + (2 * HZ);
 	do {
-		if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS)
+		if (qla4xxx_get_firmware_state(ha, NULL) == QLA_SUCCESS)
 			if (ha->firmware_state & (BIT_2 | BIT_0))
 				return;
 
@@ -1297,7 +1297,7 @@ int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 			       &ha->reg->ctrl_status);
 			readl(&ha->reg->ctrl_status);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS) {
+			if (qla4xxx_get_firmware_state(ha, NULL) == QLA_SUCCESS) {
 				DEBUG2(printk("scsi%ld: %s: Get firmware "
 					      "state -- state = 0x%x\n",
 					      ha->host_no,
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 583b9b3..7dd28d5 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -492,8 +492,9 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 /**
  * qla4xxx_get_firmware_state - gets firmware state of HBA
  * @ha: Pointer to host adapter structure.
+ * status: status of mbx command
  **/
-int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
+int qla4xxx_get_firmware_state(struct scsi_qla_host *ha, uint32_t *status)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
@@ -504,8 +505,8 @@ int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
 
 	mbox_cmd[0] = MBOX_CMD_GET_FW_STATE;
 
-	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 4, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS) {
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0],
+	    &mbox_sts[0]) != QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_FW_STATE failed w/ "
 			      "status %04X\n", ha->host_no, __func__,
 			      mbox_sts[0]));
@@ -515,7 +516,10 @@ int qla4xxx_get_firmware_state(struct scsi_qla_host * ha)
 	ha->board_id = mbox_sts[2];
 	ha->addl_fw_state = mbox_sts[3];
 	DEBUG2(printk("scsi%ld: %s firmware_state=0x%x\n",
-		      ha->host_no, __func__, ha->firmware_state);)
+		      ha->host_no, __func__, ha->firmware_state));
+
+	if (status)
+		memcpy(status, mbox_sts, (sizeof(uint32_t) * 5));
 
 	return QLA_SUCCESS;
 }
@@ -1139,3 +1143,69 @@ exit_send_tgts_no_free:
 	return ret_val;
 }
 
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
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 7, &mbox_cmd[0],
+	    &mbox_sts[0]) == QLA_ERROR) {
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
index 8aa5391..56d22b8 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -118,6 +118,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.sg_tablesize		= SG_ALL,
 
 	.max_sectors		= 0xFFFF,
+	.shost_attrs            = qla4xxx_host_attrs,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
@@ -1053,7 +1054,7 @@ void qla4xxx_dead_adapter_cleanup(struct scsi_qla_host *ha)
  * qla4xxx_recover_adapter - recovers adapter after a fatal error
  * @ha: Pointer to host adapter structure.
  **/
-static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
+int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
 	uint8_t reset_chip = 0;
-- 
1.7.0.5

