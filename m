From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] use one-element sg list in scsi_send_eh_cmnd
Date: Sat, 4 Nov 2006 12:15:58 -0800 (PST)
Message-ID: <809856.67393.qm@web31801.mail.mud.yahoo.com>
References: <20061104190421.GA23477@lst.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:27049 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965633AbWKDUP7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 15:15:59 -0500
In-Reply-To: <20061104190421.GA23477@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

--- Christoph Hellwig <hch@lst.de> wrote:

> scsi_send_eh_cmnd is the last user of non-sg commands currently.
> This patch switches it to a one-element SG list.  Also updates the
> kerneldoc comment for scsi_send_eh_cmnd to reflect reality while we're
> at it.

So now "use_sg" means "always yes".

In this case I'd suggest you rename "use_sg" to something like
"num_sg" or "num_scatter" or "num_scatter_elements" or something
to this effect.

This will unambiguate its meaning and use.

    Luben

> Test on my mptsas card, but this should get testing with as many
> drivers as possible.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2006-10-30 17:00:23.000000000 +0100
> +++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2006-11-04 17:30:33.000000000 +0100
> @@ -453,9 +453,18 @@
>  }
>  
>  /**
> - * scsi_send_eh_cmnd  - send a cmd to a device as part of error recovery.
> - * @scmd:	SCSI Cmd to send.
> - * @timeout:	Timeout for cmd.
> + * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
> + * @scmd:       SCSI command structure to hijack
> + * @cmnd:       CDB to send
> + * @cmnd_size:  size if bytes of @cmnd
> + * @timeout:    timeout for this request
> + * @copy_sense: request sense data if set to 1
> + *
> + * This function is used to send a scsi command down to a target device
> + * as part of the error recovery process.  If @copy_sense is 0 the command
> + * sent must be one that does not transfer any data.  If @copy_sense is 1
> + * the command must be REQUEST_SENSE and this functions copies out the
> + * sense buffer it got into @scmd->sense_buffer.
>   *
>   * Return value:
>   *    SUCCESS or FAILED or NEEDS_RETRY
> @@ -469,6 +478,7 @@
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	unsigned long timeleft;
>  	unsigned long flags;
> +	struct scatterlist sgl;
>  	unsigned char old_cmnd[MAX_COMMAND_SIZE];
>  	enum dma_data_direction old_data_direction;
>  	unsigned short old_use_sg;
> @@ -500,19 +510,24 @@
>  		if (shost->hostt->unchecked_isa_dma)
>  			gfp_mask |= __GFP_DMA;
>  
> -		scmd->sc_data_direction = DMA_FROM_DEVICE;
> -		scmd->request_bufflen = 252;
> -		scmd->request_buffer = kzalloc(scmd->request_bufflen, gfp_mask);
> -		if (!scmd->request_buffer)
> +		sgl.page = alloc_page(gfp_mask);
> +		if (!sgl.page)
>  			return FAILED;
> +		sgl.offset = 0;
> +		sgl.length = 252;
> +
> +		scmd->sc_data_direction = DMA_FROM_DEVICE;
> +		scmd->request_bufflen = sgl.length;
> +		scmd->request_buffer = &sgl;
> +		scmd->use_sg = 1;
>  	} else {
>  		scmd->request_buffer = NULL;
>  		scmd->request_bufflen = 0;
>  		scmd->sc_data_direction = DMA_NONE;
> +		scmd->use_sg = 0;
>  	}
>  
>  	scmd->underflow = 0;
> -	scmd->use_sg = 0;
>  	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
>  
>  	if (sdev->scsi_level <= SCSI_2)
> @@ -583,7 +598,7 @@
>  			memcpy(scmd->sense_buffer, scmd->request_buffer,
>  			       sizeof(scmd->sense_buffer));
>  		}
> -		kfree(scmd->request_buffer);
> +		__free_page(sgl.page);
>  	}
>  
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

