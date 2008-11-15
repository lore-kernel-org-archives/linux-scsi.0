From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [2/21] Add blk_q_mask
Date: Sun, 16 Nov 2008 00:11:02 +0100 (CET)
Message-ID: <20081115231102.54DF53E661A@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYKOXLB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:01 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


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
--- linux.orig/include/linux/blkdev.h	2008-11-15 22:37:12.000000000 +0100
+++ linux/include/linux/blkdev.h	2008-11-15 22:37:12.000000000 +0100
@@ -966,6 +966,11 @@
 	return bdev->bd_block_size;
 }
 
+static inline u64 blk_q_mask(struct request_queue *q)
+{
+	return ~(-1LL << (PAGE_SHIFT + fls64(q->bounce_pfn)));
+}
+
 typedef struct {struct page *v;} Sector;
 
 unsigned char *read_dev_sector(struct block_device *, sector_t, Sector *);
