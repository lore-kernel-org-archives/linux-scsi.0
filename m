From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
	non-contiguous descriptors
Date: Thu, 17 Jan 2013 10:47:41 +0000
Message-ID: <20130117104741.GY23505@n2100.arm.linux.org.uk>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org> <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com> <50F64AC1.3040304@codeaurora.org> <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com> <20130116231857.GU2668@htj.dyndns.org> <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com> <20130117103742.GX23505@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130117103742.GX23505@n2100.arm.linux.org.uk>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Tejun Heo <tj@kernel.org>, asias@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 17, 2013 at 10:37:42AM +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 17, 2013 at 09:11:20AM +0000, James Bottomley wrote:
> > I'd actually prefer page = pfn_to_page(page_to_pfn(page) + 1); because
> > it makes the code look like the hack it is.  The preferred form for all
> > iterators like this should be to iterate over the pfn instead of a
> > pointer into the page arrays, because that will always work correctly no
> > matter how many weird and wonderful memory schemes we come up with.
> 
> So, why don't we update the code to do that then?

Also, couldn't the addition of the scatterlist offset to the page also
be buggy too?

So, what about this patch which addresses both additions by keeping our
iterator as a pfn as you suggest.  It also simplifies some of the code
in the loop too.

Can the original folk with the problem test this patch?

 arch/arm/mm/dma-mapping.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 6b2fb87..076c26d 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -774,25 +774,27 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 	size_t size, enum dma_data_direction dir,
 	void (*op)(const void *, size_t, int))
 {
+	unsigned long pfn;
+	size_t left = size;
+
+	pfn = page_to_pfn(page) + offset / PAGE_SIZE;
+	offset %= PAGE_SIZE;
+
 	/*
 	 * A single sg entry may refer to multiple physically contiguous
 	 * pages.  But we still need to process highmem pages individually.
 	 * If highmem is not configured then the bulk of this loop gets
 	 * optimized out.
 	 */
-	size_t left = size;
 	do {
 		size_t len = left;
 		void *vaddr;
 
+		page = pfn_to_page(pfn);
+
 		if (PageHighMem(page)) {
-			if (len + offset > PAGE_SIZE) {
-				if (offset >= PAGE_SIZE) {
-					page += offset / PAGE_SIZE;
-					offset %= PAGE_SIZE;
-				}
+			if (len + offset > PAGE_SIZE)
 				len = PAGE_SIZE - offset;
-			}
 			vaddr = kmap_high_get(page);
 			if (vaddr) {
 				vaddr += offset;
@@ -809,7 +811,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 			op(vaddr, len, dir);
 		}
 		offset = 0;
-		page++;
+		pfn++;
 		left -= len;
 	} while (left);
 }
