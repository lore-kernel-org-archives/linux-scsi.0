From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 13/19] lpfc: Fix SCSI io host reset causing kernel crash
Date: Wed, 24 Jan 2018 14:45:42 -0800
Message-ID: <20180124224548.9530-14-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38614 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbeAXWqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:16 -0500
Received: by mail-qt0-f193.google.com with SMTP id z10so14662182qti.5
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:15 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

During SCSI error handling escalation to host reset, the SCSI io
routines were moved off the txcmplq, but the individual io's
ON_CMPLQ flag wasn't cleared.  Thus, a background thread saw the
io and attempted to access it as if on the txcmplq.

Clear the flag upon removal.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  4 ++++
 drivers/scsi/lpfc/lpfc_sli.c  | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 851d4e889042..7fc2db968379 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -958,6 +958,7 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 	LIST_HEAD(completions);
 	int i;
+	struct lpfc_iocbq *piocb, *next_iocb;
 
 	if (phba->sli_rev != LPFC_SLI_REV4) {
 		for (i = 0; i < psli->num_rings; i++) {
@@ -983,6 +984,9 @@ lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 		if (!pring)
 			continue;
 		spin_lock_irq(&pring->ring_lock);
+		list_for_each_entry_safe(piocb, next_iocb,
+					 &pring->txcmplq, list)
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		list_splice_init(&pring->txcmplq, &completions);
 		pring->txcmplq_cnt = 0;
 		spin_unlock_irq(&pring->ring_lock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8b2919a553d6..d597e15a1974 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3778,6 +3778,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 	uint32_t i;
+	struct lpfc_iocbq *piocb, *next_iocb;
 
 	spin_lock_irq(&phba->hbalock);
 	/* Indicate the I/O queues are flushed */
@@ -3792,6 +3793,9 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 			spin_lock_irq(&pring->ring_lock);
 			/* Retrieve everything on txq */
 			list_splice_init(&pring->txq, &txq);
+			list_for_each_entry_safe(piocb, next_iocb,
+						 &pring->txcmplq, list)
+				piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			/* Retrieve everything on the txcmplq */
 			list_splice_init(&pring->txcmplq, &txcmplq);
 			pring->txq_cnt = 0;
@@ -3813,6 +3817,9 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 		spin_lock_irq(&phba->hbalock);
 		/* Retrieve everything on txq */
 		list_splice_init(&pring->txq, &txq);
+		list_for_each_entry_safe(piocb, next_iocb,
+					 &pring->txcmplq, list)
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		/* Retrieve everything on the txcmplq */
 		list_splice_init(&pring->txcmplq, &txcmplq);
 		pring->txq_cnt = 0;
@@ -3844,6 +3851,7 @@ lpfc_sli_flush_nvme_rings(struct lpfc_hba *phba)
 	LIST_HEAD(txcmplq);
 	struct lpfc_sli_ring  *pring;
 	uint32_t i;
+	struct lpfc_iocbq *piocb, *next_iocb;
 
 	if (phba->sli_rev < LPFC_SLI_REV4)
 		return;
@@ -3860,8 +3868,11 @@ lpfc_sli_flush_nvme_rings(struct lpfc_hba *phba)
 	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
 		pring = phba->sli4_hba.nvme_wq[i]->pring;
 
-		/* Retrieve everything on the txcmplq */
 		spin_lock_irq(&pring->ring_lock);
+		list_for_each_entry_safe(piocb, next_iocb,
+					 &pring->txcmplq, list)
+			piocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
+		/* Retrieve everything on the txcmplq */
 		list_splice_init(&pring->txcmplq, &txcmplq);
 		pring->txcmplq_cnt = 0;
 		spin_unlock_irq(&pring->ring_lock);
-- 
2.13.1
