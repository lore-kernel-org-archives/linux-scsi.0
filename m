From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 3/3] scsi: Align queue to ARCH_DMA_MINALIGN in non-coherent DMA mode
Date: Fri, 15 Sep 2017 11:02:49 +0800
Message-ID: <1505444569-21379-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In non-coherent DMA mode, kernel uses cache flushing operations to
maintain I/O coherency, so scsi's block queue should be aligned to
ARCH_DMA_MINALIGN. Otherwise, it will cause data corruption, at least
on MIPS:

        Step 1, dma_map_single
        Step 2, cache_invalidate (no writeback)
        Step 3, dma_from_device
        Step 4, dma_unmap_single

If a DMA buffer and a kernel structure share a same cache line, and if
the kernel structure has dirty data, cache_invalidate (no writeback)
will cause data lost.

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
