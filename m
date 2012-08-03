From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/21] lpfc 8.3.33: Add debugfs interface to display SLI
 queue information
Date: Fri, 3 Aug 2012 12:35:13 -0400
Message-ID: <1344011713.6110.33.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40314 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2HCQfU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:35:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add debugfs interface to display SLI queue information


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.h |    3 +++
 lpfc_sli.c     |   35 ++++++++++++++++++++++++++++++++++-
 lpfc_sli4.h    |   29 +++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2012-07-22 12:45:05.890486486 -0400
@@ -36,6 +36,9 @@
 /* dumpHostSlim output buffer size */
 #define LPFC_DUMPHOSTSLIM_SIZE 4096
 
+/* dumpSLIqinfo output buffer size */
+#define	LPFC_DUMPSLIQINFO_SIZE 4096
+
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2012-07-22 12:45:05.896486487 -0400
@@ -141,6 +141,35 @@ struct lpfc_queue {
 	uint32_t page_count;	/* Number of pages allocated for this queue */
 	uint32_t host_index;	/* The host's index for putting or getting */
 	uint32_t hba_index;	/* The last known hba index for get or put */
+
+	/* For q stats */
+	uint32_t q_cnt_1;
+	uint32_t q_cnt_2;
+	uint32_t q_cnt_3;
+	uint64_t q_cnt_4;
+/* defines for EQ stats */
+#define	EQ_max_eqe		q_cnt_1
+#define	EQ_no_entry		q_cnt_2
+#define	EQ_badstate		q_cnt_3
+#define	EQ_processed		q_cnt_4
+
+/* defines for CQ stats */
+#define	CQ_mbox			q_cnt_1
+#define	CQ_max_cqe		q_cnt_1
+#define	CQ_release_wqe		q_cnt_2
+#define	CQ_xri_aborted		q_cnt_3
+#define	CQ_wq			q_cnt_4
+
+/* defines for WQ stats */
+#define	WQ_overflow		q_cnt_1
+#define	WQ_posted		q_cnt_4
+
+/* defines for RQ stats */
+#define	RQ_no_posted_buf	q_cnt_1
+#define	RQ_no_buf_found		q_cnt_2
+#define	RQ_buf_trunc		q_cnt_3
+#define	RQ_rcv_buf		q_cnt_4
+
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
 };
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 12:45:05.916486486 -0400
@@ -101,8 +101,11 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 	temp_wqe = q->qe[q->host_index].wqe;
 
 	/* If the host has not yet processed the next entry then we are done */
-	if (((q->host_index + 1) % q->entry_count) == q->hba_index)
+	if (((q->host_index + 1) % q->entry_count) == q->hba_index) {
+		q->WQ_overflow++;
 		return -ENOMEM;
+	}
+	q->WQ_posted++;
 	/* set consumption flag every once in a while */
 	if (!((q->host_index + 1) % q->entry_repost))
 		bf_set(wqe_wqec, &wqe->generic.wqe_com, 1);
@@ -11311,14 +11314,17 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2537 Receive Frame Truncated!!\n");
+		hrq->RQ_buf_trunc++;
 	case FC_STATUS_RQ_SUCCESS:
 		lpfc_sli4_rq_release(hrq, drq);
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		dma_buf = lpfc_sli_hbqbuf_get(&phba->hbqs[0].hbq_buffer_list);
 		if (!dma_buf) {
+			hrq->RQ_no_buf_found++;
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			goto out;
 		}
+		hrq->RQ_rcv_buf++;
 		memcpy(&dma_buf->cq_event.cqe.rcqe_cmpl, rcqe, sizeof(*rcqe));
 		/* save off the frame for the word thread to process */
 		list_add_tail(&dma_buf->cq_event.list,
@@ -11330,6 +11336,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 		break;
 	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 	case FC_STATUS_INSUFF_BUF_FRM_DISC:
+		hrq->RQ_no_posted_buf++;
 		/* Post more buffers if possible */
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		phba->hba_flag |= HBA_POST_RECEIVE_BUFFER;
@@ -11457,6 +11464,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba
 			workposted |= lpfc_sli4_sp_handle_mcqe(phba, cqe);
 			if (!(++ecount % cq->entry_repost))
 				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+			cq->CQ_mbox++;
 		}
 		break;
 	case LPFC_WCQ:
@@ -11470,6 +11478,10 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba
 			if (!(++ecount % cq->entry_repost))
 				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 		}
+
+		/* Track the max number of CQEs processed in 1 EQ */
+		if (ecount > cq->CQ_max_cqe)
+			cq->CQ_max_cqe = ecount;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -11621,17 +11633,20 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba
 	/* Check and process for different type of WCQE and dispatch */
 	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
 	case CQE_CODE_COMPL_WQE:
+		cq->CQ_wq++;
 		/* Process the WQ complete event */
 		phba->last_completion_time = jiffies;
 		lpfc_sli4_fp_handle_fcp_wcqe(phba,
 				(struct lpfc_wcqe_complete *)&wcqe);
 		break;
 	case CQE_CODE_RELEASE_WQE:
+		cq->CQ_release_wqe++;
 		/* Process the WQ release event */
 		lpfc_sli4_fp_handle_rel_wcqe(phba, cq,
 				(struct lpfc_wcqe_release *)&wcqe);
 		break;
 	case CQE_CODE_XRI_ABORTED:
+		cq->CQ_xri_aborted++;
 		/* Process the WQ XRI abort event */
 		phba->last_completion_time = jiffies;
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
@@ -11709,6 +11724,10 @@ lpfc_sli4_fp_handle_eqe(struct lpfc_hba
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
 
+	/* Track the max number of CQEs processed in 1 EQ */
+	if (ecount > cq->CQ_max_cqe)
+		cq->CQ_max_cqe = ecount;
+
 	/* Catch the no cq entry condition */
 	if (unlikely(ecount == 0))
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -11780,6 +11799,7 @@ lpfc_sli4_sp_intr_handler(int irq, void
 
 	/* Check device state for handling interrupt */
 	if (unlikely(lpfc_intr_state_check(phba))) {
+		speq->EQ_badstate++;
 		/* Check again for link_state with lock held */
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		if (phba->link_state < LPFC_LINK_DOWN)
@@ -11796,13 +11816,19 @@ lpfc_sli4_sp_intr_handler(int irq, void
 		lpfc_sli4_sp_handle_eqe(phba, eqe);
 		if (!(++ecount % speq->entry_repost))
 			lpfc_sli4_eq_release(speq, LPFC_QUEUE_NOARM);
+		speq->EQ_processed++;
 	}
 
+	/* Track the max number of EQEs processed in 1 intr */
+	if (ecount > speq->EQ_max_eqe)
+		speq->EQ_max_eqe = ecount;
+
 	/* Always clear and re-arm the slow-path EQ */
 	lpfc_sli4_eq_release(speq, LPFC_QUEUE_REARM);
 
 	/* Catch the no cq entry condition */
 	if (unlikely(ecount == 0)) {
+		speq->EQ_no_entry++;
 		if (phba->intr_type == MSIX)
 			/* MSI-X treated interrupt served as no EQ share INT */
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
@@ -11864,6 +11890,7 @@ lpfc_sli4_fp_intr_handler(int irq, void
 
 	/* Check device state for handling interrupt */
 	if (unlikely(lpfc_intr_state_check(phba))) {
+		fpeq->EQ_badstate++;
 		/* Check again for link_state with lock held */
 		spin_lock_irqsave(&phba->hbalock, iflag);
 		if (phba->link_state < LPFC_LINK_DOWN)
@@ -11880,12 +11907,18 @@ lpfc_sli4_fp_intr_handler(int irq, void
 		lpfc_sli4_fp_handle_eqe(phba, eqe, fcp_eqidx);
 		if (!(++ecount % fpeq->entry_repost))
 			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
+		fpeq->EQ_processed++;
 	}
 
+	/* Track the max number of EQEs processed in 1 intr */
+	if (ecount > fpeq->EQ_max_eqe)
+		fpeq->EQ_max_eqe = ecount;
+
 	/* Always clear and re-arm the fast-path EQ */
 	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
 
 	if (unlikely(ecount == 0)) {
+		fpeq->EQ_no_entry++;
 		if (phba->intr_type == MSIX)
 			/* MSI-X treated interrupt served as no EQ share INT */
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,



