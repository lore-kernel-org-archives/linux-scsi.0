From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 05/15] lpfc: Fix NVMEI driver not decrementing counter causing bad rport state.
Date: Wed, 10 May 2017 12:07:03 -0700
Message-ID: <20170510190713.30171-6-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34207 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753931AbdEJTHa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:30 -0400
Received: by mail-qk0-f193.google.com with SMTP id u75so726093qka.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:30 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

During driver boot, a latency in the NVMET driver
side causes the incoming NVMEI PRLI to get rejected by the
NVMET driver.  When this happens, the NVMEI driver runs
out of PRLI retries.  Bouncing the link does not fix the
situation.

If the NVMEI driver decides, on PRLI completion
failures, to retry the PRLI, always decrement the
fc4_prli_sent counter.  This allows the PRLI completion
to resolve to UNMAPPED when NVMET rejects the PRLI.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3f9f6d5f8c69..3085895464d9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2077,16 +2077,19 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (irsp->ulpStatus) {
 		/* Check for retry */
+		ndlp->fc4_prli_sent--;
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
-			ndlp->fc4_prli_sent--;
 			goto out;
 		}
+
 		/* PRLI failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "2754 PRLI failure DID:%06X Status:x%x/x%x\n",
+				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
+				 "data: x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
+				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
+
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (lpfc_error_lost_link(irsp))
 			goto out;
-- 
2.11.0
