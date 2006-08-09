From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add Promise SuperTrak EX 'stex' driver
Date: Wed, 09 Aug 2006 09:18:16 -0500
Message-ID: <1155133096.26517.120.camel@mulgrave.il.steeleye.com>
References: <NONAMEBxe2jl8n4bRNe0000069a@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38306 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750876AbWHIOS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 10:18:29 -0400
In-Reply-To: <NONAMEBxe2jl8n4bRNe0000069a@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "promise_linux@promise.com" <promise_linux@promise.com>, "akpm@osdl.org" <akpm@osdl.org>, jeff <jeff@garzik.org>

On Wed, 2006-08-09 at 13:17 +0800, Ed Lin wrote:
> >This implementation isn't correct.  Either a reset is triggered as part
> >of error handling, in which case every command is guaranteed to be
> >completed or timed out, or it's been done from sg in which case the user
> >wants an immediate reset.  In either case, you shouldn't be waiting
> >another 10 seconds for active commands.
> >
> 
> In case when the firmware is busying with some internal affairs, it
> does not process and respond requests in time, but the status of the
> firmware is still good, after a while it could resume to normal
> operation. So, waiting an extra period is equal to extending command
> time out value, it could also avoid doing costly real hard reset when
> it's avoidable. I am explaining what's the purpose of the code, but
> I agree it could be deleted since it is not the responsibility of
> driver, and the intended effect is not confirmed.

Actually, if that can happen, you can adjust the command timeouts in
your slave configure routine by setting a value in scsi_device->timeout.
This only applies to ordinary read/write commands, but by and large,
that's all you want to influence.

megaraid_sas actually does this, if you want an example (for precisely
the same problem: its firmware can be busy as well).

> >> +	if (hba->cardtype == st_shasta)
> >> +		stex_hard_reset(hba);
> >
> >Don't you also want some type of processing for st_vsc?  Otherwise it
> >looks like it will drop straight through the error handler and be
> >offlined.
> >
> Actually, I saw a SCSI driver that do nothing but just wait for fw/hw to
> be ready, if I read it correctly. We found we could do something useful
> to st_shasta. But, for st_vsc, we have not found it yet. We will try hand
> shake nonetheless, which still has a chance of success.

OK ... just checking ... we certainly have drivers whose error handling
does nothing (sometimes even because there's nothing that can be done).

> >stex_handshake is touching the doorbell without locking, is that OK?  It
> >looks like it might be since it only happens either at start of day or
> >after reset, but what happens (as the kexec people will remind us) if
> >the bios hasn't quesced the card (the handshake is done after the
> >interrupt is added ... it could fire immediately)?
> >
> In kernel 2.6, if there is an unhandled IRQ, it could simply be disabled.
> If this happens, then the driver just can not process interrupts as
> normal after all. So we need not worry about it. For the rare case where
> interrupt is triggered after request_irq() but before hand shake succeeds
> (which is highly improbable), the interrupt will be cleared and processed
> (harmlessly) in interrupt handler. So I think it's good for this case.

Thanks, just checking

> >
> >> +static void stex_hba_stop(struct st_hba *hba)
> >> +{
> >> +	unsigned long flags;
> >> +	int i;
> >> +	u16 tag;
> >> +
> >> +	spin_lock_irqsave(hba->host->host_lock, flags);
> >> +	if ((tag = stex_alloc_tag((unsigned long *)&hba->tag))
> >> +		== TAG_BITMAP_LENGTH) {
> >> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +		printk(KERN_ERR DRV_NAME "(%s): unable to alloc tag\n",
> >> +			pci_name(hba->pdev));
> >> +		return;
> >> +	}
> >> +	for (i=0; i<(ST_MAX_ARRAY_SUPPORTED*ST_MAX_LUN_PER_TARGET*2); i++) {
> >> +		stex_internal_flush(hba, i, tag);
> >> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +
> >> +		wait_event_timeout(hba->waitq,
> >> +			!(hba->ccb[tag].req_type), ST_INTERNAL_TIMEOUT*HZ);
> >> +		if (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE)
> >> +			return;
> >> +		spin_lock_irqsave(hba->host->host_lock, flags);
> >> +	}
> >> +
> >> +	stex_free_tag((unsigned long *)&hba->tag, tag);
> >> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >> +}
> >
> >This is really inefficient (looping over all targets whether present or
> >not).  Just implement slave destroy, it will keep track of allocated
> >in-use targets for you.
> >
> I guess we could use slave_destroy when it's driver unloading. But how
> about shut down? Will slave_destroy be called when system shutdown?

No ... slave destroy is really only called on module or device removal.
For the shutdown case, we use the shutdown methods of the ULDs to do
this (in your case, that would be sd).  However, for shutdown here to
call sync cache, you have to respond to the caching mode sense as having
a write back cache for this to happen (which was an issue pointed out in
the other email).

James


