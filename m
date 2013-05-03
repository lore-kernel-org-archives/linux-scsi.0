From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Fri, 03 May 2013 10:24:00 -0400
Message-ID: <20130503102400.Horde.TQF1IJir309Rg8iARNPkSKA@imap.linux.ibm.com>
References: <1366870200-6492-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55530 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762217Ab3ECOYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 May 2013 10:24:09 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 3 May 2013 10:24:08 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 1688F6E8044
	for <linux-scsi@vger.kernel.org>; Fri,  3 May 2013 10:24:02 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r43EO4Br294346
	for <linux-scsi@vger.kernel.org>; Fri, 3 May 2013 10:24:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r43EO18r018054
	for <linux-scsi@vger.kernel.org>; Fri, 3 May 2013 10:24:03 -0400
In-Reply-To: <1366870200-6492-1-git-send-email-hare@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>


Quoting Hannes Reinecke <hare@suse.de>:

> scsi_send_eh_cmnd() is calling queuecommand() directly, so
> it needs to check the return value here.
> The only valid return codes for queuecommand() are 'busy'
> states, so we need to wait for a bit to allow the LLDD
> to recover.
>
> Based on an earlier patch from Wen Xiong.
>
> Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> Cc: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
Hi James,

I have verified this patch with two new ipr adapters. EEH error can be  
recoery successfully.
Do you have any question about this new patch?

Thanks,
Wendy
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index d58db32..6a3c1d2 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -889,22 +889,32 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd  
> *scmd, unsigned char *cmnd,
>  	struct scsi_device *sdev = scmd->device;
>  	struct Scsi_Host *shost = sdev->host;
>  	DECLARE_COMPLETION_ONSTACK(done);
> -	unsigned long timeleft;
> +	unsigned long timeleft = timeout;
>  	struct scsi_eh_save ses;
> +	const int stall_for = min(HZ/10, 1);
>  	int rtn;
>
> +retry:
>  	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
>  	shost->eh_action = &done;
>
>  	scsi_log_send(scmd);
>  	scmd->scsi_done = scsi_eh_done;
> -	shost->hostt->queuecommand(shost, scmd);
> -
> -	timeleft = wait_for_completion_timeout(&done, timeout);
> +	rtn = shost->hostt->queuecommand(shost, scmd);
> +	if (rtn) {
> +		if (timeleft) {
> +			scsi_eh_restore_cmnd(scmd, &ses);
> +			timeleft -= stall_for;
> +			msleep(stall_for);
> +			goto retry;
> +		}
> +		rtn = NEEDS_RETRY;
> +	} else
> +		timeleft = wait_for_completion_timeout(&done, timeout);
>
>  	shost->eh_action = NULL;
>
> -	scsi_log_completion(scmd, SUCCESS);
> +	scsi_log_completion(scmd, rtn);
>
>  	SCSI_LOG_ERROR_RECOVERY(3,
>  		printk("%s: scmd: %p, timeleft: %ld\n",
> @@ -935,7 +945,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd  
> *scmd, unsigned char *cmnd,
>  			rtn = FAILED;
>  			break;
>  		}
> -	} else {
> +	} else if (!rtn) {
>  		scsi_abort_eh_cmnd(scmd);
>  		rtn = FAILED;
>  	}



