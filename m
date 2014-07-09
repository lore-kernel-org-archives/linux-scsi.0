From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/14] scsi: centralize command re-queueing in scsi_dispatch_fn
Date: Wed, 09 Jul 2014 13:13:31 +0200
Message-ID: <53BD23DB.3050303@suse.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-4-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 06:51 PM, Christoph Hellwig wrote:
> Make sure we only have the logic for requeing commands in one place.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi.c     |   35 ++++++++++++-----------------------
>   drivers/scsi/scsi_lib.c |    9 ++++++---
>   2 files changed, 18 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ce5b4e5..dcc43fd 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -648,9 +648,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   		 * returns an immediate error upwards, and signals
>   		 * that the device is no longer present */
>   		cmd->result =3D DID_NO_CONNECT << 16;
> -		scsi_done(cmd);
> -		/* return 0 (because the command has been processed) */
> -		goto out;
> +		goto done;
>   	}
>
>   	/* Check to see if the scsi lld made this device blocked. */
> @@ -662,17 +660,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   		 * occur until the device transitions out of the
>   		 * suspend state.
>   		 */
> -
> -		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> -
>   		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>   			"queuecommand : device blocked\n"));
> -
> -		/*
> -		 * NOTE: rtn is still zero here because we don't need the
> -		 * queue to be plugged on return (it's already stopped)
> -		 */
> -		goto out;
> +		return SCSI_MLQUEUE_DEVICE_BUSY;
>   	}
>
>   	/*
> @@ -696,20 +686,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   			       "cdb_size=3D%d host->max_cmd_len=3D%d\n",
>   			       cmd->cmd_len, cmd->device->host->max_cmd_len));
>   		cmd->result =3D (DID_ABORT << 16);
> -
> -		scsi_done(cmd);
> -		goto out;
> +		goto done;
>   	}
>
>   	if (unlikely(host->shost_state =3D=3D SHOST_DEL)) {
>   		cmd->result =3D (DID_NO_CONNECT << 16);
> -		scsi_done(cmd);
> -	} else {
> -		trace_scsi_dispatch_cmd_start(cmd);
> -		cmd->scsi_done =3D scsi_done;
> -		rtn =3D host->hostt->queuecommand(host, cmd);
> +		goto done;
> +
>   	}
>
> +	trace_scsi_dispatch_cmd_start(cmd);
> +
> +	cmd->scsi_done =3D scsi_done;
> +	rtn =3D host->hostt->queuecommand(host, cmd);
>   	if (rtn) {
>   		trace_scsi_dispatch_cmd_error(cmd, rtn);
>   		if (rtn !=3D SCSI_MLQUEUE_DEVICE_BUSY &&
> @@ -718,12 +707,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>
>   		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>   			"queuecommand : request rejected\n"));
> -
> -		scsi_queue_insert(cmd, rtn);
>   	}
>
> - out:
>   	return rtn;
> + done:
> +	scsi_done(cmd);
> +	return 0;
>   }
>
>   /**
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2667c75..63bf844 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1583,9 +1583,12 @@ static void scsi_request_fn(struct request_que=
ue *q)
>   		 * Dispatch the command to the low-level driver.
>   		 */
>   		rtn =3D scsi_dispatch_cmd(cmd);
> -		spin_lock_irq(q->queue_lock);
> -		if (rtn)
> +		if (rtn) {
> +			scsi_queue_insert(cmd, rtn);
> +			spin_lock_irq(q->queue_lock);
>   			goto out_delay;
> +		}
> +		spin_lock_irq(q->queue_lock);
>   	}
>
>   	return;
> @@ -1605,7 +1608,7 @@ static void scsi_request_fn(struct request_queu=
e *q)
>   	blk_requeue_request(q, req);
>   	sdev->device_busy--;
>   out_delay:
> -	if (sdev->device_busy =3D=3D 0)
> +	if (sdev->device_busy =3D=3D 0 && !scsi_device_blocked(sdev))
>   		blk_delay_queue(q, SCSI_QUEUE_DELAY);
>   }
>
>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
