From: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Tue, 24 Apr 2007 13:44:40 -0700 (PDT)
Message-ID: <20070424.134440.45874613.davem@davemloft.net>
References: <20070423.151322.111205472.davem@davemloft.net>
	<20070424122235.GA26242@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57396
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbXDXUoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 16:44:34 -0400
In-Reply-To: <20070424122235.GA26242@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Apr 2007 13:22:35 +0100

> Overall the driver looks really nice, thanks a lot!

Thanks.

> would be nice to have dev_printk here, but sbus still seems to
> lack driver model integration.

There is only partial integration at the moment, but filling
that gap is certainly planned.

> The non-use-sg case is dead, you can put in BUG_ON()s here and in
> the unmap path.

Thanks I've done that.

> > +static void esp_build_sync_msg(struct esp *esp, u8 period, u8 offset)
> >  {
> > +	esp->msg_out[0] = EXTENDED_MESSAGE;
> > +	esp->msg_out[1] = 3;
> > +	esp->msg_out[2] = EXTENDED_SDTR;
> > +	esp->msg_out[3] = period;
> > +	esp->msg_out[4] = offset;
> > +	esp->msg_out_len = 5;
> > +}
> >  
> > +static void esp_build_wide_msg(struct esp *esp, int wide)
> > +{
> > +	esp->msg_out[0] = EXTENDED_MESSAGE;
> > +	esp->msg_out[1] = 2;
> > +	esp->msg_out[2] = EXTENDED_WDTR;
> > +	esp->msg_out[3] = (wide ? 1 : 0);
> > +	esp->msg_out_len = 4;
> >  }
> 
> These might actually be worth putting into the spi transport
> class, taking an u8 * as first argument.  After all all
> SPI drivers without smart firmware will need them.

As others noted the SPI layer does have this already.  I converted
esp.c to use them, thanks.

> > +/* If we get a non-tagged command, we let all the current
...
> 
> The comment doesn't match the code.  You don't do the REQUEST_SENSE
> special casing anymore since implementing autosense :)

Amusing, comment deleted :-)

> > +static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
> > +			     struct esp_lun_data *lp)
> > +{
> > +	if (!lp) {
> > +		/* When we don't have lun-data yet, we disallow
> > +		 * disconnects, so we do not have to see if this
> > +		 * untagged command matches a disconnected one and
> > +		 * thus return -EBUSY.
> >  		 */
> > +		return 0;
> > +	}
> 
> Given that you allocate the lun-data in esp_slave_alloc this
> can never happen.  Some more comments on the handling of
> per-lun data here:
> 
>   - normally you allocate per-lun data in slave_alloc and free it
>     in slave_detroy.  This is guranteed to be save because
>     slave_alloc is called before the first I/O and slave_destroy
>     after the last I/O has finished.  No need for checking
>     of it already beeing allocated in esp_slave_alloc.
>   - there is no need to keep track of per-lun data on your own.
>     the midlayer gives you sdev->hostdata for it, and you can
>     easily get at it in every place you use the lun data currently
>  
> Doing things properly also avoids the !lp checks in various places.

I did all of this, and it's fine, but there is one site which is much
less pleasant, device reconnect.

With the esp_target_data->lun[] mapping the lookup during device
reconnect was O(1), now I have to use __scsi_device_lookup_by_target()
which is O(num_active_luns).

In fact the efficiency of that lookup was why I did the data
structures the way I did in the first place.

But anyways this is cleaner for now and I doubt it matters for
the setups people have with this chip.

> > +	if (dev->id == esp->scsi_id) {
> > +		cmd->result = DID_NO_CONNECT << 16;
> > +		cmd->scsi_done(cmd);
> > +		return 0;
> > +	}
> 
> This can't happen, no need to check for it.  (And yes, I know some
> drivers like sym53x8xx still have the checks despite me submitting
> patches to get rid of it)

Ok I'll remove that, thanks.

> > +	spriv->u.dma_addr = ~(dma_addr_t)0x0;
> > +	spriv->mapping_type = MAPPING_TYPE_NONE;
> >  
> > +	ent = esp_get_ent(esp);
> > +	if (!ent) {
> > +		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
> > +		cmd->scsi_done(cmd);
> > +		return 0;
> 
> This should not set ->result and call ->scsi_done but rather return
> SCSI_MLQUEUE_HOST_BUSY.

Done.

> > +	}
> > +	ent->cmd = cmd;
> >  
> > +	if (cmd->cmnd[0] == REQUEST_SENSE)
> > +		list_add(&ent->list, &esp->queued_cmds);
> > +	else
> > +		list_add_tail(&ent->list, &esp->queued_cmds);
> 
> I don't think there's a need to handle REQUEST_SENSE special anymore.

Agreed, and done.

> >  
> > +	esp_maybe_execute_command(esp);
> 
> You still have internal queueing in the driver, and I think this
> is avoidable.  Instead you should just try to directly issue
> the command and return SCSI_MLQUEUE_DEVICE_BUSY/SCSI_MLQUEUE_EH_RETRY
> if you can't do it at this point.  The midlayer keeps proper per-lun
> and per-host busy counters to call into ->queuecommand once the
> next command returned and the lun/host is not busy anymore.

Hmmm, OK.  But which of those two error codes should I use?

Actually I don't think it's avoidable.  I set cmd_per_lun to "2"
and in this way when a command completes I'll always be able to
immediately issue another command for the same device even if
disconnect is disabled.

Otherwise I have to wait for the softirq to run (after ->scsi_done())
and then the scsi mid-layer to feed me another command.  Meanwhile
the scsi bus will be idle when it could be instead running commands.

That is the reason behind this.  It's not simply for queueing up at
->queuecommand().  FWIW, I learned this technique from the aic7xxx
driver :-)

> Wouldn't it be nicer to just export __esp_interrupt and let the driver
> implement the loop around it to avoid all these indirect irq_pending
> calls?

I don't want to have to edit N source files if I want to tweak
the quickirq logic.

> 
> > +	esp->host->unique_id = instance++;
> 
> Most modern driver just set this to the mmio address. It saves no
> purpose but keeping horrible legacy user interfaces around anyway.
> doing it that way allows you to kill the potentially racy instance
> counter.

unique_id is only 32-bits, the MMIO address on sparc64 systems often
only differ in the upper 32bits, in fact I do remember one big sparc64
box where the ESP register addresses only differed like that.

That's why I implemented it this way, I did look at other drivers
and consider going the MMIO route but I simply can't :-)

> 
> > +static int esp_slave_alloc(struct scsi_device *dev)
> >  {
> > +	struct esp *esp = host_to_esp(dev->host);
> > +	struct esp_target_data *tp = &esp->target[dev->id];
> > +	struct esp_lun_data *lp;
> >  
> > +	if (dev->id >= ESP_MAX_TARGET || dev->lun >= ESP_MAX_LUN)
> > +		return -ENXIO;
> 
> Just set max_id and max_lun in the host template and you can get
> rid of these checks.

Ok.

> > +static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
> >  {
> > +	struct esp *esp = host_to_esp(cmd->device->host);
> > +	struct completion eh_reset;
> >  	unsigned long flags;
> >  
> > +	init_completion(&eh_reset);
> >  
> > +	spin_lock_irqsave(esp->host->host_lock, flags);
> >  
> > +	esp->eh_reset = &eh_reset;
> > +
> > +	/* XXX This is too simple... We should add lots of
> > +	 * XXX checks here so that if we find that the chip is
> > +	 * XXX very wedged we return failure immediately so
> > +	 * XXX that we can perform a full chip reset.
> > +	 */
> > +	esp->flags |= ESP_FLAG_RESETTING;
> > +	scsi_esp_cmd(esp, ESP_CMD_RS);
> > +
> > +	spin_unlock_irqrestore(esp->host->host_lock, flags);
> > +
> > +	schedule_timeout_uninterruptible(esp_bus_reset_settle * HZ);
> 
> This should probably be a msleep so you don't have to confert to HZ
> yourself.  (ditto for all the other schedule_timeout_uninterruptible
> uses in the driver)

Ok.  Actually ssleep() seems even more appropriate :-)  So that's
what I'll use.

> And given that you wait for the bus to settle by yourself
> you should probably set skip_settle_delay to 1 in the host template
> so that the error handler doesn't wait another 10 seconds.

Ok.

> >  #ifndef _SPARC_ESP_H
> >  #define _SPARC_ESP_H
> 
> These inclusion guards are wrong now :)

For sure. :)

Thanks for all of your comments.  I'll repost the driver patch
again in a few days in order to let some more feedback come in.
