From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv5 8/8] scsi: inline command aborts
Date: Wed, 5 Apr 2017 17:05:51 +0200
Message-ID: <20170405150551.GG5728@lst.de>
References: <1491316012-105426-1-git-send-email-hare@suse.de> <1491316012-105426-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57697 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755382AbdDEPFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 11:05:53 -0400
Content-Disposition: inline
In-Reply-To: <1491316012-105426-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

I think this also need to remove the abort_work field from
struct scsi_cmnd.

>  }
>  
>  #ifdef CONFIG_SCSI_LOGGING
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 53e3343..2355100 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -115,11 +115,9 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>   * scmd_eh_abort_handler - Handle command aborts
>   * @work:	command to be aborted.
>   */
> -void
> -scmd_eh_abort_handler(struct work_struct *work)
> +int
> +scmd_eh_abort_handler(struct scsi_cmnd *scmd)
>  {
> -	struct scsi_cmnd *scmd =
> -		container_of(work, struct scsi_cmnd, abort_work.work);
>  	struct scsi_device *sdev = scmd->device;
>  	int rtn;
>  
> @@ -127,42 +125,40 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>  		SCSI_LOG_ERROR_RECOVERY(3,
>  			scmd_printk(KERN_INFO, scmd,
>  				    "eh timeout, not aborting\n"));
> -	} else {
> -		SCSI_LOG_ERROR_RECOVERY(3,
> -			scmd_printk(KERN_INFO, scmd,
> -				    "aborting command\n"));
> -		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
> -		if (rtn == SUCCESS) {
> -			set_host_byte(scmd, DID_TIME_OUT);
> -			if (scsi_host_eh_past_deadline(sdev->host)) {
> -				SCSI_LOG_ERROR_RECOVERY(3,
> -					scmd_printk(KERN_INFO, scmd,
> -						    "eh timeout, not retrying "
> -						    "aborted command\n"));
> -			} else if (!scsi_noretry_cmd(scmd) &&
> -			    (++scmd->retries <= scmd->allowed)) {
> -				SCSI_LOG_ERROR_RECOVERY(3,
> -					scmd_printk(KERN_WARNING, scmd,
> -						    "retry aborted command\n"));
> -				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> -				return;
> -			} else {
> -				SCSI_LOG_ERROR_RECOVERY(3,
> -					scmd_printk(KERN_WARNING, scmd,
> -						    "finish aborted command\n"));
> -				scsi_finish_command(scmd);
> -				return;
> -			}
> -		} else {
> +		return FAILED;
> +	}
> +	SCSI_LOG_ERROR_RECOVERY(3,
> +		scmd_printk(KERN_INFO, scmd,
> +			    "aborting command\n"));
> +	rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
> +	if (rtn == SUCCESS) {

If you restructure the function anywat this could become an
early return / goto out.
