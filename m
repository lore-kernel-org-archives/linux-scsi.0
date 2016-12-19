From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 09/11] lpfc: Correct oops on vport port resets
Date: Mon, 19 Dec 2016 14:35:31 -0800
Message-ID: <585860b3.wr4tFe+yOCvMWfLc%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp02.broadcom.com ([192.19.219.146]:40391 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933194AbcLSWkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:40:39 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 35EFF260006
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct oops on vport port resets. Incorrect WQE type, thus the clearing
code actually overstepped the WQE.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 47b5520..d0ffcf3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17219,7 +17219,8 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	unsigned long iflags = 0;
 	char *fail_msg = NULL;
 	struct lpfc_sglq *sglq;
-	union lpfc_wqe wqe;
+	union lpfc_wqe128 wqe128;
+	union lpfc_wqe *wqe = (union lpfc_wqe *) &wqe128;
 	uint32_t txq_cnt = 0;
 
 	spin_lock_irqsave(&pring->ring_lock, iflags);
@@ -17258,9 +17259,9 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		piocbq->sli4_xritag = sglq->sli4_xritag;
 		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocbq, sglq))
 			fail_msg = "to convert bpl to sgl";
-		else if (lpfc_sli4_iocb2wqe(phba, piocbq, &wqe))
+		else if (lpfc_sli4_iocb2wqe(phba, piocbq, wqe))
 			fail_msg = "to convert iocb to wqe";
-		else if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
+		else if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, wqe))
 			fail_msg = " - Wq is full";
 		else
 			lpfc_sli_ringtxcmpl_put(phba, pring, piocbq);
-- 
2.5.0


