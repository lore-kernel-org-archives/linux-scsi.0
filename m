From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] scsi_error: send the sense buffer down without copying
Date: Wed, 23 May 2007 17:51:03 +0300
Message-ID: <465454D7.6070401@panasas.com>
References: <1179862994.3738.51.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:60463 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765045AbXEWOvN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 10:51:13 -0400
In-Reply-To: <1179862994.3738.51.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Now that the block submission path correctly bounces, we can simply
> use the command sense_buffer to send to retrieve sense information and
> junk the unnecessary page allocation.

Cool.  I like that :)

Benny

> 
> James
> 
> Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2007-05-15 11:08:31.000000000 -0500
> +++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2007-05-22 14:38:49.000000000 -0500
> @@ -18,12 +18,12 @@
>  #include <linux/sched.h>
>  #include <linux/timer.h>
>  #include <linux/string.h>
> -#include <linux/slab.h>
>  #include <linux/kernel.h>
>  #include <linux/kthread.h>
>  #include <linux/interrupt.h>
>  #include <linux/blkdev.h>
>  #include <linux/delay.h>
> +#include <linux/scatterlist.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -640,16 +640,8 @@ static int scsi_send_eh_cmnd(struct scsi
>  	memcpy(scmd->cmnd, cmnd, cmnd_size);
>  
>  	if (copy_sense) {
> -		gfp_t gfp_mask = GFP_ATOMIC;
> -
> -		if (shost->hostt->unchecked_isa_dma)
> -			gfp_mask |= __GFP_DMA;
> -
> -		sgl.page = alloc_page(gfp_mask);
> -		if (!sgl.page)
> -			return FAILED;
> -		sgl.offset = 0;
> -		sgl.length = 252;
> +		sg_init_one(&sgl, scmd->sense_buffer,
> +			    sizeof(scmd->sense_buffer));
>  
>  		scmd->sc_data_direction = DMA_FROM_DEVICE;
>  		scmd->request_bufflen = sgl.length;
> @@ -720,18 +712,6 @@ static int scsi_send_eh_cmnd(struct scsi
>  
>  
>  	/*
> -	 * Last chance to have valid sense data.
> -	 */
> -	if (copy_sense) {
> -		if (!SCSI_SENSE_VALID(scmd)) {
> -			memcpy(scmd->sense_buffer, page_address(sgl.page),
> -			       sizeof(scmd->sense_buffer));
> -		}
> -		__free_page(sgl.page);
> -	}
> -
> -
> -	/*
>  	 * Restore original data
>  	 */
>  	scmd->request_buffer = old_buffer;
> 
> 


