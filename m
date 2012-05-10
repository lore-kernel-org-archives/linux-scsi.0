From: James Smart <james.smart@emulex.com>
Subject: [PATCH 07/20] lpfc 8.3.31: Fix Read Link status data
Date: Wed, 9 May 2012 21:17:16 -0400
Message-ID: <1336612646.1996.36.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27881 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756226Ab2EJBRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:17:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix Read Link status data.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:10.000000000 -0400
@@ -5198,7 +5198,6 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *ph
 	}
 
 	cmdsize = sizeof(struct RLS_RSP) + sizeof(uint32_t);
-	mempool_free(pmb, phba->mbox_mem_pool);
 	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
 				     lpfc_max_els_tries, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
@@ -5206,8 +5205,10 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *ph
 	/* Decrement the ndlp reference count from previous mbox command */
 	lpfc_nlp_put(ndlp);
 
-	if (!elsiocb)
+	if (!elsiocb) {
+		mempool_free(pmb, phba->mbox_mem_pool);
 		return;
+	}
 
 	icmd = &elsiocb->iocb;
 	icmd->ulpContext = rxid;
@@ -5224,7 +5225,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *ph
 	rls_rsp->primSeqErrCnt = cpu_to_be32(mb->un.varRdLnk.primSeqErrCnt);
 	rls_rsp->invalidXmitWord = cpu_to_be32(mb->un.varRdLnk.invalidXmitWord);
 	rls_rsp->crcCnt = cpu_to_be32(mb->un.varRdLnk.crcCnt);
-
+	mempool_free(pmb, phba->mbox_mem_pool);
 	/* Xmit ELS RLS ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_ELS,
 			 "2874 Xmit ELS RLS ACC response tag x%x xri x%x, "



