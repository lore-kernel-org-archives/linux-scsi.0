From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Mon, 18 Feb 2008 15:21:31 +0000
Message-ID: <20080218152131.GA1609@linux-mips.org>
References: <47B48CAE.2020705@panasas.com> <47B864CB.4040604@panasas.com> <20080218045736.d35d5408.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:38438 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYBRV3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 16:29:31 -0500
Received: from localhost.localdomain ([127.0.0.1]:21226 "EHLO
	dl5rb.ham-radio-op.net") by ftp.linux-mips.org with ESMTP
	id S28574412AbYBRV33 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 21:29:29 +0000
Content-Disposition: inline
In-Reply-To: <20080218045736.d35d5408.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>, Russell King <rmk@arm.linux.org.uk>

On Mon, Feb 18, 2008 at 04:57:36AM -0800, Andrew Morton wrote:

> On Sun, 17 Feb 2008 18:46:03 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > ...
> >
> > All my testers have reported back that with these 5 patches applied they can
> > now run with a 2.6.24 kernel the same way they ran before. However there is
> > that reported issue, with the dma_free_coherent WARN_ON (above). The code was 
> > like that from day one and it is a very old issue, however it is a regression 
> > because 2.6.24 introduced that new WARN_ON.
> > (infamous commit aa24886e379d2b641c5117e178b15ce1d5d366ba)
> > >From posts on lkml and even recent one in linux-scsi about the arcmsr driver
> > it looks that all a driver can do is work around it with different kernel mechanisms
> > and driver rewrites. I'm afraid I need your help here. I'm not sure I understand
> > why does the gdth driver uses the pci_{alloc,free}_consistent() API's, and what
> > is needed to replace it. Could you please have a look in gdth_proc.c and also in
> > gdth.c for all the places that call gdth_ioctl_alloc/gdth_ioctl_free, and advise
> > what can I do in it's place. Please bear in mind that we need it for 2.6.24, as
> > a bugfix.
> > 
> > Apart from the above issue, please accept patches 3,4,5 above they have now
> > been tested and are reported to bring broken system back to production.
> > (Given that you approve off course). And mark them for inclusion to the
> > 2.6.24 stable releases. (Or is there some thing that I should do)
> > 
> > ---
> > Meanwhile on x86 systems I understand the WARN_ON is cosmetic, and does not
> > pose any harm. Some people have reported stability with temporarily disabling
> > it. For testers that want to try, here it is below. At your own risk.
> > 
> > ---
> > >From 50d3657bf6a138ee63ad1ce00052380edc75ace7 Mon Sep 17 00:00:00 2001
> > From: Boaz Harrosh <bharrosh@panasas.com>
> > Date: Sun, 17 Feb 2008 12:49:35 +0200
> > Subject: [PATCH] gdth: Hack to remove WARN_ON in arch/x86/kernel/pci-dma_32.c
> > 
> >   gdth uses dma_free_coherent() with interrupts disabled. Which
> >   is not portable, but is safe on the HW that supports gdth.
> > 
> > NOT Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > ---
> >  arch/x86/kernel/pci-dma_32.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
> > index 5133032..350dcfd 100644
> > --- a/arch/x86/kernel/pci-dma_32.c
> > +++ b/arch/x86/kernel/pci-dma_32.c
> > @@ -63,7 +63,7 @@ void dma_free_coherent(struct device *dev, size_t size,
> >  	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
> >  	int order = get_order(size);
> >  
> > -	WARN_ON(irqs_disabled());	/* for portability */
> > +/*	WARN_ON(irqs_disabled());*/	/* for portability */
> >  	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
> >  		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
> >  
> 
> Yes.   Let's reprise aa24886e379d2b641c5117e178b15ce1d5d366ba:
> 
> : commit aa24886e379d2b641c5117e178b15ce1d5d366ba
> : Author: David Brownell <david-b@pacbell.net>
> : Date:   Fri Aug 10 13:10:27 2007 -0700
> : 
> :     dma_free_coherent() needs irqs enabled (sigh)
> :     
> :     On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
> :     call context requirement: unlike its dma_alloc_coherent() sibling, it may
> :     not be called with IRQs disabled.  (This was new behavior on ARM as of late
> :     2005, caused by ARM SMP updates.) This little surprise can be annoyingly
> :     driver-visible.
> :     
> :     Since it looks like that restriction won't be removed, this patch changes
> :     the definition of the API to include that requirement.  Also, to help catch
> :     nonportable drivers, it updates the x86 and swiotlb versions to include the
> :     relevant warnings.  (I already observed that it trips on the
> :     bus_reset_tasklet of the new firewire_ohci driver.)
> : 
> 
> In general, all Linux memory-freeing functions can be called from all
> contexts.  (vfree is an irritating exception).  This is good, and provides
> maximum usefulness to callees, as all utility functions should seek to do. 
> It would be best to fix arm and mips.
> 
> But arm and mips require enabled local irqs because their
> dma_free_coherent() needs to do a cross-cpu IPI call.  Presumably because
> of certain unusual TLB protocols.
> 
> I'm not sure what we should do about this.  Presumably the gdth-on-arm
> usage base is, umm, zero, so we could lamely add
> CONFIG_DMA_FREE_COHERENT_WITH_LOCAL_IRQS_DISABLED_IS_OK and then use that
> to disable gdth (and similar) on arm amd mips.  But ugh.
> 
> Russell, Ralf: is there something we can do here to relax this requirement?

The current MIPS implementation of dma_alloc_coherent / dma_free_coherent
is a glorified wrapper around __get_free_pages rsp. free_pages that is
it doesn't depend on interrupts enabled.

This works because the current dma_alloc_coherent will only return
lowmem which is accessible without TLB mappings through KSEG0/1.

The embedded world being as quirky as it is I expect support of highmem
which will require the use of TLB entries to become eventually relevant
on MIPS but I think the lazy teardown of the mappings can take care of
that and worst case a caller of dma_alloc_coherent() has to be prepared
to handle an error return anyway.

  Ralf
