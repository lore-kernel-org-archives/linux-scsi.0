From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH] advansys: fix regression with request_firmware change
Date: Tue, 23 Mar 2010 18:25:34 -0300
Message-ID: <201003231825.35108.herton@mandriva.com.br>
References: <201003191937.26808.herton@mandriva.com.br>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:43431 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0CWVZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2010 17:25:38 -0400
In-Reply-To: <201003191937.26808.herton@mandriva.com.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Em Sex 19 Mar 2010, =E0s 19:37:26, Herton Ronaldo Krzesinski escreveu:
> On newer kernels users of advansys module are reporting system hang w=
hen
> trying to load it without firmware files present. After looking close=
ly
> at description on https://qa.mandriva.com/show_bug.cgi?id=3D53220, I =
think
> this is related to commit "[SCSI] advansys: use request_firmware". Th=
e
> problem is that after switch to request_firmware, asc_dvc->err_code
> isn't being set when firmware files aren't found or loading fails.
>=20
> err_code is used by the driver to judge if there was a fatal error or
> not, as can be seen for example on advansys_board_found, which will o=
nly
> return -ENODEV when err_code is set. Because err_code isn't being set
> when request_firmware fails, this is a change of behaviour of the cod=
e
> before request_firmware addition, making it continue to load and it
> fails later as the firmware wasn't really loaded.

Please disregard this patch, an user tested and found another issue wit=
h it,
I'll fix it and repost.

>=20
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---
>  drivers/scsi/advansys.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> Note that I'm still waiting for user on bug report to test this patch=
, but so
> far this is safe and should be ok to solve the bug, so I'm sending it=
 already.
>=20
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 22626ab..9201afe 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -4781,12 +4781,14 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VA=
R *asc_dvc)
>  	if (err) {
>  		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
>  		       fwname, err);
> +		asc_dvc->err_code |=3D ASC_IERR_MCODE_CHKSUM;
>  		return err;
>  	}
>  	if (fw->size < 4) {
>  		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
>  		       fw->size, fwname);
>  		release_firmware(fw);
> +		asc_dvc->err_code |=3D ASC_IERR_MCODE_CHKSUM;
>  		return -EINVAL;
>  	}
>  	chksum =3D (fw->data[3] << 24) | (fw->data[2] << 16) |
> @@ -5110,12 +5112,14 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *=
asc_dvc)
>  	if (err) {
>  		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
>  		       fwname, err);
> +		asc_dvc->err_code =3D ASC_IERR_MCODE_CHKSUM;
>  		return err;
>  	}
>  	if (fw->size < 4) {
>  		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
>  		       fw->size, fwname);
>  		release_firmware(fw);
> +		asc_dvc->err_code =3D ASC_IERR_MCODE_CHKSUM;
>  		return -EINVAL;
>  	}
>  	chksum =3D (fw->data[3] << 24) | (fw->data[2] << 16) |
> @@ -5624,12 +5628,14 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VA=
R *asc_dvc)
>  	if (err) {
>  		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
>  		       fwname, err);
> +		asc_dvc->err_code =3D ASC_IERR_MCODE_CHKSUM;
>  		return err;
>  	}
>  	if (fw->size < 4) {
>  		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
>  		       fw->size, fwname);
>  		release_firmware(fw);
> +		asc_dvc->err_code =3D ASC_IERR_MCODE_CHKSUM;
>  		return -EINVAL;
>  	}
>  	chksum =3D (fw->data[3] << 24) | (fw->data[2] << 16) |
> @@ -6124,12 +6130,14 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VA=
R *asc_dvc)
>  	if (err) {
>  		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
>  		       fwname, err);
> +		asc_dvc->err_code =3D ASC_IERR_MCODE_CHKSUM;
>  		return err;
>  	}
>  	if (fw->size < 4) {
>  		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
>  		       fw->size, fwname);
>  		release_firmware(fw);
> +		asc_dvc->err_code =3D ASC_IERR_MCODE_CHKSUM;
>  		return -EINVAL;
>  	}
>  	chksum =3D (fw->data[3] << 24) | (fw->data[2] << 16) |
>=20

--=20
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
