From: Kurt Garloff <garloff@suse.de>
Subject: scsi_debug: inject recovered errors
Date: Sat, 8 Feb 2003 12:54:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030208115446.GD26619@nbkurt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTiIB9CRvBOLTyqY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--hTiIB9CRvBOLTyqY
Content-Type: multipart/mixed; boundary="hK8Uo4Yp55NZU70L"
Content-Disposition: inline


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Doug,

this patch allows to inject recovered errors with scsi_debug, to see=20
whether sd handles them correctly.

Attached patch is a port to scsi_debug as in 2.4.20. (I used 2.4.19 for
testing.)=20
It has been for verifying that the fix for recovered error sense (without
valid bit) actually works.=20

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi_debug_inj_recovered_errors.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr linux-2.4.20.recerr/drivers/scsi/scsi_debug.c linux-2.4.20/driver=
s/scsi/scsi_debug.c
--- linux-2.4.20.recerr/drivers/scsi/scsi_debug.c	2002-11-29 00:53:14.00000=
0000 +0100
+++ linux-2.4.20/drivers/scsi/scsi_debug.c	2003-02-08 02:40:21.000000000 +0=
100
@@ -80,6 +80,8 @@
 static int scsi_debug_every_nth =3D DEF_EVERY_NTH;
 static int scsi_debug_cmnd_count =3D 0;
 static int scsi_debug_delay =3D DEF_DELAY;
+static int scsi_debug_inj_rec_err =3D 0;
+
=20
 #define NR_HOSTS_PRESENT (((scsi_debug_num_devs - 1) / 7) + 1)
 #define N_HEAD          8
@@ -324,6 +326,12 @@
 			num =3D cmd[4];
 		}
 		errsts =3D resp_read(SCpnt, upper_blk, block, num, devip);
+ 		if (scsi_debug_inj_rec_err && !(SCpnt->pid % scsi_debug_inj_rec_err)) {
+ 			SCpnt->result =3D (COMMAND_COMPLETE << 8) |=20
+ 					(CHECK_CONDITION << 1);
+ 			mk_sense_buffer(devip, RECOVERED_ERROR, 0x5d, 0, 14);
+ 		} else
+ 			SCpnt->result =3D 0;
 		break;
 	case REPORT_LUNS:
 		errsts =3D resp_report_luns(cmd, buff, bufflen, devip);
@@ -361,6 +369,12 @@
 	case MODE_SENSE:
 	case MODE_SENSE_10:
 		errsts =3D resp_mode_sense(cmd, target, buff, bufflen, devip);
+		if (scsi_debug_inj_rec_err && !(SCpnt->pid % scsi_debug_inj_rec_err)) {
+			SCpnt->result =3D (COMMAND_COMPLETE << 8) |=20
+					(CHECK_CONDITION << 1);
+			mk_sense_buffer(devip, RECOVERED_ERROR, 0x5d, 0, 14);
+		} else
+			SCpnt->result =3D 0;
 		break;
 	default:
 #if 0
@@ -1160,6 +1174,8 @@
 MODULE_PARM_DESC(scsi_debug_every_nth, "timeout every nth command(def=3D10=
0)");
 MODULE_PARM(scsi_debug_delay, "i");
 MODULE_PARM_DESC(scsi_debug_delay, "# of jiffies to delay response(def=3D1=
)");
+MODULE_PARM(scsi_debug_inj_rec_err, "i");
+MODULE_PARM_DESC(scsi_debug_inj_rec_err, "inject recovered errors every N =
read/write command");
 #ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL");
 #endif

--hK8Uo4Yp55NZU70L--

--hTiIB9CRvBOLTyqY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+RPAGxmLh6hyYd04RAk/gAKCp4Zi9nK0KPpdxkt/58D17hx/JWgCfYi9/
H9g4TSqxw6Ajde3tF4R5Z1U=
=6L77
-----END PGP SIGNATURE-----

--hTiIB9CRvBOLTyqY--
