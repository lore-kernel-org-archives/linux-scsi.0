From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/4] scsi: translate errors for power management
Date: Thu, 02 Aug 2012 11:43:44 +0100
Message-ID: <1343904224.5073.27.camel@dabdike.int.hansenpartnership.com>
References: <1343903227-17285-1-git-send-email-oliver@neukum.org>
	 <1343903227-17285-5-git-send-email-oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38578 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398Ab2HBKnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2012 06:43:53 -0400
In-Reply-To: <1343903227-17285-5-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, Oliver Neukum <oneukum@suse.de>

On Thu, 2012-08-02 at 12:27 +0200, Oliver Neukum wrote:
> Synchronizing caches may fail. The reason for these
> failures need to be translated to the generic layer
> so that it nows whether to ignore a failure, retry later
> or give up, aborting sleep.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  drivers/scsi/scsi_error.c |   33 +++++++++++++++++++++++++++++++++
>  drivers/scsi/sd.c         |    3 +--
>  include/scsi/scsi_eh.h    |    1 +
>  3 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 4a6381c..13f7060 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2217,3 +2217,36 @@ void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
>  	}
>  }
>  EXPORT_SYMBOL(scsi_build_sense_buffer);
> +
> +/**
> + * scsi_translate_errors_to_power_management - errors in a form driver core understands
> + * @res:	Result of scsi command
> + *
> + * Return value:
> + * 	error code driver core understands
> + **/
> +int scsi_translate_errors_to_power_management(int res)
> +{
> +	int rv = -EIO;

No need for a variable, I think

> +	switch (host_byte(res)) {
> +	/* ignore errors due to racing a disconnection */
> +	case DID_BAD_TARGET:
> +	case DID_NO_CONNECT:
> +		return 0;
> +	/* signal the upper layer it might try again */
> +	case DID_BUS_BUSY:
> +	case DID_IMM_RETRY:
> +	case DID_REQUEUE:
> +	case DID_SOFT_ERROR:
> +	case DID_TIME_OUT:
> +	case DID_ABORT:
> +	case DID_RESET:
> +	case DID_TRANSPORT_DISRUPTED:
> +		return -EBUSY;
> +	case DID_OK:
> +		return 0;
> +	}
> +	return rv;

this should be inside the switch as

default:
	return -EIO;

and no return statment outside of the switch.

Don't you still want to handle BUSY and QUEUE_FULL as -EBUSY?  Right at
the moment they'll fall through the default case and return -EIO.

James


> +}
> +EXPORT_SYMBOL(scsi_translate_errors_to_power_management);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c39a97e..8597294 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1288,10 +1288,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  		 */
>  		if ((scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a))
>  			return 0;
> +		return scsi_translate_errors_to_power_management(res);
>  	}
>  
> -	if (res)
> -		return -EIO;
>  	return 0;
>  }
>  
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 06a8790..bdf6d6c 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -59,6 +59,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>  				   u64 * info_out);
>  
>  extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
> +extern int scsi_translate_errors_to_power_management(int res);
>  
>  /*
>   * Reset request from external source


