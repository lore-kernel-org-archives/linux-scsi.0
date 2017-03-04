From: jsmart2021@gmail.com
Subject: [PATCH 03/20] scsi: lpfc: don't dereference dma_buf->iocbq before null check
Date: Sat,  4 Mar 2017 09:30:23 -0800
Message-ID: <1488648640-5170-4-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33848 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbdCDRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:30:59 -0500
Received: by mail-qk0-f194.google.com with SMTP id g129so6383314qkd.1
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:51 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Colin Ian King <colin.king@canonical.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

From: Colin Ian King <colin.king@canonical.com>

dma_buf->iocbq is being dereferenced immediately before it is
being null checked, so we have a potential null pointer dereference
bug.  Fix this by only dereferencing it only once we have passed
a null check on the pointer.

Detected by CoverityScan, CID#1411652 ("Dereference before null check")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index c61d8d6..5986c79 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -646,7 +646,6 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 	}
 
 	dma_buf->iocbq = lpfc_sli_get_iocbq(phba);
-	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
 	if (!dma_buf->iocbq) {
 		kfree(dma_buf->context);
 		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
@@ -658,6 +657,7 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 				"2621 Ran out of nvmet iocb/WQEs\n");
 		return NULL;
 	}
+	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
 	nvmewqe = dma_buf->iocbq;
 	wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
 	/* Initialize WQE */
-- 
2.5.0
