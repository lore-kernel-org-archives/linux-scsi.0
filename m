From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] [SCSI] ufs: add SCSI host lock push-down for ufs.
Date: Tue, 01 May 2012 21:59:44 +0100
Message-ID: <1335905984.2996.20.camel@dabdike>
References: <1335882686-16071-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34568 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2EAU7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 16:59:54 -0400
In-Reply-To: <1335882686-16071-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Tue, 2012-05-01 at 10:31 -0400, Namjae Jeon wrote:
> SCSI host lock push-down patch is not applied in ufs host driver yet.
> After adding it, I tried to remove unneeded spin lock in queuecommand also.

This really isn't the correct thing: you're increasing the lock coverage
not decreasing it.

In the old way, ->queuecommand() was called locked.  DEF_SCSI_QCMD() was
a macro we use to avoid converting all the previous methods from locked
to unlocked (it simply acts as a bridge between the new way and the old
way).

In the new way we call ->queuecommand() unlocked and try only to take
the lock when it's needed, if at all.  The current ufshcd_queuecommand()
is correct because it only takes the lock when it needs it in
ufshcd_send_command().  A lock push down into that routine might be
possible, but since it's only a couple of bytes, probably not worth it.

James


> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3cb7a08..a134738 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -658,23 +658,23 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
>  }
>  
>  /**
> - * ufshcd_queuecommand - main entry point for SCSI requests
> + * ufshcd_queuecommand_lck - main entry point for SCSI requests
>   * @cmd: command from SCSI Midlayer
>   * @done: call back function
>   *
>   * Returns 0 for success, non-zero in case of failure
>   */
> -static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> +static int
> +ufshcd_queuecommand_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
>  {
>  	struct ufshcd_lrb *lrbp;
>  	struct ufs_hba *hba;
> -	unsigned long flags;
>  	int tag;
>  	int err = 0;
>  
> -	hba = shost_priv(host);
> +	hba = shost_priv(scp->device->host);
>  
> -	tag = cmd->request->tag;
> +	tag = scp->request->tag;
>  
>  	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
>  		err = SCSI_MLQUEUE_HOST_BUSY;
> @@ -683,11 +683,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  
>  	lrbp = &hba->lrb[tag];
>  
> -	lrbp->cmd = cmd;
> +	lrbp->cmd = scp;
>  	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
> -	lrbp->sense_buffer = cmd->sense_buffer;
> +	lrbp->sense_buffer = scp->sense_buffer;
>  	lrbp->task_tag = tag;
> -	lrbp->lun = cmd->device->lun;
> +	lrbp->lun = scp->device->lun;
>  
>  	lrbp->command_type = UTP_CMD_TYPE_SCSI;
>  
> @@ -698,13 +698,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		goto out;
>  
>  	/* issue command to the controller */
> -	spin_lock_irqsave(hba->host->host_lock, flags);
>  	ufshcd_send_command(hba, tag);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  out:
>  	return err;
>  }
>  
> +static DEF_SCSI_QCMD(ufshcd_queuecommand);
> +
>  /**
>   * ufshcd_memory_alloc - allocate memory for host memory space data structures
>   * @hba: per adapter instance


