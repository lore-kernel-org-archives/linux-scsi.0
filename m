From: James Smart <james.smart@emulex.com>
Subject: [PATCH 07/14] lpfc: Correct reporting of vport state on fdisc
 command failure.
Date: Mon, 20 Apr 2015 09:56:30 -0400
Message-ID: <5535058e.Xf3vt3uO5y2dAs2H%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:30920 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbbDTN5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct reporting of vport state on fdisc command failure.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 455a5dd..6009158 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8238,7 +8238,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_do_scr_ns_plogi(phba, vport);
 	goto out;
 fdisc_failed:
-	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	if (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS)
+		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	/* Cancel discovery timer */
 	lpfc_can_disctmo(vport);
 	lpfc_nlp_put(ndlp);
-- 
1.7.11.7

