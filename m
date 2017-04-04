From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 10/19] Remove hba lock from NVMET isssue WQE
Date: Tue,  4 Apr 2017 10:17:03 -0700
Message-ID: <1491326232-11255-11-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38136 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755024AbdDDRZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:37 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 8669730C090
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:31 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

Unecessary lock is taken. ring lock should be sufficient

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 86ab95c..551e81a 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -519,7 +519,6 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
 	struct lpfc_hba *phba = ctxp->phba;
 	struct lpfc_iocbq *nvmewqeq;
-	unsigned long iflags;
 	int rc, id;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -594,10 +593,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	lpfc_nvmeio_data(phba, "NVMET FCP CMND: xri x%x op x%x len x%x\n",
 			 ctxp->oxid, rsp->op, rsp->rsplen);
 
-	/* For now we take hbalock */
-	spin_lock_irqsave(&phba->hbalock, iflags);
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, nvmewqeq);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (rc == WQE_SUCCESS) {
 		ctxp->flag |= LPFC_NVMET_IO_INP;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-- 
2.1.0
