From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 09:52:58 +1000
Message-ID: <1439250778.24419.5.camel@axtens.net>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RwKpdbo1lFvqFiIZwZtu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35727 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbbHJXzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2015 19:55:17 -0400
Received: by pacgr6 with SMTP id gr6so36879869pac.2
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 16:55:17 -0700 (PDT)
In-Reply-To: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


--=-RwKpdbo1lFvqFiIZwZtu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> @@ -487,11 +515,27 @@ static int cxlflash_eh_host_reset_handler(struct sc=
si_cmnd *scp)
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>  		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
> =20
> -	rcr =3D cxlflash_afu_reset(cfg);
> -	if (rcr =3D=3D 0)
> -		rc =3D SUCCESS;
> -	else
> +	switch (cfg->state) {
> +	case STATE_NORMAL:
> +		cfg->state =3D STATE_LIMBO;
> +		scsi_block_requests(cfg->host);
> +
> +		rcr =3D cxlflash_afu_reset(cfg);
> +		if (!rcr)
> +			rc =3D FAILED;

I think you want:

	if (rcr) {
		rc =3D FAILED;
		break;
	}

cxlflash_afu_reset returns 0 on success, so I think you want to drop the
negation, and also I think if it fails you want to break out and not set
STATE_NORMAL. Is that right?

Once you fix that, or explain to me why I'm wrong:
Reviewed-by: Daniel Axtens <dja@axtens.net>

--=20
Regards,
Daniel

--=-RwKpdbo1lFvqFiIZwZtu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: GPGTools - https://gpgtools.org

iQIcBAABCgAGBQJVyTlaAAoJEPC3R3P2I92FLjIP/2z5cyWkohHfwhV/btjkUzMt
pYbEZmx/y7qGkKFLP4TfRaZWCfCteEjZvOI+k33HbdHTVikU1ilBdygoaDZtkFww
u+kR+CkibaNuA2oyzCdL9QQzq8rb158Ykd7+IA4wGmuuarZ8s66ch8nBkADROTFX
bCrwpSN7kKzYpj9dtu/hMxUTg33RwfYJS5lsJZGyMKPhwocdepZDJ/kuAIU8/J4V
GIBOqLSm3IiUTk0ZUCgWeGuZy+W5E8mXKsH6bYzoDcw7IaKP1FwgMaIlulJbHO+q
Cs07aZPTBTQZI7/wpRpX4VlgRVp2HcoEpCW+CM9lypw+kaTiXdVCxz9Tz+BB9Uqv
rmuxUQntQf6dQvXA3+Usv2tVH6vACiKxqutJ2Tg77QIA+cb+5E6MmQ0wnkOt+mWa
h4O0ekDS3i3XZayVFR6desIa73aWycq9yGIk5pmjhD+Or90LyRN5VHgQicsg6dL5
WzIj/Paz8xYfHrolF5GJJZhGEz93pTIBmclGIJ5HEqEaT+8dnp+1wDQ3xisAU6LV
FM+rP5WfksT3koU2eg0pnlQ8je5ZPOnN20TFYqeiHLnkwIvpxW27aW7CFCUpOORN
nngS6/veo1/iR56Q++2HwY2lI44DQPLXT5/V4qfMDS6oG/5lYYDeWsXmS3aEW1we
sZkonEEfsAT62LWAfgRh
=uz3k
-----END PGP SIGNATURE-----

--=-RwKpdbo1lFvqFiIZwZtu--

