From: Kurt Garloff <garloff@suse.de>
Subject: 2.4.20: Handle recovered errors
Date: Sat, 8 Feb 2003 12:49:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030208114939.GC26619@nbkurt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>


--ey/N+yb7u/X9mFhi
Content-Type: multipart/mixed; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

When a command returns CHECK_CONDITION and the sense information is
retrieved, the scsi block drivers (sd, sr) do not handle the sense key
correctly.=20
The valid bit only tells about validity of the information field (bytes 3
-- 6) of the fixed sense buffer. If it's not set, the sense key and ASC/ASCQ
are still valid. [spc3r10, 7.24.2.3]
But sd/sr consider the whole sense key invalid then.
This hits us for a RECOVERED_ERROR sense key that should be reported but
considered a success. Currently (2.4.20) sd/sr erroneously do consider it=
=20
an error, if the valid bit is unset.

Patch against 2.4.20 is attached.
I did not look into 2.5.59, but I guess it has the same problem.

Note that the change to scsi_lib is not strictly required, as with the fixes
to sr and sd, one should not get there for recovered errors any more. On the
other hand, it's good to have it there for correctness.

Patch has been tested with hacked scsi_debug. (See later mail.)

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-recoverederror-2420.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr linux-2.4.20.orig/drivers/scsi/scsi_lib.c linux-2.4.20.recerr/dri=
vers/scsi/scsi_lib.c
--- linux-2.4.20.orig/drivers/scsi/scsi_lib.c	2002-11-29 00:53:14.000000000=
 +0100
+++ linux-2.4.20.recerr/drivers/scsi/scsi_lib.c	2003-02-08 02:25:46.0000000=
00 +0100
@@ -695,6 +695,8 @@
 		 */
=20
 		switch (SCpnt->sense_buffer[2]) {
+		case RECOVERED_ERROR: /* Added, KG, 2003-01-20 */
+			return;
 		case ILLEGAL_REQUEST:
 			if (SCpnt->device->ten && SCSI_RETRY_10(SCpnt->cmnd[0])) {
 				SCpnt->device->ten =3D 0;
diff -uNr linux-2.4.20.orig/drivers/scsi/sd.c linux-2.4.20.recerr/drivers/s=
csi/sd.c
--- linux-2.4.20.orig/drivers/scsi/sd.c	2002-08-03 02:39:44.000000000 +0200
+++ linux-2.4.20.recerr/drivers/scsi/sd.c	2003-02-08 02:25:46.000000000 +01=
00
@@ -621,9 +621,11 @@
=20
 	/* An error occurred */
 	if (driver_byte(result) !=3D 0 && 	/* An error occured */
-	    SCpnt->sense_buffer[0] =3D=3D 0xF0) {	/* Sense data is valid */
+	    (SCpnt->sense_buffer[0] & 0x7f) =3D=3D 0x70) {	/* Sense data is valid=
 */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
+			if (!(SCpnt->sense_buffer[0] & 0x80))
+				break;
 			error_sector =3D (SCpnt->sense_buffer[3] << 24) |
 			(SCpnt->sense_buffer[4] << 16) |
 			(SCpnt->sense_buffer[5] << 8) |
diff -uNr linux-2.4.20.orig/drivers/scsi/sr.c linux-2.4.20.recerr/drivers/s=
csi/sr.c
--- linux-2.4.20.orig/drivers/scsi/sr.c	2002-11-29 00:53:14.000000000 +0100
+++ linux-2.4.20.recerr/drivers/scsi/sr.c	2003-02-08 02:25:46.000000000 +01=
00
@@ -211,11 +211,13 @@
=20
=20
 	if (driver_byte(result) !=3D 0 &&		/* An error occurred */
-	    SCpnt->sense_buffer[0] =3D=3D 0xF0) {	/* Sense data is valid */
+	    (SCpnt->sense_buffer[0] & 0x7f) =3D=3D 0x70) {	/* Sense data is valid=
 */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 		case ILLEGAL_REQUEST:
+			if (!(SCpnt->sense_buffer[0] & 0x80))
+				break;
 			error_sector =3D (SCpnt->sense_buffer[3] << 24) |
 			(SCpnt->sense_buffer[4] << 16) |
 			(SCpnt->sense_buffer[5] << 8) |

--vni90+aGYgRvsTuO--

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+RO7SxmLh6hyYd04RAkSPAJ9BM+RxPsOvYniBilwJQI61lzw9VACfXfpQ
+vJG8EYcVLn58f0J/24rW6M=
=3lhp
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
