From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 06/15] lpfc: Fix NMI watchdog assertions when running nvmet IOPS tests
Date: Wed, 10 May 2017 12:07:04 -0700
Message-ID: <20170510190713.30171-7-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35022 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbdEJTHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:31 -0400
Received: by mail-qk0-f195.google.com with SMTP id k74so723820qke.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:31 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

After running IOPS test for 30 second we get
kernel:NMI watchdog: Watchdog detected hard LOCKUP on cpu 0

The driver is speend too much time in it's ISR.

In ISR EQ and CQ processing routines, if we hit the entry_repost
numbers of EQE/CQEs just break out of the routine as opposed to
hitting the doorbell with NOARM and continue processing.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 30 +++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.c     |  8 ++------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a41daedeb967..7284533f4df2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3075,11 +3075,11 @@ __lpfc_idiag_print_wq(struct lpfc_queue *qp, char *wqtype,
 			qp->assoc_qid, qp->q_cnt_1,
 			(unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\t\tWQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			"\t\tWQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]",
 			qp->queue_id, qp->entry_count,
 			qp->entry_size, qp->host_index,
-			qp->hba_index);
+			qp->hba_index, qp->entry_repost);
 	len +=  snprintf(pbuffer + len,
 			LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 	return len;
@@ -3126,11 +3126,11 @@ __lpfc_idiag_print_cq(struct lpfc_queue *qp, char *cqtype,
 			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
 			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\tCQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			"\tCQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]",
 			qp->queue_id, qp->entry_count,
 			qp->entry_size, qp->host_index,
-			qp->hba_index);
+			qp->hba_index, qp->entry_repost);
 
 	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 
@@ -3152,16 +3152,16 @@ __lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
 			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
 			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\t\tHQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			"\t\tHQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]\n",
 			qp->queue_id, qp->entry_count, qp->entry_size,
-			qp->host_index, qp->hba_index);
+			qp->host_index, qp->hba_index, qp->entry_repost);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\t\tDQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			"\t\tDQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]\n",
 			datqp->queue_id, datqp->entry_count,
 			datqp->entry_size, datqp->host_index,
-			datqp->hba_index);
+			datqp->hba_index, datqp->entry_repost);
 	return len;
 }
 
@@ -3247,10 +3247,10 @@ __lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
 			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
 			(unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"EQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			"EQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]",
 			qp->queue_id, qp->entry_count, qp->entry_size,
-			qp->host_index, qp->hba_index);
+			qp->host_index, qp->hba_index, qp->entry_repost);
 	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 
 	return len;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cdf02a957690..66bb86656bba 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13234,10 +13234,6 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 		hrq->RQ_no_posted_buf++;
 		/* Post more buffers if possible */
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		phba->hba_flag |= HBA_POST_RECEIVE_BUFFER;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		workposted = true;
 		break;
 	}
 out:
@@ -13391,7 +13387,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
-			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+			break;
 	}
 
 	/* Track the max number of CQEs processed in 1 EQ */
@@ -13681,7 +13677,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 
 		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
 		if (!(++ecount % fpeq->entry_repost))
-			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
+			break;
 		fpeq->EQ_processed++;
 	}
 
-- 
2.11.0
