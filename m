From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH 1/3] Continue after PQ3 on LUN0
Date: Mon, 1 May 2006 02:48:00 +0200
Message-ID: <20060501004800.GD8728@tpkurt.garloff.de>
References: <20060501004457.GC8728@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40349 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751239AbWEAAsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 20:48:02 -0400
Content-Disposition: inline
In-Reply-To: <20060501004457.GC8728@tpkurt.garloff.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Tolerate PQ 3 at LUN 0 for scanning

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
most probably we even need BLIST_SPARSELUN (and BLIST_LARGELUN). See the ne=
xt
patch for an example.

This is patch 1/3:
If we end up in sequential scan, at least try LUN 1 for devices
that reported a PQ of 3 for LUN 0.
Also return blacklist flags, even for PQ3 devices.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -uNrp linux-2.6-hg/drivers/scsi.0/scsi_scan.c linux-2.6-hg/drivers/scs=
i/scsi_scan.c
--- linux-2.6-hg/drivers/scsi.0/scsi_scan.c	2006-04-19 08:55:03.000000000 +=
0200
+++ linux-2.6-hg/drivers/scsi/scsi_scan.c	2006-04-24 07:37:39.000000000 +02=
00
@@ -880,6 +880,8 @@ static int scsi_probe_and_add_lun(struct
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
=20
+	if (bflagsp)
+		*bflagsp =3D bflags;
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
@@ -920,8 +922,6 @@ static int scsi_probe_and_add_lun(struct
 			sdev->lockable =3D 0;
 			scsi_unlock_floptical(sdev, result);
 		}
-		if (bflagsp)
-			*bflagsp =3D bflags;
 	}
=20
  out_free_result:
@@ -946,7 +946,6 @@ static int scsi_probe_and_add_lun(struct
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
  * @starget:	pointer to target structure to scan
  * @bflags:	black/white list flag for LUN 0
- * @lun0_res:	result of scanning LUN 0
  *
  * Description:
  *     Generally, scan from LUN 1 (LUN 0 is assumed to already have been
@@ -956,8 +955,7 @@ static int scsi_probe_and_add_lun(struct
  *     Modifies sdevscan->lun.
  **/
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
-				     int bflags, int lun0_res, int scsi_level,
-				     int rescan)
+				     int bflags, int scsi_level, int rescan)
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
 	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
@@ -978,13 +976,6 @@ static void scsi_sequential_lun_scan(str
 		sparse_lun =3D 0;
=20
 	/*
-	 * If not sparse lun and no device attached at LUN 0 do not scan
-	 * any further.
-	 */
-	if (!sparse_lun && (lun0_res !=3D SCSI_SCAN_LUN_PRESENT))
-		return;
-
-	/*
 	 * If less than SCSI_1_CSS, and no special lun scaning, stop
 	 * scanning; this matches 2.4 behaviour, but could just be a bug
 	 * (to continue scanning a SCSI_1_CSS device).
@@ -1395,7 +1386,7 @@ static void __scsi_scan_target(struct de
 			 * do a sequential scan.
 			 */
 			scsi_sequential_lun_scan(starget, bflags,
-				       	res, starget->scsi_level, rescan);
+						 starget->scsi_level, rescan);
 	}
=20
  out_reap:
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEVVrAxmLh6hyYd04RAiD+AKCU+x7YJu1+65E5BlNEwONlI7p7vQCfQsE4
hsgVmQi5bjfq6GTFHIwk+w0=
=aImB
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
