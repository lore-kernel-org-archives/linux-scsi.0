From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 05/20] lpfc: Linux lpfc driver doesn't re-establish the link after a cable pull on LPe12002
Date: Tue, 7 Apr 2015 15:07:12 -0400
Message-ID: <55242ae0.6GDxuFZ8R1ddw+9Q%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:33630 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbDGTIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Linux lpfc driver doesn't re-establish the link after a cable pull on LPe12002

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 3 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c66088d..6350563 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2243,8 +2243,7 @@ lpfc_adisc_done(struct lpfc_vport *vport)
 	*/
 	if (vport->port_state < LPFC_VPORT_READY) {
 		/* If we get here, there is nothing to ADISC */
-		if (vport->port_type == LPFC_PHYSICAL_PORT)
-			lpfc_issue_clear_la(phba, vport);
+		lpfc_issue_clear_la(phba, vport);
 		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
 			vport->num_disc_nodes = 0;
 			/* go thru NPR list, issue ELS PLOGIs */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 5452f1f..b1ad1a0 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5070,8 +5070,7 @@ lpfc_disc_start(struct lpfc_vport *vport)
 	    !(vport->fc_flag & FC_PT2PT) &&
 	    !(vport->fc_flag & FC_RSCN_MODE) &&
 	    (phba->sli_rev < LPFC_SLI_REV4)) {
-		if (vport->port_type == LPFC_PHYSICAL_PORT)
-			lpfc_issue_clear_la(phba, vport);
+		lpfc_issue_clear_la(phba, vport);
 		lpfc_issue_reg_vpi(phba, vport);
 		return;
 	}
@@ -5082,8 +5081,7 @@ lpfc_disc_start(struct lpfc_vport *vport)
 	 */
 	if (vport->port_state < LPFC_VPORT_READY && !clear_la_pending) {
 		/* If we get here, there is nothing to ADISC */
-		if (vport->port_type == LPFC_PHYSICAL_PORT)
-			lpfc_issue_clear_la(phba, vport);
+		lpfc_issue_clear_la(phba, vport);
 
 		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
 			vport->num_disc_nodes = 0;
-- 
1.7.11.7

