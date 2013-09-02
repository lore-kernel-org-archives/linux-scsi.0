From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 02 Sep 2013 14:45:54 +0200
Message-ID: <52248882.7060109@acm.org>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <1378105985-79686-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37260 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3IBMqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 08:46:08 -0400
In-Reply-To: <1378105985-79686-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

On 09/02/13 09:12, Hannes Reinecke wrote:
> @@ -353,6 +354,8 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>   	list_del_init(&cmd->list);
>   	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
>
> +	cancel_delayed_work(&cmd->abort_work);
> +
>   	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
>   }
>   EXPORT_SYMBOL(scsi_put_command);

Is this approach safe ? Is it e.g. possible that the abort work starts 
just before the cancel_delayed_work() call and continues to run after 
scsi_put_command() has finished ? In drivers/scsi/libfc/fc_exch.c a 
similar issue is solved by holding an additional reference as long as 
delayed work (fc_exch.timeout_work) is queued.

> +void
> +scmd_eh_abort_handler(struct work_struct *work)
> +{
> +	struct scsi_cmnd *scmd =
> +		container_of(work, struct scsi_cmnd, abort_work.work);
> +	struct scsi_device *sdev = scmd->device;
> +	unsigned long flags;
> +	int rtn;
> +
> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> +	if (scsi_host_eh_past_deadline(sdev->host)) {
> +		spin_unlock_irqrestore(sdev->host->host_lock, flags);
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "scmd %p eh timeout, not aborting\n", scmd));
> +	} else {
> +		spin_unlock_irqrestore(sdev->host->host_lock, flags);
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "aborting command %p\n", scmd));
> +		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
> +		if (rtn == SUCCESS) {
> +			scmd->result |= DID_TIME_OUT << 16;
> +			if (!scsi_noretry_cmd(scmd) &&
> +			    (++scmd->retries <= scmd->allowed)) {
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "scmd %p retry "
> +						    "aborted command\n", scmd));
> +				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> +			} else {
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "scmd %p finish "
> +						    "aborted command\n", scmd));
> +				scsi_finish_command(scmd);
> +			}
> +			return;
> +		}
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "scmd %p abort failed, rtn %d\n",
> +				    scmd, rtn));
> +	}
> +
> +	if (scsi_eh_scmd_add(scmd, 0)) {
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_WARNING, scmd,
> +				    "scmd %p terminate "
> +				    "aborted command\n", scmd));
> +		scmd->result |= DID_TIME_OUT << 16;
> +		scsi_finish_command(scmd);
> +	}
> +}

This patch adds several new calls to LLD EH handlers. Is it guaranteed 
that these will only be invoked before scsi_remove_host() has finished ? 
For more background information, see also "[PATCH] Make 
scsi_remove_host() wait until error handling finished" 
(http://thread.gmane.org/gmane.linux.scsi/82572/focus=82779).

Thanks,

Bart.
