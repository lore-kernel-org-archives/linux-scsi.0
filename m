From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 4/3] g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio
Date: Mon, 26 Sep 2016 10:37:13 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609261034480.13676@nippy.intranet>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org> <1474832360-23261-1-git-send-email-linux@rainbow-software.org> <20160925235542.GD7312@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160925235542.GD7312@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 25 Sep 2016, Christoph Hellwig wrote:

> On Sun, Sep 25, 2016 at 09:39:20PM +0200, Ondrej Zary wrote:
> 
> >  #define NCR5380_read(reg) \
> > +	ioread8(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
> > +		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
> > +		(reg))
> >  #define NCR5380_write(reg, value) \
> > -	outb(value, instance->io_port + (reg))
> > +	iowrite8(value, ((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
> > +		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
> > +		(reg))
> 
> Can we make these #defines point to inline helper functions that avoid
> the casting magic, e.g. something like
> 
> static inline void g_NCR5380_write(struct Scsi_Host *instance, u32 reg,
> 		u8 value)
> {
> 	struct NCR5380_hostdata *host = shost_priv(instance);
> 
> 	iowrite8(value, host->iomem, host->offset + reg);
> }
> 
> #define NCR5380_write(reg, value)
> 	g_NCR5380_write(instance, reg, value)

Let's not do that yet. I have a patch series that fixes the type casting 
and related issues that I will post soon. I expect that Ondrej's patches 
will be ready before mine are, so I'll rebase mine on this work before I 
ask him to test my patches.

-- 
