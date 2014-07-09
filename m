From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/14] scsi: convert target_busy to an atomic_t
Date: Wed, 09 Jul 2014 13:15:39 +0200
Message-ID: <53BD245B.1060709@suse.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaGILPl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 07:15:41 -0400
In-Reply-To: <1403715121-1201-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> Avoid taking the host-wide host_lock to check the per-target queue li=
mit.
> Instead we do an atomic_inc_return early on to grab our slot in the q=
ueue,
> and if nessecary decrement it after finishing all checks.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c    |   52 ++++++++++++++++++++++++++-------=
-----------
>   include/scsi/scsi_device.h |    4 ++--
>   2 files changed, 33 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 18e6449..5e269d6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -294,7 +294,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	shost->host_busy--;
> -	starget->target_busy--;
> +	atomic_dec(&starget->target_busy);
>   	if (unlikely(scsi_host_in_recovery(shost) &&
>   		     (shost->host_failed || shost->host_eh_scheduled)))
>   		scsi_eh_wakeup(shost);
> @@ -361,7 +361,7 @@ static inline int scsi_device_is_busy(struct scsi=
_device *sdev)
>   static inline int scsi_target_is_busy(struct scsi_target *starget)
>   {
>   	return ((starget->can_queue > 0 &&
> -		 starget->target_busy >=3D starget->can_queue) ||
> +		 atomic_read(&starget->target_busy) >=3D starget->can_queue) ||
>   		 starget->target_blocked);
>   }
>
> @@ -1305,37 +1305,49 @@ static inline int scsi_target_queue_ready(str=
uct Scsi_Host *shost,
>   					   struct scsi_device *sdev)
>   {
>   	struct scsi_target *starget =3D scsi_target(sdev);
> -	int ret =3D 0;
> +	unsigned int busy;
>
> -	spin_lock_irq(shost->host_lock);
>   	if (starget->single_lun) {
> +		spin_lock_irq(shost->host_lock);
>   		if (starget->starget_sdev_user &&
> -		    starget->starget_sdev_user !=3D sdev)
> -			goto out;
> +		    starget->starget_sdev_user !=3D sdev) {
> +			spin_unlock_irq(shost->host_lock);
> +			return 0;
> +		}
>   		starget->starget_sdev_user =3D sdev;
> +		spin_unlock_irq(shost->host_lock);
>   	}
>
> -	if (starget->target_busy =3D=3D 0 && starget->target_blocked) {
> +	busy =3D atomic_inc_return(&starget->target_busy) - 1;
> +	if (busy =3D=3D 0 && starget->target_blocked) {
>   		/*
>   		 * unblock after target_blocked iterates to zero
>   		 */
> -		if (--starget->target_blocked !=3D 0)
> -			goto out;
> +		spin_lock_irq(shost->host_lock);
> +		if (--starget->target_blocked !=3D 0) {
> +			spin_unlock_irq(shost->host_lock);
> +			goto out_dec;
> +		}
> +		spin_unlock_irq(shost->host_lock);
>
>   		SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
>   				 "unblocking target at zero depth\n"));
>   	}
>
> -	if (scsi_target_is_busy(starget)) {
> -		list_move_tail(&sdev->starved_entry, &shost->starved_list);
> -		goto out;
> -	}
> +	if (starget->can_queue > 0 && busy >=3D starget->can_queue)
> +		goto starved;
> +	if (starget->target_blocked)
> +		goto starved;
>
> -	scsi_target(sdev)->target_busy++;
> -	ret =3D 1;
> -out:
> +	return 1;
> +
> +starved:
> +	spin_lock_irq(shost->host_lock);
> +	list_move_tail(&sdev->starved_entry, &shost->starved_list);
>   	spin_unlock_irq(shost->host_lock);
> -	return ret;
> +out_dec:
> +	atomic_dec(&starget->target_busy);
> +	return 0;
>   }
>
>   /*
> @@ -1445,7 +1457,7 @@ static void scsi_kill_request(struct request *r=
eq, struct request_queue *q)
>   	spin_unlock(sdev->request_queue->queue_lock);
>   	spin_lock(shost->host_lock);
>   	shost->host_busy++;
> -	starget->target_busy++;
> +	atomic_inc(&starget->target_busy);
>   	spin_unlock(shost->host_lock);
>   	spin_lock(sdev->request_queue->queue_lock);
>
> @@ -1615,9 +1627,7 @@ static void scsi_request_fn(struct request_queu=
e *q)
>   	return;
>
>    host_not_ready:
> -	spin_lock_irq(shost->host_lock);
> -	scsi_target(sdev)->target_busy--;
> -	spin_unlock_irq(shost->host_lock);
> +	atomic_dec(&scsi_target(sdev)->target_busy);
>    not_ready:
>   	/*
>   	 * lock q, handle tag, requeue req, and decrement device_busy. We
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 816e8a2..446f741 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -290,8 +290,8 @@ struct scsi_target {
>   	unsigned int		expecting_lun_change:1;	/* A device has reported
>   						 * a 3F/0E UA, other devices on
>   						 * the same target will also. */
> -	/* commands actually active on LLD. protected by host lock. */
> -	unsigned int		target_busy;
> +	/* commands actually active on LLD. */
> +	atomic_t		target_busy;
>   	/*
>   	 * LLDs should set this in the slave_alloc host template callout.
>   	 * If set to zero then there is not limit.
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
