From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH 2/3] BLIST_ATTACH_PQ3 flag
Date: Mon, 1 May 2006 02:49:09 +0200
Message-ID: <20060501004909.GE8728@tpkurt.garloff.de>
References: <20060501004457.GC8728@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:7315 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751243AbWEAAtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 20:49:11 -0400
Content-Disposition: inline
In-Reply-To: <20060501004457.GC8728@tpkurt.garloff.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


=46rom: Kurt Garloff <garloff@suse.de>
Subject: Introduce BLIST_ATTACH_PQ3 flag

Some devices report a peripheral qualifier of 3 for LUN 0; with the original
code, we would still try a REPORT_LUNS scan (if SCSI level is >=3D 3 or if =
we=20
have the BLIST_REPORTLUNS2 passed in), but NOT any sequential scan.
Also, the device at LUN 0 (which is not connected according to the PQ) is n=
ot
registered with the OS.

Unfortunately, SANs exist that are SCSI-2 and do NOT support REPORT_LUNS, b=
ut
report a unknown device with PQ 3 on LUN 0. We still need to scan them, and
most probably we even need BLIST_SPARSELUN (and BLIST_LARGELUN). See the
referenced device for an example.

This is patch 2/3:
Implement the blacklist flag BLIST_ATTACH_PQ3 that makes the scsi
 scanning code register PQ3 devices and continues scanning; only sg
 will attach thanks to scsi_bus_match().

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -uNrp linux-2.6-hg/include/scsi.1/scsi_devinfo.h linux-2.6-hg/include/=
scsi/scsi_devinfo.h
--- linux-2.6-hg/include/scsi.1/scsi_devinfo.h	2006-04-19 08:55:05.00000000=
0 +0200
+++ linux-2.6-hg/include/scsi/scsi_devinfo.h	2006-04-24 07:40:43.000000000 =
+0200
@@ -29,4 +29,5 @@
 #define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
+#define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #endif
diff -uNrp linux-2.6-hg/drivers/scsi.1/scsi_devinfo.c linux-2.6-hg/drivers/=
scsi/scsi_devinfo.c
--- linux-2.6-hg/drivers/scsi.1/scsi_devinfo.c	2006-04-19 08:55:03.00000000=
0 +0200
+++ linux-2.6-hg/drivers/scsi/scsi_devinfo.c	2006-04-24 07:40:03.000000000 =
+0200
@@ -157,6 +157,8 @@ static struct {
 	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | B=
LIST_LARGELUN},
+	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LAR=
GELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
 	{"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
diff -uNrp linux-2.6-hg/drivers/scsi.1/scsi_scan.c linux-2.6-hg/drivers/scs=
i/scsi_scan.c
--- linux-2.6-hg/drivers/scsi.1/scsi_scan.c	2006-04-24 07:37:39.000000000 +=
0200
+++ linux-2.6-hg/drivers/scsi/scsi_scan.c	2006-04-24 07:40:03.000000000 +02=
00
@@ -885,7 +885,7 @@ static int scsi_probe_and_add_lun(struct
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if ((result[0] >> 5) =3D=3D 3) {
+	if (((result[0] >> 5) =3D=3D 3) && !(bflags & BLIST_ATTACH_PQ3)) {
 		/*
 		 * For a Peripheral qualifier 3 (011b), the SCSI
 		 * spec says: The device server is not capable of
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEVVsExmLh6hyYd04RAvqMAJ9kVmyhEWcxI2YK9XRClbSDU3NRnQCeJ5te
c6YXc6b3PDW4zq6ExEC8QYI=
=AYty
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
