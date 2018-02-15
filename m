From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi_debug: call resp_*() function after setting
 host_scribble
Date: Thu, 15 Feb 2018 09:26:06 -0500
Message-ID: <f24207ab-0ada-ebc1-31af-84746a1cac5c@interlog.com>
References: <20180214100557.30717-1-mwilck@suse.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58137 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033052AbeBOO0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Feb 2018 09:26:18 -0500
In-Reply-To: <20180214100557.30717-1-mwilck@suse.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On 2018-02-14 05:05 AM, Martin Wilck wrote:
> Error injection in scsi_debug (e.g. opts=16, SDEBUG_OPT_TRANSPORT_ERR)
> currently doesn't work correctly because the test for sqcp in
> resp_read_dt0() and similar resp_*() functions always fails.
> sqcp is set from cmnd->host_scribble, which is set in schedule_resp(), which
> is called from scsi_debug_queuecommand() after calling the resp_* function.
> 
> Defer calling resp_*() until after cmnd->host_scribble is
> set in schedule_resp().
> 
> Fixes: c483739430f1 "scsi_debug: add multiple queue support"
> 
> Changes in v2: Adapted to code changes after 80c49563e250
> 	"scsi: scsi_debug: implement IMMED bit"
> 
> Notes about this adaptation:
> 
> The "flags &= ~F_LONG_DELAY" statement in scsi_debug_queuecommand()
> from 80c49563e250 had no effect. Dropped it.
> Because we call the resp_*() function later now, the code flow in
> schedule_resp() is slightly different now for the IMMED case - instead of
> falling through to the "respond_in_thread" label immediately, the command will
> be put in the work queue with zero delay.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Ack-ed by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 53 +++++++++++++++++++++++++++++------------------
>   1 file changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 905501075ec6..26ce022dd6f4 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4315,7 +4315,10 @@ static void setup_inject(struct sdebug_queue *sqp,
>    * SCSI_MLQUEUE_HOST_BUSY if temporarily out of resources.
>    */
>   static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
> -			 int scsi_result, int delta_jiff, int ndelay)
> +			 int scsi_result,
> +			 int (*pfp)(struct scsi_cmnd *,
> +				    struct sdebug_dev_info *),
> +			 int delta_jiff, int ndelay)
>   {
>   	unsigned long iflags;
>   	int k, num_in_q, qdepth, inject;
> @@ -4331,9 +4334,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   	}
>   	sdp = cmnd->device;
>   
> -	if (unlikely(sdebug_verbose && scsi_result))
> -		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
> -			    __func__, scsi_result);
>   	if (delta_jiff == 0)
>   		goto respond_in_thread;
>   
> @@ -4388,7 +4388,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   	sqcp = &sqp->qc_arr[k];
>   	sqcp->a_cmnd = cmnd;
>   	cmnd->host_scribble = (unsigned char *)sqcp;
> -	cmnd->result = scsi_result;
>   	sd_dp = sqcp->sd_dp;
>   	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>   	if (unlikely(sdebug_every_nth && sdebug_any_injecting_opt))
> @@ -4398,6 +4397,22 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   		if (sd_dp == NULL)
>   			return SCSI_MLQUEUE_HOST_BUSY;
>   	}
> +
> +	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
> +	if (cmnd->result & SDEG_RES_IMMED_MASK) {
> +		/*
> +		 * This is the F_DELAY_OVERR case. No delay.
> +		 */
> +		cmnd->result &= ~SDEG_RES_IMMED_MASK;
> +		delta_jiff = ndelay = 0;
> +	}
> +	if (cmnd->result == 0 && scsi_result != 0)
> +		cmnd->result = scsi_result;
> +
> +	if (unlikely(sdebug_verbose && cmnd->result))
> +		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
> +			    __func__, cmnd->result);
> +
>   	if (delta_jiff > 0 || ndelay > 0) {
>   		ktime_t kt;
>   
> @@ -4440,7 +4455,10 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   	return 0;
>   
>   respond_in_thread:	/* call back to mid-layer using invocation thread */
> -	cmnd->result = scsi_result;
> +	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
> +	cmnd->result &= ~SDEG_RES_IMMED_MASK;
> +	if (cmnd->result == 0 && scsi_result != 0)
> +		cmnd->result = scsi_result;
>   	cmnd->scsi_done(cmnd);
>   	return 0;
>   }
> @@ -5628,6 +5646,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   	struct sdebug_dev_info *devip;
>   	u8 *cmd = scp->cmnd;
>   	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
> +	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
>   	int k, na;
>   	int errsts = 0;
>   	u32 flags;
> @@ -5749,19 +5768,13 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   			return 0;	/* ignore command: make trouble */
>   	}
>   	if (likely(oip->pfp))
> -		errsts = oip->pfp(scp, devip);	/* calls a resp_* function */
> -	else if (r_pfp)	/* if leaf function ptr NULL, try the root's */
> -		errsts = r_pfp(scp, devip);
> -	if (errsts & SDEG_RES_IMMED_MASK) {
> -		errsts &= ~SDEG_RES_IMMED_MASK;
> -		flags |= F_DELAY_OVERR;
> -		flags &= ~F_LONG_DELAY;
> -	}
> -
> +		pfp = oip->pfp;	/* calls a resp_* function */
> +	else
> +		pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
>   
>   fini:
>   	if (F_DELAY_OVERR & flags)
> -		return schedule_resp(scp, devip, errsts, 0, 0);
> +		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
>   	else if ((sdebug_jdelay || sdebug_ndelay) && (flags & F_LONG_DELAY)) {
>   		/*
>   		 * If any delay is active, want F_LONG_DELAY to be at least 1
> @@ -5771,14 +5784,14 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   		int jdelay = (sdebug_jdelay < 2) ? 1 : sdebug_jdelay;
>   
>   		jdelay = mult_frac(USER_HZ * jdelay, HZ, USER_HZ);
> -		return schedule_resp(scp, devip, errsts, jdelay, 0);
> +		return schedule_resp(scp, devip, errsts, pfp, jdelay, 0);
>   	} else
> -		return schedule_resp(scp, devip, errsts, sdebug_jdelay,
> +		return schedule_resp(scp, devip, errsts, pfp, sdebug_jdelay,
>   				     sdebug_ndelay);
>   check_cond:
> -	return schedule_resp(scp, devip, check_condition_result, 0, 0);
> +	return schedule_resp(scp, devip, check_condition_result, NULL, 0, 0);
>   err_out:
> -	return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, 0, 0);
> +	return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, NULL, 0, 0);
>   }
>   
>   static struct scsi_host_template sdebug_driver_template = {
> 
