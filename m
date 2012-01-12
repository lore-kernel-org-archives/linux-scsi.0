From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Thu, 12 Jan 2012 10:43:47 +0100
Message-ID: <4F0EAB53.7020404@suse.de>
References: <1325618414-26992-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2ALJnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 04:43:49 -0500
In-Reply-To: <1325618414-26992-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 01/03/2012 08:20 PM, Rob Evers wrote:
> From: Rob Evers <revers@redhat.com>
>=20
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
> change MLQUEUE_DEV_DLY_RTY to MLQUEUE_DELAYED_RETRY
>=20
I have been working on a different solution, whic
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    7 ++++---
>  drivers/scsi/scsi.c                        |    3 +++
>  drivers/scsi/scsi_error.c                  |    1 +
>  drivers/scsi/scsi_lib.c                    |    9 ++++++++-
>  include/scsi/scsi.h                        |   12 +++++++-----
>  5 files changed, 23 insertions(+), 9 deletions(-)
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
Actually, this doesn't help if the RTPG command returns with the
mentioned error; then you'll just continue flooding the array with
RTPG commands. You'll need to delay the RTPG commands, too.

I'll be sending an updated patch.

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
