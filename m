From: James Smart <james.smart@emulex.com>
Subject: [PATCH 19/21] lpfc 8.3.33: Fixed debugfs queInfo to include queue
 stats
Date: Fri, 3 Aug 2012 12:37:00 -0400
Message-ID: <1344011820.6110.44.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40348 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2HCQhH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:37:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed debugfs queInfo to include queue stats


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.c |  420 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 261 insertions(+), 159 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2012-07-22 14:29:51.217268164 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2012-07-22 14:34:05.818259322 -0400
@@ -2001,192 +2001,294 @@ lpfc_idiag_queinfo_read(struct file *fil
 {
 	struct lpfc_debug *debug = file->private_data;
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
-	int len = 0, fcp_qidx;
+	int len = 0;
 	char *pbuffer;
+	int x, cnt;
+	int max_cnt;
+	struct lpfc_queue *qp = NULL;
+
 
 	if (!debug->buffer)
 		debug->buffer = kmalloc(LPFC_QUE_INFO_GET_BUF_SIZE, GFP_KERNEL);
 	if (!debug->buffer)
 		return 0;
 	pbuffer = debug->buffer;
+	max_cnt = LPFC_QUE_INFO_GET_BUF_SIZE - 128;
 
 	if (*ppos)
 		return 0;
 
-	/* Get fast-path event queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"HBA EQ information:\n");
-	if (phba->sli4_hba.hba_eq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++) {
-			if (phba->sli4_hba.hba_eq[fcp_qidx]) {
-				len += snprintf(pbuffer+len,
-					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tEQID[%02d], "
-				"QE-COUNT[%04d], QE-SIZE[%04d], "
-				"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
-				phba->sli4_hba.hba_eq[fcp_qidx]->queue_id,
-				phba->sli4_hba.hba_eq[fcp_qidx]->entry_count,
-				phba->sli4_hba.hba_eq[fcp_qidx]->entry_size,
-				phba->sli4_hba.hba_eq[fcp_qidx]->host_index,
-				phba->sli4_hba.hba_eq[fcp_qidx]->hba_index);
-			}
-		}
-	}
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+	spin_lock_irq(&phba->hbalock);
 
-	/* Get mailbox complete queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path MBX CQ information:\n");
-	if (phba->sli4_hba.mbx_cq) {
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Associated EQID[%02d]:\n",
-			phba->sli4_hba.mbx_cq->assoc_qid);
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tCQID[%02d], "
-			"QE-COUNT[%04d], QE-SIZE[%04d], "
-			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
-			phba->sli4_hba.mbx_cq->queue_id,
-			phba->sli4_hba.mbx_cq->entry_count,
-			phba->sli4_hba.mbx_cq->entry_size,
-			phba->sli4_hba.mbx_cq->host_index,
-			phba->sli4_hba.mbx_cq->hba_index);
-	}
+	/* Fast-path event queue */
+	if (phba->sli4_hba.hba_eq && phba->cfg_fcp_io_channel) {
+		cnt = phba->cfg_fcp_io_channel;
+
+		for (x = 0; x < cnt; x++) {
+
+			/* Fast-path EQ */
+			qp = phba->sli4_hba.hba_eq[x];
+			if (!qp)
+				goto proc_cq;
 
-	/* Get slow-path complete queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path ELS CQ information:\n");
-	if (phba->sli4_hba.els_cq) {
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Associated EQID[%02d]:\n",
-			phba->sli4_hba.els_cq->assoc_qid);
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tCQID [%02d], "
-			"QE-COUNT[%04d], QE-SIZE[%04d], "
-			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
-			phba->sli4_hba.els_cq->queue_id,
-			phba->sli4_hba.els_cq->entry_count,
-			phba->sli4_hba.els_cq->entry_size,
-			phba->sli4_hba.els_cq->host_index,
-			phba->sli4_hba.els_cq->hba_index);
-	}
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\nHBA EQ info: "
+				"EQ-STAT[max:x%x noE:x%x "
+				"bs:x%x proc:x%llx]\n",
+				qp->q_cnt_1, qp->q_cnt_2,
+				qp->q_cnt_3, qp->q_cnt_4);
+
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"EQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id,
+				qp->entry_count,
+				qp->entry_size,
+				qp->host_index,
+				qp->hba_index);
+
+
+			/* Reset max counter */
+			qp->EQ_max_eqe = 0;
+
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			if (len >= max_cnt)
+				goto too_big;
+proc_cq:
+			/* Fast-path FCP CQ */
+			qp = phba->sli4_hba.fcp_cq[x];
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\tFCP CQ info: ");
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"AssocEQID[%02d]: "
+				"CQ STAT[max:x%x relw:x%x "
+				"xabt:x%x wq:x%llx]\n",
+				qp->assoc_qid,
+				qp->q_cnt_1, qp->q_cnt_2,
+				qp->q_cnt_3, qp->q_cnt_4);
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\tCQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id, qp->entry_count,
+				qp->entry_size, qp->host_index,
+				qp->hba_index);
+
+
+			/* Reset max counter */
+			qp->CQ_max_cqe = 0;
 
-	/* Get fast-path complete queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Fast-path FCP CQ information:\n");
-	fcp_qidx = 0;
-	if (phba->sli4_hba.fcp_cq) {
-		do {
-			if (phba->sli4_hba.fcp_cq[fcp_qidx]) {
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			if (len >= max_cnt)
+				goto too_big;
+
+			/* Fast-path FCP WQ */
+			qp = phba->sli4_hba.fcp_wq[x];
+
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tFCP WQ info: ");
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"AssocCQID[%02d]: "
+				"WQ-STAT[oflow:x%x posted:x%llx]\n",
+				qp->assoc_qid,
+				qp->q_cnt_1, qp->q_cnt_4);
+			len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+				"\t\tWQID[%02d], "
+				"QE-CNT[%04d], QE-SIZE[%04d], "
+				"HOST-IDX[%04d], PORT-IDX[%04d]",
+				qp->queue_id,
+				qp->entry_count,
+				qp->entry_size,
+				qp->host_index,
+				qp->hba_index);
+
+			len +=  snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			if (len >= max_cnt)
+				goto too_big;
+
+			if (x)
+				continue;
+
+			/* Only EQ 0 has slow path CQs configured */
+
+			/* Slow-path mailbox CQ */
+			qp = phba->sli4_hba.mbx_cq;
+			if (qp) {
 				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"Associated EQID[%02d]:\n",
-				phba->sli4_hba.fcp_cq[fcp_qidx]->assoc_qid);
+					"\tMBX CQ info: ");
 				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tCQID[%02d], "
-				"QE-COUNT[%04d], QE-SIZE[%04d], "
-				"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
-				phba->sli4_hba.fcp_cq[fcp_qidx]->queue_id,
-				phba->sli4_hba.fcp_cq[fcp_qidx]->entry_count,
-				phba->sli4_hba.fcp_cq[fcp_qidx]->entry_size,
-				phba->sli4_hba.fcp_cq[fcp_qidx]->host_index,
-				phba->sli4_hba.fcp_cq[fcp_qidx]->hba_index);
+					"AssocEQID[%02d]: "
+					"CQ-STAT[mbox:x%x relw:x%x "
+					"xabt:x%x wq:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3, qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tCQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
 			}
-		} while (++fcp_qidx < phba->cfg_fcp_io_channel);
-		len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
-	}
 
-	/* Get mailbox queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path MBX MQ information:\n");
-	if (phba->sli4_hba.mbx_wq) {
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Associated CQID[%02d]:\n",
-			phba->sli4_hba.mbx_wq->assoc_qid);
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tWQID[%02d], "
-			"QE-COUNT[%04d], QE-SIZE[%04d], "
-			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
-			phba->sli4_hba.mbx_wq->queue_id,
-			phba->sli4_hba.mbx_wq->entry_count,
-			phba->sli4_hba.mbx_wq->entry_size,
-			phba->sli4_hba.mbx_wq->host_index,
-			phba->sli4_hba.mbx_wq->hba_index);
-	}
+			/* Slow-path MBOX MQ */
+			qp = phba->sli4_hba.mbx_wq;
+			if (qp) {
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tMBX MQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocCQID[%02d]:\n",
+					phba->sli4_hba.mbx_wq->assoc_qid);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tWQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
 
-	/* Get slow-path work queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path ELS WQ information:\n");
-	if (phba->sli4_hba.els_wq) {
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Associated CQID[%02d]:\n",
-			phba->sli4_hba.els_wq->assoc_qid);
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tWQID[%02d], "
-			"QE-COUNT[%04d], QE-SIZE[%04d], "
-			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n\n",
-			phba->sli4_hba.els_wq->queue_id,
-			phba->sli4_hba.els_wq->entry_count,
-			phba->sli4_hba.els_wq->entry_size,
-			phba->sli4_hba.els_wq->host_index,
-			phba->sli4_hba.els_wq->hba_index);
-	}
+			/* Slow-path ELS response CQ */
+			qp = phba->sli4_hba.els_cq;
+			if (qp) {
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tELS CQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocEQID[%02d]: "
+					"CQ-STAT[max:x%x relw:x%x "
+					"xabt:x%x wq:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3, qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tCQID [%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				/* Reset max counter */
+				qp->CQ_max_cqe = 0;
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
 
-	/* Get fast-path work queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Fast-path FCP WQ information:\n");
-	if (phba->sli4_hba.fcp_wq) {
-		for (fcp_qidx = 0; fcp_qidx < phba->cfg_fcp_io_channel;
-		     fcp_qidx++) {
-			if (!phba->sli4_hba.fcp_wq[fcp_qidx])
-				continue;
-			len += snprintf(pbuffer+len,
+			/* Slow-path ELS WQ */
+			qp = phba->sli4_hba.els_wq;
+			if (qp) {
+				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"Associated CQID[%02d]:\n",
-				phba->sli4_hba.fcp_wq[fcp_qidx]->assoc_qid);
-			len += snprintf(pbuffer+len,
+					"\t\tELS WQ info: ");
+				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
-				"\tWQID[%02d], "
-				"QE-COUNT[%04d], WQE-SIZE[%04d], "
-				"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
-				phba->sli4_hba.fcp_wq[fcp_qidx]->queue_id,
-				phba->sli4_hba.fcp_wq[fcp_qidx]->entry_count,
-				phba->sli4_hba.fcp_wq[fcp_qidx]->entry_size,
-				phba->sli4_hba.fcp_wq[fcp_qidx]->host_index,
-				phba->sli4_hba.fcp_wq[fcp_qidx]->hba_index);
+					"AssocCQID[%02d]: "
+					" WQ-STAT[oflow:x%x "
+					"posted:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tWQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
+
+			if (phba->sli4_hba.hdr_rq && phba->sli4_hba.dat_rq) {
+				/* Slow-path RQ header */
+				qp = phba->sli4_hba.hdr_rq;
+
+				len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tRQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocCQID[%02d]: "
+					"RQ-STAT[nopost:x%x nobuf:x%x "
+					"trunc:x%x rcv:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3, qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tHQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+					qp->queue_id,
+					qp->entry_count,
+					qp->entry_size,
+					qp->host_index,
+					qp->hba_index);
+
+				/* Slow-path RQ data */
+				qp = phba->sli4_hba.dat_rq;
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tDQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+					qp->queue_id,
+					qp->entry_count,
+					qp->entry_size,
+					qp->host_index,
+					qp->hba_index);
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			}
 		}
-		len += snprintf(pbuffer+len,
-				LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 	}
 
-	/* Get receive queue information */
-	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Slow-path RQ information:\n");
-	if (phba->sli4_hba.hdr_rq && phba->sli4_hba.dat_rq) {
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"Associated CQID[%02d]:\n",
-			phba->sli4_hba.hdr_rq->assoc_qid);
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tHQID[%02d], "
-			"QE-COUNT[%04d], QE-SIZE[%04d], "
-			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
-			phba->sli4_hba.hdr_rq->queue_id,
-			phba->sli4_hba.hdr_rq->entry_count,
-			phba->sli4_hba.hdr_rq->entry_size,
-			phba->sli4_hba.hdr_rq->host_index,
-			phba->sli4_hba.hdr_rq->hba_index);
-		len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\tDQID[%02d], "
-			"QE-COUNT[%04d], QE-SIZE[%04d], "
-			"HOST-INDEX[%04d], PORT-INDEX[%04d]\n",
-			phba->sli4_hba.dat_rq->queue_id,
-			phba->sli4_hba.dat_rq->entry_count,
-			phba->sli4_hba.dat_rq->entry_size,
-			phba->sli4_hba.dat_rq->host_index,
-			phba->sli4_hba.dat_rq->hba_index);
-	}
+	spin_unlock_irq(&phba->hbalock);
+	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
+
+too_big:
+	len +=  snprintf(pbuffer+len,
+		LPFC_QUE_INFO_GET_BUF_SIZE-len, "Truncated ...\n");
+	spin_unlock_irq(&phba->hbalock);
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 }
 



