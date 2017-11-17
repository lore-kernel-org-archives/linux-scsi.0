From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V10 3/4] scsi: Align block queue to dma_get_cache_alignment()
Date: Fri, 17 Nov 2017 12:30:05 +0800
Message-ID: <1510893005-325-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44636 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932695AbdKQEaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2017 23:30:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>

In non-coherent DMA mode, kernel uses cache flushing operations to
maintain I/O coherency, so scsi's block queue should be aligned to
ARCH_DMA_MINALIGN. Otherwise, If a DMA buffer and a kernel structure
share a same cache line, and if the kernel structure has dirty data,
cache_invalidate (no writeback) will cause data corruption.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/scsi/scsi_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1cbc497..cc4ac97 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2148,11 +2148,11 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
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
