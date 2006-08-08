From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add Promise SuperTrak EX 'stex' driver
Date: Tue, 08 Aug 2006 13:09:18 -0500
Message-ID: <1155060558.26517.48.camel@mulgrave.il.steeleye.com>
References: <20060808120507.GA20032@havoc.gtf.org>
	 <1155053479.26517.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30863 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964960AbWHHSJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 14:09:36 -0400
In-Reply-To: <1155053479.26517.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, promise_linux@promise.com, akpm@osdl.org

Some more I missed in the first glance through:


> +	err = request_irq(pdev->irq, stex_intr, SA_SHIRQ, DRV_NAME, hba);

Needs to be IRQF_SHARED now.

> +static int stex_reset(struct scsi_cmnd *cmd)
> +{
> +	struct st_hba *hba;
> +	int tag;
> +	int i = 0;
> +	unsigned long flags;
> +	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
> +
> +wait_cmds:
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	for (tag = 0; tag < MU_MAX_REQUEST; tag++)
> +		if ((hba->tag & (1 << tag)) && hba->ccb[tag].req != NULL)
> +			break;
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	if (tag < MU_MAX_REQUEST) {
> +		ssleep(1);
> +		if (++i < 10)
> +			goto wait_cmds;
> +	}

This implementation isn't correct.  Either a reset is triggered as part
of error handling, in which case every command is guaranteed to be
completed or timed out, or it's been done from sg in which case the user
wants an immediate reset.  In either case, you shouldn't be waiting
another 10 seconds for active commands.

> +	if (hba->cardtype == st_shasta)
> +		stex_hard_reset(hba);

Don't you also want some type of processing for st_vsc?  Otherwise it
looks like it will drop straight through the error handler and be
offlined.

stex_handshake is touching the doorbell without locking, is that OK?  It
looks like it might be since it only happens either at start of day or
after reset, but what happens (as the kexec people will remind us) if
the bios hasn't quesced the card (the handshake is done after the
interrupt is added ... it could fire immediately)?


> +static void stex_hba_stop(struct st_hba *hba)
> +{
> +	unsigned long flags;
> +	int i;
> +	u16 tag;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	if ((tag = stex_alloc_tag((unsigned long *)&hba->tag))
> +		== TAG_BITMAP_LENGTH) {
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		printk(KERN_ERR DRV_NAME "(%s): unable to alloc tag\n",
> +			pci_name(hba->pdev));
> +		return;
> +	}
> +	for (i=0; i<(ST_MAX_ARRAY_SUPPORTED*ST_MAX_LUN_PER_TARGET*2); i++) {
> +		stex_internal_flush(hba, i, tag);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +		wait_event_timeout(hba->waitq,
> +			!(hba->ccb[tag].req_type), ST_INTERNAL_TIMEOUT*HZ);
> +		if (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE)
> +			return;
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +	}
> +
> +	stex_free_tag((unsigned long *)&hba->tag, tag);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +}

This is really inefficient (looping over all targets whether present or
not).  Just implement slave destroy, it will keep track of allocated
in-use targets for you.

James


