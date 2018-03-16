From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into synchronize_sched()
Date: Fri, 16 Mar 2018 22:42:40 +0100
Message-ID: <1890027.S58v862tbq@merkaba>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180316173516.3048-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Bart.

What is this one about?

Fix for the regression I (and others?) reported?¹

[1] [Bug 199077] [Possible REGRESSION, 4.16-rc4] Error updating SMART data 
during runtime and boot failures with blk_mq_terminate_expired in backtrace

https://bugzilla.kernel.org/show_bug.cgi?id=199077

Thanks,
Martin

Bart Van Assche - 16.03.18, 18:35:
> Since blk_queue_enter() uses rcu_read_lock_sched() scsi_device_quiesce()
> must use synchronize_sched().
> 
> Reported-by: Tejun Heo <tj@kernel.org>
> Fixes: 3a0a529971ec ("block, scsi: Make SCSI quiesce and resume work
> reliably") Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Martin Steigerwald <martin@lichtvoll.de>
> Cc: stable@vger.kernel.org # v4.15
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1d83f29aee74..0b99ee2fbbb5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3014,7 +3014,7 @@ scsi_device_quiesce(struct scsi_device *sdev)
>  	 * unfreeze even if the queue was already frozen before this function
>  	 * was called. See also https://lwn.net/Articles/573497/.
>  	 */
> -	synchronize_rcu();
> +	synchronize_sched();
>  	blk_mq_unfreeze_queue(q);
> 
>  	mutex_lock(&sdev->state_mutex);


-- 
Martin
