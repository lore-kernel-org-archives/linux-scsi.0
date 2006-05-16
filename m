From: Michael Reed <mdr@sgi.com>
Subject: Re: [REPOST][PATCH] update max sdev block limit
Date: Tue, 16 May 2006 10:09:57 -0500
Message-ID: <4469EB45.7070104@sgi.com>
References: <1147358563.3507.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:6532 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932079AbWEPPKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 11:10:09 -0400
In-Reply-To: <1147358563.3507.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

I disagree with this patch.

My personal opinion is that the previous value of 6000 (assume HZ==100),
or around 1 hour 40 minutes, was probably too long.  But, 120 seconds is too
short.  I would suggest a MAX value of maybe 10 minutes, or 600 seconds.
It appears that introducing an upper bound which is now more than an order
of magnitude smaller than the previous value could have some impact at
customer sites.

There are raid devices which require around 200+ seconds to crash, dump,
reboot, and return on line.  (Yes, I've timed it!)

Mike


James Smart wrote:
> Updated patch to address comments from Andreas Herrman, who noted that
> the initialization, with the HZ, was inconsistent with its use in the
> FC transport.
> --
> This patch ups the maximum limit for how long an sdev is allowed to
> be blocked. Originally, the value was 60 seconds. However, we are aware
> of array failover and switch reboot times that can be as high
> as 90 seconds. We're proposing to change the max to 120 seconds.
> 
> -- james s
> 
> 
> Signed-off-by: James Smart <James.Smart@emulex.com>
> 
> diff -upNr a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> --- a/drivers/scsi/scsi_priv.h	2006-05-10 11:36:25.000000000 -0400
> +++ b/drivers/scsi/scsi_priv.h	2006-05-11 10:37:57.000000000 -0400
> @@ -127,7 +127,7 @@ extern struct bus_type scsi_bus_type;
>   * classes.
>   */
>  
> -#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	(HZ*60)
> +#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	120	/* units in seconds */
>  extern int scsi_internal_device_block(struct scsi_device *sdev);
>  extern int scsi_internal_device_unblock(struct scsi_device *sdev);
>  
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
