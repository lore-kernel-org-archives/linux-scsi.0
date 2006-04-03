From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH 3/3] BLIST_ATTACH_PQ3 flags
Date: Mon, 3 Apr 2006 15:20:08 +0200
Message-ID: <20060403132008.GZ26303@tpkurt.garloff.de>
References: <20060329201020.GG7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nT6ukc3bqTvTgwkF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:60038 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750722AbWDCNUL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 09:20:11 -0400
Content-Disposition: inline
In-Reply-To: <20060329201020.GG7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>


--nT6ukc3bqTvTgwkF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

rediff, just for completeness. (Unchanged from old patch that still
applies with minimal offset.)


=46rom: Kurt Garloff <garloff@suse.de>
Subject: Tolerate PQ 3 at LUN 0 for scanning
Patch-mainline:=20
References: 158532

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
most probably we even need BLIST_SPARSELUN (and BLIST_LARGELUN). See the bug
reference for an infamous example.

This is patch 3/3:
3. Implement the blacklist flag BLIST_ATTACH_PQ3 that makes the scsi
   scanning code register PQ3 devices and continues scanning; only sg
   will attach thanks to scsi_bus_match().

Acked-by:=20
Signed-off-by: Kurt Garloff <garloff@suse.de>

Index: linux-2.6.16/drivers/scsi/scsi_scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.16.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.16/drivers/scsi/scsi_scan.c
@@ -887,9 +887,9 @@ static int scsi_probe_and_add_lun(struct
 		*bflagsp =3D bflags;
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if ((result[0] >> 5) =3D=3D 3) {
+	if (((result[0] >> 5) =3D=3D 3) && !(bflags & BLIST_ATTACH_PQ3)) {
 		/*
 		 * For a Peripheral qualifier 3 (011b), the SCSI
 		 * spec says: The device server is not capable of
 		 * supporting a physical device on this logical
Index: linux-2.6.16/drivers/scsi/scsi_devinfo.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.16.orig/drivers/scsi/scsi_devinfo.c
+++ linux-2.6.16/drivers/scsi/scsi_devinfo.c
@@ -154,8 +154,10 @@ static struct {
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
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
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
Index: linux-2.6.16/include/scsi/scsi_devinfo.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.16.orig/include/scsi/scsi_devinfo.h
+++ linux-2.6.16/include/scsi/scsi_devinfo.h
@@ -27,5 +27,6 @@
 #define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
 #define BLIST_NO_ULD_ATTACH	0x100000 /* device is actually for RAID config=
 */
 #define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
+#define BLIST_ATTACH_PQ3	0x800000 /* Scan: Attach to PQ3 devices */
 #endif
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--nT6ukc3bqTvTgwkF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEMSEIxmLh6hyYd04RAttlAKCe0qyJpcT9iRogg1sWylz7WSfHbACfTLAp
8Tn5dWrSH9ATbfRXId/b0EA=
=7Hjg
-----END PGP SIGNATURE-----

--nT6ukc3bqTvTgwkF--
