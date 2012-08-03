From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/21] lpfc 8.3.33: Misc changes to optimize critical path
Date: Fri, 3 Aug 2012 12:35:44 -0400
Message-ID: <1344011744.6110.36.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44831 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2HCQfu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:35:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Misc changes to optimize critical path


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   22 ++++++++++++++++------
 lpfc_sli.c  |   21 +++++++++++++--------
 2 files changed, 29 insertions(+), 14 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 13:15:37.399422869 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 13:22:17.521408971 -0400
@@ -3919,6 +3919,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	struct lpfc_iocbq *piocbq = &(lpfc_cmd->cur_iocbq);
 	int datadir = scsi_cmnd->sc_data_direction;
 	char tag[2];
+	uint8_t *ptr;
+	bool sli4;
 
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return;
@@ -3930,8 +3932,13 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
 			&lpfc_cmd->fcp_cmnd->fcp_lun);
 
-	memset(&fcp_cmnd->fcpCdb[0], 0, LPFC_FCP_CDB_LEN);
-	memcpy(&fcp_cmnd->fcpCdb[0], scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
+	ptr = &fcp_cmnd->fcpCdb[0];
+	memcpy(ptr, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
+	if (scsi_cmnd->cmd_len < LPFC_FCP_CDB_LEN) {
+		ptr += scsi_cmnd->cmd_len;
+		memset(ptr, 0, (LPFC_FCP_CDB_LEN - scsi_cmnd->cmd_len));
+	}
+
 	if (scsi_populate_tag_msg(scsi_cmnd, tag)) {
 		switch (tag[0]) {
 		case HEAD_OF_QUEUE_TAG:
@@ -3947,6 +3954,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	} else
 		fcp_cmnd->fcpCntl1 = 0;
 
+	sli4 = (phba->sli_rev == LPFC_SLI_REV4);
+
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use
 	 * the single mapping, or neither.  Start the lpfc command prep by
@@ -3956,11 +3965,12 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	if (scsi_sg_count(scsi_cmnd)) {
 		if (datadir == DMA_TO_DEVICE) {
 			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
-			if (phba->sli_rev < LPFC_SLI_REV4) {
+			if (sli4)
+				iocb_cmd->ulpPU = PARM_READ_CHECK;
+			else {
 				iocb_cmd->un.fcpi.fcpi_parm = 0;
 				iocb_cmd->ulpPU = 0;
-			} else
-				iocb_cmd->ulpPU = PARM_READ_CHECK;
+			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
 			phba->fc4OutputRequests++;
 		} else {
@@ -3984,7 +3994,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	 * of the scsi_cmnd request_buffer
 	 */
 	piocbq->iocb.ulpContext = pnode->nlp_rpi;
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (sli4)
 		piocbq->iocb.ulpContext =
 		  phba->sli4_hba.rpi_ids[pnode->nlp_rpi];
 	if (pnode->nlp_fcp_info & NLP_FCP_2_DEVICE)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 13:16:21.699421601 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 13:22:17.536408971 -0400
@@ -94,6 +94,7 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 	union lpfc_wqe *temp_wqe;
 	struct lpfc_register doorbell;
 	uint32_t host_index;
+	uint32_t idx;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
@@ -101,7 +102,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 	temp_wqe = q->qe[q->host_index].wqe;
 
 	/* If the host has not yet processed the next entry then we are done */
-	if (((q->host_index + 1) % q->entry_count) == q->hba_index) {
+	idx = ((q->host_index + 1) % q->entry_count);
+	if (idx == q->hba_index) {
 		q->WQ_overflow++;
 		return -ENOMEM;
 	}
@@ -115,7 +117,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 
 	/* Update the host index before invoking device */
 	host_index = q->host_index;
-	q->host_index = ((q->host_index + 1) % q->entry_count);
+
+	q->host_index = idx;
 
 	/* Ring Doorbell */
 	doorbell.word0 = 0;
@@ -123,7 +126,6 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 	bf_set(lpfc_wq_doorbell_index, &doorbell, host_index);
 	bf_set(lpfc_wq_doorbell_id, &doorbell, q->queue_id);
 	writel(doorbell.word0, q->phba->sli4_hba.WQDBregaddr);
-	readl(q->phba->sli4_hba.WQDBregaddr); /* Flush */
 
 	return 0;
 }
@@ -197,7 +199,6 @@ lpfc_sli4_mq_put(struct lpfc_queue *q, s
 	bf_set(lpfc_mq_doorbell_num_posted, &doorbell, 1);
 	bf_set(lpfc_mq_doorbell_id, &doorbell, q->queue_id);
 	writel(doorbell.word0, q->phba->sli4_hba.MQDBregaddr);
-	readl(q->phba->sli4_hba.MQDBregaddr); /* Flush */
 	return 0;
 }
 
@@ -237,6 +238,7 @@ static struct lpfc_eqe *
 lpfc_sli4_eq_get(struct lpfc_queue *q)
 {
 	struct lpfc_eqe *eqe;
+	uint32_t idx;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
@@ -247,10 +249,11 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 	if (!bf_get_le32(lpfc_eqe_valid, eqe))
 		return NULL;
 	/* If the host has not yet processed the next entry then we are done */
-	if (((q->hba_index + 1) % q->entry_count) == q->host_index)
+	idx = ((q->hba_index + 1) % q->entry_count);
+	if (idx == q->host_index)
 		return NULL;
 
-	q->hba_index = ((q->hba_index + 1) % q->entry_count);
+	q->hba_index = idx;
 	return eqe;
 }
 
@@ -321,6 +324,7 @@ static struct lpfc_cqe *
 lpfc_sli4_cq_get(struct lpfc_queue *q)
 {
 	struct lpfc_cqe *cqe;
+	uint32_t idx;
 
 	/* sanity check on queue memory */
 	if (unlikely(!q))
@@ -330,11 +334,12 @@ lpfc_sli4_cq_get(struct lpfc_queue *q)
 	if (!bf_get_le32(lpfc_cqe_valid, q->qe[q->hba_index].cqe))
 		return NULL;
 	/* If the host has not yet processed the next entry then we are done */
-	if (((q->hba_index + 1) % q->entry_count) == q->host_index)
+	idx = ((q->hba_index + 1) % q->entry_count);
+	if (idx == q->host_index)
 		return NULL;
 
 	cqe = q->qe[q->hba_index].cqe;
-	q->hba_index = ((q->hba_index + 1) % q->entry_count);
+	q->hba_index = idx;
 	return cqe;
 }
 



