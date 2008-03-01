From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] qla4xxx: Add target reset functionality
Date: Fri, 29 Feb 2008 18:25:20 -0600
Message-ID: <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYCAAZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 19:25:37 -0500
In-Reply-To: <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds target reset functionalty.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: David Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h   |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |   39 ++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   |   82 ++++++++++++++++++++++++++++++---------
 4 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index fe415ec..ed8ee66 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -216,6 +216,7 @@ union external_hw_config_reg {
 #define MBOX_CMD_ABOUT_FW			0x0009
 #define MBOX_CMD_PING				0x000B
 #define MBOX_CMD_LUN_RESET			0x0016
+#define MBOX_CMD_TARGET_WARM_RESET		0x0017
 #define MBOX_CMD_GET_MANAGEMENT_DATA		0x001E
 #define MBOX_CMD_GET_FW_STATUS			0x001F
 #define MBOX_CMD_SET_ISNS_SERVICE		0x0021
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index a3608e0..b403a17 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -27,6 +27,8 @@ int qla4xxx_relogin_device(struct scsi_qla_host * ha,
 			   struct ddb_entry * ddb_entry);
 int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 		      int lun);
+int qla4xxx_reset_target(struct scsi_qla_host * ha,
+			 struct ddb_entry * ddb_entry);
 int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t len);
 int qla4xxx_get_firmware_status(struct scsi_qla_host * ha);
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 35cd73c..c577d79 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -713,6 +713,45 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 	return status;
 }
 
+/**
+ * qla4xxx_reset_target - issues target Reset
+ * @ha: Pointer to host adapter structure.
+ * @db_entry: Pointer to device database entry
+ * @un_entry: Pointer to lun entry structure
+ *
+ * This routine performs a TARGET RESET on the specified target.
+ * The caller must ensure that the ddb_entry pointers
+ * are valid before calling this routine.
+ **/
+int qla4xxx_reset_target(struct scsi_qla_host *ha,
+			 struct ddb_entry *ddb_entry)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_SUCCESS;
+
+	DEBUG2(printk("scsi%ld:%d: target reset issued\n", ha->host_no,
+		      ddb_entry->os_target_id));
+
+	/*
+	 * Send target reset command to ISP, so that the ISP will return all
+	 * outstanding requests with RESET status
+	 */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_TARGET_WARM_RESET;
+	mbox_cmd[1] = ddb_entry->fw_ddb_index;
+	mbox_cmd[5] = 0x01;	/* Immediate Command Enable */
+
+	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0],
+				&mbox_sts[0]);
+	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE &&
+	    mbox_sts[0] != MBOX_STS_COMMAND_ERROR)
+		status = QLA_ERROR;
+
+	return status;
+}
 
 int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
 		      uint32_t offset, uint32_t len)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c3c59d7..8c31fe5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -71,6 +71,7 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
 static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 				void (*done) (struct scsi_cmnd *));
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static int qla4xxx_slave_configure(struct scsi_device *device);
@@ -83,6 +84,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.queuecommand		= qla4xxx_queuecommand,
 
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
+	.eh_target_reset_handler = qla4xxx_eh_target_reset,
 	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
 
 	.slave_configure	= qla4xxx_slave_configure,
@@ -1478,7 +1480,7 @@ static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
 }
 
 /**
- * qla4xxx_eh_wait_for_active_target_commands - wait for active cmds to finish.
+ * qla4xxx_eh_wait_for_commands - wait for active cmds to finish.
  * @ha: pointer to to HBA
  * @t: target id
  * @l: lun id
@@ -1486,20 +1488,22 @@ static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
  * This function waits for all outstanding commands to a lun to complete. It
  * returns 0 if all pending commands are returned and 1 otherwise.
  **/
-static int qla4xxx_eh_wait_for_active_target_commands(struct scsi_qla_host *ha,
-						 int t, int l)
+static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
+					struct scsi_target *stgt,
+					struct scsi_device *sdev)
 {
 	int cnt;
 	int status = 0;
 	struct scsi_cmnd *cmd;
 
 	/*
-	 * Waiting for all commands for the designated target in the active
-	 * array
+	 * Waiting for all commands for the designated target or dev
+	 * in the active array
 	 */
 	for (cnt = 0; cnt < ha->host->can_queue; cnt++) {
 		cmd = scsi_host_find_tag(ha->host, cnt);
-		if (cmd && cmd->device->id == t && cmd->device->lun == l) {
+		if (cmd && stgt == scsi_target(cmd->device) &&
+		    (!sdev || sdev == cmd->device)) {
 			if (!qla4xxx_eh_wait_on_command(ha, cmd)) {
 				status++;
 				break;
@@ -1547,19 +1551,12 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	/* Send marker. */
 	ha->marker_needed = 1;
 
-	/*
-	 * If we are coming down the EH path, wait for all commands to complete
-	 * for the device.
-	 */
-	if (cmd->device->host->shost_state == SHOST_RECOVERY) {
-		if (qla4xxx_eh_wait_for_active_target_commands(ha,
-							  cmd->device->id,
-							  cmd->device->lun)){
-			dev_info(&ha->pdev->dev,
-				   "DEVICE RESET FAILED - waiting for "
-				   "commands.\n");
-			goto eh_dev_reset_done;
-		}
+	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
+					 cmd->device)) {
+		dev_info(&ha->pdev->dev,
+			   "DEVICE RESET FAILED - waiting for "
+			   "commands.\n");
+		goto eh_dev_reset_done;
 	}
 
 	dev_info(&ha->pdev->dev,
@@ -1575,6 +1572,53 @@ eh_dev_reset_done:
 }
 
 /**
+ * qla4xxx_eh_target_reset - callback for target reset.
+ * @cmd: Pointer to Linux's SCSI command structure
+ *
+ * This routine is called by the Linux OS to reset the target.
+ **/
+static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
+{
+	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
+	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	int stat;
+
+	if (!ddb_entry)
+		return FAILED;
+
+	starget_printk(KERN_INFO, scsi_target(cmd->device),
+		       "WARM TARGET RESET ISSUED.\n");
+
+	DEBUG2(printk(KERN_INFO
+		      "scsi%ld: TARGET_DEVICE_RESET cmd=%p jiffies = 0x%lx, "
+		      "to=%x,dpc_flags=%lx, status=%x allowed=%d\n",
+		      ha->host_no, cmd, jiffies, cmd->timeout_per_command / HZ,
+		      ha->dpc_flags, cmd->result, cmd->allowed));
+
+	stat = qla4xxx_reset_target(ha, ddb_entry);
+	if (stat != QLA_SUCCESS) {
+		starget_printk(KERN_INFO, scsi_target(cmd->device),
+			       "WARM TARGET RESET FAILED.\n");
+		return FAILED;
+	}
+
+	/* Send marker. */
+	ha->marker_needed = 1;
+
+	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
+					 NULL)) {
+		starget_printk(KERN_INFO, scsi_target(cmd->device),
+			       "WARM TARGET DEVICE RESET FAILED - "
+			       "waiting for commands.\n");
+		return FAILED;
+	}
+
+	starget_printk(KERN_INFO, scsi_target(cmd->device),
+		       "WARM TARGET RESET SUCCEEDED.\n");
+	return SUCCESS;
+}
+
+/**
  * qla4xxx_eh_host_reset - kernel callback
  * @cmd: Pointer to Linux's SCSI command structure
  *
-- 
1.5.4.1

