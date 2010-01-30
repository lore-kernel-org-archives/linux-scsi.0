From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Fri, 29 Jan 2010 22:28:56 -0800
Message-ID: <20100130062856.GG10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9016 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0A3G1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:27:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Serialization between the error handler and recovery code.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +
 drivers/scsi/qla4xxx/ql4_isr.c  |    6 ++--
 drivers/scsi/qla4xxx/ql4_os.c   |   58 +++++++++++++++++++++++++++++++++++----
 3 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 96ebfb0..6400714 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -73,6 +73,8 @@ void qla4xxx_dump_buffer(void *b, uint32_t size);
 int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
 	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
 
+void sp_put(struct scsi_qla_host *ha, struct srb *sp);
+
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 36e6e85..21c4d02 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -97,7 +97,7 @@ qla4xxx_status_cont_entry(struct scsi_qla_host *ha,
 
 	/* Place command on done queue. */
 	if (srb->req_sense_len == 0) {
-		qla4xxx_srb_compl(ha, srb);
+		sp_put(ha, srb);
 		ha->status_srb = NULL;
 	}
 }
@@ -329,7 +329,7 @@ status_entry_exit:
 	/* complete the request, if not waiting for status_continuation pkt */
 	srb->cc_stat = sts_entry->completionStatus;
 	if (ha->status_srb == NULL)
-		qla4xxx_srb_compl(ha, srb);
+		sp_put(ha, srb);
 }
 
 /**
@@ -393,7 +393,7 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 			/* ETRY normally by sending it back with
 			 * DID_BUS_BUSY */
 			srb->cmd->result = DID_BUS_BUSY << 16;
-			qla4xxx_srb_compl(ha, srb);
+			sp_put(ha, srb);
 			break;
 
 		case ET_CONTINUE:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 97d35fd..9057860 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -372,6 +372,16 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
 }
 
+/***
+ * qla4xxx_get_new_srb - Allocate memory for a local srb.
+ * @ha: Pointer to host adapter structure.
+ * @ddb_entry: Pointer to device database entry
+ * @cmd: Pointer to Linux's SCSI command structure
+ * @done: Pointer to Linux's SCSI mid-layer done function
+ *
+ * NOTE: Sets te ref_count for non-NULL srb to one,
+ *       and initializes some fields.
+ **/
 static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 				       struct ddb_entry *ddb_entry,
 				       struct scsi_cmnd *cmd,
@@ -417,6 +427,33 @@ void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb)
 }
 
 /**
+ * sp_put - Decrement reference count and call callback.
+ * @ha: Pointer to host adapter structure.
+ * @sp: Pointer to srb structure
+ **/
+void sp_put(struct scsi_qla_host *ha, struct srb *sp)
+{
+	if (atomic_read(&sp->ref_count) == 0) {
+		DEBUG2(printk("%s: SP->ref_count ZERO\n", __func__));
+		DEBUG2(BUG());
+		return;
+	}
+	if (!atomic_dec_and_test(&sp->ref_count)) {
+		return;
+	}
+	qla4xxx_srb_compl(ha, sp);
+}
+
+/**
+ * sp_get - Increment reference count of the specified sp.
+ * @sp: Pointer to srb structure
+ **/
+void sp_get(struct srb *sp)
+{
+	atomic_inc(&sp->ref_count);
+}
+
+/**
  * qla4xxx_queuecommand - scsi layer issues scsi command to driver.
  * @cmd: Pointer to Linux's SCSI command structure
  * @done_fn: Function that the driver calls to notify the SCSI mid-layer
@@ -886,7 +923,7 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
 		srb = qla4xxx_del_from_active_array(ha, i);
 		if (srb != NULL) {
 			srb->cmd->result = DID_RESET << 16;
-			qla4xxx_srb_compl(ha, srb);
+			sp_put(ha, srb);
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1462,16 +1499,20 @@ struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t in
  * qla4xxx_eh_wait_on_command - waits for command to be returned by firmware
  * @ha: actual ha whose done queue will contain the comd returned by firmware.
  * @cmd: Scsi Command to wait on.
+ * @got_ref: Additional reference retrieved by caller.
  *
  * This routine waits for the command to be returned by the Firmware
  * for some max time.
  **/
 static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
-				      struct scsi_cmnd *cmd)
+				      struct scsi_cmnd *cmd, int got_ref)
 {
+#define ABORT_POLLING_PERIOD	1000
+#define ABORT_WAIT_ITER		1
+
 	int done = 0;
 	struct srb *rp;
-	uint32_t max_wait_time = EH_WAIT_CMD_TOV;
+	unsigned long wait_iter = ABORT_WAIT_ITER;
 
 	do {
 		/* Checking to see if its returned to OS */
@@ -1481,8 +1522,13 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
 			break;
 		}
 
-		msleep(2000);
-	} while (max_wait_time--);
+		if (got_ref && (atomic_read(&rp->ref_count) == 1)) {
+			done++;
+			break;
+		}
+
+		msleep(ABORT_POLLING_PERIOD);
+	} while (!(--wait_iter));
 
 	return done;
 }
@@ -1534,7 +1580,7 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
 		cmd = scsi_host_find_tag(ha->host, cnt);
 		if (cmd && stgt == scsi_target(cmd->device) &&
 		    (!sdev || sdev == cmd->device)) {
-			if (!qla4xxx_eh_wait_on_command(ha, cmd)) {
+			if (!qla4xxx_eh_wait_on_command(ha, cmd, 0)) {
 				status++;
 				break;
 			}
-- 
1.6.0.2

