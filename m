From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: 2.5 PATCH: test for media-change like "popular" OSes..
Date: Sun, 3 Nov 2002 15:37:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103153745.F10110@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch changes how media-change is detected to use a mechanism more
similar to what 'popular' OSes use.

The motive for this change is that more and more emulated-SCSI devices
(sbp2, usb-storage, etc) don't support START_STOP unless they need it.
Other OSes won't send a START_STOP unless the device reports NOT_READY,
indicating that it needs an explicit command to start up.

One could argue that these devices are out-of-spec, but they are so common
that they basically define the de facto spec.

Basically, any device that needs a START_STOP should still get it, but ones
that don't need it won't.

Linus, please apply.

Matt

--- a/drivers/scsi/sd.c	Sun Nov  3 10:25:14 2002
+++ b/drivers/scsi/sd.c	Sun Nov  3 15:06:38 2002
@@ -697,15 +697,17 @@
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
@@ -791,10 +793,9 @@
 		if (sd_media_not_present(sdkp, SRpnt))
 			return;
=20
-		/* Look for non-removable devices that return NOT_READY.
+		/* Look for devices that return NOT_READY.
 		 * Issue command to spin up drive for these cases. */
-		if (the_result && !sdp->removable &&
-		    SRpnt->sr_sense_buffer[2] =3D=3D NOT_READY) {
+		if (the_result && SRpnt->sr_sense_buffer[2] =3D=3D NOT_READY) {
 			unsigned long time1;
 			if (!spintime) {
 				printk(KERN_NOTICE "%s: Spinning up disk...",

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Stef, you just got beaten by a ball of DIRT.
					-- Greg
User Friendly, 12/7/1997

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xbNJIjReC7bSPZARAhWvAJ0QxNrk5usDmohU2cIe3Du2QTf0GgCg04ZC
/QebadbxkAvsmXBP6hxwq8Q=
=eDhm
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
