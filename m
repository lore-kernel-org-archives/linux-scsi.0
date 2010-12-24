From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH] dma_declare_coherent_memory: push ioremap() up to caller
Date: Fri, 24 Dec 2010 02:08:03 +0100
Message-ID: <201012240208.08365.jkrzyszt@tis.icnet.pl>
References: <201012240020.37208.jkrzyszt@tis.icnet.pl> <20101223235434.GA20587@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101223235434.GA20587@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arch@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>, Sascha Hauer <kernel@pengutronix.de>, linux-usb@vger.kernel.org, David Brownell <dbrownell@users.sourceforge.net>, linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-scsi@vger.kernel.org

=46riday 24 December 2010 00:54:34 Russell King - ARM Linux napisa=C5=82=
(a):
> On Fri, Dec 24, 2010 at 12:20:32AM +0100, Janusz Krzysztofik wrote:
> > The patch tries to implement a solution suggested by Russell King,
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December
> >/035264.html. It is expected to solve video buffer allocation issues
> > for at least a few soc_camera I/O memory less host interface
> > drivers, designed around the videobuf_dma_contig layer, which
> > allocates video buffers using dma_alloc_coherent().
> >
> > Created against linux-2.6.37-rc5.
> >
> > Tested on ARM OMAP1 based Amstrad Delta with a WIP OMAP1 camera
> > patch, patterned upon two mach-mx3 machine types which already try
> > to use the dma_declare_coherent_memory() method for reserving a
> > region of system RAM preallocated with another
> > dma_alloc_coherent(). Compile tested for all modified files except
> > arch/sh/drivers/pci/fixups-dreamcast.c.
> >
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > ---
> > I intended to quote Russell in my commit message and even asked him
> > for his permission, but since he didn't respond, I decided to
> > include a link to his original message only.
>
> There's no problem quoting messages which were sent to public mailing
> lists, especially when there's a record of what was said in public
> archives too.
>
> I think this is definitely a step forward.
>
> > ---
> > linux-2.6.37-rc5/arch/arm/mach-mx3/mach-pcm037.c.orig	2010-12-09
> > 23:07:34.000000000 +0100 +++
> > linux-2.6.37-rc5/arch/arm/mach-mx3/mach-pcm037.c	2010-12-23
> > 18:32:24.000000000 +0100 @@ -431,7 +431,7 @@ static int __init
> > pcm037_camera_alloc_dm memset(buf, 0, buf_size);
> >
> >  	dma =3D dma_declare_coherent_memory(&mx3_camera.dev,
> > -					dma_handle, dma_handle, buf_size,
> > +					buf, dma_handle, buf_size,
> >  					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> >
> >  	/* The way we call dma_declare_coherent_memory only a malloc can
> > fail */ ---
> > linux-2.6.37-rc5/arch/arm/mach-mx3/mach-mx31moboard.c.orig	2010-12-
> >09 23:07:34.000000000 +0100 +++
> > linux-2.6.37-rc5/arch/arm/mach-mx3/mach-mx31moboard.c	2010-12-23
> > 18:32:24.000000000 +0100 @@ -486,7 +486,7 @@ static int __init
> > mx31moboard_cam_alloc_ memset(buf, 0, buf_size);
> >
> >  	dma =3D dma_declare_coherent_memory(&mx3_camera.dev,
> > -					dma_handle, dma_handle, buf_size,
> > +					buf, dma_handle, buf_size,
> >  					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> >
> >  	/* The way we call dma_declare_coherent_memory only a malloc can
> > fail */
>
> A side note for the mx3 folk: although it's not specified in DMA-API,
> memory allocated from dma_alloc_coherent() on ARM is already memset
> to zero by the allocation function.
>
> > --- linux-2.6.37-rc5/drivers/base/dma-coherent.c.orig	2010-12-09
> > 23:08:03.000000000 +0100 +++
> > linux-2.6.37-rc5/drivers/base/dma-coherent.c	2010-12-23
> > 18:32:24.000000000 +0100 @@ -14,10 +14,9 @@ struct dma_coherent_mem
> > {
> >  	unsigned long	*bitmap;
> >  };
> >
> > -int dma_declare_coherent_memory(struct device *dev, dma_addr_t
> > bus_addr, +int dma_declare_coherent_memory(struct device *dev, void
> > *virt_addr, dma_addr_t device_addr, size_t size, int flags)
> >  {
> > -	void __iomem *mem_base =3D NULL;
> >  	int pages =3D size >> PAGE_SHIFT;
> >  	int bitmap_size =3D BITS_TO_LONGS(pages) * sizeof(long);
> >
> > @@ -30,10 +29,6 @@ int dma_declare_coherent_memory(struct d
> >
> >  	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN
> > */
> >
> > -	mem_base =3D ioremap(bus_addr, size);
> > -	if (!mem_base)
> > -		goto out;
> > -
> >  	dev->dma_mem =3D kzalloc(sizeof(struct dma_coherent_mem),
> > GFP_KERNEL); if (!dev->dma_mem)
> >  		goto out;
> > @@ -41,7 +36,7 @@ int dma_declare_coherent_memory(struct d
> >  	if (!dev->dma_mem->bitmap)
> >  		goto free1_out;
> >
> > -	dev->dma_mem->virt_base =3D mem_base;
> > +	dev->dma_mem->virt_base =3D virt_addr;
>
> I didn't see anything changing the dev->dma_mem->virt_base type to
> drop the __iomem attribute (which I suspect shouldn't be there -
> we're returning it via a void pointer anyway, so I think the whole
> coherent part of the DMA API should be __iomem-less.

There was no __iomem attribute specified for the .virt_base member of=20
the struct dma_coherent_mem, pure (void *), so nothing to be changed=20
there.

Thanks,
Janusz

> It also pushes the sparse address space warnings to the right place
> IMHO too.
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
