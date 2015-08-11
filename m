From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 13:41:58 +1000
Message-ID: <1439264518.14448.78.camel@kernel.crashing.org>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:35710 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbbHKDnH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2015 23:43:07 -0400
In-Reply-To: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Mon, 2015-08-10 at 12:09 -0500, Matthew R. Ochs wrote:
> Introduce support for enhanced I/O error handling.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---

So I'm not necessarily very qualified to review SCSI bits as I haven't
done anything close to the Linux SCSI code for almost a decade but I
have a couple of questions and nits...

>  	wait_queue_head_t tmf_waitq;
>  	bool tmf_active;
> -	u8 err_recovery_active:1;
> +	wait_queue_head_t limbo_waitq;
> +	enum cxlflash_state state;
>  };
>  
>  struct afu_cmd {
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 76a7286..18359d4 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -380,6 +380,18 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  	}
>  	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>  
> +	switch (cfg->state) {
> +	case STATE_LIMBO:
> +		pr_debug_ratelimited("%s: device in limbo!\n", __func__);
> +		rc = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	case STATE_FAILTERM:
> +		pr_debug_ratelimited("%s: device has failed!\n", __func__);
> +		goto error;
> +	default:
> +		break;
> +	}

I noticed that you mostly read and write that new state outside of your
tmf_waitq.lock. Is there any other lock or mutex protecting you ? In
this specific case ?

I know in the old day queuecommand was called with a host lock, is that
still the case ?

Or you just don't care about an occasional spurrious
SCSI_MLQUEUE_HOST_BUSY ?

>  	cmd = cxlflash_cmd_checkout(afu);
>  	if (unlikely(!cmd)) {
>  		pr_err("%s: could not get a free command\n", __func__);
> @@ -428,6 +440,10 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>  
>  out:
>  	return rc;
> +error:
> +	scp->result = (DID_NO_CONNECT << 16);
> +	scp->scsi_done(scp);
> +	return 0;
>  }
>  
>  /**
> @@ -455,9 +471,21 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>  
> -	rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> -	if (unlikely(rcr))
> +	switch (cfg->state) {
> +	case STATE_NORMAL:
> +		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> +		if (unlikely(rcr))
> +			rc = FAILED;
> +		break;
> +	case STATE_LIMBO:
> +		wait_event(cfg->limbo_waitq, cfg->state != STATE_LIMBO);
> +		if (cfg->state == STATE_NORMAL)
> +			break;
> +		/* fall through */
> +	default:
>  		rc = FAILED;
> +		break;
> +	}

Same here, since you are doing wait_event, I assume no lock is held
(unless it's a mutex) and in subsequent places I am not listing.

As I said, it could well be that it all works fine but it would be worth
mentioning in this case because it's not obvious from simply reading the
code.

Cheers,
Ben.



