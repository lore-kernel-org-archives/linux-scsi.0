From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] libata-scsi: do not return t10 designator if drive
 has WWN
Date: Thu, 7 Jul 2016 12:56:46 +0200
Message-ID: <577E356E.9050209@suse.de>
References: <20160706221213.1928-1-me>
 <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/07/2016 12:12 AM, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>=20
> SAT (as of sat4r05f.pdf) only requires the t10 designator if the
> drive does not support/have WWN. Besides, we already have the ATA
> information VPD.
>=20
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 9f478ad..84b3d42 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2210,21 +2210,6 @@ static unsigned int ata_scsiop_inq_83(struct a=
ta_scsi_args *args, u8 *rbuf)
>  	rbuf[1] =3D 0x83;			/* this page code */
>  	num =3D 4;
> =20
> -	/* SAT defined lu model and serial numbers descriptor */
> -	/* piv=3D0, assoc=3Dlu, code_set=3DACSII, designator=3Dt10 vendor i=
d */
> -	rbuf[num + 0] =3D 2;
> -	rbuf[num + 1] =3D 1;
> -	rbuf[num + 3] =3D sat_model_serial_desc_len;
> -	num +=3D 4;
> -	memcpy(rbuf + num, "ATA     ", 8);
> -	num +=3D 8;
> -	ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_PROD,
> -		      ATA_ID_PROD_LEN);
> -	num +=3D ATA_ID_PROD_LEN;
> -	ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_SERNO,
> -		      ATA_ID_SERNO_LEN);
> -	num +=3D ATA_ID_SERNO_LEN;
> -
>  	if (ata_id_has_wwn(args->id)) {
>  		/* SAT defined lu world wide name */
>  		/* piv=3D0, assoc=3Dlu, code_set=3Dbinary, designator=3DNAA */
> @@ -2236,6 +2221,23 @@ static unsigned int ata_scsiop_inq_83(struct a=
ta_scsi_args *args, u8 *rbuf)
>  			      ATA_ID_WWN, ATA_ID_WWN_LEN);
>  		num +=3D ATA_ID_WWN_LEN;
>  	}
> +	else {
> +		/* SAT defined lu model and serial numbers descriptor */
> +		/* piv=3D0, assoc=3Dlu, code_set=3DACSII, designator=3Dt10 vendor =
id */
> +		rbuf[num + 0] =3D 2;
> +		rbuf[num + 1] =3D 1;
> +		rbuf[num + 3] =3D sat_model_serial_desc_len;
> +		num +=3D 4;
> +		memcpy(rbuf + num, "ATA     ", 8);
> +		num +=3D 8;
> +		ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_PROD,
> +			      ATA_ID_PROD_LEN);
> +		num +=3D ATA_ID_PROD_LEN;
> +		ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_SERNO=
,
> +			      ATA_ID_SERNO_LEN);
> +		num +=3D ATA_ID_SERNO_LEN;
> +	}
> +
>  	rbuf[3] =3D num - 4;    /* page len (assume less than 256 bytes) */
>  	return 0;
>  }
>=20
Nope.
We cannot go about and remove VPD descriptors.
Existing systems might rely on the VPD attribute to be present (think o=
f
udev persistent symlinks), and the system will refuse to boot.
NACK.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
