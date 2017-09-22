From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 09/19] lpfc: Reduce log spew on controller reconnects
Date: Thu, 21 Sep 2017 23:17:31 -0700
Message-ID: <20170922061741.12347-10-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33049 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdIVGSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:04 -0400
Received: by mail-pf0-f194.google.com with SMTP id h4so96289pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:04 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

There are several log messages that report abnormal
terminations that by default are marked warn. These are
typically the result of failures due to invalid controller
state or abort completions. They are all natural when a
controller resets.

Unfortunately, as they are logged by default, it makes the
admin very concerned.

Convert the messages to Info.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c  |  6 +++---
 drivers/scsi/lpfc/lpfc_nvmet.c | 17 +++++++++++------
 2 files changed, 14 insertions(+), 9 deletions(-)
---
 drivers/scsi/lpfc/lpfc_nvme.c  |  6 +++---
 drivers/scsi/lpfc/lpfc_nvmet.c | 16 ++++++++++------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index a83b57254de6..e6948945a2f2 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -886,7 +886,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			break;
 		default:
 out_err:
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 					 "6072 NVME Completion Error: xri %x "
 					 "status x%x result x%x placed x%x\n",
 					 lpfc_ncmd->cur_iocbq.sli4_xritag,
@@ -1339,7 +1339,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	ret = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, &lpfc_ncmd->cur_iocbq);
 	if (ret) {
 		atomic_dec(&ndlp->cmd_pending);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "6113 FCP could not issue WQE err %x "
 				 "sid: x%x did: x%x oxid: x%x\n",
 				 ret, vport->fc_myDID, ndlp->nlp_DID,
@@ -1399,7 +1399,7 @@ void
 lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			   struct lpfc_wcqe_complete *abts_cmpl)
 {
-	lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
 			"6145 ABORT_XRI_CN completing on rpi x%x "
 			"original iotag x%x, abort cmd iotag x%x "
 			"req_tag x%x, status x%x, hwstatus x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index d065f5e4fa1a..43ad220e17ad 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -76,7 +76,7 @@ lpfc_nvmet_defer_release(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp)
 {
 	unsigned long iflag;
 
-	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6313 NVMET Defer ctx release xri x%x flg x%x\n",
 			ctxp->oxid, ctxp->flag);
 
@@ -494,7 +494,7 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvmefc_tgt_fcp_req *rsp;
 	struct lpfc_nvmet_rcv_ctx *ctxp;
-	uint32_t status, result, op, start_clean;
+	uint32_t status, result, op, start_clean, logerr;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t id;
 #endif
@@ -522,17 +522,21 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		if (tgtp)
 			atomic_inc(&tgtp->xmt_fcp_rsp_error);
 
+		logerr = LOG_NVME_IOERR;
+
 		/* pick up SLI4 exhange busy condition */
 		if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 			ctxp->flag |= LPFC_NVMET_XBUSY;
+			logerr |= LOG_NVME_ABTS;
 
-			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-					"6315 IO Cmpl XBUSY: xri x%x: %x/%x\n",
-					ctxp->oxid, status, result);
 		} else {
 			ctxp->flag &= ~LPFC_NVMET_XBUSY;
 		}
 
+		lpfc_printf_log(phba, KERN_INFO, logerr,
+				"6315 IO Error Cmpl xri x%x: %x/%x XBUSY:x%x\n",
+				ctxp->oxid, status, result, ctxp->flag);
+
 	} else {
 		rsp->fcp_error = NVME_SC_SUCCESS;
 		if (op == NVMET_FCOP_RSP)
@@ -2353,7 +2357,7 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 	atomic_inc(&tgtp->xmt_abort_rsp);
 
-	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6165 ABORT cmpl: xri x%x flg x%x (%d) "
 			"WCQE: %08x %08x %08x %08x\n",
 			ctxp->oxid, ctxp->flag, released,
-- 
2.13.1
