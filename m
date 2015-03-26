From: Mark Hounschell <markh@compro.net>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Thu, 26 Mar 2015 10:58:15 -0400
Message-ID: <55141E87.8040506@compro.net>
References: <54E1FFFA.1060403@compro.net> <54F60D33.8090401@compro.net> <20150323150304.GQ4441@8bytes.org> <5511513D.6090106@compro.net> <20150325135937.GR4441@8bytes.org> <20150325151332.GT4441@8bytes.org> <5512E412.9040807@compro.net> <20150326124559.GV4441@8bytes.org>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150326124559.GV4441@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org >> SCSI development list" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Joerg,

On 03/26/2015 08:45 AM, Joerg Roedel wrote:
> On Wed, Mar 25, 2015 at 12:36:34PM -0400, Mark Hounschell wrote:
>> BTW, so far the first 2 patches are working well. I was going to
>> wait until the end of the day to report but so far I have been
>> unable to produce the problems I was seeing. And I am in the middle
>> of some driver work so lots of unloading/loading going on.
> 
> Great, thanks. Please let me know when you have test results for the
> other patches too.
> 
> 
> 	Joerg
 
Sorry but CMA was still badly broken. I have a patch below that works.
I've tested it with small (no CMA) and large (with CMA) dma's using
dma_alloc_coherent. The patch below is just the "git diff" from your
cloned tree piped to a file then copied into this email. If you require
an official patch I can send one. Just let me know.

Also, in my opinion, this CMA thing is clearly a BUG not a feature
request. The AMD iommu clearly breaks CMA. I feel what ever fix
you are happy with should be back ported to stable.

Regards
Mark 

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a0197d0..5ea4fed 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2917,28 +2917,36 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	u64 dma_mask = dev->coherent_dma_mask;
 	struct protection_domain *domain;
 	unsigned long flags;
-	struct page *page;
+	struct page *page = 0;
+	int order;
+	unsigned int count;
+
+	size = PAGE_ALIGN(size);
+	order = get_order(size);
+	count = size >> PAGE_SHIFT;
 
 	INC_STATS_COUNTER(cnt_alloc_coherent);
 
 	domain = get_domain(dev);
 	if (PTR_ERR(domain) == -EINVAL) {
-		page = alloc_pages(flag, get_order(size));
+		page = alloc_pages(flag, order);
 		*dma_addr = page_to_phys(page);
 		return page_address(page);
 	} else if (IS_ERR(domain))
 		return NULL;
 
-	dma_mask  = dev->coherent_dma_mask;
 	flag     &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	flag     |= __GFP_ZERO;
 
-	page = alloc_pages(flag, get_order(size));
+	if (flag & __GFP_WAIT) {
+		page = dma_alloc_from_contiguous(dev, count, order);
+		if (page && page_to_phys(page) + size > dma_mask) {
+			dma_release_from_contiguous(dev, page, count);
+			page = NULL;
+		}
+	}
 	if (!page) {
-		if (!(flag & __GFP_WAIT))
-			return NULL;
-
-		page = dma_alloc_from_contiguous(dev, size >> PAGE_SHIFT,
-						 get_order(size));
+		page = alloc_pages(flag, order);
 		if (!page)
 			return NULL;
 	}
@@ -2951,7 +2959,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	*dma_addr = __map_single(dev, domain->priv, page_to_phys(page),
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
-	if (*dma_addr == DMA_ERROR_CODE) {
+	if (!dma_addr || (*dma_addr == DMA_ERROR_CODE)) {
 		spin_unlock_irqrestore(&domain->lock, flags);
 		goto out_free;
 	}
@@ -2965,7 +2973,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 out_free:
 
 	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
-		__free_pages(page, get_order(size));
+		__free_pages(page, order);
 
 	return NULL;
 }
@@ -2979,6 +2987,11 @@ static void free_coherent(struct device *dev, size_t size,
 {
 	unsigned long flags;
 	struct protection_domain *domain;
+	int order;
+	struct page *page = virt_to_page(virt_addr);
+
+	size = PAGE_ALIGN(size);
+	order = get_order(size);
 
 	INC_STATS_COUNTER(cnt_free_coherent);
 
@@ -2995,7 +3008,9 @@ static void free_coherent(struct device *dev, size_t size,
 	spin_unlock_irqrestore(&domain->lock, flags);
 
 free_mem:
-	free_pages((unsigned long)virt_addr, get_order(size));
+	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
+		__free_pages(page, order);
+
 }
 
 /*
