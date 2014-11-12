From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 25/37] sun3_scsi: Convert to platform device
Date: Wed, 12 Nov 2014 22:20:21 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411122206050.27845@nippy.intranet>
References: <20141112051146.525489687@telegraphics.com.au> <20141112051152.395473503@telegraphics.com.au> <CAMuHMdVtKc782AfiC0g0+tNn-uGCOig88vHsFx3yEj3dz2=U1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVtKc782AfiC0g0+tNn-uGCOig88vHsFx3yEj3dz2=U1A@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 12 Nov 2014, Geert Uytterhoeven wrote:
> 
> >   move PAGE_SIZE back to ioremap() arguments.
> 
> Sorry, I think I didn't make myself clear, and you thus misunderstood.

I thought your email was clear. Also, no-one objected to
ioremap(..., PAGE_SIZE) in the v1 patch.

Oh well.

> I meant PAGE_SIZE makes sense when ioremap()ing a small region at a 
> hardcoded address, where you don't care about the exact size, as it will 
> be rounded up to PAGE_SIZE anyway.
> 
> When ioremap()ing resources, please use the size provided by the resource.
> 
> > +static int __init sun3_scsi_probe(struct platform_device *pdev)
> > +{
> > +       struct Scsi_Host *instance;
> > +       int error;
> > +       struct resource *irq, *mem;
> > +       unsigned char *ioaddr;
> > +#ifdef SUN3_SCSI_VME
> > +       int i;
> > +#endif
> > +
> > +       if (setup_can_queue > 0)
> > +               sun3_scsi_template.can_queue = setup_can_queue;
> > +       if (setup_cmd_per_lun > 0)
> > +               sun3_scsi_template.cmd_per_lun = setup_cmd_per_lun;
> > +       if (setup_sg_tablesize >= 0)
> > +               sun3_scsi_template.sg_tablesize = setup_sg_tablesize;
> > +       if (setup_hostid >= 0)
> > +               sun3_scsi_template.this_id = setup_hostid & 7;
> > +
> > +#ifdef SUPPORT_TAGS
> > +       if (setup_use_tagged_queuing < 0)
> > +               setup_use_tagged_queuing = 1;
> > +#endif
> > +
> > +#ifdef SUN3_SCSI_VME
> > +       ioaddr = NULL;
> > +       for (i = 0; i < 2; i++) {
> > +               unsigned char x;
> > +
> > +               irq = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> > +               mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
> > +               if (!irq || !mem)
> > +                       break;
> > +
> > +               ioaddr = sun3_ioremap(mem->start, PAGE_SIZE,
> 
> Here ...

OK.

> 
> > +                                     SUN3_PAGE_TYPE_VME16);
> > +               dregs = (struct sun3_dma_regs *)(ioaddr + 8);
> > +
> > +               if (sun3_map_test((unsigned long)dregs, &x)) {
> > +                       unsigned short oldcsr;
> > +
> > +                       oldcsr = dregs->csr;
> > +                       dregs->csr = 0;
> > +                       udelay(SUN3_DMA_DELAY);
> > +                       if (dregs->csr == 0x1400)
> > +                               break;
> > +
> > +                       dregs->csr = oldcsr;
> > +               }
> > +
> > +               iounmap(ioaddr);
> > +               ioaddr = NULL;
> > +       }
> > +       if (!ioaddr)
> > +               return -ENODEV;
> > +#else
> > +       irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +       if (!irq || !mem)
> > +               return -ENODEV;
> > +
> > +       ioaddr = ioremap(mem->start, PAGE_SIZE);
> 
> and here.
> 

OK.

-- 
