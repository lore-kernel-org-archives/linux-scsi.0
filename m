From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] fix scsi cmnd retries in error handling
Date: Mon, 01 Nov 2010 09:38:35 -0400
Message-ID: <1288618715.3056.21.camel@mulgrave.site>
References: <AANLkTikYv-4STgVob=7j70Mo2fuLOR=zc3=WTD7x3Kig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0KANij (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 09:38:39 -0400
In-Reply-To: <AANLkTikYv-4STgVob=7j70Mo2fuLOR=zc3=WTD7x3Kig@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-01 at 21:02 +0800, Hillf Danton wrote:
> There are two instances of increment and test of retries of scsi cmnd
> in functions scsi_decide_disposition() and scsi_eh_flush_done_q()
> respectively.

This analysis is incomplete.  Those two functions are called in
completely separate paths, so you can't remove the increment from one
and expect the other to compensate.

James

> One of the increments is overwork when the corresponding cmnds are same.
> The overwork is fixed in scsi_decide_disposition().
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/scsi_error.c	2010-11-01 20:39:38.000000000 +0800
> @@ -1541,7 +1541,7 @@ int scsi_decide_disposition(struct scsi_
>  	 * the request was not marked fast fail.  Note that above,
>  	 * even if the request is marked fast fail, we still requeue
>  	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
> -	if ((++scmd->retries) <= scmd->allowed
> +	if (scmd->retries < scmd->allowed
>  	    && !scsi_noretry_cmd(scmd)) {
>  		return NEEDS_RETRY;
>  	} else {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


