From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH] qla4xxx: skip error recovery in case of register disconnect.
Date: Sun, 11 Feb 2018 22:48:41 -0800
Message-ID: <20180212064841.24503-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0075.outbound.protection.outlook.com ([104.47.36.75]:19863
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751332AbeBLGsp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Feb 2018 01:48:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

A system crashes when continuously removing/re-adding
the storage controller.

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |  2 ++
 drivers/scsi/qla4xxx/ql4_os.c  | 46 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index fc23371..817f312 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -168,6 +168,8 @@
 #define DEV_DB_NON_PERSISTENT	0
 #define DEV_DB_PERSISTENT	1
 
+#define QL4_ISP_REG_DISCONNECT 0xffffffffU
+
 #define COPY_ISID(dst_isid, src_isid) {			\
 	int i, j;					\
 	for (i = 0, j = ISID_SIZE - 1; i < ISID_SIZE;)	\
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2b8a8ce..efaa7f1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -262,6 +262,24 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
+static int qla4xxx_isp_check_reg(struct scsi_qla_host *ha)
+{
+	u32 reg_val = 0;
+	int rval = QLA_SUCCESS;
+
+	if (is_qla8022(ha))
+		reg_val = readl(&ha->qla4_82xx_reg->host_status);
+	else if (is_qla8032(ha) || is_qla8042(ha))
+		reg_val = qla4_8xxx_rd_direct(ha, QLA8XXX_PEG_ALIVE_COUNTER);
+	else
+		reg_val = readw(&ha->reg->ctrl_status);
+
+	if (reg_val == QL4_ISP_REG_DISCONNECT)
+		rval = QLA_ERROR;
+
+	return rval;
+}
+
 static int qla4xxx_send_ping(struct Scsi_Host *shost, uint32_t iface_num,
 			     uint32_t iface_type, uint32_t payload_size,
 			     uint32_t pid, struct sockaddr *dst_addr)
@@ -9188,10 +9206,17 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	struct srb *srb = NULL;
 	int ret = SUCCESS;
 	int wait = 0;
+	int rval;
 
 	ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Abort command issued cmd=%p, cdb=0x%x\n",
 		   ha->host_no, id, lun, cmd, cmd->cmnd[0]);
 
+	rval = qla4xxx_isp_check_reg(ha);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_INFO, ha, "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	srb = (struct srb *) CMD_SP(cmd);
 	if (!srb) {
@@ -9243,6 +9268,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
 	int ret = FAILED, stat;
+	int rval;
 
 	if (!ddb_entry)
 		return ret;
@@ -9262,6 +9288,12 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		      cmd, jiffies, cmd->request->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
+	rval = qla4xxx_isp_check_reg(ha);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_INFO, ha, "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	/* FIXME: wait for hba to go online */
 	stat = qla4xxx_reset_lun(ha, ddb_entry, cmd->device->lun);
 	if (stat != QLA_SUCCESS) {
@@ -9305,6 +9337,7 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
 	int stat, ret;
+	int rval;
 
 	if (!ddb_entry)
 		return FAILED;
@@ -9322,6 +9355,12 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		      ha->host_no, cmd, jiffies, cmd->request->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
+	rval = qla4xxx_isp_check_reg(ha);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_INFO, ha, "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	stat = qla4xxx_reset_target(ha, ddb_entry);
 	if (stat != QLA_SUCCESS) {
 		starget_printk(KERN_INFO, scsi_target(cmd->device),
@@ -9376,9 +9415,16 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	int return_status = FAILED;
 	struct scsi_qla_host *ha;
+	int rval;
 
 	ha = to_qla_host(cmd->device->host);
 
+	rval = qla4xxx_isp_check_reg(ha);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_INFO, ha, "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	if ((is_qla8032(ha) || is_qla8042(ha)) && ql4xdontresethba)
 		qla4_83xx_set_idc_dontreset(ha);
 
-- 
1.8.3.1
