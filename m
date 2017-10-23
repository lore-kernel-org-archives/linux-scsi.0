From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V9 3/4] scsi: Align block queue to dma_get_cache_alignment()
Date: Mon, 23 Oct 2017 15:12:46 +0800
Message-ID: <1508742767-28366-3-git-send-email-chenhc@lemote.com>
References: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In non-coherent DMA mode, kernel uses cache flushing operations to
maintain I/O coherency, so scsi's block queue should be aligned to
ARCH_DMA_MINALIGN. Otherwise, If a DMA buffer and a kernel structure
share a same cache line, and if the kernel structure has dirty data,
cache_invalidate (no writeback) will cause data corruption.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/scsi/scsi_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80..19abc2e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2132,11 +2132,11 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		q->limits.cluster = 0;
 
 	/*
-	 * set a reasonable default alignment on word boundaries: the
-	 * host and device may alter it using
+	 * set a reasonable default alignment on word/cacheline boundaries:
+	 * the host and device may alter it using
 	 * blk_queue_update_dma_alignment() later.
 	 */
-	blk_queue_dma_alignment(q, 0x03);
+	blk_queue_dma_alignment(q, max(4, dma_get_cache_alignment(dev)) - 1);
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
-- 
2.7.0
