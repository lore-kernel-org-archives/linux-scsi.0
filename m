From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Tue, 20 Dec 2011 16:41:04 +0100
Message-ID: <4EF0AC90.5010109@suse.de>
References: <1323816041-25557-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab1LTPlF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 10:41:05 -0500
In-Reply-To: <1323816041-25557-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 12/13/2011 11:40 PM, Rob Evers wrote:
> When alua targets are transitioning, the scsi midlayer retry mechanis=
m
> continuously retries the scsi commands that are returning with not re=
ady
> transitioning status.  The target is not capable of handling the
> commands for time on the order of several seconds during these transi=
stions.
>=20
> This patch delays the device queue for 2 seconds, which is in the sam=
e
> order of aas transition time.
>=20
> Also, handle all other cases where ADD_TO_MLQUEUE_DELAY could be retu=
rned
> instead of ADD_TO_MLQUEUE as if ADD_TO_MLQUEUE were being returned.
>=20
> Problem found by array partner testing
>=20
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    7 ++++---
>  drivers/scsi/scsi.c                        |    3 +++
>  drivers/scsi/scsi_error.c                  |    1 +
>  drivers/scsi/scsi_lib.c                    |    9 ++++++++-
>  include/scsi/scsi.h                        |    4 +++-
>  5 files changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 4ef0212..33b8df7 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -233,7 +233,7 @@ static void stpg_endio(struct request *req, int e=
rror)
>  			goto done;
>  		}
>  		err =3D alua_check_sense(h->sdev, &sense_hdr);
> -		if (err =3D=3D ADD_TO_MLQUEUE) {
> +		if (err =3D=3D ADD_TO_MLQUEUE || err =3D=3D ADD_TO_MLQUEUE_DELAY) =
{
>  			err =3D SCSI_DH_RETRY;
>  			goto done;
>  		}
> @@ -443,7 +443,7 @@ static int alua_check_sense(struct scsi_device *s=
dev,
>  			/*
>  			 * LUN Not Accessible - ALUA state transition
>  			 */
> -			return ADD_TO_MLQUEUE;
> +			return ADD_TO_MLQUEUE_DELAY;
>  		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x0b)
>  			/*
>  			 * LUN Not Accessible -- Target port in standby state
> @@ -521,7 +521,8 @@ static int alua_rtpg(struct scsi_device *sdev, st=
ruct alua_dh_data *h)
>  			return SCSI_DH_IO;
> =20
>  		err =3D alua_check_sense(sdev, &sense_hdr);
> -		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies, expiry))
> +		if ((err =3D=3D ADD_TO_MLQUEUE || err =3D=3D ADD_TO_MLQUEUE_DELAY)=
 &&
> +		    time_before(jiffies, expiry))
>  			goto retry;
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: rtpg sense code %02x/%02x/%02x\n",
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2aeb2e9..ced0085 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -600,6 +600,9 @@ void scsi_log_completion(struct scsi_cmnd *cmd, i=
nt disposition)
>  			case ADD_TO_MLQUEUE:
>  				printk("MLQUEUE\n");
>  				break;
> +			case ADD_TO_MLQUEUE_DELAY:
> +				printk("MLQUEUE_DELAY\n");
> +				break;
>  			case FAILED:
>  				printk("FAILED\n");
>  				break;
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index dc6131e..775f822 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -812,6 +812,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *sc=
md, unsigned char *cmnd,
>  		case TARGET_ERROR:
>  			break;
>  		case ADD_TO_MLQUEUE:
> +		case ADD_TO_MLQUEUE_DELAY:
>  			rtn =3D NEEDS_RETRY;
>  			break;
>  		default:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 06bc265..fb35a76 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -139,6 +139,7 @@ static int __scsi_queue_insert(struct scsi_cmnd *=
cmd, int reason, int unbusy)
>  		break;
>  	case SCSI_MLQUEUE_DEVICE_BUSY:
>  	case SCSI_MLQUEUE_EH_RETRY:
> +	case SCSI_MLQUEUE_DEV_DLY_RTY:
>  		device->device_blocked =3D device->max_device_blocked;
>  		break;
>  	case SCSI_MLQUEUE_TARGET_BUSY:
> @@ -161,7 +162,10 @@ static int __scsi_queue_insert(struct scsi_cmnd =
*cmd, int reason, int unbusy)
>  	blk_requeue_request(q, cmd->request);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
> =20
> -	kblockd_schedule_work(q, &device->requeue_work);
> +	if (reason =3D=3D SCSI_MLQUEUE_DEV_DLY_RTY)
> +		blk_delay_queue(q, 2000);
> +	else
> +		kblockd_schedule_work(q, &device->requeue_work);
> =20
>  	return 0;
>  }
> @@ -1465,6 +1469,9 @@ static void scsi_softirq_done(struct request *r=
q)
>  		case ADD_TO_MLQUEUE:
>  			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
>  			break;
> +		case ADD_TO_MLQUEUE_DELAY:
> +			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEV_DLY_RTY);
> +			break;
>  		default:
>  			if (!scsi_eh_scmd_add(cmd, 0))
>  				scsi_finish_command(cmd);
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 8001ae4..df0e353 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -466,9 +466,10 @@ static inline int scsi_is_wlun(unsigned int lun)
>  #define SOFT_ERROR      0x2005
>  #define ADD_TO_MLQUEUE  0x2006
>  #define TIMEOUT_ERROR   0x2007
> -#define SCSI_RETURN_NOT_HANDLED   0x2008
> +#define SCSI_RETURN_NOT_HANDLED	0x2008
>  #define FAST_IO_FAIL	0x2009
>  #define TARGET_ERROR    0x200A
> +#define ADD_TO_MLQUEUE_DELAY	0x200B
> =20
>  /*
>   * Midlevel queue return values.
> @@ -477,6 +478,7 @@ static inline int scsi_is_wlun(unsigned int lun)
>  #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
>  #define SCSI_MLQUEUE_EH_RETRY    0x1057
>  #define SCSI_MLQUEUE_TARGET_BUSY 0x1058
> +#define SCSI_MLQUEUE_DEV_DLY_RTY 0x1059
> =20
Can't we just name it 'MLQUEUE_DELAYED_RETRY'?
'MLQUEUE_DEV_DLY_RTY' is a bit unwieldy ...

Other than that: Looks good.

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
