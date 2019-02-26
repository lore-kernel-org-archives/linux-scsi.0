From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] scsi: lpfc: ensure error is set to -ENODEV on failing exit paths
Date: Tue, 26 Feb 2019 13:41:21 +0000
Message-ID: <20190226134121.23650-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A previous commit assigned error to the return value from the call to
dma_set_mask_and_coherent and on the non-failure path error is zero. The
subsequent error return paths now return 0 instead of -ENODEV causing
failures to now be ignored.  Fix this by setting error to -ENODEV before
these exit paths. This is indentical to an earlier fix in function
lpfc_sli_pci_mem_setup but accidentally omitted for the function
lpfc_sli4_pci_mem_setup.

Detected by cppcheck ("(warning) Identical condition 'error', second
condition is always false")

Fixes: 56de8357049c ("scsi: lpfc: fix calls to dma_set_mask_and_coherent()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3b5873f6751e..e88c606317e1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10064,6 +10064,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		error = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (error)
 		return error;
+	error = -ENODEV;
 
 	/*
 	 * The BARs and register set definitions and offset locations are
-- 
2.20.1
