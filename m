From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/16] lpfc 8.3.35: Fixed PRLI not being retried if a LS_RJT
 with a reason
Date: Sat, 29 Sep 2012 11:31:11 -0400
Message-ID: <1348932671.23909.28.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33787 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2I2Pgp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:36:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed PRLI not being retried if a LS_RJT with a reason


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-09-26 21:11:41.195154018 -0400
@@ -3160,7 +3160,8 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 				retry = 1;
 				break;
 			}
-			if (cmd == ELS_CMD_PLOGI) {
+			if ((cmd == ELS_CMD_PLOGI) ||
+			    (cmd == ELS_CMD_PRLI)) {
 				delay = 1000;
 				maxretry = lpfc_max_els_tries + 1;
 				retry = 1;
@@ -3305,7 +3306,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			if (cmd == ELS_CMD_PRLI)
 				lpfc_nlp_set_state(vport, ndlp,
-					NLP_STE_REG_LOGIN_ISSUE);
+					NLP_STE_PRLI_ISSUE);
 			else
 				lpfc_nlp_set_state(vport, ndlp,
 					NLP_STE_NPR_NODE);



