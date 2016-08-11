From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 11/14] lpfc: Fix crash on adapter reinit
Date: Thu, 11 Aug 2016 11:35:58 -0700
Message-ID: <57acc58e.tA8AOPGQuf/YmboW%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33533 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcHKSgC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:36:02 -0400
Received: by mail-qk0-f177.google.com with SMTP id t7so4361533qkh.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:36:01 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id w185sm955659qkd.23.2016.08.11.11.35.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:36:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix crash on adapter reinit

Had unset fields passed to pci_pool_destroy() on teardown.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 3fa6533..62b295d 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -254,11 +254,13 @@ lpfc_mem_free(struct lpfc_hba *phba)
 			      pool->elements[i].phys);
 	kfree(pool->elements);
 
-	pci_pool_destroy(phba->lpfc_mbuf_pool);
+	if (phba->lpfc_mbuf_pool)
+		pci_pool_destroy(phba->lpfc_mbuf_pool);
 	phba->lpfc_mbuf_pool = NULL;
 
 	/* Free DMA buffer memory pool */
-	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
+	if (phba->lpfc_scsi_dma_buf_pool)
+		pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
 	phba->lpfc_scsi_dma_buf_pool = NULL;
 
 	/* Free Device Data memory pool */
-- 
2.5.0

