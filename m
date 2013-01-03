From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/11] lpfc 8.3.37: Fixed stale ndlp state when the node is
 marked for deferred removal.
Date: Thu, 3 Jan 2013 15:43:53 -0500
Message-ID: <1357245833.2628.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:27038 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3ACUti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:49:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed processing stale ndlp state when the node is marked for deferred removal.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_nportdisc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2013-01-02 13:13:08.326087771 -0500
@@ -1115,6 +1115,13 @@ out:
 				 "0261 Cannot Register NameServer login\n");
 	}
 
+	/*
+	** In case the node reference counter does not go to zero, ensure that
+	** the stale state for the node is not processed.
+	*/
+
+	ndlp->nlp_prev_state = ndlp->nlp_state;
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_DEFER_RM;
 	spin_unlock_irq(shost->host_lock);
@@ -2159,13 +2166,16 @@ lpfc_cmpl_plogi_npr_node(struct lpfc_vpo
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
 	IOCB_t *irsp;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 	rspiocb = cmdiocb->context_un.rsp_iocb;
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
+		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_DEFER_RM;
+		spin_unlock_irq(shost->host_lock);
 		return NLP_STE_FREED_NODE;
 	}
 	return ndlp->nlp_state;



