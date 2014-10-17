From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmw_pvscsi: fixup tagging
Date: Fri, 17 Oct 2014 06:16:51 -0700
Message-ID: <20141017131651.GD16538@infradead.org>
References: <1412234501-78199-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaJQNRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 09:17:00 -0400
Content-Disposition: inline
In-Reply-To: <1412234501-78199-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Arvind Kumar <arvindkumar@vmware.com>, pv-drivers@vmware.com, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

Can I get a review from VMWare for this one, please?

On Thu, Oct 02, 2014 at 09:21:41AM +0200, Hannes Reinecke wrote:
> The request (and SCSI command) tag is the tag number assigned
> by the generic block-tagging code, not the SCSI-II tag messages.
> Those are represented by the device flags 'tagged_supported',
> 'simple_tags', and 'ordered_tags'.
> (The SCSI midlayer doesn't use HEAD_OF_QUEUE tags).
> So fixup vmw_pvscsi to assign the correct tag type.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/vmw_pvscsi.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 598f65e..d18df8c 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -724,9 +724,8 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
>  
>  	e->tag = SIMPLE_QUEUE_TAG;
>  	if (sdev->tagged_supported &&
> -	    (cmd->tag == HEAD_OF_QUEUE_TAG ||
> -	     cmd->tag == ORDERED_QUEUE_TAG))
> -		e->tag = cmd->tag;
> +	    sdev->ordered_tags)
> +		e->tag = ORDERED_QUEUE_TAG;
>  
>  	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
>  		e->flags = PVSCSI_FLAG_CMD_DIR_TOHOST;
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
