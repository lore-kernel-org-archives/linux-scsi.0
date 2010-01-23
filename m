From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] qla1280: Drop host_lock while requesting firmware
Date: Sat, 23 Jan 2010 20:17:52 +0100
Message-ID: <201001232018.08155.eike-kernel@sf-tec.de>
References: <1264272029.373.95.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16016161.noFNH5sVy2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:43493 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab0AWTSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jan 2010 14:18:13 -0500
In-Reply-To: <1264272029.373.95.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

--nextPart16016161.noFNH5sVy2
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Ben Hutchings wrote:
> request_firmware() may sleep and it appears to be safe to release the
> spinlock here.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@kernel.org
> ---
> This change was made in Debian kernel packages to address this bug
> report: <http://bugs.debian.org/543244>.  We have applied it to 2.6.31
> and 2.6.32 and there have been no further bug reports on this driver.
>=20
> Ben.
>=20
>  drivers/scsi/qla1280.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 8371d91..49ac414 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -1640,8 +1640,10 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)

I think that those request_firmware stuff together with it's error handling=
=20
should be moved from qla1280_load_firmware_pio() and=20
qla1280_load_firmware_dma() to qla1280_load_firmware().

Although the firmware version in the driver struct is updated before it is=
=20
updated, which may still fail. In that case it is not set back to the old=20
value. I don't know if that is a problem at all, that's just what I saw on =
a=20
quick look.

Eike

--nextPart16016161.noFNH5sVy2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktbS2gACgkQXKSJPmm5/E6GYQCeKfK6NDHHM7xPd3Cm6Un+vp8n
XVUAnizvL1idNhVAaFcovWmCdLKjjgWO
=6LdU
-----END PGP SIGNATURE-----

--nextPart16016161.noFNH5sVy2--
