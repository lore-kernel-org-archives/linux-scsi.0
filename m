From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Fri, 21 Jan 2011 14:49:46 -0600
Message-ID: <4D39F16A.5020002@cs.wisc.edu>
References: <1295597274-5844-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43311 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1AUUtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2011 15:49:40 -0500
In-Reply-To: <1295597274-5844-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org

On 01/21/2011 02:07 AM, Hannes Reinecke wrote:
> Consider a scenario where a SCSI EH command like TUR fails with a NOT READY
> status - MANUAL INTERVENTION REQUIRED (02/04/03). As evident in the ASC/ASCQ
> description, manual intervention is required in this case i.e. the target wants
> TUR to fail here so that the host administrator can take corrective action.
>
> But this particular ASC/ASCQ is not handled in the scsi_check_sense, which
> ultimately causes scsi_eh_tur to erroneously report a SUCCESS (device ready)
> instead of the actual FAILURE state (device not ready).
>
> This patch converts scsi_check_sense() to return SOFT_ERROR in
> cases where an error has been signalled via the sense code, but
> we should not wake the error handler. This error code will be
> reverted back to SUCCESS for normal command handling, but
> scsi_eh_completed_normally() will convert it to FAILED.
>
> Reported-by: Martin George<marting@netapp.com>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 45c7564..e86e62e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -223,7 +223,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
>    * @scmd:	Cmd to have sense checked.
>    *
>    * Return value:
> - * 	SUCCESS or FAILED or NEEDS_RETRY
> + * 	SUCCESS or FAILED or NEEDS_RETRY or SOFT_ERROR
>    *
>    * Notes:
>    *	When a deferred error is detected the current command has
> @@ -278,7 +278,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>
>   	case ABORTED_COMMAND:
>   		if (sshdr.asc == 0x10) /* DIF */
> -			return SUCCESS;
> +			return SOFT_ERROR;
>
>   		return NEEDS_RETRY;
>   	case NOT_READY:
> @@ -324,19 +324,19 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>   		 * Pass the UA upwards for a determination in the completion
>   		 * functions.
>   		 */
> -		return SUCCESS;
> +		return SOFT_ERROR;
>


For normal IO execution the UA, not ready, and illegal request handling 
in scsi_io_completion would determine that some of these are retryable 
conditions, but with the patch in the scsi_error.cs path we will return 
soft error and fail. Also a lot of these that were retryable were 
returned as success in the past, but with the patch are being failed.

Martin made me the same bugzilla :) I was thinking we needed to make 
check_sense smarter or move some of the scsi_io_completion code to some 
lib helpers so scsi_error.c could call them.

And does scsi_eh_stu need to be covnerted to check for soft error and 
failed.

Also if we did this patch, then I think we also have to convert the 
device handlers.
