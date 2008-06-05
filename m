From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Thu, 5 Jun 2008 23:49:12 +0900
Message-ID: <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	<da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49732 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbYFEOvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2008 10:51:45 -0400
In-Reply-To: <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: grundler@google.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Wed, 4 Jun 2008 11:06:15 -0700
"Grant Grundler" <grundler@google.com> wrote:

> On Wed, Jun 4, 2008 at 7:47 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> ...
> > Now I try to fix Intel IOMMU code, the free space management
> > algorithm.
> >
> > The major difference between Intel IOMMU code and the others is Intel
> > IOMMU code uses Red Black tree to manage free space while the others
> > use bitmap (swiotlb is the only exception).
> >
> > The Red Black tree method consumes less memory than the bitmap method,
> > but it incurs more overheads (the RB tree method needs to walk through
> > the tree, allocates a new item, and insert it every time it maps an
> > I/O address). Intel IOMMU (and IOMMUs for virtualization) needs
> > multiple IOMMU address spaces. That's why the Red Black tree method is
> > chosen, I guess.
> 
> It's possible to split up one flat address space and share the IOMMU
> among several users. Each user gets her own segment of bitmap and
> corresponding IO Pdir. So I don't see allocation policy as a strong reason
> to use Red/Black Tree.
> 
> I suspect R/B tree was chosen becuase they expected a host VM to allocate
> one large "static" entry for a guest OS and the guest would manage that range
> itself. R/B Tree seems like a very efficient way to handle that from the host
> VM point of view.

Good point, it would be more appropriate to evaluate the performances
of such workload rather than simple I/Os.

I'm interested in what workload Intel people played with and why they
chose RB tree.


> > Half a year ago, I tried to convert POWER IOMMU code to use the Red
> > Black method and saw performance drop:
> >
> > http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg00650.html
> >
> > So I tried to convert Intel IOMMU code to use the bitmap method to see
> > how much I can get.
> >
> > I didn't see noticable performance differences with 1GbE. So I tried
> > the modified driver of a SCSI HBA that just does memory accesses to
> > emulate the performances of SSD disk drives, 10GbE, Infiniband, etc.
> 
> You can easily emulate SSD drives by doing sequential 4K reads
> from a normal SATA HD. That should result in ~7-8K IOPS since the disk
> will recognize the sequential stream and read ahead. SAS/SCSI/FC will
> probably work the same way with different IOP rates.

Yeah, probabaly right. I thought that 10GbE give the IOMMU more
workloads than SSD does and tried to emulate something like that.


> > I got the following results with one thread issuing 1KB I/Os:
> >
> >                    IOPS (I/O per second)
> > IOMMU disabled         145253.1 (1.000)
> > RB tree (mainline)     118313.0 (0.814)
> > Bitmap                 128954.1 (0.887)
> 
> Just to make this clear, this is a 10% performance difference.
> 
> But a second metric is more telling: CPU utilization.
> How much time was spent in the IOMMU code for each
> implementation with the same workload?
> 
> This isn't a demand for that information but just a request
> to measure that in any future benchmarking.
> oprofile or perfmon2 are the best tools to determine that.

OK, I'll try next time.


> > I've attached the patch to modify Intel IOMMU code to use the bitmap
> > method but I have no intention of arguing that Intel IOMMU code
> > consumes more memory for better performance. :) I want to do more
> > performance tests with 10GbE (probably, I have to wait for a server
> > box having VT-d, which is not available on the market now).
> 
> 
> > As I said, what I want to do now is to make Intel IOMMU code respect
> > drivers' DMA alignment. Well, it's easier to do that if Intel IOMMU
> > uses the bitmap method since I can simply convert the IOMMU code to
> > use lib/iommu-helper but I can modify the RB tree method too.
> 
> Just as important as the allocation data structure is the allocation policy.
> The allocation policy will perform best if it matches the IO TLB
> replacement implemented in the IOMMU HW. Thrashing the IO TLB
> by allocating aliases to competing streams will hurt perf as well.
> Obviously a single benchmark is unlikely to detect this.

Agreed.


> > I'm just interested in other people's opinions on IOMMU
> > implementations, performances, possible future changes for performance
> > improvement, etc.
> >
> > For further information:
> >
> > LSF'08 "Storage Track" summary by Grant Grundler:
> > http://iou.parisc-linux.org/lsf2008/SUMMARY-Storage.txt
> >
> > My LSF'08 slides:
> > http://iou.parisc-linux.org/lsf2008/IO-DMA_Representations-fujita_tomonori.pdf
> 
> I personally found this to be one of the more interesting talks :)
> Excellent work!

Thanks! I think that the summary is excellent too :)


> > Tis patch is against the latst git tree (note that it just converts
> > Intel IOMMU code to use the bitmap. It doesn't make it respect
> > drivers' DMA alignment yet).
> ...
> 
> 
> > diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> > index f941f60..41ad545 100644
> > --- a/drivers/pci/dmar.c
> > +++ b/drivers/pci/dmar.c
> > @@ -26,7 +26,6 @@
> >
> >  #include <linux/pci.h>
> >  #include <linux/dmar.h>
> > -#include "iova.h"
> >  #include "intel-iommu.h"
> >
> >  #undef PREFIX
> > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > index 66c0fd2..839363a 100644
> > --- a/drivers/pci/intel-iommu.c
> > +++ b/drivers/pci/intel-iommu.c
> > @@ -32,8 +32,7 @@
> >  #include <linux/dmar.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/mempool.h>
> > -#include <linux/timer.h>
> > -#include "iova.h"
> > +#include <linux/iommu-helper.h>
> >  #include "intel-iommu.h"
> >  #include <asm/proto.h> /* force_iommu in this header in x86-64*/
> >  #include <asm/cacheflush.h>
> > @@ -51,33 +50,15 @@
> >
> >  #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
> >
> > -#define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
> > -
> > -
> > -static void flush_unmaps_timeout(unsigned long data);
> > +#define DMA_ERROR_CODE (~(dma_addr_t)0x0)
> >
> > -DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
> > +#define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
> >
> >  static struct intel_iommu *g_iommus;
> >
> > -#define HIGH_WATER_MARK 250
> > -struct deferred_flush_tables {
> > -       int next;
> > -       struct iova *iova[HIGH_WATER_MARK];
> > -       struct dmar_domain *domain[HIGH_WATER_MARK];
> > -};
> 
> Sorry, I didn't see a replacement for the deferred_flush_tables.
> Mark Gross and I agree this substantially helps with unmap performance.
> See http://lkml.org/lkml/2008/3/3/373

Yeah, I can add a nice trick in parisc sba_iommu uses. I'll try next
time.

But it probably gives the bitmap method less gain than the RB tree
since clear the bitmap takes less time than changing the tree.

The deferred_flush_tables also batches flushing TLB. The patch flushes
TLB only when it reaches the end of the bitmap (it's a trick that some
IOMMUs like SPARC does).


> ...
> >  static void dmar_init_reserved_ranges(void)
> >  {
> >        struct pci_dev *pdev = NULL;
> > -       struct iova *iova;
> >        int i;
> >        u64 addr, size;
> >
> > -       init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
> > +       reserved_it_size = 1UL << (32 - PAGE_SHIFT_4K);
> 
> Can you make reserved_it_size a module or kernel parameter?
> 
> I've never been able to come up with a good heuristic
> for determining the size of the IOVA space. It generally
> does NOT need to map all of Host Physical RAM.
> The actual requirement depends entirely on the workload,
> type and number of IO devices installed. The problem is we
> don't know any of those things until well after the IOMMU
> is already needed.

Agreed. VT-d can handle DMA virtual address space larger than 32 bits
but it means that we need more memory for the bitmap. I think that the
majority of systems don't need DMA virtual address space larger than
32 bits. Making it as a kernel parameter is a reasonable approach, I
think.


> > +       reserved_it_map = kzalloc(reserved_it_size / BITS_PER_BYTE, GFP_ATOMIC);
> > +       BUG_ON(!reserved_it_map);
> >
> >        lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
> >                &reserved_alloc_key);
> >        lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
> >                &reserved_rbtree_key);
> >
> > +       reserve_area(reserved_it_map, 0, IOVA_PFN(IOVA_START_ADDR));
> > +
> >        /* IOAPIC ranges shouldn't be accessed by DMA */
> > -       iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
> > -               IOVA_PFN(IOAPIC_RANGE_END));
> > -       if (!iova)
> > -               printk(KERN_ERR "Reserve IOAPIC range failed\n");
> > +       reserve_area(reserved_it_map, IOVA_PFN(IOAPIC_RANGE_START),
> > +                    IOVA_PFN(IOAPIC_RANGE_END));
> >
> >        /* Reserve all PCI MMIO to avoid peer-to-peer access */
> >        for_each_pci_dev(pdev) {
> 
> I didn't check....but reserving MMIO address space might be better done
> by looking at MMIO ranges routed by  all the top level PCI Host-bus controllers
> (aka PCI-e Root ports). Maybe this is an idea for Mark Gross to implement.

Calgary IOMMU code does the similar stuff, but I'm not sure. Anyway,
as you said, it's about what Mark might be interested in.


> > -static void domain_reserve_special_ranges(struct dmar_domain *domain)
> > -{
> > -       copy_reserved_iova(&reserved_iova_list, &domain->iovad);
> >  }
> >
> >  static inline int guestwidth_to_adjustwidth(int gaw)
> > @@ -1191,38 +1163,52 @@ static inline int guestwidth_to_adjustwidth(int gaw)
> >  static int domain_init(struct dmar_domain *domain, int guest_width)
> >  {
> >        struct intel_iommu *iommu;
> > -       int adjust_width, agaw;
> > +       int ret, adjust_width, agaw;
> >        unsigned long sagaw;
> >
> > -       init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
> >        spin_lock_init(&domain->mapping_lock);
> >
> > -       domain_reserve_special_ranges(domain);
> > -
> >        /* calculate AGAW */
> >        iommu = domain->iommu;
> > +
> >        if (guest_width > cap_mgaw(iommu->cap))
> >                guest_width = cap_mgaw(iommu->cap);
> >        domain->gaw = guest_width;
> >        adjust_width = guestwidth_to_adjustwidth(guest_width);
> >        agaw = width_to_agaw(adjust_width);
> >        sagaw = cap_sagaw(iommu->cap);
> > +
> > +/*     domain->it_size = 1UL << (guest_width - PAGE_SHIFT_4K); */
> > +       domain->it_size = 1UL << (32 - PAGE_SHIFT_4K);
> 
> "32-PAGE_SHIFT_4K" expression is used in several places but I didn't see
> an explanation of why 32. Can you add one someplace?

OK, I'll do next time. Most of them are about 4GB virtual address
space that the patch uses.


> out of time...

Thanks a lot! I didn't expect this patch to be reviewed. I really
appreciate it.
