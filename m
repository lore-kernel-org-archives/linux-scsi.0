From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/11] qla4xxx: added support for abort task management
	command
Date: Wed, 28 Apr 2010 11:42:24 +0530
Message-ID: <20100428061224.GA11173@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:9587
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750918Ab0D1GQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:16:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

* Handles SCSI command aborts.
* Serialization srb between error handler and command
  completion path.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_fw.h   |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    3 +-
 drivers/scsi/qla4xxx/ql4_isr.c  |    6 ++--
 drivers/scsi/qla4xxx/ql4_mbx.c  |   53 ++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   |   68 ++++++++++++++++++++++++++++++++++++--
 6 files changed, 124 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b6f2d01..4288026 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -172,7 +172,7 @@ struct srb {
 
 	struct scsi_cmnd *cmd;	/* (4) SCSI command block */
 	dma_addr_t dma_handle;	/* (4) for unmap of single transfers */
-	atomic_t ref_count;	/* reference count for this srb */
+	struct kref srb_ref;	/* reference count for this srb */
 	uint32_t fw_ddb_index;
 	uint8_t err_id;		/* error id */
 #define SRB_ERR_PORT	   1	/* Request failed because "port down" */
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index dfe7b4d..855226e 100644
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
index 987658f..c4636f6 100644
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
@@ -65,7 +66,7 @@ void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
 int qla4xxx_init_rings(struct scsi_qla_host * ha);
 struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
 					uint32_t index);
-void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb);
+void qla4xxx_srb_compl(struct kref *ref);
 int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
 int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		uint32_t state, uint32_t conn_error);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index ce5838e..596c303 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -97,7 +97,7 @@ qla4xxx_status_cont_entry(struct scsi_qla_host *ha,
 
 	/* Place command on done queue. */
 	if (srb->req_sense_len == 0) {
-		qla4xxx_srb_compl(ha, srb);
+		kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 		ha->status_srb = NULL;
 	}
 }
@@ -329,7 +329,7 @@ status_entry_exit:
 	/* complete the request, if not waiting for status_continuation pkt */
 	srb->cc_stat = sts_entry->completionStatus;
 	if (ha->status_srb == NULL)
-		qla4xxx_srb_compl(ha, srb);
+		kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 }
 
 /**
@@ -393,7 +393,7 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 			/* ETRY normally by sending it back with
 			 * DID_BUS_BUSY */
 			srb->cmd->result = DID_BUS_BUSY << 16;
-			qla4xxx_srb_compl(ha, srb);
+			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 			break;
 
 		case ET_CONTINUE:
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 43581ce..e1315cd 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -762,6 +762,59 @@ exit_get_event_log:
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
+	unsigned long flags = 0;
+	uint32_t index;
+
+	/*
+	 * Send abort task command to ISP, so that the ISP will return
+	 * request with ABORT status
+	 */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	index = (unsigned long)(unsigned char *)cmd->host_scribble;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	/* Firmware already posted completion on response queue */
+	if (index == MAX_SRBS)
+		return status;
+
+	mbox_cmd[0] = MBOX_CMD_ABORT_TASK;
+	mbox_cmd[1] = srb->fw_ddb_index;
+	mbox_cmd[2] = index;
+	/* Immediate Command Enable */
+	mbox_cmd[5] = 0x01;
+
+	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0],
+	    &mbox_sts[0]);
+	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE) {
+		status = QLA_ERROR;
+
+		DEBUG2(printk(KERN_WARNING "scsi%ld:%d:%d: abort task FAILED: "
+		    "mbx0=%04X, mb1=%04X, mb2=%04X, mb3=%04X, mb4=%04X\n",
+		    ha->host_no, cmd->device->id, cmd->device->lun, mbox_sts[0],
+		    mbox_sts[1], mbox_sts[2], mbox_sts[3], mbox_sts[4]));
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
index 0dd9578..6e72162 100644
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
@@ -383,7 +385,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 	if (!srb)
 		return srb;
 
-	atomic_set(&srb->ref_count, 1);
+	kref_init(&srb->srb_ref);
 	srb->ha = ha;
 	srb->ddb = ddb_entry;
 	srb->cmd = cmd;
@@ -405,9 +407,11 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_host *ha, struct srb *srb)
 	CMD_SP(cmd) = NULL;
 }
 
-void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb)
+void qla4xxx_srb_compl(struct kref *ref)
 {
+	struct srb *srb = container_of(ref, struct srb, srb_ref);
 	struct scsi_cmnd *cmd = srb->cmd;
+	struct scsi_qla_host *ha = srb->ha;
 
 	qla4xxx_srb_free_dma(ha, srb);
 
@@ -886,7 +890,7 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
 		srb = qla4xxx_del_from_active_array(ha, i);
 		if (srb != NULL) {
 			srb->cmd->result = DID_RESET << 16;
-			qla4xxx_srb_compl(ha, srb);
+			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1500,7 +1504,7 @@ struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t in
 
 /**
  * qla4xxx_eh_wait_on_command - waits for command to be returned by firmware
- * @ha: actual ha whose done queue will contain the comd returned by firmware.
+ * @ha: Pointer to host adapter structure.
  * @cmd: Scsi Command to wait on.
  *
  * This routine waits for the command to be returned by the Firmware
@@ -1584,6 +1588,62 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
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
+	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
+	unsigned int id = cmd->device->id;
+	unsigned int lun = cmd->device->lun;
+	unsigned long serial = cmd->serial_number;
+	struct srb *srb = NULL;
+	int ret = SUCCESS;
+	int wait = 0;
+
+	dev_info(&ha->pdev->dev,
+	    "scsi%ld:%d:%d: Abort command issued cmd=%p, pid=%ld\n",
+	    ha->host_no, id, lun, cmd, serial);
+
+	srb = (struct srb *) CMD_SP(cmd);
+
+	if (!srb)
+		return SUCCESS;
+
+	kref_get(&srb->srb_ref);
+
+	if (qla4xxx_abort_task(ha, srb) != QLA_SUCCESS) {
+		DEBUG3(printk("scsi%ld:%d:%d: Abort_task mbx failed.\n",
+		    ha->host_no, id, lun));
+		ret = FAILED;
+	} else {
+		DEBUG3(printk("scsi%ld:%d:%d: Abort_task mbx success.\n",
+		    ha->host_no, id, lun));
+		wait = 1;
+	}
+
+	kref_put(&srb->srb_ref, qla4xxx_srb_compl);
+
+	/* Wait for command to complete */
+	if (wait) {
+		if (!qla4xxx_eh_wait_on_command(ha, cmd)) {
+			DEBUG2(printk("scsi%ld:%d:%d: Abort handler timed out\n",
+			    ha->host_no, id, lun));
+			ret = FAILED;
+		}
+	}
+
+	dev_info(&ha->pdev->dev,
+	    "scsi%ld:%d:%d: Abort command - %s\n",
+	    ha->host_no, id, lun, (ret == SUCCESS) ? "succeded" : "failed");
+
+	return ret;
+}
+
+/**
  * qla4xxx_eh_device_reset - callback for target reset.
  * @cmd: Pointer to Linux's SCSI command structure
  *
-- 
1.7.0.5

