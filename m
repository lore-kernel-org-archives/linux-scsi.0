From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH]qla4xxx:fix scsi command completion, lun reset and target
	reset code
Date: Wed, 19 Mar 2008 11:23:03 -0700
Message-ID: <1205950983.7334.18.camel@q-iscsi-upstream.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47709 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbYCST3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:29:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, david.somayajulu@qlogic.com

This patch contains the following:
1. when hba completion status is good, check for iscsi transport errors (underflow/overflow) prior to checking the scsi status
2. New firmware requires that one marker iocb be issued for each task management command. The patch issues marker iocb immediately following a LUN or Target reset.

Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
----
 drivers/scsi/qla4xxx/ql4_fw.h   |    3 +-
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +
 drivers/scsi/qla4xxx/ql4_iocb.c |   14 ++----------
 drivers/scsi/qla4xxx/ql4_isr.c  |   40 ++++----------------------------------
 drivers/scsi/qla4xxx/ql4_os.c   |   20 +++++++++++++-----
 5 files changed, 26 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index ed8ee66..1b667a7 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -678,7 +678,8 @@ struct qla4_marker_entry {
 	uint32_t system_defined; /* 04-07 */
 	uint16_t target;	/* 08-09 */
 	uint16_t modifier;	/* 0A-0B */
-#define MM_LUN_RESET	     0
+#define MM_LUN_RESET		0
+#define MM_TGT_WARM_RESET	1
 
 	uint16_t flags;		/* 0C-0D */
 	uint16_t reserved1;	/* 0E-0F */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index b403a17..96ebfb0 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -70,6 +70,8 @@ int qla4xxx_reinitialize_ddb_list(struct
 int qla4xxx_process_ddb_changed(struct scsi_qla_host * ha,
 				uint32_t fw_ddb_index, uint32_t state);
 void qla4xxx_dump_buffer(void *b, uint32_t size);
+int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
+	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index e4461b5..912a674 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -66,8 +66,8 @@ static int qla4xxx_get_req_pkt(struct sc
  *
  * This routine issues a marker IOCB.
  **/
-static int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
-				    struct ddb_entry *ddb_entry, int lun)
+int qla4xxx_send_marker_iocb(struct scsi_qla_host *ha,
+	struct ddb_entry *ddb_entry, int lun, uint16_t mrkr_mod)
 {
 	struct qla4_marker_entry *marker_entry;
 	unsigned long flags = 0;
@@ -87,7 +87,7 @@ static int qla4xxx_send_marker_iocb(stru
 	marker_entry->hdr.entryType = ET_MARKER;
 	marker_entry->hdr.entryCount = 1;
 	marker_entry->target = cpu_to_le16(ddb_entry->fw_ddb_index);
-	marker_entry->modifier = cpu_to_le16(MM_LUN_RESET);
+	marker_entry->modifier = cpu_to_le16(mrkr_mod);
 	int_to_scsilun(lun, &marker_entry->lun);
 	wmb();
 
@@ -210,14 +210,6 @@ int qla4xxx_send_command_to_isp(struct s
 	/* Get real lun and adapter */
 	ddb_entry = srb->ddb;
 
-	/* Send marker(s) if needed. */
-	if (ha->marker_needed == 1) {
-		if (qla4xxx_send_marker_iocb(ha, ddb_entry,
-					     cmd->device->lun) != QLA_SUCCESS)
-			return QLA_ERROR;
-
-		ha->marker_needed = 0;
-	}
 	tot_dsds = 0;
 
 	/* Acquire hardware specific lock */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index fc84db4..a91a57c 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -11,28 +11,6 @@
 #include "ql4_inline.h"
 
 /**
- * qla2x00_process_completed_request() - Process a Fast Post response.
- * @ha: SCSI driver HA context
- * @index: SRB index
- **/
-static void qla4xxx_process_completed_request(struct scsi_qla_host *ha,
-					      uint32_t index)
-{
-	struct srb *srb;
-
-	srb = qla4xxx_del_from_active_array(ha, index);
-	if (srb) {
-		/* Save ISP completion status */
-		srb->cmd->result = DID_OK << 16;
-		qla4xxx_srb_compl(ha, srb);
-	} else {
-		DEBUG2(printk("scsi%ld: Invalid ISP SCSI completion handle = "
-			      "%d\n", ha->host_no, index));
-		set_bit(DPC_RESET_HA, &ha->dpc_flags);
-	}
-}
-
-/**
  * qla4xxx_status_entry - processes status IOCBs
  * @ha: Pointer to host adapter structure.
  * @sts_entry: Pointer to status entry structure.
@@ -47,14 +25,6 @@ static void qla4xxx_status_entry(struct
 	uint32_t residual;
 	uint16_t sensebytecnt;
 
-	if (sts_entry->completionStatus == SCS_COMPLETE &&
-	    sts_entry->scsiStatus == 0) {
-		qla4xxx_process_completed_request(ha,
-						  le32_to_cpu(sts_entry->
-							      handle));
-		return;
-	}
-
 	srb = qla4xxx_del_from_active_array(ha, le32_to_cpu(sts_entry->handle));
 	if (!srb) {
 		/* FIXMEdg: Don't we need to reset ISP in this case??? */
@@ -62,6 +32,9 @@ static void qla4xxx_status_entry(struct
 			      "handle 0x%x, sp=%p. This cmd may have already "
 			      "been completed.\n", ha->host_no, __func__,
 			      le32_to_cpu(sts_entry->handle), srb));
+		dev_warn(&ha->pdev->dev, "%s invalid status entry:"
+			" handle=0x%0x\n", __func__, sts_entry->handle);
+		set_bit(DPC_RESET_HA, &ha->dpc_flags);
 		return;
 	}
 
@@ -88,10 +61,6 @@ static void qla4xxx_status_entry(struct
 	scsi_status = sts_entry->scsiStatus;
 	switch (sts_entry->completionStatus) {
 	case SCS_COMPLETE:
-		if (scsi_status == 0) {
-			cmd->result = DID_OK << 16;
-			break;
-		}
 
 		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
 			cmd->result = DID_ERROR << 16;
@@ -100,7 +69,8 @@ static void qla4xxx_status_entry(struct
 
 		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
 			scsi_set_resid(cmd, residual);
-			if ((scsi_bufflen(cmd) - residual) < cmd->underflow) {
+			if (!scsi_status && ((scsi_bufflen(cmd) - residual) <
+				cmd->underflow)) {
 
 				cmd->result = DID_ERROR << 16;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 31e605c..0c78694 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1552,9 +1552,6 @@ static int qla4xxx_eh_device_reset(struc
 		goto eh_dev_reset_done;
 	}
 
-	/* Send marker. */
-	ha->marker_needed = 1;
-
 	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
 					 cmd->device)) {
 		dev_info(&ha->pdev->dev,
@@ -1563,6 +1560,11 @@ static int qla4xxx_eh_device_reset(struc
 		goto eh_dev_reset_done;
 	}
 
+	/* Send marker. */
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
+		MM_LUN_RESET) != QLA_SUCCESS)
+		goto eh_dev_reset_done;
+
 	dev_info(&ha->pdev->dev,
 		   "scsi(%ld:%d:%d:%d): DEVICE RESET SUCCEEDED.\n",
 		   ha->host_no, cmd->device->channel, cmd->device->id,
@@ -1606,9 +1608,6 @@ static int qla4xxx_eh_target_reset(struc
 		return FAILED;
 	}
 
-	/* Send marker. */
-	ha->marker_needed = 1;
-
 	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
 					 NULL)) {
 		starget_printk(KERN_INFO, scsi_target(cmd->device),
@@ -1617,6 +1616,15 @@ static int qla4xxx_eh_target_reset(struc
 		return FAILED;
 	}
 
+	/* Send marker. */
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
+		MM_TGT_WARM_RESET) != QLA_SUCCESS) {
+		starget_printk(KERN_INFO, scsi_target(cmd->device),
+			       "WARM TARGET DEVICE RESET FAILED - "
+			       "marker iocb failed.\n");
+		return FAILED;
+	}
+
 	starget_printk(KERN_INFO, scsi_target(cmd->device),
 		       "WARM TARGET RESET SUCCEEDED.\n");
 	return SUCCESS;

