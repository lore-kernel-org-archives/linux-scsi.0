From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 29/36] atari_NCR5380: Refactor Falcon locking
Date: Sun, 9 Nov 2014 23:18:43 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411091125480.4669@nippy.intranet>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052614.115438637@telegraphics.com.au> <5451F67A.2000708@suse.de> <alpine.LNX.2.00.1410311523590.7380@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:39048 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaKIMTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 07:19:43 -0500
In-Reply-To: <alpine.LNX.2.00.1410311523590.7380@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org


Ping...

On Fri, 31 Oct 2014, Finn Thain wrote:

> 
> On Thu, 30 Oct 2014, Hannes Reinecke wrote:
> 
> > On 10/27/2014 06:26 AM, Finn Thain wrote:
> > > Simplify falcon_release_lock_if_possible() by making callers 
> > > responsible for disabling local IRQ's, which they must do anyway to 
> > > correctly synchronize the ST DMA "lock" with core driver data 
> > > structures. Move this synchronization logic to the core driver with 
> > > which it is tightly coupled.
> > > 
> > > Other LLD's like sun3_scsi and mac_scsi that can make use of this core 
> > > driver can just stub out the NCR5380_acquire_dma_irq() and 
> > > NCR5380_release_dma_irq() calls so the compiler will eliminate the ST 
> > > DMA code.
> > > 
> > > Remove a redundant local_irq_save/restore pair (irq's are disabled for 
> > > interrupt handlers these days). Revise the locking for 
> > > atari_scsi_bus_reset(): use local_irq_save/restore() instead of 
> > > atari_turnoff/turnon_irq(). There is no guarantee that atari_scsi 
> > > still holds the ST DMA lock during EH, so atari_turnoff/turnon_irq() 
> > > could end up dropping an IDE or floppy interrupt.
> > > 
> > > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > > 
> > > ---
> > >  drivers/scsi/atari_NCR5380.c |   72 ++++++++++++++++++++++++++-----------------
> > >  drivers/scsi/atari_scsi.c    |   47 ++++++++++------------------
> > >  2 files changed, 62 insertions(+), 57 deletions(-)
> > > 
> > > Index: linux/drivers/scsi/atari_NCR5380.c
> > > ===================================================================
> > > --- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:54.000000000 +1100
> > > +++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:55.000000000 +1100
> > > @@ -926,7 +926,7 @@ static int NCR5380_queue_command(struct
> > >  	 * alter queues and touch the lock.
> > >  	 */
> > >  	/* perhaps stop command timer here */
> > > -	if (!falcon_get_lock())
> > > +	if (!NCR5380_acquire_dma_irq(instance))
> > >  		return SCSI_MLQUEUE_HOST_BUSY;
> > >  	/* perhaps restart command timer here */
> > >  
> > > @@ -962,6 +962,18 @@ static int NCR5380_queue_command(struct
> > >  	return 0;
> > >  }
> > >  
> > > +static inline void maybe_release_dma_irq(struct Scsi_Host *instance)
> > > +{
> > > +	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> > > +
> > > +	/* Caller does the locking needed to set & test these data atomically */
> > > +	if (!hostdata->disconnected_queue &&
> > > +	    !hostdata->issue_queue &&
> > > +	    !hostdata->connected &&
> > > +	    !hostdata->retain_dma_intr)
> > > +		NCR5380_release_dma_irq(instance);
> > > +}
> > > +
> > >  /*
> > >   * Function : NCR5380_main (void)
> > >   *
> > > @@ -1084,9 +1096,11 @@ static void NCR5380_main(struct work_str
> > >  					cmd_get_tag(tmp, tmp->cmnd[0] != REQUEST_SENSE);
> > >  #endif
> > >  					if (!NCR5380_select(instance, tmp)) {
> > > +						local_irq_disable();
> > >  						hostdata->retain_dma_intr--;
> > >  						/* release if target did not response! */
> > > -						falcon_release_lock_if_possible(hostdata);
> > > +						maybe_release_dma_irq(instance);
> > > +						local_irq_restore(flags);
> > >  						break;
> > >  					} else {
> > >  						local_irq_disable();
> > > @@ -2085,11 +2099,12 @@ static void NCR5380_information_transfer
> > >  				case COMMAND_COMPLETE:
> > >  					/* Accept message by clearing ACK */
> > >  					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
> > > -					/* ++guenther: possible race with Falcon locking */
> > > -					hostdata->retain_dma_intr++;
> > > -					hostdata->connected = NULL;
> > >  					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
> > >  						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
> > > +
> > > +					local_irq_save(flags);
> > > +					hostdata->retain_dma_intr++;
> > > +					hostdata->connected = NULL;
> > >  #ifdef SUPPORT_TAGS
> > >  					cmd_free_tag(cmd);
> > >  					if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
> > > @@ -2148,17 +2163,17 @@ static void NCR5380_information_transfer
> > >  
> > >  						dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n", HOSTNO);
> > >  
> > > -						local_irq_save(flags);
> > >  						LIST(cmd,hostdata->issue_queue);
> > >  						SET_NEXT(cmd, hostdata->issue_queue);
> > >  						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
> > > -						local_irq_restore(flags);
> > >  						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
> > >  							  "issue queue\n", H_NO(cmd));
> > >  					} else {
> > >  						cmd->scsi_done(cmd);
> > >  					}
> > >  
> > > +					local_irq_restore(flags);
> > > +
> > >  					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> > >  					/*
> > >  					 * Restore phase bits to 0 so an interrupted selection,
> > Probably a stupid question, but you're disabling local interrupts.
> > scsi_done() OTOH is triggering a soft irq.
> 
> Isn't that how all bottom halves work?
> 
> > Does this work?
> 
> Yes, I've tested that particular code. I'm pretty sure Michael has too.
> 
> A quick search turned up another example of this in 
> zfcp_fsf_fcp_cmnd_handler().
> 
> > Shouldn't we enable interrupts before calling scsi_done() ?
> 
> I don't see anything in the scsi_done() implementation in scsi_lib.c that 
> would be problematic. The description says "This function is interrupt 
> context safe". The same would have to apply to scsi_eh_done().
> 
> 
-- 
