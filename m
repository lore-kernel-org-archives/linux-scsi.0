From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv2 1/2] ibmvscsi: Abort init sequence during error recovery
Date: Fri, 23 May 2014 18:03:44 +0200
Message-ID: <537F7160.7080403@acm.org>
References: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:41680 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaEWQDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2014 12:03:45 -0400
In-Reply-To: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, nfont@linux.vnet.ibm.com

On 05/23/14 17:52, Brian King wrote:
> If a CRQ reset is triggered for some reason while in the middle
> of performing VSCSI adapter initialization, we don't want to
> call the done function for the initialization MAD commands as
> this will only result in two threads attempting initialization
> at the same time, resulting in failures.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvscsi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix drivers/scsi/ibmvscsi/ibmvscsi.c
> --- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix	2014-05-23 10:36:04.000000000 -0500
> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:50:03.000000000 -0500
> @@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
>  				       evt->hostdata->dev);
>  			if (evt->cmnd_done)
>  				evt->cmnd_done(evt->cmnd);
> -		} else if (evt->done)
> +		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
> +			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
>  			evt->done(evt);
>  		free_event_struct(&evt->hostdata->pool, evt);
>  		spin_lock_irqsave(hostdata->host->host_lock, flags);

Hello Brian,

Does this mean that the SRP-over-CRQ protocol is still in use for
communication between partitions ? Had you already noticed the "tgt
infrastructure removal" patch series
(http://thread.gmane.org/gmane.linux.scsi/90119) ? Feedback would be
appreciated.

Thanks,

Bart.

