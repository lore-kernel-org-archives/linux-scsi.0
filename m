From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/8] lpfc 8.3.43: Fixed spinlock hang.
Date: Thu, 10 Oct 2013 12:23:30 -0400
Message-ID: <1381422210.20248.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49082 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3JJQXv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:23:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed spinlock hang.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-10-09 17:25:39.137650922 -0400
@@ -4171,8 +4171,6 @@ lpfc_initialize_node(struct lpfc_vport *
 	NLP_INT_NODE_ACT(ndlp);
 	atomic_set(&ndlp->cmd_pending, 0);
 	ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
-	if (vport->phba->sli_rev == LPFC_SLI_REV4)
-		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
 }
 
 struct lpfc_nodelist *
@@ -4217,6 +4215,9 @@ lpfc_enable_node(struct lpfc_vport *vpor
 	lpfc_initialize_node(vport, ndlp, did);
 
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+
 
 	if (state != NLP_STE_UNUSED_NODE)
 		lpfc_nlp_set_state(vport, ndlp, state);
@@ -5617,6 +5618,9 @@ lpfc_nlp_init(struct lpfc_vport *vport,
 
 	lpfc_initialize_node(vport, ndlp, did);
 	INIT_LIST_HEAD(&ndlp->nlp_listp);
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		ndlp->nlp_rpi = lpfc_sli4_alloc_rpi(vport->phba);
+
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_NODE,
 		"node init:       did:x%x",



