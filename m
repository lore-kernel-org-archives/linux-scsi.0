From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/13] lpfc 8.3.41: Fixed not able to perform PCI function
 reset when board was not in online mode
Date: Mon, 15 Jul 2013 18:34:36 -0400
Message-ID: <1373927676.15647.26.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4555 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab3GOWej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:34:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed not able to perform PCI function reset when board was not in online mode


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:26.536056032 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:28.343056073 -0400
@@ -741,14 +741,15 @@ lpfc_selective_reset(struct lpfc_hba *ph
 	int status = 0;
 	int rc;
 
-	if ((!phba->cfg_enable_hba_reset) ||
-	    (phba->pport->fc_flag & FC_OFFLINE_MODE))
+	if (!phba->cfg_enable_hba_reset)
 		return -EACCES;
 
-	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
+	if (!(phba->pport->fc_flag & FC_OFFLINE_MODE)) {
+		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 
-	if (status != 0)
-		return status;
+		if (status != 0)
+			return status;
+	}
 
 	init_completion(&online_compl);
 	rc = lpfc_workq_post_event(phba, &status, &online_compl,




