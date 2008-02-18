From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Mon, 18 Feb 2008 04:57:36 -0800
Message-ID: <20080218045736.d35d5408.akpm@linux-foundation.org>
References: <47B48CAE.2020705@panasas.com>
	<47B864CB.4040604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760786AbYBRNFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 08:05:10 -0500
In-Reply-To: <47B864CB.4040604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>, Russell King <rmk@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>

On Sun, 17 Feb 2008 18:46:03 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> ...
>
> All my testers have reported back that with these 5 patches applied they can
> now run with a 2.6.24 kernel the same way they ran before. However there is
> that reported issue, with the dma_free_coherent WARN_ON (above). The code was 
> like that from day one and it is a very old issue, however it is a regression 
> because 2.6.24 introduced that new WARN_ON.
> (infamous commit aa24886e379d2b641c5117e178b15ce1d5d366ba)
> >From posts on lkml and even recent one in linux-scsi about the arcmsr driver
> it looks that all a driver can do is work around it with different kernel mechanisms
> and driver rewrites. I'm afraid I need your help here. I'm not sure I understand
> why does the gdth driver uses the pci_{alloc,free}_consistent() API's, and what
> is needed to replace it. Could you please have a look in gdth_proc.c and also in
> gdth.c for all the places that call gdth_ioctl_alloc/gdth_ioctl_free, and advise
> what can I do in it's place. Please bear in mind that we need it for 2.6.24, as
> a bugfix.
> 
> Apart from the above issue, please accept patches 3,4,5 above they have now
> been tested and are reported to bring broken system back to production.
> (Given that you approve off course). And mark them for inclusion to the
> 2.6.24 stable releases. (Or is there some thing that I should do)
> 
> ---
> Meanwhile on x86 systems I understand the WARN_ON is cosmetic, and does not
> pose any harm. Some people have reported stability with temporarily disabling
> it. For testers that want to try, here it is below. At your own risk.
> 
> ---
> >From 50d3657bf6a138ee63ad1ce00052380edc75ace7 Mon Sep 17 00:00:00 2001
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Sun, 17 Feb 2008 12:49:35 +0200
> Subject: [PATCH] gdth: Hack to remove WARN_ON in arch/x86/kernel/pci-dma_32.c
> 
>   gdth uses dma_free_coherent() with interrupts disabled. Which
>   is not portable, but is safe on the HW that supports gdth.
> 
> NOT Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  arch/x86/kernel/pci-dma_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
> index 5133032..350dcfd 100644
> --- a/arch/x86/kernel/pci-dma_32.c
> +++ b/arch/x86/kernel/pci-dma_32.c
> @@ -63,7 +63,7 @@ void dma_free_coherent(struct device *dev, size_t size,
>  	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
>  	int order = get_order(size);
>  
> -	WARN_ON(irqs_disabled());	/* for portability */
> +/*	WARN_ON(irqs_disabled());*/	/* for portability */
>  	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
>  		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
>  

Yes.   Let's reprise aa24886e379d2b641c5117e178b15ce1d5d366ba:

: commit aa24886e379d2b641c5117e178b15ce1d5d366ba
: Author: David Brownell <david-b@pacbell.net>
: Date:   Fri Aug 10 13:10:27 2007 -0700
: 
:     dma_free_coherent() needs irqs enabled (sigh)
:     
:     On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
:     call context requirement: unlike its dma_alloc_coherent() sibling, it may
:     not be called with IRQs disabled.  (This was new behavior on ARM as of late
:     2005, caused by ARM SMP updates.) This little surprise can be annoyingly
:     driver-visible.
:     
:     Since it looks like that restriction won't be removed, this patch changes
:     the definition of the API to include that requirement.  Also, to help catch
:     nonportable drivers, it updates the x86 and swiotlb versions to include the
:     relevant warnings.  (I already observed that it trips on the
:     bus_reset_tasklet of the new firewire_ohci driver.)
: 

In general, all Linux memory-freeing functions can be called from all
contexts.  (vfree is an irritating exception).  This is good, and provides
maximum usefulness to callees, as all utility functions should seek to do. 
It would be best to fix arm and mips.

But arm and mips require enabled local irqs because their
dma_free_coherent() needs to do a cross-cpu IPI call.  Presumably because
of certain unusual TLB protocols.

I'm not sure what we should do about this.  Presumably the gdth-on-arm
usage base is, umm, zero, so we could lamely add
CONFIG_DMA_FREE_COHERENT_WITH_LOCAL_IRQS_DISABLED_IS_OK and then use that
to disable gdth (and similar) on arm amd mips.  But ugh.

Russell, Ralf: is there something we can do here to relax this requirement?

I'm thinking that perhaps we can do some rcu/refcounting tricks: launch the
IPI from within dma_free_coherent(), but don't wait for it to complete. 
When all CPUs have handled the IPI then (and only then) the virtual address
becomes recyclable, or something like that?

<double-checks>

Actually I think David might have been wrong about mips.  afaict its
dma_free_coherent() is callable under local_irq_disable(), so ARM SMP is
the sole exception?  


