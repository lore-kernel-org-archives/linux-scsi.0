From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/15] lpfc 8.1.7 : Fixed infinite retry of REG_LOGIN
	mailbox failed due to MBXERR_RPI_FULL
Date: Thu, 06 Jul 2006 15:49:42 -0400
Message-ID: <1152215382.23158.21.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20108 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750772AbWGFTt2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:28 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JnPL4006931
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed infinite retry of REG_LOGIN mailbox failed due to MBXERR_RPI_FULL

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-07-06 14:47:43.000000000 -0400
@@ -1110,6 +1110,17 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
 				phba->brd_no,
 				did, mb->mbxStatus, phba->hba_state);
 
+		/*
+		 * If RegLogin failed due to lack of HBA resources do not
+		 * retry discovery.
+		 */
+		if (mb->mbxStatus == MBXERR_RPI_FULL) {
+			ndlp->nlp_prev_state = NLP_STE_UNUSED_NODE;
+			ndlp->nlp_state = NLP_STE_UNUSED_NODE;
+			lpfc_nlp_list(phba, ndlp, NLP_UNUSED_LIST);
+			return ndlp->nlp_state;
+		}
+
 		/* Put ndlp in npr list set plogi timer for 1 sec */
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
 		spin_lock_irq(phba->host->host_lock);


