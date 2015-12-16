From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 12/17] lpfc: Fix mbox reuse in PLOGI completion
Date: Wed, 16 Dec 2015 18:12:03 -0500
Message-ID: <5671efc3.0ctNdaGDOZR2f0ML%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33354 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbbLPXMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:22 -0500
Received: by mail-pa0-f41.google.com with SMTP id ur14so30973979pab.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:22 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id 72sm1904025pfa.92.2015.12.16.15.12.20
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix mbox reuse in PLOGI completion. Moved allocations so that buffer
properly init'd.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9e571dd..193733e 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1045,16 +1045,6 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	if (irsp->ulpStatus)
 		goto out;
 
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "0133 PLOGI: no memory for reg_login "
-				 "Data: x%x x%x x%x x%x\n",
-				 ndlp->nlp_DID, ndlp->nlp_state,
-				 ndlp->nlp_flag, ndlp->nlp_rpi);
-		goto out;
-	}
-
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 
 	prsp = list_get_first(&pcmd->list, struct lpfc_dmabuf, list);
@@ -1118,6 +1108,17 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			lpfc_issue_reg_vfi(vport);
 		} else {
+			mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+			if (!mbox) {
+				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+						 "0133 PLOGI: no memory "
+						 "for config_link "
+						 "Data: x%x x%x x%x x%x\n",
+						 ndlp->nlp_DID, ndlp->nlp_state,
+						 ndlp->nlp_flag, ndlp->nlp_rpi);
+				goto out;
+			}
+
 			lpfc_config_link(phba, mbox);
 
 			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -1132,6 +1133,16 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 
 	lpfc_unreg_rpi(vport, ndlp);
 
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0018 PLOGI: no memory for reg_login "
+				 "Data: x%x x%x x%x x%x\n",
+				 ndlp->nlp_DID, ndlp->nlp_state,
+				 ndlp->nlp_flag, ndlp->nlp_rpi);
+		goto out;
+	}
+
 	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
 			 (uint8_t *) sp, mbox, ndlp->nlp_rpi) == 0) {
 		switch (ndlp->nlp_DID) {
-- 
1.7.11.7

