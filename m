From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/14] lpfc: in sli3 use configured sg_seg_cnt for
 sg_tablesize
Date: Mon, 14 Sep 2015 09:34:56 +0200
Message-ID: <55F678A0.6070209@suse.de>
References: <55e4bd8a.9Holn3dFdEAEsMk9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbbINHe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:34:57 -0400
In-Reply-To: <55e4bd8a.9Holn3dFdEAEsMk9%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>=20
> Hi James,
>=20
> We had some performance problems with RAID systems connected to LPe12=
k.
> AFAICS, the reason is a small bug in lpfc.ko, causing the IO-size to
> be smaller than expected.
>=20
> The patch below fixes it for us.
>=20
> Please CC me, I'm not on the list.
>=20
> Best regards
> Bodo
>=20
> ------------------------------------------------------
>=20
> Currently the module parameter lpfc_sg_seg_count does not have effect
> for sli3 devices.
>=20
> In lpfc_sli_driver_resource_setup(), which is used for sli3, the code
> writes the configured sg_seg_cnt into lpfc_template.sg_tablesize.
> But lpfc_template is the template used for sli4 only. Thus the value =
should
> correctly be written to lpfc_template_s3->sg_tablesize.
>=20
> This patch is for kernel 4.1-rc5, but is tested with lpfc 10.2.405.26=
 only.
>=20
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index da9b6fc..81bfb2d 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4994,7 +4994,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba =
*phba)
> =20
>  	/* Initialize the host templates the configured values. */
>  	lpfc_vport_template.sg_tablesize =3D phba->cfg_sg_seg_cnt;
> -	lpfc_template.sg_tablesize =3D phba->cfg_sg_seg_cnt;
> +	lpfc_template_s3.sg_tablesize =3D phba->cfg_sg_seg_cnt;
> =20
>  	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp */
>  	if (phba->cfg_enable_bg) {
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
