From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 8/8] [SCSI] pmcraid: Pass pointers to access_ok(), not
 integers
Date: Sun, 27 Oct 2013 21:54:46 +0000
Message-ID: <1382910886.2994.52.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9EF/Kz7nWl4ndrKzjFMq"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-9EF/Kz7nWl4ndrKzjFMq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Most architectures define access_ok() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on sparc64.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/pmcraid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..4e0a2f3 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3794,7 +3794,8 @@ static long pmcraid_ioctl_passthrough(
 	}
=20
 	if (request_size > 0) {
-		rc =3D access_ok(access, arg, request_offset + request_size);
+		rc =3D access_ok(access, (void *)arg,
+			       request_offset + request_size);
=20
 		if (!rc) {
 			rc =3D -EFAULT;

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-9EF/Kz7nWl4ndrKzjFMq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2Lpue/yOyVhhEJAQogaRAApuI/XAprWm6oVY6AfWjkNkz5GOFzOpTW
7PMjorw6tklt1T1H/eCJ5CluK6TVS8w79NEItUFpWzafUg3E7kBz9oYnkBzCmhMn
TZ1WMzgHPhqo9iYYSyKQU2BcTwO71X3fxtjq+TS95VgZuIxHfmvi06/P34JSElkh
w908L6i8f1Gzc8jb1gCDyCz7BKtdahwpwdo+DsirL+R1fftU+agucjInKhxqDNCQ
sepyDeinqeoGt+0ESqvg88N25mN/yFtG6ZNcVd40tVoP9+g1GxrspYFWOH+o/36m
I0clahiJBo8MF2jwsnkPql/yxSpCoMruPvegn7IhLT1KyeVDsBzAAZIwkDvhWowG
fTBBwKwoDU7qbg9rUuzqUUL2IQ0+RIVVpUYjd4qpU3Hw0V+5pAtlv/CXyLE0egmN
73pPVOrE1jn8kuPnBX0FPWVB4ViTKc/9XOOr1baqyPvb4gRfu1A+TDOceaiD+egc
DA94zgxp0WhfvbEowRJDd3Hod6rJkxIELJosQRtPtuYLJatMMKhCBNhUyrF957ZS
s/axzP6LSk+SGyfFu9nsWGsSqC6Dn/+mFMABANaaM/wKby7s1ZbyKUY4BCLTGpcp
im0UveK+P9HUKgPvYMwptW1Rdgy53b1juxiB2OsBrqJxl+8V+j+scBNdMky0D44/
cxDM/Lc2bIM=
=Usk9
-----END PGP SIGNATURE-----

--=-9EF/Kz7nWl4ndrKzjFMq--
