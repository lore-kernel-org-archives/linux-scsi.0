From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] sd varyio fix
Date: Tue, 16 Jul 2002 00:16:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020715221604.GA10274@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Dave Jones <davej@suse.de>


--XF85m9dhOBO43t/C
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo,

another one: The bit shift for vary io in the sd driver was wrong.
I don't know whether it has much impact, but it should be fixed anyway.

Patch against 2.4.19rc1 attached.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sd-varyio-2419rc1.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/sd.c.orig	Wed Jun 12 11:39:47 2002
+++ drivers/scsi/sd.c	Tue Jul 16 00:12:40 2002
@@ -1345,7 +1345,7 @@
 	if (SDp->host->hostt->can_do_varyio) {
 		if (blkdev_varyio[SD_DISK_MAJOR(i)] =3D=3D NULL) {
 			blkdev_varyio[SD_DISK_MAJOR(i)] =3D=20
-				sd_varyio + ((i / SCSI_DISKS_PER_MAJOR) >> 8);
+				sd_varyio + ((i / SCSI_DISKS_PER_MAJOR) << 8);
 		}
 		memset(blkdev_varyio[SD_DISK_MAJOR(i)] + (devnum << 4), 1, 16);
 	}

--CE+1k2dSO48ffgeK--

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9M0mkxmLh6hyYd04RAto0AKDQOgr2cTmGqT22oIYGIeSRM/KPsQCeIxly
dnJ3BNIoN4F+1skWGpmfg08=
=RD7j
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
