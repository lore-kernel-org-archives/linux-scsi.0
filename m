From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Fix uses of dma_max_pfn() when converting to a
	limiting address
Date: Thu, 13 Feb 2014 20:01:12 +0000
Message-ID: <20140213200112.GF30257@n2100.arm.linux.org.uk>
References: <E1WDH7v-00038J-2k@rmk-PC.arm.linux.org.uk> <1392310690.2175.13.camel@dabdike.int.hansenpartnership.com> <20140213171117.GA30257@n2100.arm.linux.org.uk> <1392314821.2175.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392314821.2175.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-mmc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2014 at 10:07:01AM -0800, James Bottomley wrote:
> On Thu, 2014-02-13 at 17:11 +0000, Russell King - ARM Linux wrote:
> > On Thu, Feb 13, 2014 at 08:58:10AM -0800, James Bottomley wrote:
> > > This doesn't really look like the right fix.  You replaced dev->dma_mask
> > > with a calculation on dev_max_pfn().  Since dev->dma_mask is always u64
> > > and dev_max_pfn is supposed to be returning the pfn of the dma_mask, it
> > > should unconditionally be 64 bits as well.  Either that or it should
> > > return dma_addr_t.
> > 
> > My reasoning is that PFNs in the system are always of type "unsigned long"
> > and therefore a function returning a pfn should have that type.  If we
> > overflow a PFN fitting in an unsigned long, we have lots of places which
> > need fixing.
> 
> It's not intuitive to people who need the dma mask that they're supposed
> to use dma_max_pfn() << PAGE_SHIFT but now they have to worry about the
> casting and, if they don't get it right, nothing will warn or tell them.
> what about a new macro, say dma_max_mask(dev) that just returns
> (u64)dma_max_pfn() << PAGE_SHIFT?

This sounds like a good idea.

I've just been looking at places which do this << PAGE_SHIFT, and we
have other places which suffer from this same bug all over the kernel,
so maybe we actually need a pfn_to_addr() macro or similar so that
people get this right in these other places too?  It appears to be
quite a widespread problem.

I'm surprised none of the below haven't already caused a problem.

Thoughts?

int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
                 unsigned long nr_pages)
{
        resource_size_t start, size;

        start = phys_start_pfn << PAGE_SHIFT;

void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
                unsigned long start_pfn, enum memmap_context context)
{
        unsigned long end_pfn = start_pfn + size;
        unsigned long pfn;

                /* The shift won't overflow because ZONE_NORMAL is below 4G. */
                if (!is_highmem_idx(zone))
                        set_page_address(page, __va(pfn << PAGE_SHIFT));

void __init free_area_init_nodes(unsigned long *max_zone_pfn)
{
        unsigned long start_pfn, end_pfn;

        for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
                printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
                       start_pfn << PAGE_SHIFT, (end_pfn << PAGE_SHIFT) - 1);
(thankfully, this one is just a printk).

int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
                           struct vm_area_struct **res_vma, dma_addr_t *res_pa)
{
        unsigned long this_pfn, prev_pfn;
        dma_addr_t pa = 0;

                if (prev_pfn == 0)
                        pa = this_pfn << PAGE_SHIFT;

static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
                                     unsigned long size, pgprot_t vma_prot)
{
#ifdef pgprot_noncached
        phys_addr_t offset = pfn << PAGE_SHIFT;

        if (uncached_access(file, offset))
                return pgprot_noncached(vma_prot);
#endif
        return vma_prot;

static int i810_insert_dcache_entries(struct agp_memory *mem, off_t pg_start,
                                      int type)
{
        int i;

        for (i = pg_start; i < (pg_start + mem->page_count); i++) {
                dma_addr_t addr = i << PAGE_SHIFT;


-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
