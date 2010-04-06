From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 09/12] qla4xxx: added srb reference counter
Date: Tue, 6 Apr 2010 03:14:32 -0700
Message-ID: <20100406101432.GP22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27616 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0DFKQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:16:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Serialization srb between error handler and command completion path.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c  |    6 ++--
 drivers/scsi/qla4xxx/ql4_os.c   |   50 +++++++++++++++++++++++---------------
 4 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index af339be..8ff06f0 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -171,7 +171,7 @@ struct srb {
 
 	struct scsi_cmnd *cmd;	/* (4) SCSI command block */
 	dma_addr_t dma_handle;	/* (4) for unmap of single transfers */
-	atomic_t ref_count;	/* reference count for this srb */
+	struct kref srb_ref;	/* reference count for this srb */
 	uint32_t fw_ddb_index;
 	uint8_t err_id;		/* error id */
 #define SRB_ERR_PORT	   1	/* Request failed because "port down" */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 3c8f753..c4636f6 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -66,7 +66,7 @@ void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
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
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2ca5659..720f9dc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -385,7 +385,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 	if (!srb)
 		return srb;
 
-	atomic_set(&srb->ref_count, 1);
+	kref_init(&srb->srb_ref);
 	srb->ha = ha;
 	srb->ddb = ddb_entry;
 	srb->cmd = cmd;
@@ -407,9 +407,11 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_host *ha, struct srb *srb)
 	cmd->SCp.ptr = NULL;
 }
 
-void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb)
+void qla4xxx_srb_compl(struct kref *ref)
 {
+	struct srb *srb = container_of(ref, struct srb, srb_ref);
 	struct scsi_cmnd *cmd = srb->cmd;
+	struct scsi_qla_host *ha = srb->ha;
 
 	qla4xxx_srb_free_dma(ha, srb);
 
@@ -888,7 +890,7 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
 		srb = qla4xxx_del_from_active_array(ha, i);
 		if (srb != NULL) {
 			srb->cmd->result = DID_RESET << 16;
-			qla4xxx_srb_compl(ha, srb);
+			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1497,7 +1499,7 @@ struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t in
 
 /**
  * qla4xxx_eh_wait_on_command - waits for command to be returned by firmware
- * @ha: actual ha whose done queue will contain the comd returned by firmware.
+ * @ha: Pointer to host adapter structure.
  * @cmd: Scsi Command to wait on.
  *
  * This routine waits for the command to be returned by the Firmware
@@ -1507,17 +1509,14 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
 				      struct scsi_cmnd *cmd)
 {
 	int done = 0;
-	struct srb *rp;
 	uint32_t max_wait_time = EH_WAIT_CMD_TOV;
 
 	do {
 		/* Checking to see if its returned to OS */
-		rp = (struct srb *) cmd->SCp.ptr;
-		if (rp == NULL) {
+		if (cmd->host_scribble == NULL) {
 			done++;
 			break;
 		}
-
 		msleep(2000);
 	} while (max_wait_time--);
 
@@ -1630,7 +1629,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: ABORT ISSUED "
 		 "cmd=%p, pid=%ld, ref=%d\n", ha->host_no, channel, id, lun,
-		 cmd, serial, atomic_read(&srb->ref_count));
+		 cmd, serial, atomic_read(&srb->srb_ref.refcount));
 
 	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk(KERN_WARNING "scsi%ld:%d: %s: Unable to abort "
@@ -1658,6 +1657,8 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 				id, lun, __func__, srb, serial));
 		DEBUG3(qla4xxx_print_scsi_cmd(cmd));
 
+		kref_get(&srb->srb_ref);
+
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		if (qla4xxx_abort_task(ha, srb) != QLA_SUCCESS) {
@@ -1674,18 +1675,27 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	/* Wait for command to complete */
-	if (qla4xxx_eh_wait_on_command(ha, cmd)) {
-		dev_info(&ha->pdev->dev,
-			 "scsi%ld:%d:%d:%d: ABORT SUCCEEDED - "
-			 "cmd returned back to OS.\n",
-			 ha->host_no, channel, id, lun);
-		ret = SUCCESS;
-	}
 
-	DEBUG2(printk("scsi%ld:%d:%d:%d: ABORT cmd=%p, pid=%ld, ref=%d, "
-		      "ret=%x\n", ha->host_no, channel, id, lun, cmd,
-		      serial, atomic_read(&srb->ref_count), ret));
+	if (i < MAX_SRBS) {
+		/* Wait for command to complete */
+		if (qla4xxx_eh_wait_on_command(ha, cmd)) {
+			dev_info(&ha->pdev->dev,
+			    "scsi%ld:%d:%d:%d: ABORT SUCCEEDED - "
+			    "cmd returned back to OS.\n",
+			    ha->host_no, channel, id, lun);
+			ret = SUCCESS;
+		}
+
+		DEBUG2(printk("scsi%ld:%d:%d:%d: ABORT cmd=%p, pid=%ld, ref=%d, "
+		    "ret=%x\n", ha->host_no, channel, id, lun, cmd,
+		    serial, atomic_read(&srb->srb_ref.refcount), ret));
+
+		kref_put(&srb->srb_ref, qla4xxx_srb_compl);
+	} else {
+		dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: ABORT FAILED",
+		    ha->host_no, channel, id, lun);
+		ret = FAILED;
+	}
 
 	return ret;
 }
-- 
1.6.0.2

----- End forwarded message -----
