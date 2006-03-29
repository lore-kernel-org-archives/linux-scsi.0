From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH 1/3] Try LUN 1 and use bflags
Date: Wed, 29 Mar 2006 22:11:47 +0200
Message-ID: <20060329201147.GH7919@tpkurt.suse.de>
References: <20060329201020.GG7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B2qqeP0Q02yiX6Uc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:48865 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751047AbWC2ULK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 15:11:10 -0500
Content-Disposition: inline
In-Reply-To: <20060329201020.GG7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>


--B2qqeP0Q02yiX6Uc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

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
@@ -860,6 +860,8 @@ static int scsi_probe_and_add_lun(struct
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
=20
+	if (bflagsp)
+		*bflagsp =3D bflags;
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
@@ -887,8 +889,6 @@ static int scsi_probe_and_add_lun(struct
 			sdev->lockable =3D 0;
 			scsi_unlock_floptical(sdev, result);
 		}
-		if (bflagsp)
-			*bflagsp =3D bflags;
 	}
=20
  out_free_result:
@@ -945,11 +945,13 @@ static void scsi_sequential_lun_scan(str
 		sparse_lun =3D 0;
=20
 	/*
-	 * If not sparse lun and no device attached at LUN 0 do not scan
-	 * any further.
-	 */
+	 * If LUN0 did respond, but did not have an attachable LUN (PQ=3D3),
+	 * we do NOT abort the sequential scan yet, let's try one more
+	 * LUN and only abort the scan if we don't find anything there.
+	 *=20
 	if (!sparse_lun && (lun0_res !=3D SCSI_SCAN_LUN_PRESENT))
 		return;
+	 */
=20
 	/*
 	 * If less than SCSI_1_CSS, and no special lun scaning, stop
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--B2qqeP0Q02yiX6Uc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEKuoCxmLh6hyYd04RAqJuAKClImk7OBmt+xMnRPmHdMAFW0sqowCgrbpl
HIP69SzSb6FP9YSeGlGcrEE=
=CmQF
-----END PGP SIGNATURE-----

--B2qqeP0Q02yiX6Uc--
