From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [Open-FCoE] [PATCH] fix computation related to FC_EX_CLOSED in
 FC local port
Date: Thu, 16 Dec 2010 12:05:42 -0800
Message-ID: <1292529942.15910.17.camel@vi2.jf.intel.com>
References: <AANLkTinZ04+m0-TOrv3vbLNH43b4VqKNJ9EyXdJYgj1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0LPUFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 15:05:43 -0500
In-Reply-To: <AANLkTinZ04+m0-TOrv3vbLNH43b4VqKNJ9EyXdJYgj1A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Thu, 2010-12-16 at 23:54 +0800, Hillf Danton wrote:
> In fc_lport_error(), FC_EX_CLOSED could be understood to be no more
> rettries, so resetting local port is reasonable and necessary.
> 

It is not reasonable/necessary in this case as FC_EX_CLOSED is issued on
lport reset thru exch block reset called there, so doing lport reset
again in same call flow is not needed unless I'm missing something to do
reset again here. Are hitting any bug which got fixed by this patch ?

  
> When processing response to flogi request, FC_EX_CLOSED should be
> treated as other errors, since the state machine of local port could
> reach reset.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/libfc/fc_lport.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_lport.c	2010-12-16 23:46:06.000000000 +0800
> @@ -1013,7 +1013,7 @@ static void fc_lport_error(struct fc_lpo
>  		     lport->retry_count);
> 
>  	if (PTR_ERR(fp) == -FC_EX_CLOSED)
> -		return;
> +		goto reset;
> 
>  	/*
>  	 * Memory allocation failure, or the exchange timed out
> @@ -1029,6 +1029,7 @@ static void fc_lport_error(struct fc_lpo
> 
>  		schedule_delayed_work(&lport->retry_work, delay);
>  	} else
> + reset:
>  		fc_lport_enter_reset(lport);
>  }
> 
> @@ -1428,9 +1429,6 @@ void fc_lport_flogi_resp(struct fc_seq *
> 
>  	FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc_els_resp_type(fp));
> 
> -	if (fp == ERR_PTR(-FC_EX_CLOSED))
> -		return;
> -

Like other resp handlers in lport.c, above code is required instead just
removing for  fc_lport_flogi_resp, this is to allow exch clean up on
exch block reset.

	Vasu

>  	mutex_lock(&lport->lp_mutex);
> 
>  	if (lport->state != LPORT_ST_FLOGI) {
> _______________________________________________
> devel mailing list
> devel@lists.open-fcoe.org
> https://lists.open-fcoe.org/mailman/listinfo/devel

