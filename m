From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 3/3] scsi: Align queue to ARCH_DMA_MINALIGN in non-coherent DMA mode
Date: Tue, 12 Sep 2017 15:08:23 +0800
Message-ID: <1505200104-24667-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In non-coherent DMA mode, kernel uses cache flushing operations to
maintain I/O coherency, so scsi's block queue should be aligned to
ARCH_DMA_MINALIGN.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/scsi/scsi_lib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80..79433ad 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2132,11 +2132,14 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		q->limits.cluster = 0;
 
 	/*
-	 * set a reasonable default alignment on word boundaries: the
-	 * host and device may alter it using
+	 * set a reasonable default alignment on word/cacheline boundaries:
+	 * the host and device may alter it using
 	 * blk_queue_update_dma_alignment() later.
 	 */
-	blk_queue_dma_alignment(q, 0x03);
+	if (plat_device_is_coherent(dev))
+		blk_queue_dma_alignment(q, 0x04 - 1);
+	else
+		blk_queue_dma_alignment(q, dma_get_cache_alignment() - 1);
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
-- 
2.7.0
