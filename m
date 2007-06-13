From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/5] ibmvscsi: Add eh_host_reset_handler
Date: Wed, 13 Jun 2007 18:30:21 -0400
Message-ID: <46706FFD.5030704@garzik.org>
References: <11817727312836-patch-mail.ibm.com> <200706132212.l5DMCQD9002964@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40464 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbXFMWaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:30:25 -0400
In-Reply-To: <200706132212.l5DMCQD9002964@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Brian King wrote:
> +	spin_lock_irqsave(hostdata->host->host_lock, flags);
> +	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
> +		list_del(&tmp_evt->list);
> +		del_timer(&tmp_evt->timer);
> +		if (tmp_evt->cmnd) {
> +			tmp_evt->cmnd->result = (error_code << 16);
> +			unmap_cmd_data(&tmp_evt->iu.srp.cmd,
> +				       tmp_evt,
> +				       tmp_evt->hostdata->dev);
> +			if (tmp_evt->cmnd_done)
> +				tmp_evt->cmnd_done(tmp_evt->cmnd);
> +		} else if (tmp_evt->done)
> +			tmp_evt->done(tmp_evt);
> +		free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
> +	}
> +	spin_unlock_irqrestore(hostdata->host->host_lock, flags);


Since it's been so long since I bothered with the old-style error 
handling, a dumb question:

Are you sure that you should be completing the commands in the host 
reset handler?  I thought EH took care of that, and your sole task in 
the host reset handler was to reset everything attached to a single 
scsi_host.

	Jeff


