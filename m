From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Sat, 25 Dec 2010 00:24:34 +0100
Message-ID: <201012250024.38576.jkrzyszt@tis.icnet.pl>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl> <201012241455.30430.jkrzyszt@tis.icnet.pl> <20101224154120.GH20587@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20101224154120.GH20587@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arch@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>, Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org, David Brownell <dbrownell@users.sourceforge.net>, linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-scsi@vger.kernel.org

=46riday 24 December 2010 16:41:20 Russell King - ARM Linux napisa=C5=82=
(a):
> On Fri, Dec 24, 2010 at 02:55:25PM +0100, Janusz Krzysztofik wrote:
> > Friday 24 December 2010 14:02:00 Russell King - ARM Linux wrote:
> > > On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik=20
wrote:
> > > > The patch tries to implement a solution suggested by Russell
> > > > King,
> > > > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-Dece
> > > >mber /035264.html. It is expected to solve video buffer
> > > > allocation issues for at least a few soc_camera I/O memory less
> > > > host interface drivers, designed around the videobuf_dma_contig
> > > > layer, which allocates video buffers using
> > > > dma_alloc_coherent().
> > > >
> > > > Created against linux-2.6.37-rc5.
> > > >
> > > > Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera
> > > > patch, patterned upon two mach-mx3 machine types which already
> > > > try to use the dma_declare_coherent_memory() method for
> > > > reserving a region of system RAM preallocated with another
> > > > dma_alloc_coherent(). Compile tested for all modified files
> > > > except arch/sh/drivers/pci/fixups-dreamcast.c.
> > >
> > > Another note: with the pair of patches I've sent to the
> > > linux-arm-kernel list earlier today changing the DMA coherent
> > > allocator to steal memory from the system at boot.
> > >
> > > This means there's less need to pre-allocate DMA memory - if
> > > there's sufficient contiguous space in the DMA region to satisfy
> > > the allocation, then the allocation will succeed.  It's also
> > > independent of the maximum page size from the kernel's memory
> > > allocators too.
> > >
> > > So I suspect that mach-mx3 (and others) no longer need to do
> > > their own pre-allocation anymore if both of these patches go in.
> >
> > Then, my rationale will no longer be valid. So, either drop my
> > patch if you think you have finally come out with a better solution
> > which doesn't touch any system-wide API, or suggest a new
> > justification for use in the commit log if you think still the
> > patch solves something important.
>
> No.  It's not clear whether my pair of patches are both going to make
> it into the kernel, or even what timeframe they're going to make it
> in.
>
> Irrespective of that, we do need a solution to this problem so that
> this stuff starts working again.
>
> In any case, your patch makes complete sense through and through:
>
> 1. if other architecture/machine wants to reserve a chunk of DMA-able
>    memory for a specific device (eg, because of a restriction on the
>    number of DMA address bits available) and it's completely DMA
>    coherent, it shouldn't have to go through the pains of having that
>    memory unconditionally ioremap'd.
>
> 2. What if the memory being provided from some source where you
> already have the mapping setup in a specific way for a reason?
>
> For example, say I have an ARM design, and all peripherals are in a
> single 256MB memory region, which includes a chunk of SRAM set aside
> for DMA purposes.  Let's say I can map that really efficiently by a
> few page table entries, which means relatively little TLB usage for
> accessing this region.
>
> With the current API, it becomes difficult to pass that mapping
> through the dma_declare_coherent_memory() because the physical
> address goes through ioremap(), which obfuscates what's going on.=20
> However, if I could pass the bus and virtual address, then there's no
> ambiguity over what I want to do.
>
> What if I want to declare memory to the DMA coherent allocator with
> attributes different from what ioremap() gives me, maybe with write
> combining properties (because it happens to be safe for the specific
> device) ?
>
> Passing the virtual address allows the API to become much more
> flexible. Not only that, it allows it to be used on ARM, rather than
> becoming (as it currently stands) prohibited on ARM.
>
> I believe that putting ioremap() inside this API was the wrong thing
> to do, and moving it outside makes the API much more flexible and
> usable. It's something I still fully support.

Thanks, this is what I was missing, having my point of view rather my=20
machine centric, with not much wider experience. I'll quote your=20
argumentation in next iteration of this patch if required.

Thanks,
Janusz
