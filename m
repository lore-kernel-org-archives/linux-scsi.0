From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/20] lpfc 8.3.31: Revise FCP LOG for easier Finisar trace
 correlation
Date: Wed, 9 May 2012 21:18:20 -0400
Message-ID: <1336612701.1996.40.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27892 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338Ab2EJBSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:18:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Revise FCP LOG for easier Finisar trace correlation


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:16.000000000 -0400
@@ -3660,11 +3660,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			logit = LOG_FCP | LOG_FCP_UNDER;
 		lpfc_printf_vlog(vport, KERN_WARNING, logit,
 			 "9030 FCP cmd x%x failed <%d/%d> "
-			 "status: x%x result: x%x Data: x%x x%x\n",
+			 "status: x%x result: x%x "
+			 "sid: x%x did: x%x oxid: x%x "
+			 "Data: x%x x%x\n",
 			 cmd->cmnd[0],
 			 cmd->device ? cmd->device->id : 0xffff,
 			 cmd->device ? cmd->device->lun : 0xffff,
 			 lpfc_cmd->status, lpfc_cmd->result,
+			 vport->fc_myDID, pnode->nlp_DID,
+			 phba->sli_rev == LPFC_SLI_REV4 ?
+			     lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
 			 pIocbOut->iocb.ulpContext,
 			 lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
 



