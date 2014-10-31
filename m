From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 30/36] atari_NCR5380: Merge from sun3_NCR5380.c
Date: Fri, 31 Oct 2014 18:21:23 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1410311524140.7380@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052614.365442007@telegraphics.com.au> <5451F7F6.3020704@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <5451F7F6.3020704@suse.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sam Creasey <sammy@sammy.net>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 30 Oct 2014, Hannes Reinecke wrote:

> On 10/27/2014 06:26 AM, Finn Thain wrote:
> > There is very little difference between the sun3_NCR5380.c core driver 
> > and atari_NCR5380.c. The former is a fork of the latter.
> > 
> > Merge the sun3_NCR5380.c core driver into atari_NCR5380.c so that 
> > sun3_scsi.c can adopt the latter and the former can be deleted.
> > 
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > 
> > ---
> > 
> > This patch brings some undesirable #ifdef's to atari_NCR5380. It's a 
> > small price to pay for the elimination of so much duplication. 
> > Eventually, with some testing, it should be possible to remove many of 
> > these.
> > 
> > Elimination of the SUN3_SCSI_VME macro is necessary to reach the goal 
> > of a single platform driver to replace the 
> > {atari,mac,sun3,sun3_vme}_scsi modules.
> > 
> > Elimination of the #ifdef CONFIG_SUN3 tests is not necessary. But some 
> > of these would go away if the sun3 driver followed the atari logic 
> > more closely, such as use of PIO vs DMA for certain phases and 
> > transfer sizes.
> > 
> > After applying this patch it is easy to compare the new 
> > atari_NCR5380.c with sun3_NCR5380.c, to check that they are 
> > equivalent. E.g.
> > 
> > $ cp drivers/scsi/{sun3,atari}_NCR5380.c /tmp
> > $ sed -i -e 's/  *$//'      /tmp/{sun3,atari}_NCR5380.c
> > $ scripts/Lindent -l96 -hnl /tmp/{sun3,atari}_NCR5380.c
> > $ meld                      /tmp/{sun3,atari}_NCR5380.c
> > 
> > One can see that the two implementations of tagged command queueing 
> > have diverged since the fork. The atari version has been updated and 
> > the sun3 implementation is unused as sun3_scsi.c does not define 
> > SUPPORT_TAGS.
> > 
> > The remaining differences are merge_contiguous_buffers() and the 
> > falcon locking code. The falcon code disappears when suitable macro 
> > definitions are provided in sun3_scsi.c. merge_contiguous_buffers() 
> > could be a problem for sun3 (due to a DMA setup in an odd place) so it 
> > is #ifdef'd for sun3 until the DMA setup discrepancies can be 
> > reconciled or moved out of the core driver.
> > 
> > ---
> >  drivers/scsi/atari_NCR5380.c |  210 +++++++++++++++++++++++++++++++++++++++----
> >  drivers/scsi/atari_scsi.c    |    1 
> >  2 files changed, 195 insertions(+), 16 deletions(-)
> > 
> > Index: linux/drivers/scsi/atari_NCR5380.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:55.000000000 +1100
> > +++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:56.000000000 +1100
> > @@ -71,6 +71,9 @@
> >   * 1.  Test linked command handling code after Eric is ready with
> >   *     the high level code.
> >   */
> > +
> > +/* Adapted for the sun3 by Sam Creasey. */
> > +
> >  #include <scsi/scsi_dbg.h>
> >  #include <scsi/scsi_transport_spi.h>
> >  
> > @@ -458,6 +461,7 @@ static void free_all_tags(void)
> >  
> >  static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
> >  {
> > +#if !defined(CONFIG_SUN3)
> >  	unsigned long endaddr;
> >  #if (NDEBUG & NDEBUG_MERGING)
> >  	unsigned long oldlen = cmd->SCp.this_residual;
> > @@ -482,6 +486,7 @@ static void merge_contiguous_buffers(str
> >  		dprintk(NDEBUG_MERGING, "merged %d buffers from %p, new length %08x\n",
> >  			   cnt, cmd->SCp.ptr, cmd->SCp.this_residual);
> >  #endif
> > +#endif /* !defined(CONFIG_SUN3) */
> >  }
> >  
> >  /*
> > @@ -1043,12 +1048,10 @@ static void NCR5380_main(struct work_str
> >  			     prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp)) {
> >  				u8 lun = tmp->device->lun;
> >  
> > -#if (NDEBUG & NDEBUG_LISTS)
> > -				if (prev != tmp)
> > -					printk("MAIN tmp=%p   target=%d   busy=%d lun=%llu\n",
> > -					       tmp, tmp->device->id, hostdata->busy[tmp->device->id],
> > -					       lun);
> > -#endif
> > +				dprintk(NDEBUG_LISTS,
> > +				        "MAIN tmp=%p target=%d busy=%d lun=%d\n",
> > +				        tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
> > +				        lun);
> >  				/*  When we find one, remove it from the issue queue. */
> >  				/* ++guenther: possible race with Falcon locking */
> >  				if (
> > @@ -1157,9 +1160,11 @@ static void NCR5380_main(struct work_str
> >  static void NCR5380_dma_complete(struct Scsi_Host *instance)
> >  {
> >  	SETUP_HOSTDATA(instance);
> > -	int transfered, saved_data = 0, overrun = 0, cnt, toPIO;
> > -	unsigned char **data, p;
> > +	int transfered;
> > +	unsigned char **data;
> >  	volatile int *count;
> > +	int saved_data = 0, overrun = 0;
> > +	unsigned char p;
> >  
> >  	if (!hostdata->connected) {
> >  		printk(KERN_WARNING "scsi%d: received end of DMA interrupt with "
> 
> nitpick: shouldn't that be 'transferred' ?


The intention of this patch was to merge two files into one file, in such 
a way that the result could be easily compared with the originals.

With that in mind, fixing this typo could be done pre-merger by patching 
both files, or post-merger by patching just one.

If this patch series ends up iterating again as v3, I'll add a new patch 
to the end to fix this (long standing) typo.

If there's no need for a re-spin, I'll send a separate patch with Cc to 
trivial@kernel.org.


> 
> > @@ -1185,6 +1190,26 @@ static void NCR5380_dma_complete(struct
> >  		   HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
> >  		   NCR5380_read(STATUS_REG));
> >  
> > +#if defined(CONFIG_SUN3)
> > +	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
> > +		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
> > +		       instance->host_no);
> > +		pr_err("please e-mail sammy@sammy.net with a description of how this error was produced.\n");
> > +		BUG();
> > +	}
> > +
> > +	/* make sure we're not stuck in a data phase */
> > +	if ((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH | BASR_ACK)) ==
> > +	    (BASR_PHASE_MATCH | BASR_ACK)) {
> > +		pr_err("scsi%d: BASR %02x\n", instance->host_no,
> > +		       NCR5380_read(BUS_AND_STATUS_REG));
> > +		pr_err("scsi%d: bus stuck in data phase -- probably a single byte overrun!\n",
> > +		       instance->host_no);
> > +		pr_err("not prepared for this error! please e-mail sammy@sammy.net with a description of how this error was produced.\n");
> > +		BUG();
> > +	}
> > +#endif
> > +
> >  	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> >  	NCR5380_write(MODE_REG, MR_BASE);
> >  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> > @@ -1198,6 +1223,8 @@ static void NCR5380_dma_complete(struct
> >  	*count -= transfered;
> >  
> >  	if (hostdata->read_overruns) {
> > +		int cnt, toPIO;
> > +
> >  		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) == p && (p & SR_IO)) {
> >  			cnt = toPIO = hostdata->read_overruns;
> >  			if (overrun) {
> > @@ -1277,11 +1304,14 @@ static irqreturn_t NCR5380_intr(int irq,
> >  			{
> >  /* MS: Ignore unknown phase mismatch interrupts (caused by EOP interrupt) */
> >  				if (basr & BASR_PHASE_MATCH)
> > -					printk(KERN_NOTICE "scsi%d: unknown interrupt, "
> > +					dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt, "
> >  					       "BASR 0x%x, MR 0x%x, SR 0x%x\n",
> >  					       HOSTNO, basr, NCR5380_read(MODE_REG),
> >  					       NCR5380_read(STATUS_REG));
> >  				(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +#ifdef SUN3_SCSI_VME
> > +				dregs->csr |= CSR_DMA_ENABLE;
> > +#endif
> >  			}
> >  		} /* if !(SELECTION || PARITY) */
> >  		handled = 1;
> > @@ -1290,6 +1320,9 @@ static irqreturn_t NCR5380_intr(int irq,
> >  		       "BASR 0x%X, MR 0x%X, SR 0x%x\n", HOSTNO, basr,
> >  		       NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
> >  		(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +#ifdef SUN3_SCSI_VME
> > +		dregs->csr |= CSR_DMA_ENABLE;
> > +#endif
> >  	}
> >  
> >  	if (!done) {
> > @@ -1622,6 +1655,9 @@ static int NCR5380_select(struct Scsi_Ho
> >  #ifndef SUPPORT_TAGS
> >  	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
> >  #endif
> > +#ifdef SUN3_SCSI_VME
> > +	dregs->csr |= CSR_INTR;
> > +#endif
> >  
> >  	initialize_SCp(cmd);
> >  
> > @@ -1845,9 +1881,54 @@ static int NCR5380_transfer_dma(struct S
> >  	SETUP_HOSTDATA(instance);
> >  	register int c = *count;
> >  	register unsigned char p = *phase;
> > +	unsigned long flags;
> > +
> > +#if defined(CONFIG_SUN3)
> > +	/* sanity check */
> > +	if (!sun3_dma_setup_done) {
> > +		pr_err("scsi%d: transfer_dma without setup!\n",
> > +		       instance->host_no);
> > +		BUG();
> > +	}
> > +	hostdata->dma_len = c;
> > +
> > +	dprintk(NDEBUG_DMA, "scsi%d: initializing DMA for %s, %d bytes %s %p\n",
> > +		instance->host_no, (p & SR_IO) ? "reading" : "writing",
> > +		c, (p & SR_IO) ? "to" : "from", *data);
> > +
> > +	/* netbsd turns off ints here, why not be safe and do it too */
> > +	local_irq_save(flags);
> > +
> > +	/* send start chain */
> > +	sun3scsi_dma_start(c, *data);
> > +
> > +	if (p & SR_IO) {
> > +		NCR5380_write(TARGET_COMMAND_REG, 1);
> > +		NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +		NCR5380_write(INITIATOR_COMMAND_REG, 0);
> > +		NCR5380_write(MODE_REG,
> > +			      (NCR5380_read(MODE_REG) | MR_DMA_MODE | MR_ENABLE_EOP_INTR));
> > +		NCR5380_write(START_DMA_INITIATOR_RECEIVE_REG, 0);
> > +	} else {
> > +		NCR5380_write(TARGET_COMMAND_REG, 0);
> > +		NCR5380_read(RESET_PARITY_INTERRUPT_REG);
> > +		NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_DATA);
> > +		NCR5380_write(MODE_REG,
> > +			      (NCR5380_read(MODE_REG) | MR_DMA_MODE | MR_ENABLE_EOP_INTR));
> > +		NCR5380_write(START_DMA_SEND_REG, 0);
> > +	}
> > +
> > +#ifdef SUN3_SCSI_VME
> > +	dregs->csr |= CSR_DMA_ENABLE;
> > +#endif
> > +
> > +	local_irq_restore(flags);
> > +
> > +	sun3_dma_active = 1;
> > +
> > +#else /* !defined(CONFIG_SUN3) */
> >  	register unsigned char *d = *data;
> >  	unsigned char tmp;
> > -	unsigned long flags;
> >  
> >  	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
> >  		*phase = tmp;
> > @@ -1895,6 +1976,8 @@ static int NCR5380_transfer_dma(struct S
> >  			NCR5380_dma_write_setup(instance, d, c);
> >  		local_irq_restore(flags);
> >  	}
> > +#endif /* !defined(CONFIG_SUN3) */
> > +
> >  	return 0;
> >  }
> >  #endif /* defined(REAL_DMA) */
> > @@ -1930,6 +2013,10 @@ static void NCR5380_information_transfer
> >  	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
> >  	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
> >  
> > +#ifdef SUN3_SCSI_VME
> > +	dregs->csr |= CSR_INTR;
> > +#endif
> > +
> >  	while (1) {
> >  		tmp = NCR5380_read(STATUS_REG);
> >  		/* We only have a valid SCSI phase when REQ is asserted */
> > @@ -1939,6 +2026,33 @@ static void NCR5380_information_transfer
> >  				old_phase = phase;
> >  				NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
> >  			}
> > +#if defined(CONFIG_SUN3)
> > +			if (phase == PHASE_CMDOUT) {
> > +#if defined(REAL_DMA)
> > +				void *d;
> > +				unsigned long count;
> > +
> > +				if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
> > +					count = cmd->SCp.buffer->length;
> > +					d = sg_virt(cmd->SCp.buffer);
> > +				} else {
> > +					count = cmd->SCp.this_residual;
> > +					d = cmd->SCp.ptr;
> > +				}
> > +				/* this command setup for dma yet? */
> > +				if ((count >= DMA_MIN_SIZE) && (sun3_dma_setup_done != cmd)) {
> > +					if (cmd->request->cmd_type == REQ_TYPE_FS) {
> > +						sun3scsi_dma_setup(d, count,
> > +						                   rq_data_dir(cmd->request));
> > +						sun3_dma_setup_done = cmd;
> > +					}
> > +				}
> > +#endif
> > +#ifdef SUN3_SCSI_VME
> > +				dregs->csr |= CSR_INTR;
> > +#endif
> > +			}
> > +#endif /* CONFIG_SUN3 */
> >  
> >  			if (sink && (phase != PHASE_MSGOUT)) {
> >  				NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
> > @@ -2000,8 +2114,11 @@ static void NCR5380_information_transfer
> >  				 */
> >  
> >  #if defined(REAL_DMA)
> > -				if (!cmd->device->borken &&
> > -				    (transfersize = NCR5380_dma_xfer_len(instance,cmd,phase)) > 31) {
> > +				if (
> > +#if !defined(CONFIG_SUN3)
> > +				    !cmd->device->borken &&
> > +#endif
> > +				    (transfersize = NCR5380_dma_xfer_len(instance, cmd, phase)) >= DMA_MIN_SIZE) {
> >  					len = transfersize;
> >  					cmd->SCp.phase = phase;
> >  					if (NCR5380_transfer_dma(instance, &phase,
> > @@ -2038,6 +2155,11 @@ static void NCR5380_information_transfer
> >  					NCR5380_transfer_pio(instance, &phase,
> >  							     (int *)&cmd->SCp.this_residual,
> >  							     (unsigned char **)&cmd->SCp.ptr);
> > +#if defined(CONFIG_SUN3) && defined(REAL_DMA)
> > +				/* if we had intended to dma that command clear it */
> > +				if (sun3_dma_setup_done == cmd)
> > +					sun3_dma_setup_done = NULL;
> > +#endif
> >  				break;
> >  			case PHASE_MSGIN:
> >  				len = 1;
> > @@ -2243,6 +2365,9 @@ static void NCR5380_information_transfer
> >  					/* Wait for bus free to avoid nasty timeouts */
> >  					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
> >  						barrier();
> > +#ifdef SUN3_SCSI_VME
> > +					dregs->csr |= CSR_DMA_ENABLE;
> > +#endif
> >  					return;
> >  					/*
> >  					 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
> > @@ -2402,17 +2527,20 @@ static void NCR5380_information_transfer
> >   */
> >  
> >  
> > +/* it might eventually prove necessary to do a dma setup on
> > +   reselection, but it doesn't seem to be needed now -- sam */
> > +
> >  static void NCR5380_reselect(struct Scsi_Host *instance)
> >  {
> >  	SETUP_HOSTDATA(instance);
> >  	unsigned char target_mask;
> > -	unsigned char lun, phase;
> > -	int len;
> > +	unsigned char lun;
> >  #ifdef SUPPORT_TAGS
> >  	unsigned char tag;
> >  #endif
> >  	unsigned char msg[3];
> > -	unsigned char *data;
> > +	int __maybe_unused len;
> > +	unsigned char __maybe_unused *data, __maybe_unused phase;
> >  	struct scsi_cmnd *tmp = NULL, *prev;
> >  
> >  	/*
> > @@ -2449,10 +2577,18 @@ static void NCR5380_reselect(struct Scsi
> >  	while (!(NCR5380_read(STATUS_REG) & SR_REQ))
> >  		;
> >  
> > +#if defined(CONFIG_SUN3) && defined(REAL_DMA)
> > +	/* acknowledge toggle to MSGIN */
> > +	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(PHASE_MSGIN));
> > +
> > +	/* peek at the byte without really hitting the bus */
> > +	msg[0] = NCR5380_read(CURRENT_SCSI_DATA_REG);
> > +#else
> >  	len = 1;
> >  	data = msg;
> >  	phase = PHASE_MSGIN;
> >  	NCR5380_transfer_pio(instance, &phase, &len, &data);
> > +#endif
> >  
> >  	if (!(msg[0] & 0x80)) {
> >  		printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
> > @@ -2462,7 +2598,7 @@ static void NCR5380_reselect(struct Scsi
> >  	}
> >  	lun = (msg[0] & 0x07);
> >  
> > -#ifdef SUPPORT_TAGS
> > +#if defined(SUPPORT_TAGS) && !defined(CONFIG_SUN3)
> >  	/* If the phase is still MSGIN, the target wants to send some more
> >  	 * messages. In case it supports tagged queuing, this is probably a
> >  	 * SIMPLE_QUEUE_TAG for the I_T_L_Q nexus.
> > @@ -2524,9 +2660,51 @@ static void NCR5380_reselect(struct Scsi
> >  		return;
> >  	}
> >  
> > +#if defined(CONFIG_SUN3) && defined(REAL_DMA)
> > +	/* engage dma setup for the command we just saw */
> > +	{
> > +		void *d;
> > +		unsigned long count;
> > +
> > +		if (!tmp->SCp.this_residual && tmp->SCp.buffers_residual) {
> > +			count = tmp->SCp.buffer->length;
> > +			d = sg_virt(tmp->SCp.buffer);
> > +		} else {
> > +			count = tmp->SCp.this_residual;
> > +			d = tmp->SCp.ptr;
> > +		}
> > +		/* setup this command for dma if not already */
> > +		if ((count >= DMA_MIN_SIZE) && (sun3_dma_setup_done != tmp)) {
> > +			sun3scsi_dma_setup(d, count, rq_data_dir(tmp->request));
> > +			sun3_dma_setup_done = tmp;
> > +		}
> > +	}
> > +
> > +	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
> > +#endif
> > +
> >  	/* Accept message by clearing ACK */
> >  	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> >  
> > +#if defined(SUPPORT_TAGS) && defined(CONFIG_SUN3)
> > +	/* If the phase is still MSGIN, the target wants to send some more
> > +	 * messages. In case it supports tagged queuing, this is probably a
> > +	 * SIMPLE_QUEUE_TAG for the I_T_L_Q nexus.
> > +	 */
> > +	tag = TAG_NONE;
> > +	if (phase == PHASE_MSGIN && setup_use_tagged_queuing) {
> > +		/* Accept previous IDENTIFY message by clearing ACK */
> > +		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> > +		len = 2;
> > +		data = msg + 1;
> > +		if (!NCR5380_transfer_pio(instance, &phase, &len, &data) &&
> > +		    msg[1] == SIMPLE_QUEUE_TAG)
> > +			tag = msg[2];
> > +		dprintk(NDEBUG_TAGS, "scsi%d: target mask %02x, lun %d sent tag %d at reselection\n"
> > +			HOSTNO, target_mask, lun, tag);
> > +	}
> > +#endif
> > +
> >  	hostdata->connected = tmp;
> >  	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %llu, tag = %d\n",
> >  		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
> > Index: linux/drivers/scsi/atari_scsi.c
> > ===================================================================
> > --- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:55.000000000 +1100
> > +++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:25:56.000000000 +1100
> > @@ -89,6 +89,7 @@
> >  #define REAL_DMA
> >  #define SUPPORT_TAGS
> >  #define MAX_TAGS                        32
> > +#define DMA_MIN_SIZE                    32
> >  
> >  #define NCR5380_implementation_fields   /* none */
> >  
> > 
> > 
> You reference a certain Sam Creasey in the code (and there is even
> his email in it). Has he contributed to this patch?

No, the patch is my work.

As I understand it, sun3_NCR5380.c was originally Sam's (derived) work.


> If so, shouldn't he be added somewhere in the patch description,
> either with 'From;' (if the patch was originally by him)
> or with a 'Signed-off-by' tag?

I did Cc these patches to Sam, for comment/testing; perhaps a Cc tag might 
have been appropriate but I gather they are optional.

-- 
