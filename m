From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/21] lpfc 8.3.30: Fix resource leak when acc fails for
 received plogi
Date: Thu, 1 Mar 2012 22:36:15 -0500
Message-ID: <1330659377.18500.36.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38856 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828Ab2CBDgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:36:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix resource leak when acc fails for received plogi.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_nportdisc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-03-01 17:33:43.000000000 -0500
@@ -440,11 +440,15 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 		spin_unlock_irq(shost->host_lock);
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
-		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
+		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
 			ndlp, mbox);
+		if (rc)
+			mempool_free(mbox, phba->mbox_mem_pool);
 		return 1;
 	}
-	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
+	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
+	if (rc)
+		mempool_free(mbox, phba->mbox_mem_pool);
 	return 1;
 out:
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;

        

