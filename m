From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] sd: error handling synchronizing caches
Date: Wed, 01 Aug 2012 11:35:36 -0500
Message-ID: <50195AD8.2090803@cs.wisc.edu>
References: <1343832250-24228-1-git-send-email-oliver@neukum.org> <1343832250-24228-4-git-send-email-oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34131 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab2HAQgg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2012 12:36:36 -0400
In-Reply-To: <1343832250-24228-4-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de, Oliver Neukum <oneukum@suse.de>

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a344220..49b0c52 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1278,8 +1278,32 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  
>  	if (res) {
>  		sd_print_result(sdkp, res);
> +
>  		if (driver_byte(res) & DRIVER_SENSE)
>  			sd_print_sense_hdr(sdkp, &sshdr);
> +			/* we need to evaluate the error return  */
> +			if ((scsi_sense_valid(&sshdr) &&
> +				/* 0x3a is medium not present */
> +				sshdr.asc == 0x3a))
> +					/* this is no error here */
> +					return 0;
> +
> +			switch (host_byte(res)) {
> +			/* ignore errors due to racing a disconnection */
> +			case DID_BAD_TARGET:
> +			case DID_NO_CONNECT:
> +				return 0;
> +			/* signal the upper layer it might try again */
> +			case DID_BUS_BUSY:
> +			case DID_IMM_RETRY:
> +			case DID_REQUEUE:
> +			case DID_SOFT_ERROR:
> +				return -EBUSY;
> +			default:
> +				return -EIO;

Could we have all the host/scsi-ml to -EXYZ error conversions put in one
place like __scsi_error_from_host_byte()?


