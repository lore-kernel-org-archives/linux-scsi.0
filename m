From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 1/6] NCR5380: Use probe_irq_*() for IRQ probing
Date: Wed, 2 Nov 2016 09:00:31 +0100
Message-ID: <201611020900.31899.linux@rainbow-software.org>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-2-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1611011208420.25806@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1611011208420.25806@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 02 November 2016, Finn Thain wrote:
> On Mon, 31 Oct 2016, Ondrej Zary wrote:
> > Use standard probe_irq_on() and probe_irq_off() functions instead of own
> > implementation. This prevents warning messages like this in the kernel
> > log: genirq: Flags mismatch irq 1. 00000000 (NCR-probe) vs. 00000080
> > (i8042)
> >
> > Move the IRQ trigger code to a separate function so it can be used for
> > other purposes (testing if the IRQ works) and move the code from NCR5380
> > to g_NCR5380.
> >
> > Also add missing IRQ reset before and after the probe.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/scsi/NCR5380.c   |   77
> > +--------------------------------------------- drivers/scsi/NCR5380.h   |
> >    1 -
> >  drivers/scsi/g_NCR5380.c |   50 +++++++++++++++++++++++++++++-
> >  3 files changed, 50 insertions(+), 78 deletions(-)
> >
> > diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> > index d849ffa..4f5ca79 100644
> > --- a/drivers/scsi/NCR5380.c
> > +++ b/drivers/scsi/NCR5380.c
> > @@ -97,9 +97,6 @@
> >   * and macros and include this file in your driver.
> >   *
> >   * These macros control options :
> > - * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be
> > - * defined.
> > - *
> >   * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
> >   * for commands that return with a CHECK CONDITION status.
> >   *
> > @@ -127,9 +124,7 @@
> >   * NCR5380_dma_residual   - residual byte count
> >   *
> >   * The generic driver is initialized by calling NCR5380_init(instance),
> > - * after setting the appropriate host specific fields and ID.  If the
> > - * driver wishes to autoprobe for an IRQ line, the
> > NCR5380_probe_irq(instance, - * possible) function may be used.
> > + * after setting the appropriate host specific fields and ID.
> >   */
> >
> >  #ifndef NCR5380_io_delay
> > @@ -351,76 +346,6 @@ static void NCR5380_print_phase(struct Scsi_Host
> > *instance) }
> >  #endif
> >
> > -
> > -static int probe_irq;
> > -
> > -/**
> > - * probe_intr	-	helper for IRQ autoprobe
> > - * @irq: interrupt number
> > - * @dev_id: unused
> > - * @regs: unused
> > - *
> > - * Set a flag to indicate the IRQ in question was received. This is
> > - * used by the IRQ probe code.
> > - */
> > -
> > -static irqreturn_t probe_intr(int irq, void *dev_id)
> > -{
> > -	probe_irq = irq;
> > -	return IRQ_HANDLED;
> > -}
> > -
> > -/**
> > - * NCR5380_probe_irq	-	find the IRQ of an NCR5380
> > - * @instance: NCR5380 controller
> > - * @possible: bitmask of ISA IRQ lines
> > - *
> > - * Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
> > - * and then looking to see what interrupt actually turned up.
> > - */
> > -
> > -static int __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
> > -						int possible)
> > -{
> > -	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> > -	unsigned long timeout;
> > -	int trying_irqs, i, mask;
> > -
> > -	for (trying_irqs = 0, i = 1, mask = 2; i < 16; ++i, mask <<= 1)
> > -		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe",
> > NULL) == 0)) -			trying_irqs |= mask;
> > -
> > -	timeout = jiffies + msecs_to_jiffies(250);
> > -	probe_irq = NO_IRQ;
> > -
> > -	/*
> > -	 * A interrupt is triggered whenever BSY = false, SEL = true
> > -	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
> > -	 * SCSI bus.
> > -	 *
> > -	 * Note that the bus is only driven when the phase control signals
> > -	 * (I/O, C/D, and MSG) match those in the TCR, so we must reset that
> > -	 * to zero.
> > -	 */
> > -
> > -	NCR5380_write(TARGET_COMMAND_REG, 0);
> > -	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> > -	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
> > -	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA |
> > ICR_ASSERT_SEL); -
> > -	while (probe_irq == NO_IRQ && time_before(jiffies, timeout))
> > -		schedule_timeout_uninterruptible(1);
> > -
> > -	NCR5380_write(SELECT_ENABLE_REG, 0);
> > -	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> > -
> > -	for (i = 1, mask = 2; i < 16; ++i, mask <<= 1)
> > -		if (trying_irqs & mask)
> > -			free_irq(i, NULL);
> > -
> > -	return probe_irq;
> > -}
> > -
> >  /**
> >   * NCR58380_info - report driver and host information
> >   * @instance: relevant scsi host instance
> > diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> > index 3c6ce54..4724558 100644
> > --- a/drivers/scsi/NCR5380.h
> > +++ b/drivers/scsi/NCR5380.h
> > @@ -290,7 +290,6 @@ static inline struct scsi_cmnd
> > *NCR5380_to_scmd(struct NCR5380_cmd *ncmd_ptr) #define
> > NCR5380_dprint_phase(flg, arg) do {} while (0)
> >  #endif
> >
> > -static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
> >  static int NCR5380_init(struct Scsi_Host *instance, int flags);
> >  static int NCR5380_maybe_reset_bus(struct Scsi_Host *);
> >  static void NCR5380_exit(struct Scsi_Host *instance);
> > diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> > index 7299ad9..09c660b 100644
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -67,6 +67,54 @@
> >  MODULE_ALIAS("g_NCR5380_mmio");
> >  MODULE_LICENSE("GPL");
> >
> > +static void NCR5380_trigger_irq(struct Scsi_Host *instance)
>
> That should be 'g_NCR5380_trigger_irq' (if it needs a prefix).
>
> > +{
> > +	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> > +
> > +	/*
> > +	 * An interrupt is triggered whenever BSY = false, SEL = true
> > +	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
> > +	 * SCSI bus.
> > +	 *
> > +	 * Note that the bus is only driven when the phase control signals
> > +	 * (I/O, C/D, and MSG) match those in the TCR, so we must reset that
> > +	 * to zero.
> > +	 */
> > +	NCR5380_write(TARGET_COMMAND_REG, 0);
>
> That assumes bus free phase, which we hope is the case but
> NCR5380_maybe_reset_bus() doesn't guarantee it. This is more robust:
>
> 	 * Note that the bus is only driven when the phase control signals
> 	 * (I/O, C/D, and MSG) match those in the TCR.
> 	 */
> 	NCR5380_write(TARGET_COMMAND_REG,
> 		PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG) & PHASE_MASK));
>
> > +	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> > +	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
> > +	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA |
> > ICR_ASSERT_SEL); +
> > +	usleep_range(1000, 20000);
>
> Again, msleep(1) would be more appropriate here.

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
#164: FILE: drivers/scsi/g_NCR5380.c:88:
+       msleep(1);

> > +
> > +	NCR5380_write(SELECT_ENABLE_REG, 0);
> > +	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> > +}
> > +
> > +/**
> > + * NCR5380_probe_irq	-	find the IRQ of an NCR5380
>
> This should be 'g_NCR5380_probe_irq' (if it needs a prefix).
>
> > + * @instance: NCR5380 controller
> > + *
> > + * Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
> > + * and then looking to see what interrupt actually turned up.
> > + */
> > +
> > +static int NCR5380_probe_irq(struct Scsi_Host *instance)
> > +{
> > +	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> > +	int irq_mask, irq;
> > +
> > +	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +	irq_mask = probe_irq_on();
> > +	NCR5380_trigger_irq(instance);
> > +	irq = probe_irq_off(irq_mask);
> > +	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +	if (irq < 0)
> > +		irq = NO_IRQ;
> > +
> > +	return irq;
> > +}
> > +
> >  /*
> >   * Configure I/O address of 53C400A or DTC436 by writing magic numbers
> >   * to ports 0x779 and 0x379.
> > @@ -265,7 +313,7 @@ static int generic_NCR5380_init_one(struct
> > scsi_host_template *tpnt, if (irq != IRQ_AUTO)
> >  		instance->irq = irq;
> >  	else
> > -		instance->irq = NCR5380_probe_irq(instance, 0xffff);
> > +		instance->irq = NCR5380_probe_irq(instance);
> >
> >  	/* Compatibility with documented NCR5380 kernel parameters */
> >  	if (instance->irq == 255)



-- 
Ondrej Zary
