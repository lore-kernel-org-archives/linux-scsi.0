From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 16:59:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621165920.F2811@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:56592 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264304AbTFUXpR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 19:45:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch makes sr.c respect the use_10_for_ms flag.

The old behavior was to try the 6-byte command, and if it fails make some
assumptions.

The new behavior is to first try the 10-bit version (only if use_10_for_ms
is set), the fall back to the old behavior.

With this patch, we should be able to cut out a few hundred lines of
problematic code in usb-storage.

Linus, please apply.

Matt

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.709   -> 1.710 =20
#	   drivers/scsi/sr.c	1.47    -> 1.48  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/20	mdharm@zen.san.one-eyed-alien.net	1.710
# Make SCSI CD-ROM driver respect the use_10_for_ms flag.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Fri Jun 20 17:34:56 2003
+++ b/drivers/scsi/sr.c	Fri Jun 20 17:34:56 2003
@@ -663,7 +663,7 @@
 {
 	struct cdrom_generic_command cgc;
 	unsigned char *buffer;
-	int rc, n;
+	int n, rc =3D 0;
=20
 	static char *loadmech[] =3D
 	{
@@ -682,16 +682,38 @@
 		printk(KERN_ERR "sr: out of memory.\n");
 		return;
 	}
-	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
-	cgc.cmd[0] =3D MODE_SENSE;
-	cgc.cmd[2] =3D 0x2a;
-	cgc.cmd[4] =3D 128;
-	cgc.buffer =3D buffer;
-	cgc.buflen =3D 128;
-	cgc.quiet =3D 1;
-	cgc.data_direction =3D SCSI_DATA_READ;
-	cgc.timeout =3D SR_TIMEOUT;
-	rc =3D sr_do_ioctl(cd, &cgc);
+
+	/* first, attempt 10-byte command */
+	if (cd->device->use_10_for_ms) {
+		memset(&cgc, 0, sizeof(struct cdrom_generic_command));
+		cgc.cmd[0] =3D MODE_SENSE_10;
+		cgc.cmd[2] =3D 0x2a;		/* page code */
+		cgc.cmd[8] =3D 128;		/* allocation length */
+		cgc.buffer =3D buffer;
+		cgc.buflen =3D 128;
+		cgc.quiet =3D 1;
+		cgc.data_direction =3D SCSI_DATA_READ;
+		cgc.timeout =3D SR_TIMEOUT;
+		rc =3D sr_do_ioctl(cd, &cgc);
+	}
+
+	/* if we got an error, return to old behavior */
+	if (rc)
+		cd->device->use_10_for_ms =3D 0;
+
+	/* issue 6-byte command */
+	if (!cd->device->use_10_for_ms) {
+		memset(&cgc, 0, sizeof(struct cdrom_generic_command));
+		cgc.cmd[0] =3D MODE_SENSE;
+		cgc.cmd[2] =3D 0x2a;		/* page code */
+		cgc.cmd[4] =3D 128;		/* allocation length */
+		cgc.buffer =3D buffer;
+		cgc.buflen =3D 128;
+		cgc.quiet =3D 1;
+		cgc.data_direction =3D SCSI_DATA_READ;
+		cgc.timeout =3D SR_TIMEOUT;
+		rc =3D sr_do_ioctl(cd, &cgc);
+	}
=20
 	if (rc) {
 		/* failed, drive doesn't have capabilities mode page */
@@ -703,7 +725,13 @@
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
 		return;
 	}
-	n =3D buffer[3] + 4;
+
+	/* calculate the start of the page */
+	if (cd->device->use_10_for_ms)
+		n =3D (buffer[6] << 8) + buffer[7] + 8;
+	else
+		n =3D buffer[3] + 4;
+
 	cd->cdi.speed =3D ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	cd->readcd_known =3D 1;
 	cd->readcd_cdda =3D buffer[n + 5] & 0x01;

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  How about "Web Designer"?
DP: I'd like a name that people won't laugh at.
					-- Pitr and Dust Puppy
User Friendly, 12/6/1997

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9PFYIjReC7bSPZARAnP7AKCozic2kPrA7NvfA2/qPWbMSteKmACfQvB1
St2VGnhCJyBkDRViQQhKcFU=
=n7GF
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
