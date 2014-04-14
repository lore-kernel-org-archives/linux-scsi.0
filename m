From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] sd: medium access timeout counter fails to reset
Date: Mon, 14 Apr 2014 11:50:13 -0400
Message-ID: <1397490613.3832.20.camel@localhost.localdomain>
References: <20140410150830.GA19457@fury.redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaDNQE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2014 12:04:27 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3EG4Qdq017933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 12:04:27 -0400
In-Reply-To: <20140410150830.GA19457@fury.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: djeffery@redhat.com

On Thu, 2014-04-10 at 11:08 -0400, David Jeffery wrote:
> There is an error with the medium access timeout feature of the sd driver. The
> sdkp->medium_access_timed_out value is reset to zero in sd_done() in the wrong
> place.  Currently it is reset to zero only when a command returns sense data.
> This can result in cases where the medium access check falsely triggers from
> timed out commands which are hours or days apart.
> 
> For example, an I/O command times out and is aborted.  It then retries and
> succeeds.  But with no sense data generated and returned, the
> medium_access_timed_out value is not reset.  If no sd command returns sense
> data, then the next command to time out (however far in time from the first
> failure) will trigger the medium access timeout and put the device offline.
> 
> The resetting of sdkp->medium_access_timed_out should occur before the check
> for sense data.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> 
> ---
> 
> To reproduce using scsi_debug, use SCSI_DEBUG_OPT_TIMEOUT or
> SCSI_DEBUG_OPT_MAC_TIMEOUT to force an I/O command to timeout.  Then, remove
> the opt value so the I/O will succeed on retry.  Perform more I/O as desired.
> Finally, repeat the process to make a new I/O command time out.  Without the
> patch, the device will be marked offline even though many I/O commands have
> succeeded between the 2 instances of timed out commands.
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 470954a..a41e68e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1689,12 +1689,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  						   sshdr.ascq));
>  	}
>  #endif
> +	sdkp->medium_access_timed_out = 0;
> +
>  	if (driver_byte(result) != DRIVER_SENSE &&
>  	    (!sense_valid || sense_deferred))
>  		goto out;
>  
> -	sdkp->medium_access_timed_out = 0;
> -
>  	switch (sshdr.sense_key) {
>  	case HARDWARE_ERROR:
>  	case MEDIUM_ERROR:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hey James-

Is there some reason why this patch was never accepted?  David posted it
a couple of times last year and Martin ack'ed it, but I don't see it in
your tree, and I don't see any other comments on it.

It seems like something that ought to be fixed.

Reviewed-by:  Ewan D. Milne <emilne@redhat.com>




