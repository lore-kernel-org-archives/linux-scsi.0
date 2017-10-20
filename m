From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH] scsi/eh: fix hang adding ehandler wakeups after
 decrementing host_busy
Date: Fri, 20 Oct 2017 10:48:34 +0300
Message-ID: <8b9d9fd4-86f9-6763-8add-60ed44ddf3f8@virtuozzo.com>
References: <20170905125424.15412-1-ptikhomirov@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905125424.15412-1-ptikhomirov@virtuozzo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, devel@openvz.org
List-Id: linux-scsi@vger.kernel.org

ping

On 09/05/2017 03:54 PM, Pavel Tikhomirov wrote:
> We have a problem on several our nodes with scsi EH. Imagine such an
> order of execution of two threads:
> 
> CPU1 scsi_eh_scmd_add		CPU2 scsi_host_queue_ready
> /* shost->host_busy == 1 initialy */
> 
> 				if (shost->shost_state == SHOST_RECOVERY)
> 					/* does not get here */
> 					return 0;
> 
> lock(shost->host_lock);
> shost->shost_state = SHOST_RECOVERY;
> 
> 				busy = shost->host_busy++;
> 				/* host->can_queue == 1 initialy, busy == 1
> 				 * - go to starved label */
> 				lock(shost->host_lock) /* wait */
> 
> shost->host_failed++;
> /* shost->host_busy == 2, shost->host_failed == 1 */
> call scsi_eh_wakeup(shost) {
> 	if (host_busy == host_failed) {
> 		/* does not get here */
> 		wake_up_process(shost->ehandler)
> 	}
> }
> unlock(shost->host_lock)
> 
> 				/* acquire lock */
> 				shost->host_busy--;
> 
> Finaly we do not wakeup scsi_error_handler and all other commands
> coming will hang as we are in never ending recovery state as there
> is no one left to wakeup handler.
> 
> So scsi disc in these host becomes unresponsive and all bio on node
> hangs. (We trigger these problem when scsi cmnds to DVD drive timeout.)
> 
> Main idea of the fix is to try to do wake up every time we decrement
> host_busy or increment host_failed(the latter is already OK).
> 
> Now the very *last* one of busy threads getting host_lock after
> decrementing host_busy will see all write operations on host's
> shost_state, host_busy and host_failed completed thanks to implied
> memory barriers on spin_lock/unlock, so at the time of busy==failed
> we will trigger wakeup in at least one thread. (Thats why putting
> recovery and failed checks under lock)
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>   drivers/scsi/scsi_lib.c | 21 +++++++++++++++++----
>   1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f6097b89d5d3..6c99221d60aa 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -320,12 +320,11 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> +	spin_lock_irqsave(shost->host_lock, flags);
>   	if (unlikely(scsi_host_in_recovery(shost) &&
> -		     (shost->host_failed || shost->host_eh_scheduled))) {
> -		spin_lock_irqsave(shost->host_lock, flags);
> +		     (shost->host_failed || shost->host_eh_scheduled)))
>   		scsi_eh_wakeup(shost);
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> -	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>   
>   	atomic_dec(&sdev->device_busy);
>   }
> @@ -1503,6 +1502,13 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>   	spin_unlock_irq(shost->host_lock);
>   out_dec:
>   	atomic_dec(&shost->host_busy);
> +
> +	spin_lock_irq(shost->host_lock);
> +	if (unlikely(scsi_host_in_recovery(shost) &&
> +		     (shost->host_failed || shost->host_eh_scheduled)))
> +		scsi_eh_wakeup(shost);
> +	spin_unlock_irq(shost->host_lock);
> +
>   	return 0;
>   }
>   
> @@ -1964,6 +1970,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   
>   out_dec_host_busy:
>   	atomic_dec(&shost->host_busy);
> +
> +	spin_lock_irq(shost->host_lock);
> +	if (unlikely(scsi_host_in_recovery(shost) &&
> +		     (shost->host_failed || shost->host_eh_scheduled)))
> +		scsi_eh_wakeup(shost);
> +	spin_unlock_irq(shost->host_lock);
> +
>   out_dec_target_busy:
>   	if (scsi_target(sdev)->can_queue > 0)
>   		atomic_dec(&scsi_target(sdev)->target_busy);
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
