From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 14/17] lpfc: Correct panics with eh_timeout and
 eh_deadline
Date: Thu, 13 Oct 2016 15:06:15 -0700
Message-ID: <58000557.XB6b5rUlrmwRw04e%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([199.3.246.86]:36367 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753140AbcJMWHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:07:19 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id AA0901209D5
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct panics with eh_timeout and eh_deadline

We were having double completions on our SLI-3 version of adapters.
Solved by clearing our command pointer before calling scsi_done.

The eh paths potentially ran simulatenously and would see the non-null
value and invoke scsi_done again.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c |  6 +++---
 drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4c53149e..1b0ef79 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4142,13 +4142,13 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 
-	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
-	cmd->scsi_done(cmd);
-
 	spin_lock_irqsave(&phba->hbalock, flags);
 	lpfc_cmd->pCmd = NULL;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
+	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
+	cmd->scsi_done(cmd);
+
 	/*
 	 * If there is a thread waiting for command completion
 	 * wake up the thread.
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cb59f4e..27cbd68 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2677,15 +2677,16 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
-		list_del_init(&cmd_iocb->list);
 		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
+			/* remove from txcmpl queue list */
+			list_del_init(&cmd_iocb->list);
 			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
+			return cmd_iocb;
 		}
-		return cmd_iocb;
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"0317 iotag x%x is out off "
+			"0317 iotag x%x is out of "
 			"range: max iotag x%x wd0 x%x\n",
 			iotag, phba->sli.last_iotag,
 			*(((uint32_t *) &prspiocb->iocb) + 7));
@@ -2720,8 +2721,9 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			return cmd_iocb;
 		}
 	}
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"0372 iotag x%x is out off range: max iotag (x%x)\n",
+			"0372 iotag x%x is out of range: max iotag (x%x)\n",
 			iotag, phba->sli.last_iotag);
 	return NULL;
 }
@@ -11808,6 +11810,8 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 	/* Look up the ELS command IOCB and create pseudo response IOCB */
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+	/* Put the iocb back on the txcmplq */
+	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
 	if (unlikely(!cmdiocbq)) {
-- 
2.5.0


