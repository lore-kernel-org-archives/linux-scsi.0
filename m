From: Robert Annessi <robert@annessi.at>
Subject: Re: dc395x: Report
Date: Mon, 14 Aug 2006 17:01:50 +0200
Message-ID: <44E0905E.1000003@annessi.at>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange> <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange> <44D0BC2F.3030700@annessi.at> <Pine.LNX.4.60.0608022348570.12263@poirot.grange> <44D13418.2000005@annessi.at> <Pine.LNX.4.60.0608092315060.3728@poirot.grange> <44DF70D4.7030504@annessi.at> <Pine.LNX.4.60.0608132129120.3508@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7226766C11380C6C916A5B5B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-01.sil.at ([86.59.12.198]:22983 "EHLO mx-01.sil.at")
	by vger.kernel.org with ESMTP id S1750926AbWHNPCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 11:02:14 -0400
In-Reply-To: <Pine.LNX.4.60.0608132129120.3508@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7226766C11380C6C916A5B5B
Content-Type: multipart/mixed;
 boundary="------------090609050602070905030505"

This is a multi-part message in MIME format.
--------------090609050602070905030505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/13/06 21:47, Guennadi Liakhovetski wrote:
> Emn, sorry, I have to ask - are you sure this is the correct output=20
> (applied the patch, recompiled and reloaded the driver)? The output loo=
ks=20
> EXACTLY the same as last time, and this is pretty strange. Well, there =
is=20

Yes, I'm sure I applied the patch and used that kernel (freshly built,
no modules used).


> still one semi-logical explanation I can come up with:
>=20
> at first FIFOCNT =3D 1 and SCSICNT =3D 0xfffffe, therefore d_left_count=
er =3D=20
> 0xfffffe + (1 << 1) =3D 0x1000000. Then after one loop iteration=20
> d_left_counter =3D 0xffffff, and now FIFOCNT =3D 0x40. So we break out =
of the=20
> loop with the above funny value of d_left_counter. If this is the case,=
=20
> well, I don't know what this value of SCSICNT means and what to do with=
=20
> it (in the absence of a datasheet).
>=20
> To verify this could you, please, replace the printk at line 2335 with =

> this one:
>=20
> 					printk(KERN_WARNING "dc395x: inconsistent counters: "
> 					       "FIFOCNT %u, SCSICNT %u, left %u, %s\n", fc, sc, d_left_cou=
nter,
> 					       srb->dcb->sync_period & WIDE_SYNC ?
> 					       "wide" : "narrow");



Here is the relevant output of dmesg with 2.6.18-rc4 (and your patches):

dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:02.0
dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MHz), dev_mode=3D0x3=
7
dc395x:                AdaptMode=3D0x4e, Tags=3D0(01), DelayReset=3D1s
dc395x: (Wide) Connectors: int68  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
  Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
dc395x: inconsistent counters: FIFOCNT 64, SCSICNT 16777214, left
16777215, wide
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
dc395x: inconsistent counters: FIFOCNT 64, SCSICNT 16777214, left
16777215, wide
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
dc395x: inconsistent counters: FIFOCNT 64, SCSICNT 16777214, left
16777215, wide
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
dc395x: inconsistent counters: FIFOCNT 64, SCSICNT 16777214, left
16777215, wide
SCSI device sda: drive cache: write back w/ FUA
 sda: unknown partition table
sd 0:0:0:0: Attached scsi disk sda


Just to make sure I attached the patch I used.

Regards,
Robert

--------------090609050602070905030505
Content-Type: text/x-patch;
 name="linux-2.6.18-rc4-dc395x.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="linux-2.6.18-rc4-dc395x.patch"

diff -urN linux-2.6.18-rc4.orig/drivers/scsi/dc395x.c linux-2.6.18-rc4-dc=
395x/drivers/scsi/dc395x.c
--- linux-2.6.18-rc4.orig/drivers/scsi/dc395x.c	2006-08-13 23:30:21.00000=
0000 +0200
+++ linux-2.6.18-rc4-dc395x/drivers/scsi/dc395x.c	2006-08-13 23:34:05.000=
000000 +0200
@@ -78,7 +78,7 @@
  * Set to disable parts of the driver
  */
 /*#define DC395x_NO_DISCONNECT*/
-/*#define DC395x_NO_TAGQ*/
+#define DC395x_NO_TAGQ
 /*#define DC395x_NO_SYNC*/
 /*#define DC395x_NO_WIDE*/
=20
@@ -2123,7 +2123,7 @@
 		 */
 		if (srb->total_xfer_length > DC395x_LASTPIO)
 			d_left_counter +=3D
-			    DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
+			    DC395x_read32(acb, TRM_S1040_SCSI_COUNTER) & ((1 << 24) - 1);
=20
 		/* Is this a good idea? */
 		/*clear_fifo(acb, "DOP1"); */
@@ -2253,7 +2253,7 @@
 				DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT));
 		}
 		/* Now: Check remainig data: The SCSI counters should tell us ... */
-		sc =3D DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
+		sc =3D DC395x_read32(acb, TRM_S1040_SCSI_COUNTER) & ((1 << 24) - 1);
 		fc =3D DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
 		d_left_counter =3D sc + ((fc & 0x1f)
 		       << ((srb->dcb->sync_period & WIDE_SYNC) ? 1 :
@@ -2307,6 +2307,14 @@
=20
 				while (len) {
 					u8 byte;
+
+					fc =3D DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
+
+					if (fc =3D=3D 0x40) {
+						left_io =3D 0;
+						break;
+					}
+
 					byte =3D DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 					*virt++ =3D byte;
=20
@@ -2317,16 +2325,16 @@
 					sg_subtract_one(srb);
=20
 					len--;
-
-					fc =3D DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
-
-					if (fc =3D=3D 0x40) {
-						left_io =3D 0;
-						break;
-					}
 				}
=20
-				WARN_ON((fc !=3D 0x40) =3D=3D !d_left_counter);
+				if (((fc !=3D 0x40) && !d_left_counter) ||
+				    ((fc =3D=3D 0x40) && d_left_counter &&
+				     (!(srb->dcb->sync_period & WIDE_SYNC)
+				      || d_left_counter !=3D 1)))
+					printk(KERN_WARNING "dc395x: inconsistent counters: "
+					       "FIFOCNT %u, SCSICNT %u, left %u, %s\n", fc, sc, d_left_coun=
ter,
+					       srb->dcb->sync_period & WIDE_SYNC ?
+					       "wide" : "narrow");
=20
 				if (fc =3D=3D 0x40 && (srb->dcb->sync_period & WIDE_SYNC)) {
 					/* Read the last byte ... */

--------------090609050602070905030505--

--------------enig7226766C11380C6C916A5B5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iEYEARECAAYFAkTgkGMACgkQVoNfMxmfyFO+MgCfdqW7ryaNUtaCslM96MQBwmo8
jeQAn2I7aP+i0fjI+8NIILK185FIezJa
=2W/g
-----END PGP SIGNATURE-----

--------------enig7226766C11380C6C916A5B5B--
