From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] lpfc: Fix race on command completion
Date: Wed, 20 Jan 2016 17:26:12 +0100
Message-ID: <569FB524.3090305@redhat.com>
References: <1452851303-89378-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934015AbcATQ0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 11:26:15 -0500
In-Reply-To: <1452851303-89378-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Smart <james.smart@avagotech.com>
Cc: Dick Kennedy <dick.kennedy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 15.1.2016 10:48, Hannes Reinecke wrote:
> Upon command completion the lpfc driver would call ->done()
> on the scsi command before taking the host lock and
> releasing the command internally.
> This opens up a race window there this command might be re-used
> after ->done(), leading to a double completion on the same command.

I agree that a driver should clean up the command before calling
->done, but this driver uses a list based system where a command 
can't be reused only until it was returned to the list,
so I don't understand how a 'done' before internal free could
cause an issue other than a failed lpfc_get_scsi_buf in .queuecommand.
Is your issue related to the abort_handler 
(maybe cmd->host_scribble = NULL; changes the abort handler flow)?

Tomas 

>
> This patch takes the host lock before accessing the scsi command,
> and disconnect the internal command under the same lock.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 4679ed4..974af28 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3908,9 +3908,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
>  	uint32_t logit = LOG_FCP;
>  
>  	/* Sanity check on return of outstanding command */
> -	if (!(lpfc_cmd->pCmd))
> +	spin_lock_irqsave(&phba->hbalock, flags);
> +	if (!(lpfc_cmd->pCmd)) {
> +		spin_unlock_irqrestore(&phba->hbalock, flags);
>  		return;
> +	}
>  	cmd = lpfc_cmd->pCmd;
> +	cmd->host_scribble = NULL;
> +	lpfc_cmd->pCmd = NULL;
> +	spin_unlock_irqrestore(&phba->hbalock, flags);
> +
>  	shost = cmd->device->host;
>  
>  	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
> @@ -4125,10 +4132,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
>  	cmd->scsi_done(cmd);
>  
>  	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
> -		spin_lock_irqsave(&phba->hbalock, flags);
> -		lpfc_cmd->pCmd = NULL;
> -		spin_unlock_irqrestore(&phba->hbalock, flags);
> -
>  		/*
>  		 * If there is a thread waiting for command completion
>  		 * wake up the thread.
> @@ -4141,10 +4144,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
>  		return;
>  	}
>  
> -	spin_lock_irqsave(&phba->hbalock, flags);
> -	lpfc_cmd->pCmd = NULL;
> -	spin_unlock_irqrestore(&phba->hbalock, flags);
> -
>  	/*
>  	 * If there is a thread waiting for command completion
>  	 * wake up the thread.

