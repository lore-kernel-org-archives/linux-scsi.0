From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Sat, 11 Jun 2005 16:37:45 +0100
Message-ID: <20050611153745.GA31943@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21889 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261342AbVFKPhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 11:37:47 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC72@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

> diff -upNr linux-2.6.12-rc6/drivers/scsi/scsi_scan.c linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_scan.c
> --- linux-2.6.12-rc6/drivers/scsi/scsi_scan.c	2005-06-09 15:58:31.000000000 -0400
> +++ linux-2.6.12-rc6.PATCHED/drivers/scsi/scsi_scan.c	2005-06-10 16:11:04.000000000 -0400
> @@ -332,9 +332,23 @@ static struct scsi_target *scsi_alloc_ta
>  	unsigned long flags;
>  	const int size = sizeof(struct scsi_target)
>  		+ shost->transportt->target_size;
> -	struct scsi_target *starget = kmalloc(size, GFP_ATOMIC);
> +	struct scsi_target *starget;
>  	struct scsi_target *found_target;
>  
> +	/*
> +	 * Obtain the real parent from the transport. The transport
> +	 * is allowed to fail (no error) if there is nothing at that
> +	 * target id.
> +	 */
> +	if (shost->transportt->target_parent) {
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		parent = shost->transportt->target_parent(shost, channel, id);
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		if (!parent)
> +			return NULL;
> +	}

Ok, this idea is a lot better, but I think scsi_alloc_target is still
the wrong place to put this.  It has an explicit parent argument that
all but one of it's callers get right, and we're now totally ignoring
and looking it up again when the transport has a ->target_parent method.

I'm not totally sure where the right place to put it in the
scsi_scan_host_selected path is, though.  Probably scsi_scan_host_selected
shoud just become __scsi_scan_host_selected, scsi_scan_host would call
it directly but the sysfs and legacy procfs scanning would call the method.

Or it might be better to give the transport completely control over the
scan sysfs attribute, that way we could even allow scanning by WWNs or
similar things.

