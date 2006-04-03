From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH 1/3] Try LUN 1 and use bflags
Date: Mon, 3 Apr 2006 15:16:48 +0200
Message-ID: <20060403131648.GX26303@tpkurt.garloff.de>
References: <20060329201020.GG7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lh1tzOZp3jg2TtWy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:27347 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750759AbWDCNQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 09:16:55 -0400
Content-Disposition: inline
In-Reply-To: <20060329201020.GG7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>


--Lh1tzOZp3jg2TtWy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

patch redone, incorporating Pat Mansfield's suggestion to remove the
lun0_res variable, as it was unused after patching.

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

This is patch 1/3:
If we end up in sequential scan, at least try LUN 1 for devices
that reported a PQ of 3 for LUN 0.
Also return blacklist flags, even for PQ3 devices.

Acked-by:=20
Signed-off-by: Kurt Garloff <garloff@suse.de>

Index: linux-2.6.16/drivers/scsi/scsi_scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.16.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.16/drivers/scsi/scsi_scan.c
@@ -859,8 +859,10 @@ static int scsi_probe_and_add_lun(struct
=20
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
=20
+	if (bflagsp)
+		*bflagsp =3D bflags;
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
 	if ((result[0] >> 5) =3D=3D 3) {
@@ -886,10 +888,8 @@ static int scsi_probe_and_add_lun(struct
 		if (bflags & BLIST_KEY) {
 			sdev->lockable =3D 0;
 			scsi_unlock_floptical(sdev, result);
 		}
-		if (bflagsp)
-			*bflagsp =3D bflags;
 	}
=20
  out_free_result:
 	kfree(result);
@@ -912,9 +912,8 @@ static int scsi_probe_and_add_lun(struct
 /**
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
  * @starget:	pointer to target structure to scan
  * @bflags:	black/white list flag for LUN 0
- * @lun0_res:	result of scanning LUN 0
  *
  * Description:
  *     Generally, scan from LUN 1 (LUN 0 is assumed to already have been
  *     scanned) to some maximum lun until a LUN is found with no device
@@ -922,10 +921,9 @@ static int scsi_probe_and_add_lun(struct
  *
  *     Modifies sdevscan->lun.
  **/
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
-				     int bflags, int lun0_res, int scsi_level,
-				     int rescan)
+				     int bflags, int scsi_level, int rescan)
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
 	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
=20
@@ -944,15 +942,8 @@ static void scsi_sequential_lun_scan(str
 	} else
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
 	 *
@@ -1363,9 +1354,9 @@ static void __scsi_scan_target(struct de
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
 			scsi_sequential_lun_scan(starget, bflags,
-				       	res, starget->scsi_level, rescan);
+						 starget->scsi_level, rescan);
 	}
=20
  out_reap:
 	/* now determine if the target has any children at all

--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--Lh1tzOZp3jg2TtWy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEMSBAxmLh6hyYd04RAhOtAJ0XpIntUM/pyFh+9QHNYFXEDo5F2gCfR67E
B+fPBVl7Xwq7DMSQGwBtoMw=
=FM2h
-----END PGP SIGNATURE-----

--Lh1tzOZp3jg2TtWy--
