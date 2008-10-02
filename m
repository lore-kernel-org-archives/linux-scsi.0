From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [2/21] SCSI-ISA-DMA: Add blk_q_mask
Date: Thu,  2 Oct 2008 09:58:40 +0200 (CEST)
Message-ID: <20081002075840.1E5E13E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57077 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYJBH6m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:42 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


[Merge note: this patch will be in a SCSI patchkit and in the core
mask allocator patchkit. They are equivalent. If one of them 
is merged first simply drop it in the other]

Converts the queue bounce_pfn to a DMA mask suitable for the mask allocator

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/blkdev.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -890,6 +890,11 @@ static inline unsigned int block_size(st
 	return bdev->bd_block_size;
 }
 
+static inline u64 blk_q_mask(struct request_queue *q)
+{
+	return ~(-1LL << (PAGE_SHIFT + fls64(q->bounce_pfn)));
+}
+
 typedef struct {struct page *v;} Sector;
 
 unsigned char *read_dev_sector(struct block_device *, sector_t, Sector *);
