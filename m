From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 03/11] x86: make pci-gart iommu respect the segment
 size limits
Date: Wed, 24 Oct 2007 19:48:10 +0900
Message-ID: <20071024165440D.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59915 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbXJXK5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:57:22 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp

This patch makes pci-gart iommu respect segment size limits when
merging sg lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c56e9ee..dfe3828 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -384,6 +384,8 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int start;
 	unsigned long pages = 0;
 	int need = 0, nextneed;
+	unsigned int seg_size;
+	unsigned int max_seg_size;
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 
 	if (nents == 0) 
@@ -395,6 +397,8 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	out = 0;
 	start = 0;
 	start_sg = sgmap = sg;
+	seg_size = 0;
+	max_seg_size = dma_get_max_seg_size(dev);
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = sg_phys(s);
@@ -408,11 +412,13 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			/* Can only merge when the last chunk ends on a page 
 			   boundary and the new one doesn't have an offset. */
 			if (!iommu_merge || !nextneed || !need || s->offset ||
+			    (s->length + seg_size > max_seg_size) ||
 			    (ps->offset + ps->length) % PAGE_SIZE) {
 				if (dma_map_cont(start_sg, i - start, sgmap,
 						  pages, need) < 0)
 					goto error;
 				out++;
+				seg_size = 0;
 				sgmap = sg_next(sgmap);
 				pages = 0;
 				start = i;
@@ -420,6 +426,7 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			}
 		}
 
+		seg_size += s->length;
 		need = nextneed;
 		pages += to_pages(s->offset, s->length);
 		ps = s;
-- 
1.5.2.4

