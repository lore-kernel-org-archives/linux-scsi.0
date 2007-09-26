From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 5/5] x86-64: pci-gart iommu uses max_segment_size
Date: Wed, 26 Sep 2007 17:58:03 +0900
Message-ID: <20070925142201H.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:39664 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbXIZI6e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 04:58:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

This enables pci-gart iommu to merge sg lists properly about lld's max
segment size limit.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86_64/kernel/pci-gart.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 4918c57..be98341 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -381,6 +381,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 	int start;
 	unsigned long pages = 0;
 	int need = 0, nextneed;
+	unsigned len;
 
 	if (nents == 0) 
 		return 0;
@@ -390,6 +391,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 	out = 0;
 	start = 0;
+	len = 0;
 	for (i = 0; i < nents; i++) {
 		struct scatterlist *s = &sg[i];
 		dma_addr_t addr = page_to_phys(s->page) + s->offset;
@@ -404,16 +406,20 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 			/* Can only merge when the last chunk ends on a page 
 			   boundary and the new one doesn't have an offset. */
 			if (!iommu_merge || !nextneed || !need || s->offset ||
+			    (dev->max_segment_size &&
+			     dev->max_segment_size < s->length + len) ||
 			    (ps->offset + ps->length) % PAGE_SIZE) { 
 				if (dma_map_cont(sg, start, i, sg+out, pages,
 						 need) < 0)
 					goto error;
 				out++;
+				len = 0;
 				pages = 0;
 				start = i;	
 			}
 		}
 
+		len += s->length;
 		need = nextneed;
 		pages += to_pages(s->offset, s->length);
 	}
-- 
1.5.2.4

