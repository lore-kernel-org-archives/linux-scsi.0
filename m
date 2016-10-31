From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 2/3] g_NCR5380: Test the IRQ before accepting it
Date: Mon, 31 Oct 2016 20:46:01 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610312040460.20925@nippy.intranet>
References: <1477867203-7480-1-git-send-email-linux@rainbow-software.org> <1477867203-7480-2-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1610311348110.32132@nippy.intranet> <201610310935.58892.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201610310935.58892.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 31 Oct 2016, Ondrej Zary wrote:

> On Monday 31 October 2016, Finn Thain wrote:
> > On Sun, 30 Oct 2016, Ondrej Zary wrote:
> > > Trigger an IRQ first with a test IRQ handler to find out if it really
> > > works. Disable the IRQ if not.
> > >
> > > This prevents hang when incorrect IRQ was specified by user.
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > ---
> > >  drivers/scsi/g_NCR5380.c |   32 ++++++++++++++++++++++++++++++--
> > >  1 file changed, 30 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> > > index 3790ed5..261e168 100644
> > > --- a/drivers/scsi/g_NCR5380.c
> > > +++ b/drivers/scsi/g_NCR5380.c
> > > @@ -67,6 +67,14 @@
> > >  MODULE_ALIAS("g_NCR5380_mmio");
> > >  MODULE_LICENSE("GPL");
> > >
> > > +static bool irq_working;
> > > +
> > > +static irqreturn_t test_irq(int irq, void *dev_id)
> > > +{
> > > +	irq_working = true;
> > > +	return IRQ_HANDLED;
> > > +}
> > > +
> > >  /*
> > >   * Configure I/O address of 53C400A or DTC436 by writing magic numbers
> > >   * to ports 0x779 and 0x379.
> > > @@ -275,10 +283,30 @@ static int generic_NCR5380_init_one(struct
> > > scsi_host_template *tpnt, /* set IRQ for HP C2502 */
> > >  		if (board == BOARD_HP_C2502)
> > >  			magic_configure(port_idx, instance->irq, magic);
> > > -		if (request_irq(instance->irq, generic_NCR5380_intr,
> > > -				0, "NCR5380", instance)) {
> > > +		/* test if the IRQ is working */
> > > +		irq_working = false;
> > > +		if (request_irq(instance->irq, test_irq,
> > > +				0, "NCR5380-irqtest", NULL)) {
> > >  			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n",
> > > instance->host_no, instance->irq); instance->irq = NO_IRQ;
> > > +		} else {
> > > +			NCR5380_trigger_irq(instance);
> > > +			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > > +			free_irq(instance->irq, NULL);
> > > +			if (irq_working) {
> > > +				if (request_irq(instance->irq,
> > > +						generic_NCR5380_intr, 0,
> > > +						"NCR5380", instance)) {
> > > +					printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts
> > > disabled\n", +					       instance->host_no,
> > > +					       instance->irq);
> > > +					instance->irq = NO_IRQ;
> > > +				}
> > > +			} else {
> > > +				printk(KERN_WARNING "scsi%d : IRQ%d not working, interrupts
> > > disabled\n", +				       instance->host_no, instance->irq);
> > > +				instance->irq = NO_IRQ;
> > > +			}
> > >  		}
> > >  	}
> >
> > If the user omits to specify an irq, you can just default to IRQ_AUTO. 
> > This might result in NO_IRQ, which gives the same result as this 
> > patch.
> 
> Looks like a good idea.
> 
> > And when the user does specify an IRQ, we should trust them. So this 
> > compexity doesn't add any value AFAICT. Thanks but no thanks.
> 
> This fixes a real problem: specifying wrong IRQ hangs the machine 
> completely.
> 
> It's really easy - if the IRQ is free but configured in BIOS as PCI IRQ 
> (not ISA). Everything seems fine except the IRQ will never trigger.
> 
> 

How does that cause a hang? I'd expect scsi command timeouts, but there 
are any number of module parameters that the user can stuff up which will 
lead to command timeouts. I expect the same could be said of BIOS 
settings.

-- 
