From: James Smart <james.smart@emulex.com>
Subject: [PATCH 21/22] lpfc 8.3.39: Fixed driver handling of CLEAR_LA with
 NPIV enabled causing SID=0 frames out
Date: Wed, 17 Apr 2013 20:20:00 -0400
Message-ID: <1366244400.1513.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24347 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DRAUD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:20:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed driver handling of CLEAR_LA with NPIV enabled causing SID=0 frames out


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:55.603041543 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:56.995041575 -0400
@@ -1009,9 +1009,6 @@ lpfc_linkup(struct lpfc_hba *phba)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
 			lpfc_linkup_port(vports[i]);
 	lpfc_destroy_vport_work_array(phba, vports);
-	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
-	    (phba->sli_rev < LPFC_SLI_REV4))
-		lpfc_issue_clear_la(phba, phba->pport);
 
 	return 0;
 }
@@ -5028,11 +5025,13 @@ lpfc_disc_start(struct lpfc_vport *vport
 	if (num_sent)
 		return;
 
-	/* Register the VPI for SLI3, NON-NPIV only. */
+	/* Register the VPI for SLI3, NPIV only. */
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 	    !(vport->fc_flag & FC_PT2PT) &&
 	    !(vport->fc_flag & FC_RSCN_MODE) &&
 	    (phba->sli_rev < LPFC_SLI_REV4)) {
+		if (vport->port_type == LPFC_PHYSICAL_PORT)
+			lpfc_issue_clear_la(phba, vport);
 		lpfc_issue_reg_vpi(phba, vport);
 		return;
 	}



