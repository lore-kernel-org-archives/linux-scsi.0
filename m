From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 25/36] sun3_scsi: Convert to platform device
Date: Sun, 9 Nov 2014 23:12:10 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411092312040.21822@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052613.155430175@telegraphics.com.au> <CAMuHMdUULx29rmrSPxmSJugTQAbRVnkcjVzg6j3-eN4U7hLpZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38995 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaKIMNT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 07:13:19 -0500
In-Reply-To: <CAMuHMdUULx29rmrSPxmSJugTQAbRVnkcjVzg6j3-eN4U7hLpZA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>


On Sun, 9 Nov 2014, Geert Uytterhoeven wrote:

> On Mon, Oct 27, 2014 at 6:26 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> > --- linux.orig/arch/m68k/sun3/config.c  2014-10-27 16:17:59.000000000 +1100
> > +++ linux/arch/m68k/sun3/config.c       2014-10-27 16:25:50.000000000 +1100
> 
> > @@ -169,3 +171,61 @@ static void __init sun3_sched_init(irq_h
> >          intersil_clear();
> >  }
> >
> > +#ifdef CONFIG_SUN3_SCSI
> > +
> > +static const struct resource sun3_scsi_vme_rsrc[] __initconst = {
> > +       {
> > +               .flags = IORESOURCE_IRQ,
> > +               .start = SUN3_VEC_VMESCSI0,
> > +               .end   = SUN3_VEC_VMESCSI0,
> > +       }, {
> > +               .flags = IORESOURCE_MEM,
> > +               .start = 0xff200000,
> > +               .end   = 0xff200000 + PAGE_SIZE - 1,
> 
> PAGE_SIZE is a software kernel configuration option, not a hardware
> property. It makes sense to use it in an ioremap() call, but not in a
> platform device's resource, which describes the hardware.
> 
> > +       }, {
> > +               .flags = IORESOURCE_IRQ,
> > +               .start = SUN3_VEC_VMESCSI1,
> > +               .end   = SUN3_VEC_VMESCSI1,
> > +       }, {
> > +               .flags = IORESOURCE_MEM,
> > +               .start = 0xff204000,
> > +               .end   = 0xff204000 + PAGE_SIZE - 1,
> 
> Likewise
> 
> > +       },
> > +};
> > +
> > +/*
> > + * Int: level 2 autovector
> > + * IO: type 1, base 0x00140000, 5 bits phys space: A<4..0>
> > + */
> > +static const struct resource sun3_scsi_rsrc[] __initconst = {
> > +       {
> > +               .flags = IORESOURCE_IRQ,
> > +               .start = 2,
> > +               .end   = 2,
> > +       }, {
> > +               .flags = IORESOURCE_MEM,
> > +               .start = 0x00140000,
> > +               .end   = 0x00140000 + PAGE_SIZE - 1,
> 
> Likewise
> 
> According to the Sun-3 Architecture Manual v2.0 (May 1985), end should
> be 0x0014001f.

OK. Where did you find that, BTW?

> 
> I guess the resource length is 0x20 for VME SCSI, too?

For VME SCSI it would need to be 8 + sizeof(struct sun3_dma_regs) which I 
think equals 0x22:

struct sun3_dma_regs {
        unsigned short dma_addr_hi; /* vme only */
        unsigned short dma_addr_lo; /* vme only */
        unsigned short dma_count_hi; /* vme only */
        unsigned short dma_count_lo; /* vme only */
        unsigned short udc_data; /* udc dma data reg (obio only) */
        unsigned short udc_addr; /* uda dma addr reg (obio only) */
        unsigned short fifo_data; /* fifo data reg, holds extra byte on
                                     odd dma reads */
        unsigned short fifo_count;
        unsigned short csr; /* control/status reg */
        unsigned short bpack_hi; /* vme only */
        unsigned short bpack_lo; /* vme only */
        unsigned short ivect; /* vme only */
        unsigned short fifo_count_hi; /* vme only */
};

I'll make these changes and re-spin the patch series once Hannes' 
questions have been resolved. Thanks for reviewing.

-- 
