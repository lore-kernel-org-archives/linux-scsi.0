From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 07/17] lpfc: Driver fails to detect direct attach storage array
Date: Fri,  3 Nov 2017 15:56:18 -0700
Message-ID: <20171103225628.24716-8-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:50730 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756020AbdKCW4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:44 -0400
Received: by mail-qt0-f193.google.com with SMTP id d9so5052998qtd.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:44 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The driver does not respond to PLOGI from the direct attach target.
The driver uses incorrect S_ID in CONFIG_LINK, after FLOGI completion

Correct by issuing CONFIG_LINK with the correct S_ID after receiving
the PLOGI from the target

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7df791047f55..95872a0329ad 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -858,6 +858,9 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	vport->fc_flag |= FC_PT2PT;
 	spin_unlock_irq(shost->host_lock);
 
+	/* If we are pt2pt with another NPort, force NPIV off! */
+	phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
+
 	/* If physical FC port changed, unreg VFI and ALL VPIs / RPIs */
 	if ((phba->sli_rev == LPFC_SLI_REV4) && phba->fc_topology_changed) {
 		lpfc_unregister_fcf_prep(phba);
@@ -916,28 +919,29 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
-	} else
+
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!mbox)
+			goto fail;
+
+		lpfc_config_link(phba, mbox);
+
+		mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
+		mbox->vport = vport;
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED) {
+			mempool_free(mbox, phba->mbox_mem_pool);
+			goto fail;
+		}
+	} else {
 		/* This side will wait for the PLOGI, decrement ndlp reference
 		 * count indicating that ndlp can be released when other
 		 * references to it are done.
 		 */
 		lpfc_nlp_put(ndlp);
 
-	/* If we are pt2pt with another NPort, force NPIV off! */
-	phba->sli3_options &= ~LPFC_SLI3_NPIV_ENABLED;
-
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
-		goto fail;
-
-	lpfc_config_link(phba, mbox);
-
-	mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
-	mbox->vport = vport;
-	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED) {
-		mempool_free(mbox, phba->mbox_mem_pool);
-		goto fail;
+		/* Start discovery - this should just do CLEAR_LA */
+		lpfc_disc_start(vport);
 	}
 
 	return 0;
-- 
2.13.1
