From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/14] scsi: fix the {host,target,device}_blocked counter
 mess
Date: Wed, 09 Jul 2014 13:12:17 +0200
Message-ID: <53BD2391.90800@suse.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-10-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> Seems like these counters are missing any sort of synchronization for
> updates, as a over 10 year old comment from me noted.  Fix this by
> using atomic counters, and while we're at it also make sure they are
> in the same cacheline as the _busy counters and not needlessly stored
> to in every I/O completion.
>
> With the new model the _busy counters can temporarily go negative,
> so all the readers are updated to check for > 0 values.  Longer
> term every successful I/O completion will reset the counters to zero,
> so the temporarily negative values will not cause any harm.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi.c        |   21 ++++++------
>   drivers/scsi/scsi_lib.c    |   82 +++++++++++++++++++++------------=
-----------
>   drivers/scsi/scsi_sysfs.c  |   10 +++++-
>   include/scsi/scsi_device.h |    7 ++--
>   include/scsi/scsi_host.h   |    7 ++--
>   5 files changed, 64 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 35a23e2..b362058 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -729,17 +729,16 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>
>   	scsi_device_unbusy(sdev);
>
> -        /*
> -         * Clear the flags which say that the device/host is no long=
er
> -         * capable of accepting new commands.  These are set in scsi=
_queue.c
> -         * for both the queue full condition on a device, and for a
> -         * host full condition on the host.
> -	 *
> -	 * XXX(hch): What about locking?
> -         */
> -        shost->host_blocked =3D 0;
> -	starget->target_blocked =3D 0;
> -        sdev->device_blocked =3D 0;
> +	/*
> +	 * Clear the flags which say that the device/target/host is no long=
er
> +	 * capable of accepting new commands.
> +	 */
> +	if (atomic_read(&shost->host_blocked))
> +		atomic_set(&shost->host_blocked, 0);
> +	if (atomic_read(&starget->target_blocked))
> +		atomic_set(&starget->target_blocked, 0);
> +	if (atomic_read(&sdev->device_blocked))
> +		atomic_set(&sdev->device_blocked, 0);
>
>   	/*
>   	 * If we have valid sense information, then some kind of recovery
Hmm. I guess there is a race window between
atomic_read() and atomic_set().
Doesn't this cause issues when someone calls atomic_set() just=20
before the call to atomic_read?

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e23fef5..a39d5ba 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -99,14 +99,16 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reaso=
n)
>   	 */
>   	switch (reason) {
>   	case SCSI_MLQUEUE_HOST_BUSY:
> -		host->host_blocked =3D host->max_host_blocked;
> +		atomic_set(&host->host_blocked, host->max_host_blocked);
>   		break;
>   	case SCSI_MLQUEUE_DEVICE_BUSY:
>   	case SCSI_MLQUEUE_EH_RETRY:
> -		device->device_blocked =3D device->max_device_blocked;
> +		atomic_set(&device->device_blocked,
> +			   device->max_device_blocked);
>   		break;
>   	case SCSI_MLQUEUE_TARGET_BUSY:
> -		starget->target_blocked =3D starget->max_target_blocked;
> +		atomic_set(&starget->target_blocked,
> +			   starget->max_target_blocked);
>   		break;
>   	}
>   }
> @@ -351,30 +353,39 @@ static void scsi_single_lun_run(struct scsi_dev=
ice *current_sdev)
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
>
> -static inline int scsi_device_is_busy(struct scsi_device *sdev)
> +static inline bool scsi_device_is_busy(struct scsi_device *sdev)
>   {
>   	if (atomic_read(&sdev->device_busy) >=3D sdev->queue_depth)
> -		return 1;
> -	if (sdev->device_blocked)
> -		return 1;
> +		return true;
> +	if (atomic_read(&sdev->device_blocked) > 0)
> +		return true;
>   	return 0;
>   }
>
> -static inline int scsi_target_is_busy(struct scsi_target *starget)
> +static inline bool scsi_target_is_busy(struct scsi_target *starget)
>   {
> -	return ((starget->can_queue > 0 &&
> -		 atomic_read(&starget->target_busy) >=3D starget->can_queue) ||
> -		 starget->target_blocked);
> +	if (starget->can_queue > 0) {
> +		if (atomic_read(&starget->target_busy) >=3D starget->can_queue)
> +			return true;
> +		if (atomic_read(&starget->target_blocked) > 0)
> +			return true;
> +	}
> +
> +	return false;
>   }
>
> -static inline int scsi_host_is_busy(struct Scsi_Host *shost)
> +static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
>   {
> -	if ((shost->can_queue > 0 &&
> -	     atomic_read(&shost->host_busy) >=3D shost->can_queue) ||
> -	    shost->host_blocked || shost->host_self_blocked)
> -		return 1;
> +	if (shost->can_queue > 0) {
> +		if (atomic_read(&shost->host_busy) >=3D shost->can_queue)
> +			return true;
> +		if (atomic_read(&shost->host_blocked) > 0)
> +			return true;
> +		if (shost->host_self_blocked)
> +			return true;
> +	}
>
> -	return 0;
> +	return false;
>   }
>
>   static void scsi_starved_list_run(struct Scsi_Host *shost)
> @@ -1283,11 +1294,8 @@ static inline int scsi_dev_queue_ready(struct =
request_queue *q,
>   	unsigned int busy;
>
>   	busy =3D atomic_inc_return(&sdev->device_busy) - 1;
> -	if (busy =3D=3D 0 && sdev->device_blocked) {
> -		/*
> -		 * unblock after device_blocked iterates to zero
> -		 */
> -		if (--sdev->device_blocked !=3D 0) {
> +	if (busy =3D=3D 0 && atomic_read(&sdev->device_blocked) > 0) {
> +		if (atomic_dec_return(&sdev->device_blocked) > 0) {
>   			blk_delay_queue(q, SCSI_QUEUE_DELAY);
>   			goto out_dec;
>   		}
> @@ -1297,7 +1305,7 @@ static inline int scsi_dev_queue_ready(struct r=
equest_queue *q,
>
>   	if (busy >=3D sdev->queue_depth)
>   		goto out_dec;
> -	if (sdev->device_blocked)
> +	if (atomic_read(&sdev->device_blocked) > 0)
>   		goto out_dec;
>
>   	return 1;
> @@ -1328,16 +1336,9 @@ static inline int scsi_target_queue_ready(stru=
ct Scsi_Host *shost,
>   	}
>
>   	busy =3D atomic_inc_return(&starget->target_busy) - 1;
> -	if (busy =3D=3D 0 && starget->target_blocked) {
> -		/*
> -		 * unblock after target_blocked iterates to zero
> -		 */
> -		spin_lock_irq(shost->host_lock);
> -		if (--starget->target_blocked !=3D 0) {
> -			spin_unlock_irq(shost->host_lock);
> +	if (busy =3D=3D 0 && atomic_read(&starget->target_blocked) > 0) {
> +		if (atomic_dec_return(&starget->target_blocked) > 0)
>   			goto out_dec;
> -		}
> -		spin_unlock_irq(shost->host_lock);
>
>   		SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
>   				 "unblocking target at zero depth\n"));
> @@ -1345,7 +1346,7 @@ static inline int scsi_target_queue_ready(struc=
t Scsi_Host *shost,
>
>   	if (starget->can_queue > 0 && busy >=3D starget->can_queue)
>   		goto starved;
> -	if (starget->target_blocked)
> +	if (atomic_read(&starget->target_blocked) > 0)
>   		goto starved;
>
>   	return 1;
> @@ -1374,16 +1375,9 @@ static inline int scsi_host_queue_ready(struct=
 request_queue *q,
>   		return 0;
>
>   	busy =3D atomic_inc_return(&shost->host_busy) - 1;
> -	if (busy =3D=3D 0 && shost->host_blocked) {
> -		/*
> -		 * unblock after host_blocked iterates to zero
> -		 */
> -		spin_lock_irq(shost->host_lock);
> -		if (--shost->host_blocked !=3D 0) {
> -			spin_unlock_irq(shost->host_lock);
> +	if (busy =3D=3D 0 && atomic_read(&shost->host_blocked) > 0) {
> +		if (atomic_dec_return(&shost->host_blocked) > 0)
>   			goto out_dec;
> -		}
> -		spin_unlock_irq(shost->host_lock);
>
>   		SCSI_LOG_MLQUEUE(3,
>   			shost_printk(KERN_INFO, shost,
Same with this one.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
