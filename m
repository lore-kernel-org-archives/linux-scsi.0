From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH ver2 5/5] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
Date: Wed, 12 Sep 2007 08:44:34 +0100
Message-ID: <20070912074434.GC2653@flint.arm.linux.org.uk>
References: <46E59760.9020705@panasas.com> <46E59D5F.5060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58613 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765013AbXILHqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2007 03:46:15 -0400
Content-Disposition: inline
In-Reply-To: <46E59D5F.5060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Mon, Sep 10, 2007 at 10:39:11PM +0300, Boaz Harrosh wrote:
> 
>   - Use new scsi_eh_prep/restor_cmnd() for synchronous
>     REQUEST_SENSE invocation.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/arm/fas216.c |   16 +++-------------
>  drivers/scsi/arm/fas216.h |    3 +++
>  2 files changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index fb5f202..a715632 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2018,6 +2018,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
>  	 * the upper layers to process.  This would have been set
>  	 * correctly by fas216_std_done.
>  	 */
> +	scsi_eh_restore_cmnd(SCpnt, &info->ses);
>  	SCpnt->scsi_done(SCpnt);
>  }
>  
> @@ -2103,23 +2104,12 @@ request_sense:
>  	if (SCpnt->cmnd[0] == REQUEST_SENSE)
>  		goto done;
>  
> +	scsi_eh_prep_cmnd(SCpnt, &info->ses, NULL, 0, ~0);
>  	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
>  			  "requesting sense");
> -	memset(SCpnt->cmnd, 0, sizeof (SCpnt->cmnd));
> -	SCpnt->cmnd[0] = REQUEST_SENSE;
> -	SCpnt->cmnd[1] = SCpnt->device->lun << 5;
> -	SCpnt->cmnd[4] = sizeof(SCpnt->sense_buffer);
> -	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
> -	SCpnt->SCp.buffer = NULL;
> -	SCpnt->SCp.buffers_residual = 0;
> -	SCpnt->SCp.ptr = (char *)SCpnt->sense_buffer;
> -	SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
> -	SCpnt->SCp.phase = sizeof(SCpnt->sense_buffer);
> +	init_SCp(SCpnt);
>  	SCpnt->SCp.Message = 0;
>  	SCpnt->SCp.Status = 0;
> -	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
> -	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
> -	SCpnt->use_sg = 0;
>  	SCpnt->tag = 0;
>  	SCpnt->host_scribble = (void *)fas216_rq_sns_done;

So where do we end up setting up the request sense command?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
