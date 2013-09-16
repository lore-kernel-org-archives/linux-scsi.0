From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] mvsas: Recognise device/subsystem 9485/9485 as 88SE9485
Date: Mon, 16 Sep 2013 03:35:57 +0100
Message-ID: <1379298957.23881.10.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KLL0rNBGSVSA1xbbbnXr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56206 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755568Ab3IPCgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Sep 2013 22:36:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matt Taggart <taggart@debian.org>, Debian kernel maintainers <debian-kernel@lists.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>


--=-KLL0rNBGSVSA1xbbbnXr
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


--=-KLL0rNBGSVSA1xbbbnXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUjZujee/yOyVhhEJAQptdw/+MOxAEKN7RcyGh5MmdQVHk6mTM6J15Zey
4ZosW8flwCtLjw8mYY0z+Le0armZR+3DmIqOJ8jAFvHuIsyRokNk1YQ3UUnEw2Xv
WT/flz+Lz9Eax/0NuK9GDMEg+DcjNaQScinS0Q0tFGQL3HT1cq59slRtUTKFOX1i
aOWtl/ylPeE3FkhH55rSElqZkPt8Sa64NcI0fKjOmkhE90vz92pwFh0ZaPiP7KhF
jJYWGMdpxO7ihGMu7UYTLNJKcbIyFDYfinyKmuzWla8b8go/t18mRdBWDWKBFXqw
lr/8pItyww6OD0XT0v2I/DlteqqQbS2kyf35xnQ2leq2LNJmtslaXPocR7q/PS0R
qhXSpsjxiu/7o95kzLMWP/3sVBQzIu2uuSpsG5abrDi6VNhDbyP6QtpydjtAozT+
g7ISlFrT+uUTQD7dLGLaB1d/3MpTEOTSDIk4nPMetZUdETMZHp42/fo6+YCvLwKB
ND/qyR22NfWKkPyJMtE3bfKT8Wbgk8hYyfmxecEj8cfEmRtxCFIQ1gQQXIvvJKqK
4wk7meiArJeKmL4LEr9scDw3tqE62rlXd1YjjoYsKDiTiY1+yJw9ugKgezQRk38s
/BIfuw+P+yl/fEAKCxAnpI66Ihsfk6eaeCKV8hJzFEPwTXQjl35HO+1taK4Nwjy1
JZL1H/2ULzo=
=1XcI
-----END PGP SIGNATURE-----

--=-KLL0rNBGSVSA1xbbbnXr--
