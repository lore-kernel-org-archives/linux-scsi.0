From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi: use kzalloc for allocating one thing
Date: Thu, 18 Jun 2015 07:52:31 +0200
Message-ID: <55825C9F.4060104@suse.de>
References: <1434602194-14484-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbbFRFwg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2015 01:52:36 -0400
In-Reply-To: <1434602194-14484-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>, JBottomley@odin.com, hch@lst.de, michaelc@cs.wisc.edu, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com

On 06/18/2015 06:36 AM, Maninder Singh wrote:
> Use kzalloc rather than kcalloc(1,...) for allocating one thing
>=20
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Reviewed-by: Vaneet Narang <v.narang@samsung.com>
> ---
>  drivers/scsi/mvsas/mv_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_ini=
t.c
> index d40d734..65e47eb 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -558,7 +558,7 @@ static int mvs_pci_init(struct pci_dev *pdev, con=
st struct pci_device_id *ent)
> =20
>  	chip =3D &mvs_chips[ent->driver_data];
>  	SHOST_TO_SAS_HA(shost) =3D
> -		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
> +		kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
>  	if (!SHOST_TO_SAS_HA(shost)) {
>  		kfree(shost);
>  		rc =3D -ENOMEM;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
