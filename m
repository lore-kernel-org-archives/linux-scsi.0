From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RESEND 2] mvsas: Recognise device/subsystem 9485/9485 as
 88SE9485
Date: Wed, 19 Feb 2014 01:06:42 +0000
Message-ID: <1392772002.10088.50.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PFPMUmJIS/th3y4M3BES"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44475 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbaBSBG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Feb 2014 20:06:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matt Taggart <taggart@debian.org>, Debian kernel maintainers <debian-kernel@lists.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>


--=-PFPMUmJIS/th3y4M3BES
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Matt Taggart reported that mvsas didn't bind to the Marvell
SAS controller on a Supermicro AOC-SAS2LP-MV8 board.

lspci reports it as:

01:00.0 RAID bus controller [0104]: Marvell Technology Group Ltd. Device [1=
b4b:9485] (rev 03)
        Subsystem: Marvell Technology Group Ltd. Device [1b4b:9485]
[...]

Add it to the device table as chip_9485.

Reported-by: Matt Taggart <taggart@debian.org>
Tested-by: Matt Taggart <taggart@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mvsas/mv_init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 7b7381d..83fa5f8 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -729,6 +729,15 @@ static struct pci_device_id mvs_pci_table[] =3D {
 		.class_mask	=3D 0,
 		.driver_data	=3D chip_9485,
 	},
+	{
+		.vendor		=3D PCI_VENDOR_ID_MARVELL_EXT,
+		.device		=3D 0x9485,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D 0x9485,
+		.class		=3D 0,
+		.class_mask	=3D 0,
+		.driver_data	=3D chip_9485,
+	},
 	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
 	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */
 	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact=
 model unknown) */


--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-PFPMUmJIS/th3y4M3BES
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUwQDoue/yOyVhhEJAQqJ8Q//fpOXndV3YJfWEsMDaGwZ4UpkRowCQY04
5d55lRykfAqp2q7IB0KJbXjfbTaBepXcjHchGnJCRMkvEpjO7/+w0TBaOPb/blZt
HXc8Lma2OMU/3RGnjZKumSM58pVLuLYre9QB+Ez0QG1j+eqnvXX7kfS9co7H2ct2
tPs8ix8ZkJ0CQmhD6RFZ3NKyA6EWMslSYQmlw3ipRpRS9Np3jax71VSnI1CU7sBj
dbIp6Km6mB/7BEU6vl+pyIWmUDydWISDEzmQGgvjPLknL6fIls9TjUhmrCK2GAoZ
yBkZ1u2w8HS+FdXhf5ry5pOmdIeGev7W/hW7WWgTnTcuW8J2QBT4ZmPSqLl/xx0u
+oQO9XCiGrnhoa7QLDeaMTgKlXTzeluZpzf2Q+Ldotl1GMvnWZeS8jkxjdfNNTbc
zwxiZf7x/Ntgp1xQVyCbwqiQIpm6BahLyjfLMkzR0XPp7XgMejy2Cz0hDWdWMcND
dsW7suHAGgPtp61BxpHs0qxl/iCw199EgM/5xgMTGA+gawGsTe3BCdEdFEkFEc6G
AIUs4iT43j8cbkjFQeDgAw9NhvXQSFiMZiq511UQuRoktRYmzO7BCYkYH5kVSPHr
wAvNEbYxRogiMa7y/WwDr0WBiGPHruwp3gGN1PpweEW65N5UafKiYkNriQ7WSkZX
aumU3IyJtXU=
=ELz9
-----END PGP SIGNATURE-----

--=-PFPMUmJIS/th3y4M3BES--
