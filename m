From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 67/87] scsi: bfa: remove memset after dma_alloc_coherent in bfad.c
Date: Fri, 28 Jun 2019 01:45:34 +0800
Message-ID: <20190627174534.6045-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/bfa/bfad.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 2f9213b257a4..39ac58337290 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -622,7 +622,6 @@ bfad_hal_mem_alloc(struct bfad_s *bfad)
 			goto ext;
 		}
 		dma_elem->dma = phys_addr;
-		memset(dma_elem->kva, 0, dma_elem->mem_len);
 	}
 ext:
 	return rc;
-- 
2.11.0
