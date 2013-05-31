From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/17] lpfc 8.3.40: Fixed crash during FCoE failover testing.
Date: Fri, 31 May 2013 17:03:18 -0400
Message-ID: <1370034198.17258.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:21348 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3EaVJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:09:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed crash during FCoE failover testing.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-05-31 10:58:07.689057397 -0400
@@ -4074,7 +4074,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 			 cmd->device ? cmd->device->id : 0xffff,
 			 cmd->device ? cmd->device->lun : 0xffff,
 			 lpfc_cmd->status, lpfc_cmd->result,
-			 vport->fc_myDID, pnode->nlp_DID,
+			 vport->fc_myDID,
+			 (pnode) ? pnode->nlp_DID : 0,
 			 phba->sli_rev == LPFC_SLI_REV4 ?
 			     lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
 			 pIocbOut->iocb.ulpContext,



