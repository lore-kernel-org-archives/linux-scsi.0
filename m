From: jsmart2021@gmail.com
Subject: [PATCH v3 14/22] Remove hba lock from NVMET issue WQE.
Date: Fri, 21 Apr 2017 16:04:58 -0700
Message-ID: <20170421230506.925-15-jsmart2021@gmail.com>
References: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34904 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426487AbdDUXF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:29 -0400
Received: by mail-oi0-f67.google.com with SMTP id m34so14689771oik.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:29 -0700 (PDT)
In-Reply-To: <20170421230506.925-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Unnecessary lock is taken. ring lock should be sufficient to protect the
work queue submission.

This was noticed when doing performance testing. The hbalock is not
needed to issue io to the nvme work queue.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index c8a4941..5a994a8 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -517,7 +517,6 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
 	struct lpfc_hba *phba = ctxp->phba;
 	struct lpfc_iocbq *nvmewqeq;
-	unsigned long iflags;
 	int rc, id;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -571,10 +570,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
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
2.9.3
