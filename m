From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/1] scsi: Initialize sdp after NULL check of cmnd
Date: Wed, 17 Jun 2015 13:38:19 +0200
Message-ID: <20150617113819.GC22164@c203.arch.suse.de>
References: <1434540067-69384-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434540067-69384-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, pankaj.m@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2015 at 04:51:07PM +0530, Maninder Singh wrote:
> Currently cmnd pointer is already dereferenced before NULL check
> and thus getting below warning in static analysis:
> warn: variable dereferenced before check 'cmnd'
>=20
> So initialize struct scsi_device *sdp after NULL check
> of cmnd
>=20
>=20
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>
> ---
>  drivers/scsi/scsi_debug.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1f8e2dc..bb97a5a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3942,7 +3942,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sd=
ebug_dev_info *devip,
>  	unsigned long iflags;
>  	int k, num_in_q, qdepth, inject;
>  	struct sdebug_queued_cmd *sqcp =3D NULL;
> -	struct scsi_device *sdp =3D cmnd->device;
> +	struct scsi_device *sdp;
> =20
>  	if (NULL =3D=3D cmnd || NULL =3D=3D devip) {
>  		pr_warn("%s: called with NULL cmnd or devip pointer\n",
> @@ -3950,6 +3950,8 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sd=
ebug_dev_info *devip,
>  		/* no particularly good error to report back */
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
> +
> +	sdp =3D cmnd->device;
>  	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
>  		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=3D0x%x\n",
>  			    __func__, scsi_result);
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
