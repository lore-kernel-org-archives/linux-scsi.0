From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RESEND] mvsas: Recognise device/subsystem 9485/9485 as
 88SE9485
Date: Wed, 11 Dec 2013 15:02:09 +0000
Message-ID: <1386774129.12186.82.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SRdLUglDE8VQpRs4b4zf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60282 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab3LKPCa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Dec 2013 10:02:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matt Taggart <taggart@debian.org>, Debian kernel maintainers <debian-kernel@lists.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>


--=-SRdLUglDE8VQpRs4b4zf
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

--=-SRdLUglDE8VQpRs4b4zf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUqh+cee/yOyVhhEJAQrC8hAAleYogQ6LUA+Slwu6ghWaHgocVhtNp9uw
xYz5srT+kvpvwX31XAdab4iBb3XzNF18XnU+R05GQS0dkPY/24iayyJ/MTG97MKw
u1zf/AyRdkmTOVlFD7b0THtAHvhIqk0fQdGZuSUQuRLuZOk0fyHa4pbgTjuWyxRo
+2unC9RVdbL+qvlg/GXaptTRH8EhVb46MxWuTV4v0gAqG51iuUeTIefpQHIJDhKu
WbULqGfbb8RcD0hWMKgvJIx0y2slSI2DZ0lDQvq5JWolB/r1NzjO2oxmhbDg5wx/
2QBI6Hvy1gAyyO77BLp7NXfsLsK28dgM8/4vHkDZtoMLgPmQSgSUbA8N0JmMbWiH
GCmdlxlZIZ38F2cm8qYBU1FOn31hEdF7reQCxpFYCw4oxHJTSqi0EryhfWBZ4Rio
hCzx4C8p8KBp85s3w9eoTrPjWskwNUpS7J/5L1ukkSyla06hSrtx4fecqzZjhGYh
kbGao4q5gIKtmD4pRq/a8MPm+QT8mzaXM6+LGTwDckE/S1+4h+XVixYMTw0uIHax
7uBvHXFD52UCfa9qTXwsct30947OgbXFKhgsUTsx0o1c4IBPSD75+Ozs4vtWr7oq
EjB1zgYGTgzL8F5e48MzIZuZm2ZGtL5dV9mLeGDUT5msgHu3M6KXvU2ahdXIhqWp
wgIob9cbAlg=
=4chK
-----END PGP SIGNATURE-----

--=-SRdLUglDE8VQpRs4b4zf--
