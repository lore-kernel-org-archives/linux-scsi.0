From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 07/17] lpfc: Driver fails to detect direct attach storage array
Date: Mon, 20 Nov 2017 16:00:34 -0800
Message-ID: <20171121000044.27702-8-jsmart2021@gmail.com>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38593 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751915AbdKUABB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:01:01 -0500
Received: by mail-qk0-f195.google.com with SMTP id a142so9762095qkb.5
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:01:01 -0800 (PST)
In-Reply-To: <20171121000044.27702-1-jsmart2021@gmail.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c81cdc637e64..532cd4b49c5d 100644
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
