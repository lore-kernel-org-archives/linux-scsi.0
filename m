From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 2/2] scsi: Align block queue to dma_get_cache_alignment()
Date: Mon, 25 Sep 2017 17:46:06 +0800
Message-ID: <1506332766-23966-2-git-send-email-chenhc@lemote.com>
References: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Roland Dreier <rolandd@cisco.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>, Andy Gross <agross@codeaurora.org>, "Mark A . Greer" <mgreer@mv>
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
