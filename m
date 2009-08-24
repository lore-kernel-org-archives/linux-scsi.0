From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Mon, 24 Aug 2009 10:24:55 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0908241018580.20262@rslab159.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.0908061701240.15176@rslab159.pmc-sierra.bc.ca> <1250647356.18426.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:39685 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbZHXSRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Aug 2009 14:17:34 -0400
In-Reply-To: <1250647356.18426.29.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, gregkh@suse.de, anil_ravindranath@pmc-sierra.com



On Tue, 18 Aug 2009, James Bottomley wrote:

> On Thu, 2009-08-06 at 17:16 -0700, Anil Ravindranath wrote:
> > Here is an updated driver patch which incorporates all the review inputs 
> > received so far.
> > Also, as per previous suggestions, signal is replaced with netlink to 
> > send event messages to user applications.
> 
> The basics all look OK to me.
> 
> > SIGNED-OFF-BY: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> 
> This should be Signed-off-by:
>
Will change this accordingly.

 
> > +/*
> 
> Docbook actually needs to start with /** (two asterisks)
> 
> > + * pmcraid_slave_alloc - Prepare for commands to a device
> > + * @scsi_dev: scsi device struct
> > + *
> > + * This function is called by mid-layer prior to sending any command to the new
> > + * device. Stores resource entry details of the device in scsi_device struct.
> > + * Queuecommand uses the resource handle and other details to fill up IOARCB
> > + * while sending commands to the device.
> > + *
> > + * Return value:
> > + *	  0 on success / -ENXIO if device does not exist
> > + */
> [...]
> 

Will change this accordingly.

> There also appear to be a few write posting problems:
> 
> > +/*
> > + * pmcraid_start_bist - starts BIST
> > + * @cmd: pointer to reset cmd
> > + * Return Value
> > + *   none
> > + */
> > +static void pmcraid_start_bist(struct pmcraid_cmd *cmd)
> > +{
> > +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> > +
> > +	/* proceed with bist and wait for 2 seconds */
> > +	iowrite32(DOORBELL_IOA_START_BIST,
> > +		pinstance->int_regs.host_ioa_interrupt_reg);
> > +	pmcraid_info("doorbells after start bist: %x, intrs=%x\n",
> > +		      ioread32(pinstance->int_regs.host_ioa_interrupt_reg),
> > +		      ioread32(pinstance->int_regs.ioa_host_interrupt_reg));
> > +
> > +	cmd->u.time_left = msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
> > +	cmd->timer.data = (unsigned long)cmd;
> > +	cmd->timer.expires = jiffies + msecs_to_jiffies(PMCRAID_BIST_TIMEOUT);
> > +	cmd->timer.function = (void (*)(unsigned long))pmcraid_bist_done;
> > +	add_timer(&cmd->timer);
> 
> This is a classic posted write.  You're starting the timer with no
> guarantee that the START_BIST isn't held in the bus cache.
> 
> [...]
> 

We will do a read memory cycle so that the posted writes are flushed and 
then start the timer.

> > +/*
> > + * pmcraid_isr_common - Common interrupt handler routine
> > + *
> > + * @pinstance: pointer to adapter instance
> > + * @intrs: active interrupts (contents of ioa_host_interrupt register)
> > + * @hrrq_id: Host RRQ index
> > + *
> > + * Return Value
> > + *	none
> > + */
> > +static void pmcraid_isr_common(
> > +	struct pmcraid_instance *pinstance,
> > +	u32 intrs,
> > +	int hrrq_id
> > +)
> > +{
> > +	if (intrs & INTRS_CRITICAL_OP_IN_PROGRESS) {
> > +		iowrite32(intrs,
> > +			  pinstance->int_regs.ioa_host_interrupt_clr_reg);
> > +	} else {
> > +		/* valid hrrq, schedule tasklet to handle the response */
> > +		iowrite32(INTRS_HRRQ_VALID,
> > +			  pinstance->int_regs.ioa_host_interrupt_clr_reg);
> > +		tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]));
> > +	}
> > +}
> 
> These clear interrupt register writes are also posted.
> 
> > +/*
> > + * pmcraid_isr  - implements interrupt handling routine
> > + *
> > + * @irq: interrupt vector number
> > + * @dev_id: pointer hrrq_vector
> > + *
> > + * Return Value
> > + *	 IRQ_HANDLED if interrupt is handled or IRQ_NONE if ignored
> > + */
> > +static irqreturn_t pmcraid_isr(int irq, void *dev_id)
> > +{
> > +	struct pmcraid_isr_param *hrrq_vector;
> > +	struct pmcraid_instance *pinstance;
> > +	unsigned long lock_flags;
> > +	u32 intrs;
> > +
> > +	/* In case of legacy interrupt mode where interrupts are shared across
> > +	 * isrs, it may be possible that the current interrupt is not from IOA
> > +	 */
> > +	if (!dev_id) {
> > +		printk(KERN_INFO "%s(): NULL host pointer\n", __func__);
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	hrrq_vector = (struct pmcraid_isr_param *)dev_id;
> > +	pinstance = hrrq_vector->drv_inst;
> > +
> > +	/* Acquire the lock (currently host_lock) while processing interrupts.
> > +	 * This interval is small as most of the response processing is done by
> > +	 * tasklet without the lock.
> > +	 */
> > +	spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
> > +	intrs = pmcraid_read_interrupts(pinstance);
> > +
> > +	if (unlikely((intrs & PMCRAID_PCI_INTERRUPTS) == 0)) {
> > +		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	/* Any error interrupts including unit_check, initiate IOA reset.
> > +	 * In case of unit check indicate to reset_sequence that IOA unit
> > +	 * checked and prepare for a dump during reset sequence
> > +	 */
> > +	if (intrs & PMCRAID_ERROR_INTERRUPTS) {
> > +
> > +		if (intrs & INTRS_IOA_UNIT_CHECK)
> > +			pinstance->ioa_unit_check = 1;
> > +
> > +		iowrite32(intrs,
> > +			  pinstance->int_regs.ioa_host_interrupt_clr_reg);
> > +		pmcraid_err("ISR: error interrupts: %x initiating reset\n",
> > +			    intrs);
> > +		pmcraid_initiate_reset(pinstance);
> > +	} else {
> > +		pmcraid_isr_common(pinstance, intrs, hrrq_vector->hrrq_id);
> 
> Because you call them here
> 
> > +	}
> > +
> > +	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
> > +
> > +	return IRQ_HANDLED;
> 
> And then return IRQ_HANDLED.  If the write is posted, the interrupt
> won't clear and there'll be an immediate reinterrupt.
> 

Will do a read register memory cycle after the write to take of care of 
posted write issue.

> James
> 
> 
> 
