From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] return all status bytes for sg io.
Date: Wed, 2 Jun 2004 21:31:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040602193158.GB2401@suse.de>
References: <40BDC726.7070004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:61640 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263868AbUFBTcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2004 15:32:02 -0400
Content-Disposition: inline
In-Reply-To: <40BDC726.7070004@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jun 02 2004, Mike Christie wrote:
> Hi Jens,
> 
> For block/scsi_ioctl.c only the status_byte is returned. However, when sg 
> io is performed through a sg device the host, msg and driver bytes are 
> passed back. I was not sure if this is a bug on the block layers part 
> (becuase as you see in the patch, after the msg, host and driver bytes are 
> zerod out they are tested), or is the bug in the app and it should be 
> modifed to access sg devices instead of block devs. The attached patch was 
> built against 2.6.7-rc2.
> 
> Thanks,
> 
> Mike

> diff -arup linux-2.6.7-rc2/drivers/block/scsi_ioctl.c linux-2.6.7-rc2-work/drivers/block/scsi_ioctl.c
> --- linux-2.6.7-rc2/drivers/block/scsi_ioctl.c	2004-05-29 23:26:48.000000000 -0700
> +++ linux-2.6.7-rc2-work/drivers/block/scsi_ioctl.c	2004-06-02 04:32:27.000000000 -0700
> @@ -185,11 +185,11 @@ static int sg_io(request_queue_t *q, str
>  	blk_execute_rq(q, bd_disk, rq);
>  
>  	/* write to all output members */
> -	hdr->status = rq->errors;	
> -	hdr->masked_status = (hdr->status >> 1) & 0x1f;
> -	hdr->msg_status = 0;
> -	hdr->host_status = 0;
> -	hdr->driver_status = 0;
> +	hdr->status = 0xff & rq->errors;
> +	hdr->masked_status = status_byte(rq->errors);
> +	hdr->msg_status = msg_byte(rq->errors);
> +	hdr->host_status = host_byte(rq->errors);
> +	hdr->driver_status = driver_byte(rq->errors);

For SCSI, this looks good. I need to look at ide-cd to be sure it's ok,
did you verify this?

-- 
Jens Axboe

