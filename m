From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Fix hard lock up NMI in els timeout handling.
Date: Tue,  7 Nov 2017 12:59:02 -0800
Message-ID: <20171107205902.17352-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:43969 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933309AbdKGU7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 15:59:14 -0500
Received: by mail-qk0-f195.google.com with SMTP id 78so794979qkz.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 12:59:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

System crashed due to a hard lockup at lpfc_els_timeout_handler+0x128.

The els ring's txcmplq list is corrupted: the last element in the list
does not point back the the head causing a loop. Issue is the
els processing path for sli4 hbas are using the hbalock instead of
the ring_lock for removing elements from the txcmplq list.

Use the adapter SLI_REV to determine which lock should be used for
removing iocbqs from the els rings txcmplq.

note: the future refactoring will address this so that we don't have
this ugly type-based lock code.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1229f58bdd09..c1c7df607604 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2732,7 +2732,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  *
  * This function looks up the iocb_lookup table to get the command iocb
  * corresponding to the given response iocb using the iotag of the
- * response iocb. This function is called with the hbalock held.
+ * response iocb. This function is called with the hbalock held
+ * for sli3 devices or the ring_lock for sli4 devices.
  * This function returns the command iocb object if it finds the command
  * iocb else returns NULL.
  **/
@@ -2828,9 +2829,15 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	unsigned long iflag;
 
 	/* Based on the iotag field, get the cmd IOCB from the txcmplq */
-	spin_lock_irqsave(&phba->hbalock, iflag);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_lock_irqsave(&pring->ring_lock, iflag);
+	else
+		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		spin_unlock_irqrestore(&pring->ring_lock, iflag);
+	else
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	if (cmdiocbp) {
 		if (cmdiocbp->iocb_cmpl) {
-- 
2.13.1
