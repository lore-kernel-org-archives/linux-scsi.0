From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH] Ensure that the SCSI error handler gets woken up
Date: Tue, 28 Nov 2017 11:38:53 +0300
Message-ID: <5a4a37ba-5604-08a0-b962-59747872a31d@virtuozzo.com>
Reply-To: 20171123010505.9603-1-bart.vanassche@wdc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve1eur01on0092.outbound.protection.outlook.com ([104.47.1.92]:35664
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750904AbdK1IjB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 03:39:01 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>, linux-scsi@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

1-st, Stuart - thanks for adding me to CC, 2-nd Bart - no idea why you 
didn't? =)

> If scsi_eh_scmd_add() is called concurrently with scsi_host_queue_ready()
> while shost->host_blocked > 0 then it can happen that neither function
> wakes up the SCSI error handler. Fix this by making every function that
> decreases the host_busy counter to wake up the error handler if necessary.

Bart, you've added a comment to my initial patch() about performance, 
let me quote it here:

  > An important achievement of the scsi-mq code was removal of all
  > spin_lock_irq(shost->host_lock) statements from the hot path. The above
  > changes will have a significant negative performance impact, 
especially if
  > multiple LUNs associated with the same SCSI host are involved. Can the
  > reported race be fixed without slowing down the hot path 
significantly? I
  > think that both adding spin lock or smp_mb() calls in the hot path will
  > have a significant negative performance impact.

These was a tricky question so I had no immediate answer. Here is the one:

a) We need to check if scsi_eh_wakeup needs to wake up error handler 
thread in every place where we change host_busy. Else we have a chance 
that these change will break the wake up check in other existing places 
and will lead to deadlock.

b) If we have several variables and change them (one different variable 
in in different thread) and after that we want to check the joint state 
of these variables, we sould surely have some kind of memory barriers to 
have a consistent state at some point.

c) We already have spinlocks in scsi_schedule_eh, scsi_eh_scmd_add and 
scsi_device_unbusy, so it seems the good thing to reuse them for new 
checks too.

I don't see another way to fix these problem.

Your patch puts spinlocks under check which should itself be under 
spinlock, and breaks the initial fix (see Stuart's comment that the 
problem still reproduces). And you does _not_ answer your own question.

> 
> Reported-by: Pavel Tikhomirov <ptikhomirov@xxxxxxxxxxxxx>
> Fixes: commit 746650160866 ("scsi: convert host_busy to atomic_t")
> Signed-off-by: Bart Van Assche <bart.vanassche@xxxxxxx>

As your patch is based on my initial patch 
(https://patchwork.kernel.org/patch/9938919/), when all problems will be 
resolved with it, can you please add here:
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

> Cc: Konstantin Khorenko <khorenko@xxxxxxxxxxxxx>
> Cc: Stuart Hayes <stuart.w.hayes@xxxxxxxxx>
> Cc: Christoph Hellwig <hch@xxxxxx>
> Cc: Hannes Reinecke <hare@xxxxxxxx>
> Cc: Johannes Thumshirn <jthumshirn@xxxxxxx>
> Cc: <stable@xxxxxxxxxxxxxxx>
> ---
>  drivers/scsi/scsi_error.c |  3 ++-
>  drivers/scsi/scsi_lib.c   | 22 ++++++++++++++--------
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5e89049e9b4e..f7f014c755d7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -61,9 +61,10 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>  				 struct scsi_cmnd *);
>  
> -/* called with shost->host_lock held */
>  void scsi_eh_wakeup(struct Scsi_Host *shost)
>  {
> +	lockdep_assert_held(shost->host_lock);
> +
>  	if (atomic_read(&shost->host_busy) == shost->host_failed) {
>  		trace_scsi_eh_wakeup(shost);
>  		wake_up_process(shost->ehandler);
I also think these hunk is just an additional precaution and should be 
in separate patch.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1e05e1885ac8..abd37d77af2d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -318,22 +318,28 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
>  		cmd->cmd_len = scsi_command_size(cmd->cmnd);
>  }
>  
> -void scsi_device_unbusy(struct scsi_device *sdev)
> +static void scsi_dec_host_busy(struct Scsi_Host *shost)
>  {
> -	struct Scsi_Host *shost = sdev->host;
> -	struct scsi_target *starget = scsi_target(sdev);
>  	unsigned long flags;
>  
>  	atomic_dec(&shost->host_busy);
> -	if (starget->can_queue > 0)
> -		atomic_dec(&starget->target_busy);
> -
>  	if (unlikely(scsi_host_in_recovery(shost) &&
>  		     (shost->host_failed || shost->host_eh_scheduled))) {

As I've wrote above you do wrong locking here in scsi_dec_host_busy. 
Note that the above check reads host_failed and can load host_failed 
before host_busy is decremented due to reordering.

>  		spin_lock_irqsave(shost->host_lock, flags);
>  		scsi_eh_wakeup(shost);
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  	}
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
>  	atomic_dec(&sdev->device_busy);
>  } > @@ -1532,7 +1538,7 @@ static inline int scsi_host_queue_ready(struct 
request_queue *q,
>  		list_add_tail(&sdev->starved_entry, &shost->starved_list);
>  	spin_unlock_irq(shost->host_lock);
>  out_dec:
> -	atomic_dec(&shost->host_busy);
> +	scsi_dec_host_busy(shost);
>  	return 0;
>  }
>  
> @@ -2020,7 +2026,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	return BLK_STS_OK;
>  
>  out_dec_host_busy:
> -       atomic_dec(&shost->host_busy);
> +	scsi_dec_host_busy(shost);
>  out_dec_target_busy:
>  	if (scsi_target(sdev)->can_queue > 0)
>  		atomic_dec(&scsi_target(sdev)->target_busy);
> -- 
> 2.15.0

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
