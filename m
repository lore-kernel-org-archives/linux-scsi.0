From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 13/18] scsi_dh_alua: rework alua_check_tpgs() to return
 the tpgs mode
Date: Tue, 24 Nov 2015 13:17:10 +0100
Message-ID: <1448367430.2877.22.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbbKXMRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:17:11 -0500
In-Reply-To: <1447081703-110552-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Instead of returning an error code in alua_check_tpgs() we should
> rather return the tpgs mode directly and have a cleaner syntax.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 25 +++++++++++----=
-----
> -----
> =C2=A01 file changed, 11 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index d54f42e..c9751c9 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -262,24 +262,23 @@ static unsigned submit_stpg(struct alua_dh_data
> *h)
> =C2=A0 * Examine the TPGS setting of the sdev to find out if ALUA
> =C2=A0 * is supported.
> =C2=A0 */
> -static int alua_check_tpgs(struct scsi_device *sdev, struct
> alua_dh_data *h)
> +static int alua_check_tpgs(struct scsi_device *sdev)
> =C2=A0{
> -	int err =3D SCSI_DH_OK;
> +	int tpgs =3D TPGS_MODE_NONE;
> =C2=A0
> =C2=A0	/*
> =C2=A0	=C2=A0* ALUA support for non-disk devices is fraught with
> =C2=A0	=C2=A0* difficulties, so disable it for now.
> =C2=A0	=C2=A0*/
> =C2=A0	if (sdev->type !=3D TYPE_DISK) {
> -		h->tpgs =3D TPGS_MODE_NONE;
> =C2=A0		sdev_printk(KERN_INFO, sdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0"%s: disable for non-disk devices\n"=
,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> -		return SCSI_DH_DEV_UNSUPP;
> +		return tpgs;
> =C2=A0	}
> =C2=A0
> -	h->tpgs =3D scsi_device_tpgs(sdev);
> -	switch (h->tpgs) {
> +	tpgs =3D scsi_device_tpgs(sdev);
> +	switch (tpgs) {
> =C2=A0	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
> =C2=A0		sdev_printk(KERN_INFO, sdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0"%s: supports implicit and explicit
> TPGS\n",
> @@ -296,18 +295,16 @@ static int alua_check_tpgs(struct scsi_device
> *sdev, struct alua_dh_data *h)
> =C2=A0	case TPGS_MODE_NONE:
> =C2=A0		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> -		err =3D SCSI_DH_DEV_UNSUPP;
> =C2=A0		break;
> =C2=A0	default:
> =C2=A0		sdev_printk(KERN_INFO, sdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0"%s: unsupported TPGS setting %d\n",
> -			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, h->tpgs);
> -		h->tpgs =3D TPGS_MODE_NONE;
> -		err =3D SCSI_DH_DEV_UNSUPP;
> +			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, tpgs);
> +		tpgs =3D TPGS_MODE_NONE;
> =C2=A0		break;
> =C2=A0	}
> =C2=A0
> -	return err;
> +	return tpgs;
> =C2=A0}
> =C2=A0
> =C2=A0/*
> @@ -627,10 +624,10 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0 */
> =C2=A0static int alua_initialize(struct scsi_device *sdev, struct
> alua_dh_data *h)
> =C2=A0{
> -	int err;
> +	int err =3D SCSI_DH_DEV_UNSUPP;
> =C2=A0
> -	err =3D alua_check_tpgs(sdev, h);
> -	if (err !=3D SCSI_DH_OK)
> +	h->tpgs =3D alua_check_tpgs(sdev);
> +	if (h->tpgs =3D=3D TPGS_MODE_NONE)
> =C2=A0		goto out;
> =C2=A0
> =C2=A0	err =3D alua_check_vpd(sdev, h);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
