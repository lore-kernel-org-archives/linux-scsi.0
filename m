From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH][RESEND] SCSI, Brocade FC HBA: Remember to always release_firmware() so we don't leak memory.
Date: Thu, 24 Mar 2011 08:02:10 +0100
Message-ID: <2959663.zb4mtM3Vnv@donald.sf-tec.de>
References: <alpine.LNX.2.00.1103232356510.28372@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2999983.SGzsIX4d4E"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1103232356510.28372@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org


--nextPart2999983.SGzsIX4d4E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Am Donnerstag, 24. M=E4rz 2011, 00:00:39 schrieb Jesper Juhl:
> Once we've called request_firmware() we must remember to call
> release_firmware() to free memory. We don't currently do this in
> bfad_read_firmware(); causing a memory leak.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Jing Huang <huangj@brocade.com>
> ---
>  bfad.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>=20
>  Could someone merge this please?
>=20
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
> index 44524cf..d7bafeb 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -1558,23 +1558,22 @@ bfad_read_firmware(struct pci_dev *pdev, u32
> **bfi_image,
>=20
>  =09if (request_firmware(&fw, fw_name, &pdev->dev)) {
>  =09=09printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
> -=09=09goto error;
> +=09=09*bfi_image =3D NULL;
> +=09=09goto out;
>  =09}

A simple "return NULL;" here is enough, there is nothing that could be =
freed=20
later on.

Looking a bit deeper I think the interface of this function is totally =
b0rked:
-it has a return value that is always the same as one of the arguments=20=

(+dereference)
-noone ever checks this return value
-at least in my tree it is never called from anywhere outside this file=
 but is=20
still exported and not static

Eike
--nextPart2999983.SGzsIX4d4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk2K7HkACgkQXKSJPmm5/E6sHwCfeORb3K244JKQ+cq+55bdw4l4
Gu0An2DBV+RMvq351iKsJyMYEx3nk6YZ
=BkTS
-----END PGP SIGNATURE-----

--nextPart2999983.SGzsIX4d4E--
