From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: PATCH: unusual_devs fixups
Date: Sun, 15 Jun 2003 20:49:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030615204908.C10908@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:41487 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263298AbTFPDf1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2003 23:35:27 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: USB Developers <linux-usb-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, torvalds@transmeta.com


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(Resend due to error in address for linux-scsi.)

This patch moves the initialization of the struct scsi_device fields
use_10_for_ms and use_10_for_rw into a central place.  This allows the
host's slave_configure() function to change them (with effect).  This also
collapses two identical sections of code into a single one.

This patch is needed by usb-storage, so we can resolve some Babble
problems, some device-crashing problems, and remove a great deal of
troublesome mode-sense-translation code.

This patch is made against one of Greg K-H's USB trees, but it should apply
with little-or-no fuzz against a Linus tree or a linux-scsi tree.

Linus, please apply.

Matt


# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1963  -> 1.1964=20
#	   drivers/scsi/sr.c	1.46    -> 1.47  =20
#	   drivers/scsi/sd.c	1.49    -> 1.50  =20
#	drivers/scsi/scsi_scan.c	1.39    -> 1.40  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/15	mdharm@zen.san.one-eyed-alien.net	1.1964
# Move the setting of the use_10_for_ms and use_10_for_rw members of struct
# scsi_device to between where the structure is created and where
# slave_configure() is called.
#=20
# This allows slave_configure() to manipulate the variables while
# simultaneously moves two pieces of identical code into one common place.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sun Jun 15 20:38:43 2003
+++ b/drivers/scsi/scsi_scan.c	Sun Jun 15 20:38:43 2003
@@ -686,6 +686,9 @@
 	 * function */
 	sdev->max_device_blocked =3D SCSI_DEFAULT_DEVICE_BLOCKED;
=20
+	sdev->use_10_for_rw =3D 1;
+	sdev->use_10_for_ms =3D 0;
+
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
=20
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sun Jun 15 20:38:43 2003
+++ b/drivers/scsi/sd.c	Sun Jun 15 20:38:43 2003
@@ -1265,8 +1265,6 @@
 	if (sdkp->media_present)
 		sd_read_cache_type(sdkp, disk->disk_name, SRpnt, buffer);
 	=09
-	SRpnt->sr_device->use_10_for_rw =3D 1;
-	SRpnt->sr_device->use_10_for_ms =3D 0;
 	SRpnt->sr_device->remap =3D 1;
=20
  leave:
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Sun Jun 15 20:38:43 2003
+++ b/drivers/scsi/sr.c	Sun Jun 15 20:38:43 2003
@@ -524,8 +524,6 @@
 	sprintf(cd->cdi.name, "sr%d", minor);
=20
 	sdev->sector_size =3D 2048;	/* A guess, just in case */
-	sdev->use_10_for_rw =3D 1;
-	sdev->use_10_for_ms =3D 0;
 	sdev->remap =3D 1;
=20
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+7T40IjReC7bSPZARAsosAKC6ZMbsSvqHhIgWbMhc7mNcyrHuqACgl0qT
cnnU29ThSrdLXvBseL5cmn0=
=SB9Q
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
