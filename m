From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH] scsi: lpfc: remove redundant code
Date: Thu,  8 Aug 2019 09:35:25 +0800
Message-ID: <20190808013525.13681-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Remove the redundant initialization code.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 1 -
 drivers/scsi/lpfc/lpfc_sli.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index b7216d694bff..5f66a2da2599 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1571,7 +1571,6 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		"2722 Xmit CT response on exchange x%x Data: x%x x%x x%x\n",
 		icmd->ulpContext, icmd->ulpIoTag, tag, phba->link_state);
 
-	ctiocb->iocb_cmpl = NULL;
 	ctiocb->iocb_flag |= LPFC_IO_LIBDFC;
 	ctiocb->vport = phba->pport;
 	ctiocb->context1 = dd_data;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f9e6a135d656..156224c14cc7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17445,7 +17445,6 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	icmd->ulpContext = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
 	ctiocb->context1 = lpfc_nlp_get(ndlp);
 
-	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;
 	ctiocb->iocb_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
 	ctiocb->sli4_lxritag = NO_XRI;
-- 
2.11.0
