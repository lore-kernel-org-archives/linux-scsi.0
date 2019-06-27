From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 69/87] scsi: arcmsr: remove memset after dma_coherent in arcmsr_hba.c
Date: Fri, 28 Jun 2019 01:45:53 +0800
Message-ID: <20190627174554.6206-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, Geert Uytterhoeven <geert+renesas@glider.be>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 88053b15c363..a0d0dc83184f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -727,7 +727,6 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	}
 	acb->dma_coherent = dma_coherent;
 	acb->dma_coherent_handle = dma_coherent_handle;
-	memset(dma_coherent, 0, acb->uncache_size);
 	acb->ccbsize = roundup_ccbsize;
 	ccb_tmp = dma_coherent;
 	curr_phy_upper32 = upper_32_bits(dma_coherent_handle);
-- 
2.11.0
