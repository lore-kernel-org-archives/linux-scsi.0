From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: PATCH: change START_STOP to TEST_UNIT_READY
Date: Sun, 27 Oct 2002 01:43:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027014357.A3770@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, USB Storage List <usb-storage@one-eyed-alien.net>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch changes a use of START_STOP to TEST_UNIT_READY in the function
to check for a media change.

This is required for emulated SCSI busses (IEEE1394 sbp2 and usb-storage),
as none of the 'popular' OSes will send a START_STOP unless the target
requests it (via sense data that indicates a startup command is needed).
Thus, lots of device firmware out there will crash or do something equally
bad when a START_STOP is sent.

Yeah, busted devices, I know.  But, in the end, people just want it to
work, and there is no reason why we can't use TEST_UNIT_READY here instead.
As the comments indicate, devices that need a spinup will get one anyway.

Will one of the SCSI gurus please send this to Linus?

Matt

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.561.1.395 -> 1.636 =20
#	drivers/usb/storage/initializers.c	1.2.1.2 -> 1.5   =20
#	drivers/usb/storage/transport.h	1.7.1.5 -> 1.13  =20
#	drivers/usb/core/message.c	1.20.1.3 -> 1.22  =20
#	     kernel/signal.c	1.23.1.6 -> 1.29  =20
#	drivers/usb/storage/datafab.c	1.8.1.5 -> 1.14  =20
#	drivers/usb/storage/protocol.c	1.7.1.3 -> 1.9   =20
#	drivers/usb/storage/usb.h	1.5.1.19 -> 1.26  =20
#	drivers/usb/storage/isd200.c	1.8.1.10 -> 1.19  =20
#	drivers/usb/storage/raw_bulk.h	1.1.1.3 -> 1.5   =20
#	drivers/usb/storage/jumpshot.c	1.10.1.6 -> 1.17  =20
#	drivers/usb/storage/debug.h	1.1.1.4 -> 1.6   =20
#	drivers/usb/storage/sddr55.c	1.3.1.6 -> 1.9   =20
#	drivers/usb/storage/shuttle_usbat.c	1.9.1.8 -> 1.18  =20
#	drivers/usb/storage/raw_bulk.c	1.1.1.10 -> 1.13  =20
#	drivers/usb/storage/sddr09.c	1.12.1.8 -> 1.21  =20
#	drivers/usb/storage/scsiglue.h	1.1.1.2 -> 1.4   =20
#	drivers/usb/storage/debug.c	1.8.1.2 -> 1.10  =20
#	   drivers/scsi/sd.c	1.22.1.13 -> 1.36  =20
#	drivers/usb/storage/scsiglue.c	1.11.1.19 -> 1.30  =20
#	drivers/usb/storage/transport.c	1.17.1.37 -> 1.57  =20
#	drivers/scsi/scsi_scan.c	1.9.1.11 -> 1.16  =20
#	drivers/usb/storage/freecom.c	1.6.1.10 -> 1.17  =20
#	drivers/usb/storage/usb.c	1.16.1.33 -> 1.53  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/10/26	mdharm@zen.san.one-eyed-alien.net	1.631.1.1
# Merge bk://linuxusb.bkbits.net/usb-2.5
# into zen.san.one-eyed-alien.net:/home/mdharm/linux-usb/greg-tree
# --------------------------------------------
# 02/10/26	mdharm@zen.san.one-eyed-alien.net	1.635
# Merge
# --------------------------------------------
# 02/10/26	mdharm@zen.san.one-eyed-alien.net	1.636
# Changed comments to match code.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sat Oct 26 18:29:11 2002
+++ b/drivers/scsi/sd.c	Sat Oct 26 18:29:11 2002
@@ -733,15 +733,17 @@
 				 * check_disk_change */
 	}
=20
-	/* Using Start/Stop enables differentiation between drive with
+	/* Using TEST_UNIT_READY enables differentiation between drive with
 	 * no cartridge loaded - NOT READY, drive with changed cartridge -
 	 * UNIT ATTENTION, or with same cartridge - GOOD STATUS.
-	 * This also handles drives that auto spin down. eg iomega jaz 1GB
-	 * as this will spin up the drive.
+	 *
+	 * Drives that auto spin down. eg iomega jaz 1G, will be started
+	 * by sd_spinup_disk() from sd_init_onedisk(), which happens whenever
+	 * sd_revalidate() is called.
 	 */
 	retval =3D -ENODEV;
 	if (scsi_block_when_processing_errors(sdp))
-		retval =3D scsi_ioctl(sdp, SCSI_IOCTL_START_UNIT, NULL);
+		retval =3D scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NULL);
=20
 	if (retval) {		/* Unable to test, unit probably not ready.
 				 * This usually means there is no disc in the
--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Dudes! May the Open Source be with you.
					-- Eric S. Raymond
User Friendly, 12/3/1998

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9u6dNIjReC7bSPZARAkIOAJ9tPjr9hmpqR7dVBq5AQd9jCM2h9wCgsVwl
991uHOsc4BlbDYBC/SHvTBM=
=pZP3
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
