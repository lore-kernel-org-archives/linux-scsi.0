From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/20] lpfc 8.3.31: Reregister VPI for SLI3 after cable
 moved to new Saturn port
Date: Wed, 9 May 2012 21:18:49 -0400
Message-ID: <1336612730.1996.43.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27894 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756994Ab2EJBTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:19:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reregister VPI for SLI3 after cable moved to new Saturn port


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:10.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:20.000000000 -0400
@@ -707,14 +707,17 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			lpfc_sli4_unreg_all_rpis(vport);
 			lpfc_mbx_unreg_vpi(vport);
 			spin_lock_irq(shost->host_lock);
-			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-			/*
-			* If VPI is unreged, driver need to do INIT_VPI
-			* before re-registering
-			*/
 			vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			spin_unlock_irq(shost->host_lock);
 		}
+
+		/*
+		 * For SLI3 and SLI4, the VPI needs to be reregistered in
+		 * response to this fabric parameter change event.
+		 */
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+		spin_unlock_irq(shost->host_lock);
 	} else if ((phba->sli_rev == LPFC_SLI_REV4) &&
 		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
 			/*



