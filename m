From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/16] lpfc 8.1.12 : Fixed recovery of rport after race with
	dev_loss_tmo
Date: Wed, 25 Apr 2007 09:52:41 -0400
Message-ID: <1177509162.23155.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51665 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031005AbXDYNwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:33 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqWNd006599
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed recovery of rport after race with dev_loss_tmo

Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
@@ -109,6 +109,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 		return;
 	}
 
+	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
+		return;
+
 	name = (uint8_t *)&ndlp->nlp_portname;
 	phba = ndlp->nlp_phba;
 
@@ -149,7 +152,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 
 	if (!(phba->fc_flag & FC_UNLOADING) &&
 	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
-	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC))
+	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
+	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE))
 		lpfc_disc_state_machine(phba, ndlp, NULL, NLP_EVT_DEVICE_RM);
 	else {
 		rdata->pnode = NULL;
@@ -1326,8 +1330,6 @@ lpfc_nlp_state_cleanup(struct lpfc_hba *
 			 * already. If we have, and it's a scsi entity, be
 			 * sure to unblock any attached scsi devices
 			 */
-		if (!ndlp->rport ||
-		    ndlp->rport->port_state == FC_PORTSTATE_BLOCKED)
 			lpfc_register_remote_port(phba, ndlp);
 	}
 


