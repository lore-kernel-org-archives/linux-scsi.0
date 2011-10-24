From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: [PATCH v2/RESEND] mv_sas: OCZ RevoDrive3 & zDrive R4 support
Date: Mon, 24 Oct 2011 22:30:08 +0000
Message-ID: <20111024223008.GB3305@orbis-terrarum.net>
References: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/GPgYEyhnw15BExa"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318032026-21913-1-git-send-email-robbat2@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: "Robin H. Johnson" <robbat2@gentoo.org>
List-Id: linux-scsi@vger.kernel.org


--/GPgYEyhnw15BExa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

In the OCZ RevoDrive3/zDrive R4 series, the "OCZ SuperScale Storage
Controller" with "Virtualized Controller Architecture 2.0" really seems
to be a Marvell 88SE9485 part, with OCZ firmware/BIOS.

Developed and tested on OCZ RevoDrive3 120GB [PCI 1b85:1021]

Should work on:
- OCZ RevoDrive3 (2x SandForce 2281)
- OCZ RevoDrive3 X2 (4x SandForce 2281)
- OCZ zDrive R4 CM84 (4x SandForce 2281)
- OCZ zDrive R4 CM88 (8x SandForce 2281)
- OCZ zDrive R4 RM84 (4x SandForce 2582)
- OCZ zDrive R4 RM88 (8x SandForce 2582)

All of this because a friend recently bought a OCZ RevoDrive3 and was
bitten by the lack of Linux support.

Notes from testing:
-------------------
- SMART works.
- VPD Device Identification is "OCZ-REVODRIVE3"
- Thin provisioning/TRIM seems to be implemented as WRITE SAME UNMAP,
  with deterministic (non-zero) read after TRIM, but I'm not sure if it
  works 100% in my testing.
- Some of the tuning in the firmware seems to ensure much better
  performance when in a RAID0 setup than using the two devices
  seperately.

I have not tested booting from the SSD, because all of this was
developed and tested remotely from the actual hardware.

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Thanks-To: Gordon Pritchard <gordp@sfu.ca>
---
 drivers/scsi/mvsas/mv_init.c |   10 ++++++++++
 include/linux/pci_ids.h      |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

Resending for the v3.2 merge window.

I tested it with more than 5TiB of IO, no stability problems detected.

Some fio performance numbers:
http://paste.pocoo.org/show/489716/
 =20
dmesg/hdparm/smartctl:
http://www.ocztechnologyforum.com/forum/showthread.php?95151-Linux-patch-su=
pport-for-RevoDrive3-RevoDrive3-X2-zDrive-R4&p=3D686054&viewfull=3D1#post68=
6054

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e9af66..b88315a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -723,6 +723,16 @@ static struct pci_device_id __devinitdata mvs_pci_tabl=
e[] =3D {
 		.class_mask	=3D 0,
 		.driver_data	=3D chip_9485,
 	},
+	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
+	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1041), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1042), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1043), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1044), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1080), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1083), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1084), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
=20
 	{ }	/* terminate list */
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae96bbe..3fe46e9 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2868,3 +2868,5 @@
=20
 #define PCI_VENDOR_ID_XEN		0x5853
 #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
+
+#define PCI_VENDOR_ID_OCZ		0x1b85
--=20
1.7.7


--/GPgYEyhnw15BExa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAk6l5vAACgkQPpIsIjIzwizbkwCeK5PZ+Oae8/EUVnayf5pyB14d
pacAoLOtUrHUeIhDnnOstyp2MCnIatj4
=6zqG
-----END PGP SIGNATURE-----

--/GPgYEyhnw15BExa--
