From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Correct issue with midlayer scsi target allocation and transports that create the targets
Date: Fri, 10 Jun 2005 21:25:43 +0100
Message-ID: <20050610202543.GA13494@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC6F@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60382 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261209AbVFJUZp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 16:25:45 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC6F@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

> Here's a proposed patch. The real problem in all of this was that
> we had 2 places allocating a scsi target (or should I say, that
> invoked the scan function that makes the target, but the parents
> are different).  This patch adds a transport alloc_target function,
> which allows the transport to adjusts the parent, and then calls
> back into the midlayer to complete the allocation (small recursive
> call). It has one additional optimization in that, if the transport
> is doling out targets, it fails target allocations on things that
> don't exist. This will make scanning slightly faster. I also like
> this patch as it leaves all "scan" logic in the midlayer.

I don't like the recursion part of this at all.  I'd suggest to make
scsi_alloc_target a tiny wrapper around the transport ->alloc_target +
a default action, the shared body that's in scsi_alloc_target will
become __scsi_alloc_target.

> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_for_each_entry_safe(rport, next_rport,
> +			&fc_host_rports(shost), peers) {

you don't actually need list_for_each_entry_safe here as you're dropping
out of the loop once the right rport has been found.

> +		if ((rport->channel == channel) &&
> +		    (rport->scsi_target_id == id)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			starget = scsi_alloc_target(&rport->dev, channel, id);
> +			if (starget)
> +				return 0;
> +			return 1;

this is always under the scan_mutex, right?  else we'd get a race after
the sin_unlock but before registering the new target.

