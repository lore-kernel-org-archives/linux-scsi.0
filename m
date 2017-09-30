From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 02/21] lpfc: fix pci hot plug crash in list_add call
Date: Fri, 29 Sep 2017 17:34:28 -0700
Message-ID: <20170930003447.10747-3-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:47060 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752571AbdI3Ae6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:34:58 -0400
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, stable@vger.kernel.org, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

During pci hot plug, the kernel crashes in a list_add_call

The lookup by tag function will return null if the IOCB is out of
range or does not have the on txcmplq flag set.

Fix: Check for null return from lookup by tag.

Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v2: original v1 hot plug patch split into 2 patches

 drivers/scsi/lpfc/lpfc_sli.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

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
