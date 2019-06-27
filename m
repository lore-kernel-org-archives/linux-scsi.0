From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 61/87] scsi: lpfc: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:44:31 +0800
Message-ID: <20190627174431.5520-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index eaaef682de25..c3cca3be87f1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7770,8 +7770,6 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_els_hbq_free;
 
-	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
-
 	phba->MBslimaddr = phba->slim_memmap_p;
 	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
 	phba->CAregaddr = phba->ctrl_regs_memmap_p + CA_REG_OFFSET;
-- 
2.11.0
