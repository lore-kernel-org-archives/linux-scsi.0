From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCHv2] libsas: Check for completed commands before calling
 lldd_abort_task()
Date: Tue, 9 Jan 2018 12:09:25 +0800
Message-ID: <5A544075.4010705@huawei.com>
References: <1515413086-34256-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3704 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751811AbeAIELN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 23:11:13 -0500
In-Reply-To: <1515413086-34256-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.com>

Hannes,

On 2018/1/8 20:04, Hannes Reinecke wrote:
> The abort handler might be racing with command completion, so the
> task might already be NULL by the time the abort handler is called.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/libsas/sas_scsi_host.c | 22 +++++++++++++++++++---
>   1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 58476b7..08203fb 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -486,18 +486,34 @@ static int sas_queue_reset(struct domain_device *dev, int reset_type,
>
>   int sas_eh_abort_handler(struct scsi_cmnd *cmd)
>   {
> -	int res;
> -	struct sas_task *task = TO_SAS_TASK(cmd);
> +	int res = TMF_RESP_FUNC_COMPLETE;
> +	struct sas_task *task;
>   	struct Scsi_Host *host = cmd->device->host;
>   	struct sas_internal *i = to_sas_internal(host->transportt);
> +	struct domain_device *dev = cmd_to_domain_dev(cmd);
> +	struct sas_ha_struct *ha = dev->port->ha;
> +	unsigned long flags;
>
>   	if (!i->dft->lldd_abort_task)
>   		return FAILED;
>
> -	res = i->dft->lldd_abort_task(task);
> +	/* Avoid sas_scsi_task_done() interfering */
> +	spin_lock_irqsave(&dev->done_lock, flags);
> +	task = TO_SAS_TASK(cmd);
> +	if (test_bit(SAS_HA_FROZEN, &ha->state)) {
> +		res = TMF_RESP_FUNC_FAILED;
> +		task = NULL;
> +	} else
> +		ASSIGN_SAS_TASK(cmd, NULL);
> +	spin_unlock_irqrestore(&dev->done_lock, flags);
> +	if (task)
> +		res = i->dft->lldd_abort_task(task);
>   	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
>   		return SUCCESS;
>
> +	spin_lock_irqsave(&dev->done_lock, flags);
> +	ASSIGN_SAS_TASK(cmd, task);
> +	spin_unlock_irqrestore(&dev->done_lock, flags);

Why do you assign task back? As I remember, when this cmd dispatch
again, we will create a new task and assign to it again. So should we
end this task here?


>   	return FAILED;
>   }
>   EXPORT_SYMBOL_GPL(sas_eh_abort_handler);
>
