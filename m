From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
Date: Sun, 13 Sep 2009 10:04:11 +0200
Message-ID: <200909131004.19489.eike@sf-mail.de>
References: <20090913040104.ab1d0b69.const@mimas.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5475248.XWu9tlgf66";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51557 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZIMILB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2009 04:11:01 -0400
In-Reply-To: <20090913040104.ab1d0b69.const@mimas.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Constantin Baranov <const@mimas.ru>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

--nextPart5475248.XWu9tlgf66
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Sonntag 13 September 2009 01:01:04 schrieb Constantin Baranov:
> The scsitemp module attaches a device to each SCSI device
> and registers it in hwmon. Currently the only method of
> reading temperature is ATA SMART. Adding support of the
> pure SCSI methods is provided.

That sounds useful. Do you have any nagios rules or something similar aroun=
d=20
that make use of this?

> +static int scsitemp_ata_temp_input(struct scsitemp *st, long *temp)
> +{
> +	static const u8 cdb[16] =3D {
> +		ATA_16,			0x08,	0x0e,			0x00,
> +		ATA_SMART_READ_VALUES,	0x00,	0x01,			0x00,
> +		0x00,			0x00,	ATA_SMART_LBAM_PASS,	0x00,
> +		ATA_SMART_LBAH_PASS,	0x00,	ATA_CMD_SMART,		0x00,
> +	};
> +
> +	u8 values[512];
> +	unsigned len =3D sizeof(values);
> +	unsigned nattrs, i;
> +	int err;
> +
> +	err =3D scsitemp_execute(st, cdb, values, &len);
> +	if (err)
> +		goto out;

How about directly doing "return err;" here? This would make the label=20
superfluous and tthe code a bit more obvious.

> +	err =3D -ENXIO;
> +	nattrs =3D min_t(unsigned, 30, len / 12);
> +	for (i =3D 0; i < nattrs; i++) {
> +		u8 *attr =3D values + i * 12;
> +
> +		if (attr[2] =3D=3D 194) {
> +			*temp =3D attr[7] * 1000;
> +			err =3D 0;
> +			break;
> +		}
> +	}
> +
> +out:
> +	return err;
> +}

--nextPart5475248.XWu9tlgf66
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkqsp4MACgkQXKSJPmm5/E6CLwCfYbSFY6w6DJtUxXtTth6b+w9a
NcYAoIOHKbvWF3dKuqjgQ6TrGxRFgvne
=40Wg
-----END PGP SIGNATURE-----

--nextPart5475248.XWu9tlgf66--
