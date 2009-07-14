From: michaelc@cs.wisc.edu
Subject: [PATCH 2/6] qla4xxx: Correct Extended Sense Data Errors
Date: Mon, 13 Jul 2009 22:24:04 -0500
Message-ID: <1247541848-30412-2-git-send-email-michaelc@cs.wisc.edu>
References: <1247541848-30412-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38072 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZGNDYT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2009 23:24:19 -0400
In-Reply-To: <1247541848-30412-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Higgins <karen.higgins@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

Fixed sense data errors occurring above the first 32 bytes,
as required by some third party applications.  Sense data
in the first 32 bytes has always been correct.

Patch updated to use srb data variables instead of scsi command
scratchpad data area, as scratchpad area is already used.

Also, corrected debug print alignment bug in dump_buffer routine.
Changed KERN_DEBUG to KERN_INFO in printk statements in this routine.

Changed version number to 5.01.00-k9

Patch was made over scsi-rc-fixes.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
[michaelc: fixed checkpath.pl errors]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_dbg.c     |   15 ++--
 drivers/scsi/qla4xxx/ql4_def.h     |    7 ++
 drivers/scsi/qla4xxx/ql4_fw.h      |    7 ++
 drivers/scsi/qla4xxx/ql4_isr.c     |  145 +++++++++++++++++++++++++-----------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 5 files changed, 122 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index fcc184c..cbceb0e 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -15,19 +15,18 @@ void qla4xxx_dump_buffer(void *b, uint32_t size)
 	uint32_t cnt;
 	uint8_t *c = b;
 
-	printk(" 0   1	 2   3	 4   5	 6   7	 8   9	Ah  Bh	Ch  Dh	Eh  "
+	printk(" 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  "
 	       "Fh\n");
 	printk("------------------------------------------------------------"
 	       "--\n");
-	for (cnt = 0; cnt < size; cnt++, c++) {
-		printk(KERN_DEBUG "%02x", *c);
-		if (!(cnt % 16))
-			printk(KERN_DEBUG "\n");
+	for (cnt = 0; cnt < size; c++) {
+		printk(KERN_INFO "%02x", *c);
+		if (!(++cnt % 16))
+			printk(KERN_INFO "\n");
 
 		else
-			printk(KERN_DEBUG "  ");
+			printk(KERN_INFO "  ");
 	}
-	if (cnt % 16)
-		printk(KERN_DEBUG "\n");
+	printk(KERN_INFO "\n");
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b586f27..963e855 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -184,6 +184,11 @@ struct srb {
 	uint16_t cc_stat;
 	u_long r_start;		/* Time we recieve a cmd from OS */
 	u_long u_start;		/* Time when we handed the cmd to F/W */
+
+	/* Used for extended sense / status continuation */
+	uint8_t *req_sense_ptr;
+	uint16_t req_sense_len;
+	uint16_t reserved2;
 };
 
 /*
@@ -436,6 +441,8 @@ struct scsi_qla_host {
 	/* Map ddb_list entry by FW ddb index */
 	struct ddb_entry *fw_ddb_index_map[MAX_DDB_ENTRIES];
 
+	/* Saved srb for status continuation entry processing */
+	struct srb *status_srb;
 };
 
 static inline int is_qla4010(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 1b667a7..9cd7a60 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -572,6 +572,7 @@ struct conn_event_log_entry {
  *************************************************************************/
 #define IOCB_MAX_CDB_LEN	    16	/* Bytes in a CBD */
 #define IOCB_MAX_SENSEDATA_LEN	    32	/* Bytes of sense data */
+#define IOCB_MAX_EXT_SENSEDATA_LEN  60  /* Bytes of extended sense data */
 
 /* IOCB header structure */
 struct qla4_header {
@@ -733,6 +734,12 @@ struct status_entry {
 
 };
 
+/* Status Continuation entry */
+struct status_cont_entry {
+       struct qla4_header hdr; /* 00-03 */
+       uint8_t ext_sense_data[IOCB_MAX_EXT_SENSEDATA_LEN]; /* 04-63 */
+};
+
 struct passthru0 {
 	struct qla4_header hdr;		       /* 00-03 */
 	uint32_t handle;	/* 04-07 */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 799120f..8025ee1 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -11,6 +11,98 @@
 #include "ql4_inline.h"
 
 /**
+ * qla4xxx_copy_sense - copy sense data	into cmd sense buffer
+ * @ha: Pointer to host adapter structure.
+ * @sts_entry: Pointer to status entry structure.
+ * @srb: Pointer to srb structure.
+ **/
+static void qla4xxx_copy_sense(struct scsi_qla_host *ha,
+                               struct status_entry *sts_entry,
+                               struct srb *srb)
+{
+	struct scsi_cmnd *cmd = srb->cmd;
+	uint16_t sense_len;
+
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	sense_len = le16_to_cpu(sts_entry->senseDataByteCnt);
+	if (sense_len == 0)
+		return;
+
+	/* Save total available sense length,
+	 * not to exceed cmd's sense buffer size */
+	sense_len = min_t(uint16_t, sense_len, SCSI_SENSE_BUFFERSIZE);
+	srb->req_sense_ptr = cmd->sense_buffer;
+	srb->req_sense_len = sense_len;
+
+	/* Copy sense from sts_entry pkt */
+	sense_len = min_t(uint16_t, sense_len, IOCB_MAX_SENSEDATA_LEN);
+	memcpy(cmd->sense_buffer, sts_entry->senseData, sense_len);
+
+	DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: %s: sense key = %x, "
+		"ASL= %02x, ASC/ASCQ = %02x/%02x\n", ha->host_no,
+		cmd->device->channel, cmd->device->id,
+		cmd->device->lun, __func__,
+		sts_entry->senseData[2] & 0x0f,
+		sts_entry->senseData[7],
+		sts_entry->senseData[12],
+		sts_entry->senseData[13]));
+
+	DEBUG5(qla4xxx_dump_buffer(cmd->sense_buffer, sense_len));
+	srb->flags |= SRB_GOT_SENSE;
+
+	/* Update srb, in case a sts_cont pkt follows */
+	srb->req_sense_ptr += sense_len;
+	srb->req_sense_len -= sense_len;
+	if (srb->req_sense_len != 0)
+		ha->status_srb = srb;
+	else
+		ha->status_srb = NULL;
+}
+
+/**
+ * qla4xxx_status_cont_entry - Process a Status Continuations entry.
+ * @ha: SCSI driver HA context
+ * @sts_cont: Entry pointer
+ *
+ * Extended sense data.
+ */
+static void
+qla4xxx_status_cont_entry(struct scsi_qla_host *ha,
+			  struct status_cont_entry *sts_cont)
+{
+	struct srb *srb = ha->status_srb;
+	struct scsi_cmnd *cmd;
+	uint8_t sense_len;
+
+	if (srb == NULL)
+		return;
+
+	cmd = srb->cmd;
+	if (cmd == NULL) {
+		DEBUG2(printk(KERN_INFO "scsi%ld: %s: Cmd already returned "
+			"back to OS srb=%p srb->state:%d\n", ha->host_no,
+			__func__, srb, srb->state));
+		ha->status_srb = NULL;
+		return;
+	}
+
+	/* Copy sense data. */
+	sense_len = min_t(uint16_t, srb->req_sense_len,
+			  IOCB_MAX_EXT_SENSEDATA_LEN);
+	memcpy(srb->req_sense_ptr, sts_cont->ext_sense_data, sense_len);
+	DEBUG5(qla4xxx_dump_buffer(srb->req_sense_ptr, sense_len));
+
+	srb->req_sense_ptr += sense_len;
+	srb->req_sense_len -= sense_len;
+
+	/* Place command on done queue. */
+	if (srb->req_sense_len == 0) {
+		qla4xxx_srb_compl(ha, srb);
+		ha->status_srb = NULL;
+	}
+}
+
+/**
  * qla4xxx_status_entry - processes status IOCBs
  * @ha: Pointer to host adapter structure.
  * @sts_entry: Pointer to status entry structure.
@@ -23,7 +115,6 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	struct srb *srb;
 	struct ddb_entry *ddb_entry;
 	uint32_t residual;
-	uint16_t sensebytecnt;
 
 	srb = qla4xxx_del_from_active_array(ha, le32_to_cpu(sts_entry->handle));
 	if (!srb) {
@@ -92,24 +183,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			break;
 
 		/* Copy Sense Data into sense buffer. */
-		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
-		sensebytecnt = le16_to_cpu(sts_entry->senseDataByteCnt);
-		if (sensebytecnt == 0)
-			break;
-
-		memcpy(cmd->sense_buffer, sts_entry->senseData,
-		       min_t(uint16_t, sensebytecnt, SCSI_SENSE_BUFFERSIZE));
-
-		DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key = %x, "
-			      "ASC/ASCQ = %02x/%02x\n", ha->host_no,
-			      cmd->device->channel, cmd->device->id,
-			      cmd->device->lun, __func__,
-			      sts_entry->senseData[2] & 0x0f,
-			      sts_entry->senseData[12],
-			      sts_entry->senseData[13]));
-
-		srb->flags |= SRB_GOT_SENSE;
+		qla4xxx_copy_sense(ha, sts_entry, srb);
 		break;
 
 	case SCS_INCOMPLETE:
@@ -176,23 +250,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 				break;
 
 			/* Copy Sense Data into sense buffer. */
-			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-
-			sensebytecnt =
-				le16_to_cpu(sts_entry->senseDataByteCnt);
-			if (sensebytecnt == 0)
-				break;
-
-			memcpy(cmd->sense_buffer, sts_entry->senseData,
-			       min_t(uint16_t, sensebytecnt, SCSI_SENSE_BUFFERSIZE));
-
-			DEBUG2(printk("scsi%ld:%d:%d:%d: %s: sense key = %x, "
-				      "ASC/ASCQ = %02x/%02x\n", ha->host_no,
-				      cmd->device->channel, cmd->device->id,
-				      cmd->device->lun, __func__,
-				      sts_entry->senseData[2] & 0x0f,
-				      sts_entry->senseData[12],
-				      sts_entry->senseData[13]));
+			qla4xxx_copy_sense(ha, sts_entry, srb);
 		} else {
 			/*
 			 * If RISC reports underrun and target does not
@@ -268,9 +326,10 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 status_entry_exit:
 
-	/* complete the request */
+	/* complete the request, if not waiting for status_continuation pkt */
 	srb->cc_stat = sts_entry->completionStatus;
-	qla4xxx_srb_compl(ha, srb);
+	if (ha->status_srb == NULL)
+		qla4xxx_srb_compl(ha, srb);
 }
 
 /**
@@ -305,10 +364,7 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 		/* process entry */
 		switch (sts_entry->hdr.entryType) {
 		case ET_STATUS:
-			/*
-			 * Common status - Single completion posted in single
-			 * IOSB.
-			 */
+			/* Common status */
 			qla4xxx_status_entry(ha, sts_entry);
 			break;
 
@@ -316,9 +372,8 @@ static void qla4xxx_process_response_queue(struct scsi_qla_host * ha)
 			break;
 
 		case ET_STATUS_CONTINUATION:
-			/* Just throw away the status continuation entries */
-			DEBUG2(printk("scsi%ld: %s: Status Continuation entry "
-				      "- ignoring\n", ha->host_no, __func__));
+			qla4xxx_status_cont_entry(ha,
+				(struct status_cont_entry *) sts_entry);
 			break;
 
 		case ET_COMMAND:
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index ab984cb..6980cb2 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,5 +5,5 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.01.00-k8"
+#define QLA4XXX_DRIVER_VERSION	"5.01.00-k9"
 
-- 
1.6.2.2

