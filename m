From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 2/6] g_NCR5380: Test the IRQ before accepting it
Date: Wed, 2 Nov 2016 20:16:00 +0100
Message-ID: <201611022016.00556.linux@rainbow-software.org>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-3-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1611011257130.25806@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1611011257130.25806@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 02 November 2016 08:45:26 Finn Thain wrote:
> On Mon, 31 Oct 2016, Ondrej Zary wrote:
> > Trigger an IRQ first with a test IRQ handler to find out if it really
> > works. Disable the IRQ if not.
> >
> > This prevents hang when incorrect IRQ was specified by user.
>
> Once again, how does it cause a hang?

Kernel scans the bus, finds a HDD, then attempts to read MBR. modprobe process 
is stuck but the system is still running. Then the transfer probably times 
out and everything locks up hard, even fbcon cursor stops blinking. I guess 
that kernel is trying to abort or reset.
BTW. rescan-scsi-bus also causes hang, anytime, even without IRQ.

> If the user specifies an IRQ, we should trust them. If they don't specify
> an IRQ then probe (as in patch 5/6).
>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/scsi/g_NCR5380.c |   44
> > +++++++++++++++++++++++++++++++++++++++++--- 1 file changed, 41
> > insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> > index 09c660b..0d1f6ad 100644
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -115,6 +115,32 @@ static int NCR5380_probe_irq(struct Scsi_Host
> > *instance) return irq;
> >  }
> >
> > +static bool irq_working;
> > +
> > +static irqreturn_t test_irq(int irq, void *dev_id)
> > +{
> > +	irq_working = true;
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +/* test if the IRQ is working */
> > +static int NCR5380_test_irq(struct Scsi_Host *instance, int irq)
> > +{
> > +	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> > +
> > +	irq_working = false;
> > +	if (request_irq(irq, test_irq, 0, "NCR5380-irqtest", NULL))
> > +		return -EBUSY;
> > +	NCR5380_trigger_irq(instance);
> > +	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +	free_irq(irq, NULL);
> > +
> > +	if (!irq_working)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
>
> IMO the extra complexity is not justified by the possibility of machines
> with misconfigured BIOS or incorrect module parameters.
>
> I don't want another irq probing mechanism. We just got rid of one.
>
> But I won't mind if the SCSI maintainers who know ISA better than I do
> would like to review this.
>
> >  /*
> >   * Configure I/O address of 53C400A or DTC436 by writing magic numbers
> >   * to ports 0x779 and 0x379.
> > @@ -323,9 +349,21 @@ static int generic_NCR5380_init_one(struct
> > scsi_host_template *tpnt, /* set IRQ for HP C2502 */
> >  		if (board == BOARD_HP_C2502)
> >  			magic_configure(port_idx, instance->irq, magic);
> > -		if (request_irq(instance->irq, generic_NCR5380_intr,
> > -				0, "NCR5380", instance)) {
> > -			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n",
> > instance->host_no, instance->irq); +		ret = NCR5380_test_irq(instance,
> > instance->irq);
> > +		if (ret) {
> > +			printk(KERN_WARNING "scsi%d : IRQ%d not %s, interrupts disabled\n",
> > +			       instance->host_no, instance->irq,
> > +			       (ret == -EBUSY) ? "free" : "working");
> > +			instance->irq = NO_IRQ;
> > +		}
> > +	}
> > +
> > +	if (instance->irq != NO_IRQ) {
> > +		if (request_irq(instance->irq, generic_NCR5380_intr, 0,
> > +				"NCR5380", instance)) {
> > +			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n",
> > +			       instance->host_no,
> > +			       instance->irq);
> >  			instance->irq = NO_IRQ;
> >  		}
> >  	}


-- 
Ondrej Zary
