From: Joerg Roedel <jroedel@suse.de>
Subject: Re: "iommu/amd: Set exclusion range correctly" causes smartpqi
 offline
Date: Mon, 6 May 2019 14:29:16 +0200
Message-ID: <20190506122916.GB3486@suse.de>
References: <1556290348.6132.6.camel@lca.pw>
 <ca40e139-3b0e-01db-b3c8-df0c1a04f9e6@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ca40e139-3b0e-01db-b3c8-df0c1a04f9e6@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: hch@lst.de, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, don.brace@microsemi.com, kevin.barnett@microsemi.com, scott.teel@microsemi.com, david.carroll@microsemi.com
List-Id: linux-scsi@vger.kernel.org

On Sun, May 05, 2019 at 10:56:28PM -0400, Qian Cai wrote:
> It turned out another linux-next commit is needed to reproduce this, i.e.,
> 7a5dbf3ab2f0 ("iommu/amd: Remove the leftover of bypass support"). Specifically,
> the chunks for map_sg() and unmap_sg(). This has been reproduced on 3 different
> HPE ProLiant DL385 Gen10 systems so far.
> 
> Either reverted the chunks (map_sg() and unmap_sg()) on the top of the latest
> linux-next fixed the issue or applied them on the top of the mainline v5.1
> reproduced it immediately.
> 
> Lots of time it triggered this BUG_ON(!iova) in iova_magazine_free_pfns()
> instead of the smartpqi offline.

Thanks a lot for tracking this down further. I queued a revert of the
above patch, as it does some questionable things I missed during review.
We should revisit the patch during the next cycle, but for now it is
better to just revert it. Revert attached.

>From 89736a0ee81d14439d085c8d4653bc1d86fe64d8 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Mon, 6 May 2019 14:24:18 +0200
Subject: [PATCH] Revert "iommu/amd: Remove the leftover of bypass support"

This reverts commit 7a5dbf3ab2f04905cf8468c66fcdbfb643068bcb.

This commit not only removes the leftovers of bypass
support, it also mostly removes the checking of the return
value of the get_domain() function. This can lead to silent
data corruption bugs when a device is not attached to its
dma_ops domain and a DMA-API function is called for that
device.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 80 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index bc98de5fa867..23c1a7eebb06 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2459,10 +2459,20 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 			   unsigned long attrs)
 {
 	phys_addr_t paddr = page_to_phys(page) + offset;
-	struct protection_domain *domain = get_domain(dev);
-	struct dma_ops_domain *dma_dom = to_dma_ops_domain(domain);
+	struct protection_domain *domain;
+	struct dma_ops_domain *dma_dom;
+	u64 dma_mask;
+
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL)
+		return (dma_addr_t)paddr;
+	else if (IS_ERR(domain))
+		return DMA_MAPPING_ERROR;
+
+	dma_mask = *dev->dma_mask;
+	dma_dom = to_dma_ops_domain(domain);
 
-	return __map_single(dev, dma_dom, paddr, size, dir, *dev->dma_mask);
+	return __map_single(dev, dma_dom, paddr, size, dir, dma_mask);
 }
 
 /*
@@ -2471,8 +2481,14 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 		       enum dma_data_direction dir, unsigned long attrs)
 {
-	struct protection_domain *domain = get_domain(dev);
-	struct dma_ops_domain *dma_dom = to_dma_ops_domain(domain);
+	struct protection_domain *domain;
+	struct dma_ops_domain *dma_dom;
+
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
+		return;
+
+	dma_dom = to_dma_ops_domain(domain);
 
 	__unmap_single(dma_dom, dma_addr, size, dir);
 }
@@ -2512,13 +2528,20 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 		  unsigned long attrs)
 {
 	int mapped_pages = 0, npages = 0, prot = 0, i;
-	struct protection_domain *domain = get_domain(dev);
-	struct dma_ops_domain *dma_dom = to_dma_ops_domain(domain);
+	struct protection_domain *domain;
+	struct dma_ops_domain *dma_dom;
 	struct scatterlist *s;
 	unsigned long address;
-	u64 dma_mask = *dev->dma_mask;
+	u64 dma_mask;
 	int ret;
 
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
+		return 0;
+
+	dma_dom  = to_dma_ops_domain(domain);
+	dma_mask = *dev->dma_mask;
+
 	npages = sg_num_pages(dev, sglist, nelems);
 
 	address = dma_ops_alloc_iova(dev, dma_dom, npages, dma_mask);
@@ -2592,11 +2615,20 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		     int nelems, enum dma_data_direction dir,
 		     unsigned long attrs)
 {
-	struct protection_domain *domain = get_domain(dev);
-	struct dma_ops_domain *dma_dom = to_dma_ops_domain(domain);
+	struct protection_domain *domain;
+	struct dma_ops_domain *dma_dom;
+	unsigned long startaddr;
+	int npages = 2;
+
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
+		return;
+
+	startaddr = sg_dma_address(sglist) & PAGE_MASK;
+	dma_dom   = to_dma_ops_domain(domain);
+	npages    = sg_num_pages(dev, sglist, nelems);
 
-	__unmap_single(dma_dom, sg_dma_address(sglist) & PAGE_MASK,
-			sg_num_pages(dev, sglist, nelems) << PAGE_SHIFT, dir);
+	__unmap_single(dma_dom, startaddr, npages << PAGE_SHIFT, dir);
 }
 
 /*
@@ -2607,11 +2639,16 @@ static void *alloc_coherent(struct device *dev, size_t size,
 			    unsigned long attrs)
 {
 	u64 dma_mask = dev->coherent_dma_mask;
-	struct protection_domain *domain = get_domain(dev);
+	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
 	struct page *page;
 
-	if (IS_ERR(domain))
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL) {
+		page = alloc_pages(flag, get_order(size));
+		*dma_addr = page_to_phys(page);
+		return page_address(page);
+	} else if (IS_ERR(domain))
 		return NULL;
 
 	dma_dom   = to_dma_ops_domain(domain);
@@ -2657,13 +2694,22 @@ static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr,
 			  unsigned long attrs)
 {
-	struct protection_domain *domain = get_domain(dev);
-	struct dma_ops_domain *dma_dom = to_dma_ops_domain(domain);
-	struct page *page = virt_to_page(virt_addr);
+	struct protection_domain *domain;
+	struct dma_ops_domain *dma_dom;
+	struct page *page;
 
+	page = virt_to_page(virt_addr);
 	size = PAGE_ALIGN(size);
 
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
+		goto free_mem;
+
+	dma_dom = to_dma_ops_domain(domain);
+
 	__unmap_single(dma_dom, dma_addr, size, DMA_BIDIRECTIONAL);
+
+free_mem:
 	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
 		__free_pages(page, get_order(size));
 }
-- 
2.16.4
