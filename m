From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC] Add user scatter gather I/O to SG_IO
Date: Mon, 13 Jun 2005 08:55:30 +0200
Message-ID: <20050613065529.GF1414@suse.de>
References: <1118447969.5031.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:6376 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261395AbVFMGyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 02:54:21 -0400
Content-Disposition: inline
In-Reply-To: <1118447969.5031.44.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Jun 10 2005, James Bottomley wrote:
> diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
> --- a/drivers/block/scsi_ioctl.c
> +++ b/drivers/block/scsi_ioctl.c
> @@ -231,9 +231,6 @@ static int sg_io(struct file *file, requ
>  	if (verify_command(file, cmd))
>  		return -EPERM;
>  
> -	/*
> -	 * we'll do that later
> -	 */
>  	if (hdr->iovec_count)
>  		return -EOPNOTSUPP;

Didn't you want to remove more than the comment here?

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1230,6 +1230,9 @@ static void scsi_eh_offline_sdevs(struct
>  				scmd->device->channel,
>  				scmd->device->id,
>  				scmd->device->lun);
> +		/* try to reset the bus and the card to a sane state */
> +		scsi_try_bus_reset(scmd);
> +		scsi_try_host_reset(scmd);
>  		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
>  		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {

Different patch?

Other than that I think it looks good, thanks. I'll get this added asap.

-- 
Jens Axboe

