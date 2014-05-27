From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/2] ibmvscsi: Abort init sequence during error recovery
Date: Tue, 27 May 2014 08:55:44 -0500
Message-ID: <53849960.60505@linux.vnet.ibm.com>
References: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35309 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaE0Nzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 09:55:50 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <nfont@linux.vnet.ibm.com>;
	Tue, 27 May 2014 07:55:49 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 449183E4003B
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 07:55:46 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4RDsYw110944974
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 15:54:34 +0200
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4RDtjJA022519
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2014 07:55:46 -0600
In-Reply-To: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

On 05/23/2014 10:52 AM, Brian King wrote:
> If a CRQ reset is triggered for some reason while in the middle
> of performing VSCSI adapter initialization, we don't want to
> call the done function for the initialization MAD commands as
> this will only result in two threads attempting initialization
> at the same time, resulting in failures.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

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
> _
> 

