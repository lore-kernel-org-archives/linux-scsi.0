From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 01/11] scsi: provide a generic change_queue_type method
Date: Thu, 06 Nov 2014 16:28:41 +0100
Message-ID: <545B93A9.3070206@acm.org>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:37413 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaKFP2s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 10:28:48 -0500
In-Reply-To: <1415087656-9491-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/14 08:54, Christoph Hellwig wrote:
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index bcb64eb..2233ed6 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -321,16 +321,10 @@ static int pmcraid_change_queue_type(struct scsi_device *scsi_dev, int tag)
>   	struct pmcraid_resource_entry *res;
>
>   	res = (struct pmcraid_resource_entry *)scsi_dev->hostdata;
> -
> -	if ((res) && scsi_dev->tagged_supported &&
> -	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry))) {
> -		scsi_set_tag_type(scsi_dev, tag);
> -
> -		if (tag)
> -			scsi_activate_tcq(scsi_dev, scsi_dev->queue_depth);
> -		else
> -			scsi_deactivate_tcq(scsi_dev, scsi_dev->queue_depth);
> -	} else
> +	if (res && scsi_dev->tagged_supported &&
> +	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry)))
> +	    	tag = scsi_change_queue_type(scsi_dev, tag);
> +	else
>   		tag = 0;
>
>   	return tag;

A minor nit: do we really need to keep the scsi_dev->tagged_supported 
test in the above code ? Anyway,

Reviewed-by: Bart Van Assche <bvanassche@acm.org>



