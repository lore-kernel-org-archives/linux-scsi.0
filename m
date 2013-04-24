From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH][v3] scsi: Handle MLQUEUE busy response in
 scsi_send_eh_cmnd
Date: Wed, 24 Apr 2013 14:48:42 +0000
Message-ID: <1366814922.1971.5.camel@dabdike>
References: <1366803168-79391-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:55525 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3DXOsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 10:48:42 -0400
In-Reply-To: <1366803168-79391-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <FACFD0D9DEE582489FE9505509748426@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>

On Wed, 2013-04-24 at 13:32 +0200, Hannes Reinecke wrote:
> scsi_send_eh_cmnd() is calling queuecommand() directly, so
> it needs to check the return value here.
> The only valid return codes for queuecommand() are 'busy'
> states, so we need to wait for a bit to allow the LLDD
> to recover.
> 
> Based on an earlier patch from Wen Xiong.

This looks good, only one minor nitpick:

> Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> Cc: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c1b05a8..1fc6da94 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -791,22 +791,32 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
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

Stall for is in HZ: need to convert to ms, so

			msleep(stall_for * 1000/HZ);

I also don't see a need to restore and reprep the command each time, but
I don't see a problem with it either.

James


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
> @@ -837,7 +847,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  			rtn = FAILED;
>  			break;
>  		}
> -	} else {
> +	} else if (!rtn) {
>  		scsi_abort_eh_cmnd(scmd);
>  		rtn = FAILED;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

