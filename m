From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 01/19] lpfc: Fix crash in pci hot plug situations
Date: Thu, 21 Sep 2017 23:17:23 -0700
Message-ID: <20170922061741.12347-2-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36694 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdIVGR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:17:57 -0400
Received: by mail-pg0-f67.google.com with SMTP id d8so120443pgt.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:17:56 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

During pci hot plug scenarios the driver had two issues:

a) oops in a list_add call

The lookup by tag function will return null if the IOCB is out of
range or does not have the on txcmplq flag set.

Fix: Check for null return from lookup by tag.

b) oops in kernels timer management code

The sli4 remove_one handler is not stoping the timers as it starts to
remove the port so that it can be swapped.

Fix: Stop the timers early in the routine.
Note: Fix in SLI-4 only. SLI-3 already stopped the timers properly.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  1 +
 drivers/scsi/lpfc/lpfc_sli.c  | 17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7e7ae786121b..1773b9ce3149 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11419,6 +11419,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	lpfc_debugfs_terminate(vport);
 	lpfc_sli4_hba_unset(phba);
 
+	lpfc_stop_hba_timers(phba);
 	spin_lock_irq(&phba->hbalock);
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8b119f87b51d..b8513c1adcef 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12507,19 +12507,21 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 	/* Look up the ELS command IOCB and create pseudo response IOCB */
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
-	/* Put the iocb back on the txcmplq */
-	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
-	spin_unlock_irqrestore(&pring->ring_lock, iflags);
-
 	if (unlikely(!cmdiocbq)) {
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0386 ELS complete with no corresponding "
-				"cmdiocb: iotag (%d)\n",
-				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+				"cmdiocb: 0x%x 0x%x 0x%x 0x%x\n",
+				wcqe->word0, wcqe->total_data_placed,
+				wcqe->parameter, wcqe->word3);
 		lpfc_sli_release_iocbq(phba, irspiocbq);
 		return NULL;
 	}
 
+	/* Put the iocb back on the txcmplq */
+	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
+
 	/* Fake the irspiocbq and copy necessary response information */
 	lpfc_sli4_iocb_param_transfer(phba, irspiocbq, cmdiocbq, wcqe);
 
@@ -17137,7 +17139,8 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 	if (pcmd && pcmd->virt)
 		dma_pool_free(phba->lpfc_drb_pool, pcmd->virt, pcmd->phys);
 	kfree(pcmd);
-	lpfc_sli_release_iocbq(phba, iocbq);
+	if (iocbq)
+		lpfc_sli_release_iocbq(phba, iocbq);
 	lpfc_in_buf_free(phba, &dmabuf->dbuf);
 }
 
-- 
2.13.1
