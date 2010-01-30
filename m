From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 10/11] qla4xxx: added support for abort task management
	command
Date: Fri, 29 Jan 2010 22:29:34 -0800
Message-ID: <20100130062934.GK10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9059 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0A3G1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:27:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Handles SCSI aborts.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h   |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |   45 ++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   |  147 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 194 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 835c95c..0274341 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -215,6 +215,7 @@ union external_hw_config_reg {
 /*  Mailbox command definitions */
 #define MBOX_CMD_ABOUT_FW			0x0009
 #define MBOX_CMD_PING				0x000B
+#define MBOX_CMD_ABORT_TASK			0x0015
 #define MBOX_CMD_LUN_RESET			0x0016
 #define MBOX_CMD_TARGET_WARM_RESET		0x0017
 #define MBOX_CMD_GET_MANAGEMENT_DATA		0x001E
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 4218c75..5aae45e 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -25,6 +25,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen);
 int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha);
 int qla4xxx_relogin_device(struct scsi_qla_host * ha,
 			   struct ddb_entry * ddb_entry);
+int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 		      int lun);
 int qla4xxx_reset_target(struct scsi_qla_host * ha,
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 8cb2dae..02b7b0d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -740,6 +740,51 @@ exit_get_event_log:
 }
 
 /**
+ * qla4xxx_abort_task - issues Abort Task
+ * @ha: Pointer to host adapter structure.
+ * @srb: Pointer to srb entry
+ *
+ * This routine performs a LUN RESET on the specified target/lun.
+ * The caller must ensure that the ddb_entry and lun_entry pointers
+ * are valid before calling this routine.
+ **/
+int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	struct scsi_cmnd *cmd = srb->cmd;
+	int status = QLA_SUCCESS;
+
+	DEBUG2(printk("scsi%ld:%d:%d:%d: abort task issued\n", ha->host_no,
+			cmd->device->channel, cmd->device->id, cmd->device->lun));
+
+	/*
+	 * Send abort task command to ISP, so that the ISP will return
+	 * request with ABORT status
+	 */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_ABORT_TASK;
+	mbox_cmd[1] = srb->fw_ddb_index;
+	mbox_cmd[2] = (unsigned long)(unsigned char *)cmd->host_scribble;
+	mbox_cmd[5] = 0x01;     /* Immediate Command Enable */
+
+	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]);
+	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE) {
+		status = QLA_ERROR;
+
+		DEBUG2(printk("scsi%ld:%d:%d:%d: abort task FAILED: ", ha->host_no,
+			cmd->device->channel, cmd->device->id, cmd->device->lun));
+		DEBUG2(printk("mbx0=%04X, mb1=%04X, mb2=%04X, mb3=%04X, mb4=%04X\n",
+			mbox_sts[0], mbox_sts[1], mbox_sts[2], mbox_sts[3],
+			mbox_sts[4]));
+	}
+
+	return status;
+}
+
+/**
  * qla4xxx_reset_lun - issues LUN Reset
  * @ha: Pointer to host adapter structure.
  * @db_entry: Pointer to device database entry
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b780d29..3d95061 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -73,6 +73,7 @@ static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
  */
 static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 				void (*done) (struct scsi_cmnd *));
+static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
@@ -87,6 +88,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.proc_name		= DRIVER_NAME,
 	.queuecommand		= qla4xxx_queuecommand,
 
+	.eh_abort_handler	= qla4xxx_eh_abort,
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
 	.eh_target_reset_handler = qla4xxx_eh_target_reset,
 	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
@@ -1611,6 +1613,151 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
 }
 
 /**
+ * qla4xxx_eh_abort - callback for abort task.
+ * @cmd: Pointer to Linux's SCSI command structure
+ *
+ * This routine is called by the Linux OS to abort the specified
+ * command.
+ **/
+static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
+{
+	struct scsi_qla_host *ha;
+	struct srb *srb = NULL;
+	struct ddb_entry *ddb_entry;
+	struct scsi_cmnd *srb_cmd = NULL;
+	int ret = SUCCESS;
+	unsigned int channel;
+	unsigned int id;
+	unsigned int lun;
+	unsigned long serial;
+	unsigned long flags = 0;
+	int i = 0;
+	int got_ref = 0;
+	unsigned long wait_online;
+
+	if (cmd == NULL) {
+		DEBUG2(printk("ABORT - **** SCSI mid-layer passing in NULL cmd\n"));
+		return SUCCESS;
+	}
+
+	ha = to_qla_host(cmd->device->host);
+	ddb_entry = cmd->device->hostdata;
+	channel = cmd->device->channel;
+	id = cmd->device->id;
+	lun = cmd->device->lun;
+	serial = cmd->serial_number;
+
+	if (!ddb_entry) {
+		DEBUG2(printk("scsi%ld: ABORT - NULL ddb entry.\n", ha->host_no));
+		return FAILED;
+	}
+
+	if (!cmd->SCp.ptr) {
+		DEBUG2(printk("scsi%ld: ABORT - cmd already completed.\n",
+			      ha->host_no));
+		return ret;
+	}
+
+
+
+	srb = (struct srb *) cmd->SCp.ptr;
+
+	dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: ABORT ISSUED "
+		 "cmd=%p, pid=%ld, ref=%d\n", ha->host_no, channel, id, lun,
+		 cmd, serial, atomic_read(&srb->ref_count));
+
+	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
+		DEBUG2(printk("scsi%ld:%d: %s: Unable to abort task. Adapter "
+				"DEAD.\n", ha->host_no, cmd->device->channel
+				, __func__));
+
+		return FAILED;
+	}
+
+	/* Check active list for command */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (i = 1; i < MAX_SRBS; i++) {
+		srb_cmd = scsi_host_find_tag(ha->host, i);
+		if (srb_cmd == NULL)
+			continue;
+
+		srb = (struct srb *)srb_cmd->host_scribble;
+		if (srb == NULL)
+			continue;
+
+		if (srb->cmd != cmd)
+			continue;
+
+		DEBUG2(printk("scsi%ld:%d:%d:%d %s: aborting srb %p from RISC. "
+			      "pid=%ld.\n", ha->host_no, channel, id, lun,
+			      __func__, srb, serial));
+		DEBUG3(qla4xxx_print_scsi_cmd(cmd));
+
+		/* Get a reference to the sp and drop the lock.*/
+		sp_get(srb);
+		got_ref++;
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		/*
+		 * If device is not online wait for 10 sec for device to come online,
+		 * else return error and do not issue abort task.
+		 */
+		if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+			wait_online = jiffies + (DEVICE_ONLINE_TOV * HZ);
+			while (time_before(jiffies, wait_online)) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(HZ);
+				if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
+					break;
+			}
+			if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+				DEBUG2(printk("scsi%ld:%d: %s: Unable to abort task."
+						"Device is not online.\n", ha->host_no
+						, cmd->device->channel, __func__));
+
+				return FAILED;
+			}
+		}
+
+		if (qla4xxx_abort_task(ha, srb) != QLA_SUCCESS) {
+			dev_info(&ha->pdev->dev,
+				"scsi%ld:%d:%d:%d: ABORT TASK - FAILED.\n",
+				ha->host_no, channel, id, lun);
+		} else {
+			dev_info(&ha->pdev->dev,
+				"scsi%ld:%d:%d:%d: ABORT TASK - mbx success.\n",
+				ha->host_no, channel, id, lun);
+		}
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		break;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Wait for command to complete */
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (qla4xxx_eh_wait_on_command(ha, cmd, got_ref)) {
+		dev_info(&ha->pdev->dev,
+			"scsi%ld:%d:%d:%d: ABORT SUCCEEDED - "
+			 "cmd returned back to OS.\n",
+			 ha->host_no, channel, id, lun);
+		ret = SUCCESS;
+	}
+
+	if (got_ref)
+		sp_put(ha, srb);
+
+	DEBUG2(printk("scsi%ld:%d:%d:%d: ABORT cmd=%p, pid=%ld, ref=%d, "
+		      "ret=%x\n", ha->host_no, channel, id, lun, cmd,
+		      serial, atomic_read(&srb->ref_count), ret));
+
+	return ret;
+}
+
+
+
+
+/**
  * qla4xxx_eh_device_reset - callback for target reset.
  * @cmd: Pointer to Linux's SCSI command structure
  *
-- 
1.6.0.2

