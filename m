From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/7] lpfc 8.3.36: Fixed setting sequential delivery bit
Date: Wed, 31 Oct 2012 14:45:01 -0400
Message-ID: <1351709101.957.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47843 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2JaSpo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:45:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed setting sequential delivery bit in a service class that is not valid


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-10-23 09:51:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-10-29 11:18:42.206033069 -0400
@@ -1182,8 +1182,6 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 	sp->cmn.w2.r_a_tov = 0;
 	sp->cmn.virtual_fabric_support = 0;
 	sp->cls1.classValid = 0;
-	sp->cls2.seqDelivery = 1;
-	sp->cls3.seqDelivery = 1;
 	if (sp->cmn.fcphLow < FC_PH3)
 		sp->cmn.fcphLow = FC_PH3;
 	if (sp->cmn.fcphHigh < FC_PH3)
@@ -1198,7 +1196,13 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 			/* Set the fcfi to the fcfi we registered with */
 			elsiocb->iocb.ulpContext = phba->fcf.fcfi;
 		}
+		/* Can't do SLI4 class2 without support sequence coalescing */
+		sp->cls2.classValid = 0;
+		sp->cls2.seqDelivery = 0;
 	} else {
+		/* Historical, setting sequential-delivery bit for SLI3 */
+		sp->cls2.seqDelivery = (sp->cls2.classValid) ? 1 : 0;
+		sp->cls3.seqDelivery = (sp->cls3.classValid) ? 1 : 0;
 		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 			sp->cmn.request_multiple_Nport = 1;
 			/* For FLOGI, Let FLOGI rsp set the NPortID for VPI 0 */



