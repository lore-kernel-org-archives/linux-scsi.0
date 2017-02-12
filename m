From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 04/16] lpfc: refactor debugfs queue prints
Date: Sun, 12 Feb 2017 13:52:28 -0800
Message-ID: <58a0d91c.FMlII2L+0d4RFlSj%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35716 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdBLVwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:31 -0500
Received: by mail-ot0-f193.google.com with SMTP id 65so9206471otq.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


Create common wq, cq, eq, rq print functions

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |   1 +
 drivers/scsi/lpfc/lpfc_debugfs.c | 564 ++++++++++++++++-----------------------
 2 files changed, 228 insertions(+), 337 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 64022d7..8e0d6f4 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -948,6 +948,7 @@ struct lpfc_hba {
 	struct dentry *idiag_ctl_acc;
 	struct dentry *idiag_mbx_acc;
 	struct dentry *idiag_ext_acc;
+	uint8_t lpfc_idiag_last_eq;
 #endif
 
 	/* Used for deferred freeing of ELS data buffers */
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 0b99bdf..4b00809 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1972,6 +1972,155 @@ lpfc_idiag_baracc_write(struct file *file, const char __user *buf,
 	return -EINVAL;
 }
 
+static int
+__lpfc_idiag_print_wq(struct lpfc_queue *qp, char *wqtype,
+			char *pbuffer, int len)
+{
+	if (!qp)
+		return len;
+
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\t\t%s WQ info: ", wqtype);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"AssocCQID[%04d]: WQ-STAT[oflow:x%x posted:x%llx]\n",
+			qp->assoc_qid, qp->q_cnt_1,
+			(unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\t\tWQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id, qp->entry_count,
+			qp->entry_size, qp->host_index,
+			qp->hba_index);
+	len +=  snprintf(pbuffer + len,
+			LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
+	return len;
+}
+
+static int
+lpfc_idiag_wqs_for_cq(struct lpfc_hba *phba, char *wqtype, char *pbuffer,
+		int *len, int max_cnt, int cq_id)
+{
+	struct lpfc_queue *qp;
+	int qidx;
+
+	for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++) {
+		qp = phba->sli4_hba.fcp_wq[qidx];
+		if (qp->assoc_qid != cq_id)
+			continue;
+		*len = __lpfc_idiag_print_wq(qp, wqtype, pbuffer, *len);
+		if (*len >= max_cnt)
+			return 1;
+	}
+	return 0;
+}
+
+static int
+__lpfc_idiag_print_cq(struct lpfc_queue *qp, char *cqtype,
+			char *pbuffer, int len)
+{
+	if (!qp)
+		return len;
+
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\t%s CQ info: ", cqtype);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"AssocEQID[%02d]: CQ STAT[max:x%x relw:x%x "
+			"xabt:x%x wq:x%llx]\n",
+			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
+			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\tCQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id, qp->entry_count,
+			qp->entry_size, qp->host_index,
+			qp->hba_index);
+
+	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
+
+	return len;
+}
+
+static int
+__lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
+			char *rqtype, char *pbuffer, int len)
+{
+	if (!qp || !datqp)
+		return len;
+
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\t\t%s RQ info: ", rqtype);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"AssocCQID[%02d]: RQ-STAT[nopost:x%x nobuf:x%x "
+			"trunc:x%x rcv:x%llx]\n",
+			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
+			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\t\tHQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			qp->queue_id, qp->entry_count, qp->entry_size,
+			qp->host_index, qp->hba_index);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\t\tDQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			datqp->queue_id, datqp->entry_count,
+			datqp->entry_size, datqp->host_index,
+			datqp->hba_index);
+	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
+
+	return len;
+}
+
+static int
+lpfc_idiag_cqs_for_eq(struct lpfc_hba *phba, char *pbuffer,
+		int *len, int max_cnt, int eq_id)
+{
+	struct lpfc_queue *qp;
+	int qidx, rc;
+
+	for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++) {
+		qp = phba->sli4_hba.fcp_cq[qidx];
+		if (qp->assoc_qid != eq_id)
+			continue;
+
+		*len = __lpfc_idiag_print_cq(qp, "FCP", pbuffer, *len);
+
+		/* Reset max counter */
+		qp->CQ_max_cqe = 0;
+
+		if (*len >= max_cnt)
+			return 1;
+
+		rc = lpfc_idiag_wqs_for_cq(phba, "FCP", pbuffer, len,
+				max_cnt, qp->queue_id);
+		if (rc)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int
+__lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
+			char *pbuffer, int len)
+{
+	if (!qp)
+		return len;
+
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\n%s EQ info: EQ-STAT[max:x%x noE:x%x "
+			"bs:x%x proc:x%llx]\n",
+			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
+			(unsigned long long)qp->q_cnt_4);
+	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"EQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
+			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			qp->queue_id, qp->entry_count, qp->entry_size,
+			qp->host_index, qp->hba_index);
+	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
+
+	return len;
+}
+
 /**
  * lpfc_idiag_queinfo_read - idiag debugfs read queue information
  * @file: The file pointer to read from.
@@ -1982,6 +2131,9 @@ lpfc_idiag_baracc_write(struct file *file, const char __user *buf,
  * Description:
  * This routine reads data from the @phba SLI4 PCI function queue information,
  * and copies to user @buf.
+ * This routine only returns 1 EQs worth of information. It remembers the last
+ * EQ read and jumps to the next EQ. Thus subsequent calls to queInfo will
+ * retrieve all EQs allocated for the phba.
  *
  * Returns:
  * This function returns the amount of data that was read (this could be less
@@ -1993,19 +2145,16 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 {
 	struct lpfc_debug *debug = file->private_data;
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
-	int len = 0;
 	char *pbuffer;
-	int x, cnt;
-	int max_cnt;
+	int max_cnt, rc, x, len = 0;
 	struct lpfc_queue *qp = NULL;
 
-
 	if (!debug->buffer)
 		debug->buffer = kmalloc(LPFC_QUE_INFO_GET_BUF_SIZE, GFP_KERNEL);
 	if (!debug->buffer)
 		return 0;
 	pbuffer = debug->buffer;
-	max_cnt = LPFC_QUE_INFO_GET_BUF_SIZE - 128;
+	max_cnt = LPFC_QUE_INFO_GET_BUF_SIZE - 256;
 
 	if (*ppos)
 		return 0;
@@ -2014,374 +2163,115 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 
 	/* Fast-path event queue */
 	if (phba->sli4_hba.hba_eq && phba->cfg_fcp_io_channel) {
-		cnt = phba->cfg_fcp_io_channel;
 
-		for (x = 0; x < cnt; x++) {
+		x = phba->lpfc_idiag_last_eq;
+		if (phba->cfg_fof && (x >= phba->cfg_fcp_io_channel)) {
+			phba->lpfc_idiag_last_eq = 0;
+			goto fof;
+		}
+		phba->lpfc_idiag_last_eq++;
+		if (phba->lpfc_idiag_last_eq >= phba->cfg_fcp_io_channel)
+			if (phba->cfg_fof == 0)
+				phba->lpfc_idiag_last_eq = 0;
 
-			/* Fast-path EQ */
-			qp = phba->sli4_hba.hba_eq[x];
-			if (!qp)
-				goto proc_cq;
+		len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+					"EQ %d out of %d HBA EQs\n",
+					x, phba->cfg_fcp_io_channel);
 
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\nHBA EQ info: "
-				"EQ-STAT[max:x%x noE:x%x "
-				"bs:x%x proc:x%llx]\n",
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"EQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
-				qp->hba_index);
-
-
-			/* Reset max counter */
-			qp->EQ_max_eqe = 0;
+		/* Fast-path EQ */
+		qp = phba->sli4_hba.hba_eq[x];
+		if (!qp)
+			goto out;
 
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-proc_cq:
-			/* Fast-path FCP CQ */
-			qp = phba->sli4_hba.fcp_cq[x];
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tFCP CQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocEQID[%02d]: "
-				"CQ STAT[max:x%x relw:x%x "
-				"xabt:x%x wq:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tCQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id, qp->entry_count,
-				qp->entry_size, qp->host_index,
-				qp->hba_index);
+		len = __lpfc_idiag_print_eq(qp, "HBA", pbuffer, len);
 
+		/* Reset max counter */
+		qp->EQ_max_eqe = 0;
 
-			/* Reset max counter */
-			qp->CQ_max_cqe = 0;
+		if (len >= max_cnt)
+			goto too_big;
 
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
+		rc = lpfc_idiag_cqs_for_eq(phba, pbuffer, &len,
+			max_cnt, qp->queue_id);
+		if (rc)
+			goto too_big;
 
-			/* Fast-path FCP WQ */
-			qp = phba->sli4_hba.fcp_wq[x];
+		/* Only EQ 0 has slow path CQs configured */
+		if (x)
+			goto out;
 
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tFCP WQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocCQID[%02d]: "
-				"WQ-STAT[oflow:x%x posted:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tWQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
-				qp->hba_index);
-
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-
-			if (x)
-				continue;
-
-			/* Only EQ 0 has slow path CQs configured */
-
-			/* Slow-path mailbox CQ */
-			qp = phba->sli4_hba.mbx_cq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tMBX CQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocEQID[%02d]: "
-					"CQ-STAT[mbox:x%x relw:x%x "
-					"xabt:x%x wq:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tCQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+		/* Slow-path mailbox CQ */
+		qp = phba->sli4_hba.mbx_cq;
+		len = __lpfc_idiag_print_cq(qp, "MBX", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
 
-			/* Slow-path MBOX MQ */
-			qp = phba->sli4_hba.mbx_wq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tMBX MQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocCQID[%02d]:\n",
-					phba->sli4_hba.mbx_wq->assoc_qid);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tWQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+		/* Slow-path MBOX MQ */
+		qp = phba->sli4_hba.mbx_wq;
+		len = __lpfc_idiag_print_wq(qp, "MBX", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
 
-			/* Slow-path ELS response CQ */
-			qp = phba->sli4_hba.els_cq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tELS CQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocEQID[%02d]: "
-					"CQ-STAT[max:x%x relw:x%x "
-					"xabt:x%x wq:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\tCQID [%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				/* Reset max counter */
-				qp->CQ_max_cqe = 0;
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+		/* Slow-path ELS response CQ */
+		qp = phba->sli4_hba.els_cq;
+		len = __lpfc_idiag_print_cq(qp, "ELS", pbuffer, len);
+		/* Reset max counter */
+		if (qp)
+			qp->CQ_max_cqe = 0;
+		if (len >= max_cnt)
+			goto too_big;
 
-			/* Slow-path ELS WQ */
-			qp = phba->sli4_hba.els_wq;
-			if (qp) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tELS WQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocCQID[%02d]: "
-					" WQ-STAT[oflow:x%x "
-					"posted:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tWQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]",
-					qp->queue_id, qp->entry_count,
-					qp->entry_size, qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-				if (len >= max_cnt)
-					goto too_big;
-			}
+		/* Slow-path ELS WQ */
+		qp = phba->sli4_hba.els_wq;
+		len = __lpfc_idiag_print_wq(qp, "ELS", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
 
-			if (phba->sli4_hba.hdr_rq && phba->sli4_hba.dat_rq) {
-				/* Slow-path RQ header */
-				qp = phba->sli4_hba.hdr_rq;
+		qp = phba->sli4_hba.hdr_rq;
+		len = __lpfc_idiag_print_rqpair(qp, phba->sli4_hba.dat_rq,
+				"RQpair", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
 
-				len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tRQ info: ");
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"AssocCQID[%02d]: "
-					"RQ-STAT[nopost:x%x nobuf:x%x "
-					"trunc:x%x rcv:x%llx]\n",
-					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3,
-					(unsigned long long)qp->q_cnt_4);
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tHQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
-					qp->queue_id,
-					qp->entry_count,
-					qp->entry_size,
-					qp->host_index,
-					qp->hba_index);
-
-				/* Slow-path RQ data */
-				qp = phba->sli4_hba.dat_rq;
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-					"\t\tDQID[%02d], "
-					"QE-CNT[%04d], QE-SIZE[%04d], "
-					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
-					qp->queue_id,
-					qp->entry_count,
-					qp->entry_size,
-					qp->host_index,
-					qp->hba_index);
-
-				len +=  snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			}
-		}
+		goto out;
 	}
 
+fof:
 	if (phba->cfg_fof) {
 		/* FOF EQ */
 		qp = phba->sli4_hba.fof_eq;
-		if (!qp)
-			goto out;
-
-		len += snprintf(pbuffer+len,
-			LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\nFOF EQ info: "
-			"EQ-STAT[max:x%x noE:x%x "
-			"bs:x%x proc:x%llx]\n",
-			qp->q_cnt_1, qp->q_cnt_2,
-			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-
-		len += snprintf(pbuffer+len,
-			LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"EQID[%02d], "
-			"QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
-			qp->queue_id,
-			qp->entry_count,
-			qp->entry_size,
-			qp->host_index,
-			qp->hba_index);
+		len = __lpfc_idiag_print_eq(qp, "FOF", pbuffer, len);
 
 		/* Reset max counter */
-		qp->EQ_max_eqe = 0;
+		if (qp)
+			qp->EQ_max_eqe = 0;
 
-		len +=  snprintf(pbuffer+len,
-			LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 		if (len >= max_cnt)
 			goto too_big;
-	}
-
-	if (phba->cfg_fof) {
 
 		/* OAS CQ */
 		qp = phba->sli4_hba.oas_cq;
-		if (qp) {
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tOAS CQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocEQID[%02d]: "
-				"CQ STAT[max:x%x relw:x%x "
-				"xabt:x%x wq:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tCQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id, qp->entry_count,
-				qp->entry_size, qp->host_index,
-				qp->hba_index);
-
-			/* Reset max counter */
+		len = __lpfc_idiag_print_cq(qp, "OAS", pbuffer, len);
+		/* Reset max counter */
+		if (qp)
 			qp->CQ_max_cqe = 0;
-
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-		}
+		if (len >= max_cnt)
+			goto too_big;
 
 		/* OAS WQ */
 		qp = phba->sli4_hba.oas_wq;
-		if (qp) {
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tOAS WQ info: ");
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"AssocCQID[%02d]: "
-				"WQ-STAT[oflow:x%x posted:x%llx]\n",
-				qp->assoc_qid,
-				qp->q_cnt_1, (unsigned long long)qp->q_cnt_4);
-			len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\t\tWQID[%02d], "
-				"QE-CNT[%04d], QE-SIZE[%04d], "
-				"HOST-IDX[%04d], PORT-IDX[%04d]",
-				qp->queue_id,
-				qp->entry_count,
-				qp->entry_size,
-				qp->host_index,
-				qp->hba_index);
-
-			len +=  snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-			if (len >= max_cnt)
-				goto too_big;
-		}
+		len = __lpfc_idiag_print_wq(qp, "OAS", pbuffer, len);
+		if (len >= max_cnt)
+			goto too_big;
 	}
-out:
+
 	spin_unlock_irq(&phba->hbalock);
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 
 too_big:
-	len +=  snprintf(pbuffer+len,
-		LPFC_QUE_INFO_GET_BUF_SIZE-len, "Truncated ...\n");
+	len +=  snprintf(pbuffer + len,
+		LPFC_QUE_INFO_GET_BUF_SIZE - len, "Truncated ...\n");
+out:
 	spin_unlock_irq(&phba->hbalock);
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 }
-- 
2.5.0
