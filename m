From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH]: aic94xx: fix uninitialized variable warning
Date: Fri, 28 May 2010 21:18:07 +0200
Message-ID: <201005282118.08243.eike-kernel@sf-tec.de>
References: <20100527182056.24051.65113.sendpatchset@prarit.bos.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1580910.HhON1X79BE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:39639 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0E1TSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 15:18:13 -0400
In-Reply-To: <20100527182056.24051.65113.sendpatchset@prarit.bos.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

--nextPart1580910.HhON1X79BE
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Prarit Bhargava wrote:
> Fixes warning:
>=20
> drivers/scsi/aic94xx/aic94xx_sds.c: In function
> =E2=80=98asd_process_ctrl_a_user=E2=80=99: drivers/scsi/aic94xx/aic94xx_s=
ds.c:985:
> error: =E2=80=98offs=E2=80=99 may be used uninitialized in this function

Your mailer has messed this up as it did not declare any character set. Thi=
s=20
was probably UTF8 or something like that.

> diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c
> b/drivers/scsi/aic94xx/aic94xx_sds.c index edb43fd..2f1751a 100644
> --- a/drivers/scsi/aic94xx/aic94xx_sds.c
> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c
> @@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_stru=
ct
> *asd_ha, struct asd_flash_dir *flash_dir)
>  {
>  	int err, i;
> -	u32 offs, size;
> +	u32 uninitialized_var(offs), size;
>  	struct asd_ll_el *el;
>  	struct asd_ctrla_phy_settings *ps;
>  	struct asd_ctrla_phy_settings dflt_ps;

I would vote for putting the declarations if different lines if one of them=
=20
gets initialized or otherwise treated specially as it is otherwise hardly=20
readable.

Eike

--nextPart1580910.HhON1X79BE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwAFvAACgkQXKSJPmm5/E5GWgCdEHI1kC9KEtlrPOAxPny3HTW3
7KsAoKTI7eK/IUCzk0ZcSOmnYdjjAhtj
=SGv6
-----END PGP SIGNATURE-----

--nextPart1580910.HhON1X79BE--
