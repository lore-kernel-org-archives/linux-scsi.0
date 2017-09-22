From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 16/19] lpfc: Ensure io aborts interlocked with the target.
Date: Thu, 21 Sep 2017 23:17:38 -0700
Message-ID: <20170922061741.12347-17-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34868 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdIVGSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:11 -0400
Received: by mail-pg0-f66.google.com with SMTP id j16so123281pga.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:11 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Before releasing nvme io back to the io stack for possible
retry on other paths, ensure the io termination is interlocked
with the target device by ensuring the entire ABTS-LS protocol is
complete.

Additionally, FC-NVME ABTS-LS protocol does not use RRQ. Remove RRQ
behavior from ABTS-LS.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 59 +++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 02ba06f364c4..e3642c1890ea 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -850,7 +850,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	} else {
 		lpfc_ncmd->status = (bf_get(lpfc_wcqe_c_status, wcqe) &
 			    LPFC_IOCB_STATUS_MASK);
-		lpfc_ncmd->result = wcqe->parameter;
+		lpfc_ncmd->result = (wcqe->parameter & IOERR_PARAM_MASK);
 
 		/* For NVME, the only failure path that results in an
 		 * IO error is when the adapter rejects it.  All other
@@ -884,6 +884,17 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 					 lpfc_ncmd->status, lpfc_ncmd->result,
 					 wcqe->total_data_placed);
 			break;
+		case IOSTAT_LOCAL_REJECT:
+			/* Let fall through to set command final state. */
+			if (lpfc_ncmd->result == IOERR_ABORT_REQUESTED)
+				lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_NVME_IOERR,
+					 "6032 Delay Aborted cmd %p "
+					 "nvme cmd %p, xri x%x, "
+					 "xb %d\n",
+					 lpfc_ncmd, nCmd,
+					 lpfc_ncmd->cur_iocbq.sli4_xritag,
+					 bf_get(lpfc_wcqe_c_xb, wcqe));
 		default:
 out_err:
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
@@ -930,12 +941,18 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 #endif
 	freqpriv = nCmd->private;
 	freqpriv->nvme_buf = NULL;
-	nCmd->done(nCmd);
+
+	/* NVME targets need completion held off until the abort exchange
+	 * completes.
+	 */
+	if (!lpfc_ncmd->flags & LPFC_SBUF_XBUSY)
+		nCmd->done(nCmd);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	lpfc_ncmd->nrport = NULL;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
+	/* Call release with XB=1 to queue the IO into the abort list. */
 	lpfc_release_nvme_buf(phba, lpfc_ncmd);
 }
 
@@ -2064,9 +2081,6 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	spin_lock_irqsave(&phba->nvme_buf_list_get_lock, iflag);
 	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
 				 &phba->lpfc_nvme_buf_list_get, list) {
-		if (lpfc_test_rrq_active(phba, ndlp,
-					 lpfc_ncmd->cur_iocbq.sli4_lxritag))
-			continue;
 		list_del_init(&lpfc_ncmd->list);
 		found = 1;
 		break;
@@ -2079,9 +2093,6 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 		spin_unlock(&phba->nvme_buf_list_put_lock);
 		list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
 					 &phba->lpfc_nvme_buf_list_get, list) {
-			if (lpfc_test_rrq_active(
-				phba, ndlp, lpfc_ncmd->cur_iocbq.sli4_lxritag))
-				continue;
 			list_del_init(&lpfc_ncmd->list);
 			found = 1;
 			break;
@@ -2118,7 +2129,6 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_nvme_buf *lpfc_ncmd)
 
 		spin_lock_irqsave(&phba->sli4_hba.abts_nvme_buf_list_lock,
 					iflag);
-		lpfc_ncmd->nvmeCmd = NULL;
 		list_add_tail(&lpfc_ncmd->list,
 			&phba->sli4_hba.lpfc_abts_nvme_buf_list);
 		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvme_buf_list_lock,
@@ -2486,18 +2496,18 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  * @axri: pointer to the fcp xri abort wcqe structure.
  *
  * This routine is invoked by the worker thread to process a SLI4 fast-path
- * FCP aborted xri.
+ * NVME aborted xri.  Aborted NVME IO commands are completed to the transport
+ * here.
  **/
 void
 lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 			   struct sli4_wcqe_xri_aborted *axri)
 {
 	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
-	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
 	struct lpfc_nvme_buf *lpfc_ncmd, *next_lpfc_ncmd;
+	struct nvmefc_fcp_req *nvme_cmd = NULL;
 	struct lpfc_nodelist *ndlp;
 	unsigned long iflag = 0;
-	int rrq_empty = 0;
 
 	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
 		return;
@@ -2513,25 +2523,24 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 			spin_unlock(
 				&phba->sli4_hba.abts_nvme_buf_list_lock);
 
-			rrq_empty = list_empty(&phba->active_rrq_list);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			ndlp = lpfc_ncmd->ndlp;
-			if (ndlp) {
-				lpfc_set_rrq_active(
-					phba, ndlp,
-					lpfc_ncmd->cur_iocbq.sli4_lxritag,
-					rxid, 1);
+			if (ndlp)
 				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
-			}
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-					"6311 XRI Aborted xri x%x tag x%x "
-					"released\n",
-					xri, lpfc_ncmd->cur_iocbq.iotag);
-
+					"6311 nvme_cmd %p xri x%x tag x%x "
+					"abort complete and xri released\n",
+					lpfc_ncmd->nvmeCmd, xri,
+					lpfc_ncmd->cur_iocbq.iotag);
+
+			/* Aborted NVME commands are required to not complete
+			 * before the abort exchange command fully completes.
+			 * Once completed, it is available via the put list.
+			 */
+			nvme_cmd = lpfc_ncmd->nvmeCmd;
+			nvme_cmd->done(nvme_cmd);
 			lpfc_release_nvme_buf(phba, lpfc_ncmd);
-			if (rrq_empty)
-				lpfc_worker_wake_up(phba);
 			return;
 		}
 	}
-- 
2.13.1
