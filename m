From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 58/87] scsi: mvsas: remove memset after dma_alloc_coherent
Date: Fri, 28 Jun 2019 01:43:53 +0800
Message-ID: <20190627174355.5252-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Allison Randal <allison@lohutok.net>, Johannes Thumshirn <jthumshirn@suse.de>, Thomas Gleixner <tglx@linutronix.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index da719b0694dc..f2fae160691d 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -241,19 +241,16 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 				     &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
-	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
 	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
 					 &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
 	mvi->rx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				     &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
-	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 	mvi->rx[0] = cpu_to_le32(0xfff);
 	mvi->rx_cons = 0xfff;
 
@@ -262,7 +259,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 				       &mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
-- 
2.11.0
