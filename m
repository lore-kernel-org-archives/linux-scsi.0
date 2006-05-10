From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Wed, 10 May 2006 12:41:57 -0400
Message-ID: <446217D5.3020606@torque.net>
References: <4461EFD0.50902@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60141 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751490AbWEJQmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:42:10 -0400
In-Reply-To: <4461EFD0.50902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> Hi all,
> 
> this patch allows to set the REQ_FAILFAST flag to be set from SG_IO
> commands. With it one can send generic SCSI commands which behave
> exactly like normal requests send via the block layer.
> 
> Comments etc welcome.

Hannes,
Looks good. There is no proposed change to sg.c .
Could SG_FLAG_FAILFAST be made to work via sg device
nodes?

Doug Gilbert


> ------------------------------------------------------------------------
> 
> Allow FAILFAST flag to be set for SG_IO commands
> 
> This patch allows the FAILFAST flag to be set for SG_IO commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index b33eda2..658b1b5 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -295,6 +295,8 @@ static int sg_io(struct file *file, requ
>  	rq->sense_len = 0;
>  
>  	rq->flags |= REQ_BLOCK_PC;
> +	if (hdr->flags & SG_FLAGS_FAILFAST)
> +		rq->flags |= REQ_FAILFAST;
>  	bio = rq->bio;
>  
>  	/*
> diff --git a/include/scsi/sg.h b/include/scsi/sg.h
> index 0a487fe..9cc466a 100644
> --- a/include/scsi/sg.h
> +++ b/include/scsi/sg.h
> @@ -142,6 +142,7 @@ typedef struct sg_io_hdr
>  #define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
>  				/* command block (when <= SCSI_2) */
>  #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
> +#define SG_FLAG_FAILFAST 8      /* request should set FAILFAST flag */
>  #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
>  				/* user space (debug indirect IO) */
>  

