From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/20] lpfc 8.3.31: Fix log message for Mailbox command when
 no error is detected
Date: Wed, 9 May 2012 21:18:30 -0400
Message-ID: <1336612711.1996.41.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27892 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756833Ab2EJBSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:18:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix log message for Mailbox command when no error is detected.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:17.000000000 -0400
@@ -7207,14 +7207,19 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 		if (rc != MBX_SUCCESS)
 			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
 					"(%d):2541 Mailbox command x%x "
-					"(x%x/x%x) cannot issue Data: "
-					"x%x x%x\n",
+					"(x%x/x%x) failure: "
+					"mqe_sta: x%x mcqe_sta: x%x/x%x "
+					"Data: x%x x%x\n,",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
 									mboxq),
 					lpfc_sli_config_mbox_opcode_get(phba,
 									mboxq),
+					bf_get(lpfc_mqe_status, &mboxq->u.mqe),
+					bf_get(lpfc_mcqe_status, &mboxq->mcqe),
+					bf_get(lpfc_mcqe_ext_status,
+					       &mboxq->mcqe),
 					psli->sli_flag, flag);
 		return rc;
 	} else if (flag == MBX_POLL) {
@@ -7233,18 +7238,22 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *
 			/* Successfully blocked, now issue sync mbox cmd */
 			rc = lpfc_sli4_post_sync_mbox(phba, mboxq);
 			if (rc != MBX_SUCCESS)
-				lpfc_printf_log(phba, KERN_ERR,
+				lpfc_printf_log(phba, KERN_WARNING,
 					LOG_MBOX | LOG_SLI,
-					"(%d):2597 Mailbox command "
-					"x%x (x%x/x%x) cannot issue "
-					"Data: x%x x%x\n",
-					mboxq->vport ?
-					mboxq->vport->vpi : 0,
+					"(%d):2597 Sync Mailbox command "
+					"x%x (x%x/x%x) failure: "
+					"mqe_sta: x%x mcqe_sta: x%x/x%x "
+					"Data: x%x x%x\n,",
+					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
 									mboxq),
 					lpfc_sli_config_mbox_opcode_get(phba,
 									mboxq),
+					bf_get(lpfc_mqe_status, &mboxq->u.mqe),
+					bf_get(lpfc_mcqe_status, &mboxq->mcqe),
+					bf_get(lpfc_mcqe_ext_status,
+					       &mboxq->mcqe),
 					psli->sli_flag, flag);
 			/* Unblock the async mailbox posting afterward */
 			lpfc_sli4_async_mbox_unblock(phba);



