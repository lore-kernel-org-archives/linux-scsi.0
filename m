From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/8] pm80xx: Fix for Incorrect DMA Unmapping of SG List
Date: Wed, 29 Jul 2015 10:54:37 +0200
Message-ID: <55B894CD.6050409@suse.de>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com> <1438151240-4097-5-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbbG2Iyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 04:54:39 -0400
In-Reply-To: <1438151240-4097-5-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com

On 07/29/2015 08:27 AM, Viswas.G@pmcs.com wrote:
> From: Viswas G <Viswas.G@pmcs.com>
>=20
> In pm8001_ccb_task_free(), the dma unmapping is done based on
> ccb->n_elem value. This should be initialized to zero in the
> task_abort(). Otherwise, pm8001_ccb_task_free() will try for
> dma_unmap_sg() which is invalid for task abort and can lead to
> kernel crash.
>=20
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>=20
> ---
>  drivers/scsi/pm8001/pm8001_sas.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/p=
m8001_sas.c
> index 4e6955f..b1c5fb9 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -790,6 +790,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba=
_info *pm8001_ha,
>  		ccb->device =3D pm8001_dev;
>  		ccb->ccb_tag =3D ccb_tag;
>  		ccb->task =3D task;
> +		ccb->n_elem =3D 0;
> =20
>  		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha,
>  			pm8001_dev, flag, task_tag, ccb_tag);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
