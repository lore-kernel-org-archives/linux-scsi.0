From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] 1/6: scsi_largelun and scsi_sparselun
Date: Sun, 18 Apr 2004 20:58:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418185820.GD4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:32933 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263645AbUDRTAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Feature.

Three new kernel/module parameters that affect SCSI scanning, all relevant
for SCSI-2 only, as for SCSI-3, REPORT_LUNS is normally used:
* scsi_sparselun allows the user to disable the Linux scanning optimization
  that assumes that LUNs are consecutive. Equivalent to setting BLIST_SPARS=
ELUN
  blacklist entry for all devices.
* scsi_largelun alloes the user to disable the check to need SCSI-3 to allow
  LUNs >=3D 8. Equivalent to a global BLIST_LARGELUN.
* max_scsi_sparseluns: Allows to set a different limit for targets with=20
  sparse LUN numbering.

--- linux-2.6.5/drivers/scsi/scsi_scan.c.orig	2004-04-04 05:37:41.000000000=
 +0200
+++ linux-2.6.5/drivers/scsi/scsi_scan.c	2004-04-15 21:47:12.859160471 +0200
@@ -80,6 +80,21 @@ module_param_named(max_luns, max_scsi_lu
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
=20
+static int scsi_sparselun;
+module_param_named(scsi_sparselun, scsi_sparselun, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scsi_sparselun,
+		 "Assume sparse LUNs for all SCSI devices");
+
+static int scsi_largelun;
+module_param_named(scsi_largelun, scsi_largelun, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scsi_largelun,
+		 "Assume all SCSI-2 devs support more than 8 LUNs");
+
+static unsigned int max_scsi_sparseluns;
+module_param_named(max_scsi_sparseluns, max_scsi_sparseluns, int, S_IRUGO|=
S_IWUSR);
+MODULE_PARM_DESC(max_scsi_sparseluns,
+		 "Limit LUNs for scanning sparse LUN devices");
+
 #ifdef CONFIG_SCSI_REPORT_LUNS
 /*
  * max_scsi_report_luns: the maximum number of LUNS that will be
@@ -800,8 +815,9 @@ static void scsi_sequential_lun_scan(str
 	 * override the other settings, and scan all of them. Normally,
 	 * SCSI-3 devices should be scanned via the REPORT LUNS.
 	 */
-	if (bflags & BLIST_SPARSELUN) {
-		max_dev_lun =3D shost->max_lun;
+	if (bflags & BLIST_SPARSELUN || scsi_sparselun) {
+		max_dev_lun =3D min(shost->max_lun, max_scsi_sparseluns?=20
+				  max_scsi_sparseluns: max_scsi_luns);
 		sparse_lun =3D 1;
 	} else
 		sparse_lun =3D 0;
@@ -845,7 +861,7 @@ static void scsi_sequential_lun_scan(str
 	 * Do not scan SCSI-2 or lower device past LUN 7, unless
 	 * BLIST_LARGELUN.
 	 */
-	if (scsi_level < SCSI_3 && !(bflags & BLIST_LARGELUN))
+	if (scsi_level < SCSI_3 && !(bflags & BLIST_LARGELUN) && !scsi_largelun)
 		max_dev_lun =3D min(8U, max_dev_lun);
=20
 	/*
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgs/MxmLh6hyYd04RAkgQAJ9eylbfS+2J11EQ39izhAm30d8G4gCfW6Q0
i2F2B1Iv2NrhiOj06Mx8/e0=
=2qWP
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
