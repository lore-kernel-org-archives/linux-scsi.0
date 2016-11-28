From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: lpfc: Replace pci_pool_alloc by pci_pool_zalloc
Date: Mon, 28 Nov 2016 15:22:37 +0530
Message-ID: <20161128095237.GA30900@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35987 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753329AbcK1Jwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2016 04:52:41 -0500
Received: by mail-pg0-f68.google.com with SMTP id x23so12710211pgx.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 01:52:41 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com
Cc: linux-scsi@vger.kernel.org

In lpfc_new_scsi_buf_s3() and lpfc_new_scsi_buf_s4() pci_pool_alloc
followed by memset will be replaced by pci_pool_zalloc()

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d197aa1..58851c7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -413,15 +413,13 @@ struct scsi_dif_tuple {
 		 * struct fcp_cmnd, struct fcp_rsp and the number of bde's
 		 * necessary to support the sg_tablesize.
 		 */
-		psb->data = pci_pool_alloc(phba->lpfc_scsi_dma_buf_pool,
+		psb->data = pci_pool_zalloc(phba->lpfc_scsi_dma_buf_pool,
 					GFP_KERNEL, &psb->dma_handle);
 		if (!psb->data) {
 			kfree(psb);
 			break;
 		}
 
-		/* Initialize virtual ptrs to dma_buf region. */
-		memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
 
 		/* Allocate iotag for psb->cur_iocbq. */
 		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
@@ -821,13 +819,12 @@ struct scsi_dif_tuple {
 		 * for the struct fcp_cmnd, struct fcp_rsp and the number
 		 * of bde's necessary to support the sg_tablesize.
 		 */
-		psb->data = pci_pool_alloc(phba->lpfc_scsi_dma_buf_pool,
+		psb->data = pci_pool_zalloc(phba->lpfc_scsi_dma_buf_pool,
 						GFP_KERNEL, &psb->dma_handle);
 		if (!psb->data) {
 			kfree(psb);
 			break;
 		}
-		memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
 
 		/*
 		 * 4K Page alignment is CRITICAL to BlockGuard, double check
-- 
1.9.1


