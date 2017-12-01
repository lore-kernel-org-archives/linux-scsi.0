From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH 1/2] Ensure that the SCSI error handler gets woken up
Date: Fri, 1 Dec 2017 11:42:15 +0300
Message-ID: <2f7daf8a-fd66-95c2-78e0-644e0bff4dd0@virtuozzo.com>
References: <20171130224456.23100-1-bart.vanassche@wdc.com>
 <20171130224456.23100-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr10119.outbound.protection.outlook.com ([40.107.1.119]:14413
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751796AbdLAImW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Dec 2017 03:42:22 -0500
In-Reply-To: <20171130224456.23100-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org



On 12/01/2017 01:44 AM, Bart Van Assche wrote:
> If scsi_eh_scmd_add() is called concurrently with
> scsi_host_queue_ready() while shost->host_blocked > 0 then it can
> happen that neither function wakes up the SCSI error handler. Fix
> this by making every function that decreases the host_busy counter
> wake up the error handler if necessary and by protecting the
> host_failed checks with the SCSI host lock.
> 
> Reported-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Fixes: commit 746650160866 ("scsi: convert host_busy to atomic_t")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
> Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/scsi_error.c |  8 +++++++-
>   drivers/scsi/scsi_lib.c   | 39 ++++++++++++++++++++++++++++-----------
>   2 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5e89049e9b4e..b22a9a23c74c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -233,19 +233,25 @@ static void scsi_eh_reset(struct scsi_cmnd *scmd)
>   void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>   {
>   	struct Scsi_Host *shost = scmd->device->host;
> +	enum scsi_host_state shost_state;
>   	unsigned long flags;
>   	int ret;
>   
>   	WARN_ON_ONCE(!shost->ehandler);
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
> +	shost_state = shost->shost_state;
>   	if (scsi_host_set_state(shost, SHOST_RECOVERY)) {
>   		ret = scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
>   		WARN_ON_ONCE(ret);
>   	}
>   	if (shost->eh_deadline != -1 && !shost->last_reset)
>   		shost->last_reset = jiffies;
> -
> +	if (shost_state != shost->shost_state) {
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		synchronize_rcu();

We can come here from interrupt context, so may be we should use 
call_rcu() here instead, possible backtrace:

  => scsi_eh_scmd_add
  => scsi_times_out
  => blk_rq_timed_out
  => blk_abort_request
  => ata_qc_schedule_eh
  => ata_qc_complete
  => ata_do_link_abort
  => ata_port_abort
  => ahci_handle_port_interrupt
  => ahci_single_irq_intr
  => __handle_irq_event_percpu
  => handle_irq_event_percpu
  => handle_irq_event
  => handle_edge_irq
  => handle_irq
  => do_IRQ

> +		spin_lock_irqsave(shost->host_lock, flags);
> +	}
>   	scsi_eh_reset(scmd);
>   	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>   	shost->host_failed++;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b6d3842b6809..7d18fb245d7d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -318,22 +318,39 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
>   		cmd->cmd_len = scsi_command_size(cmd->cmnd);
>   }
>   
> -void scsi_device_unbusy(struct scsi_device *sdev)
> +/*
> + * Decrement the host_busy counter and wake up the error handler if necessary.
> + * Avoid as follows that the error handler is not woken up if shost->host_busy
> + * == shost->host_failed: use synchronize_rcu() in scsi_eh_scmd_add() in
> + * combination with an RCU read lock in this function to ensure that this
> + * function in its entirety either finishes before scsi_eh_scmd_add()
> + * increases the host_failed counter or that it notices the shost state change
> + * made by scsi_eh_scmd_add().
> + */
> +static void scsi_dec_host_busy(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = sdev->host;
> -	struct scsi_target *starget = scsi_target(sdev);
>   	unsigned long flags;
>   
> +	rcu_read_lock();
>   	atomic_dec(&shost->host_busy);
> -	if (starget->can_queue > 0)
> -		atomic_dec(&starget->target_busy);
> -
> -	if (unlikely(scsi_host_in_recovery(shost) &&
> -		     (shost->host_failed || shost->host_eh_scheduled))) {
> +	if (unlikely(scsi_host_in_recovery(shost))) {
>   		spin_lock_irqsave(shost->host_lock, flags);
> -		scsi_eh_wakeup(shost);
> +		if (shost->host_failed || shost->host_eh_scheduled)
> +			scsi_eh_wakeup(shost);
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   	}
> +	rcu_read_unlock();
> +}
> +
> +void scsi_device_unbusy(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	struct scsi_target *starget = scsi_target(sdev);
> +
> +	scsi_dec_host_busy(shost);
> +
> +	if (starget->can_queue > 0)
> +		atomic_dec(&starget->target_busy);
>   
>   	atomic_dec(&sdev->device_busy);
>   }
> @@ -1531,7 +1548,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>   		list_add_tail(&sdev->starved_entry, &shost->starved_list);
>   	spin_unlock_irq(shost->host_lock);
>   out_dec:
> -	atomic_dec(&shost->host_busy);
> +	scsi_dec_host_busy(shost);
>   	return 0;
>   }
>   
> @@ -2017,7 +2034,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	return BLK_STS_OK;
>   
>   out_dec_host_busy:
> -       atomic_dec(&shost->host_busy);
> +	scsi_dec_host_busy(shost);
>   out_dec_target_busy:
>   	if (scsi_target(sdev)->can_queue > 0)
>   		atomic_dec(&scsi_target(sdev)->target_busy);
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
