From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] 2/6: scsi_noreportlun and scsi_reportlun2
Date: Sun, 18 Apr 2004 20:58:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418185836.GE4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:37541 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263762AbUDRTAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Feature.

Remove CONFIG_SCSI_REPORT_LUNS config option.
Instead provide two boot/module parameters that affect SCSI scanning:

* scsi_noreportlun:
  Allows the user to disable the use of REPORT_LUNS during SCSI scanning.
* scsi_reportlun2:
  Tell the kernel to try REPORT_LUNS for scanning also for SCSI-2 devices,
  if the host adapter supports more than 8 LUNs.

 Kconfig     |   11 -----------
 scsi_scan.c |   29 ++++++++++++++++++++---------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -uNrp linux-2.6.5/drivers/scsi/Kconfig linux-2.6.5.replun2/drivers/scs=
i/Kconfig
--- linux-2.6.5/drivers/scsi/Kconfig	2004-04-14 20:20:19.000000000 +0200
+++ linux-2.6.5.replun2/drivers/scsi/Kconfig	2004-04-15 21:54:17.000000000 =
+0200
@@ -170,17 +170,6 @@ config SCSI_MULTI_LUN
 	  so most people can say N here and should in fact do so, because it
 	  is safer.
=20
-config SCSI_REPORT_LUNS
-	bool "Build with SCSI REPORT LUNS support"
-	depends on SCSI
-	default y
-	help
-	  If you want support for SCSI REPORT LUNS, say Y here.
-	  The REPORT LUNS command is useful for devices (such as disk arrays)
-	  with large numbers of LUNs where the LUN values are not contiguous
-	  (sparse LUN).  REPORT LUNS scanning is done only for SCSI-3 devices.
-	  Most users can safely answer N here.
-
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=3D12K)"
 	depends on SCSI
diff -uNrp linux-2.6.5/drivers/scsi/scsi_scan.c linux-2.6.5.replun2/drivers=
/scsi/scsi_scan.c
--- linux-2.6.5/drivers/scsi/scsi_scan.c	2004-04-15 21:47:12.000000000 +0200
+++ linux-2.6.5.replun2/drivers/scsi/scsi_scan.c	2004-04-15 22:33:51.940951=
876 +0200
@@ -95,7 +95,6 @@ module_param_named(max_scsi_sparseluns,=20
 MODULE_PARM_DESC(max_scsi_sparseluns,
 		 "Limit LUNs for scanning sparse LUN devices");
=20
-#ifdef CONFIG_SCSI_REPORT_LUNS
 /*
  * max_scsi_report_luns: the maximum number of LUNS that will be
  * returned from the REPORT LUNS command. 8 times this value must
@@ -103,13 +102,23 @@ MODULE_PARM_DESC(max_scsi_sparseluns,
  * in practice, the maximum number of LUNs suppored by any device
  * is about 16k.
  */
-static unsigned int max_scsi_report_luns =3D 128;
+static unsigned int max_scsi_report_luns =3D 511;
=20
 module_param_named(max_report_luns, max_scsi_report_luns, int, S_IRUGO|S_I=
WUSR);
 MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
-#endif
+
+static int scsi_noreportlun;
+module_param_named(scsi_noreportlun, scsi_noreportlun, int, S_IRUGO|S_IWUS=
R);
+MODULE_PARM_DESC(scsi_noreportlun,
+		 "Don't use REPORT_LUNs for scanning SCSI-3 devs");
+
+static int scsi_reportlun2;
+module_param_named(scsi_reportlun2, scsi_reportlun2, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scsi_reportlun2,
+		 "Use REPORT_LUNs for scanning SCSI-2 devs as well");
+
=20
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
@@ -876,7 +885,6 @@ static void scsi_sequential_lun_scan(str
 			return;
 }
=20
-#ifdef CONFIG_SCSI_REPORT_LUNS
 /**
  * scsilun_to_int: convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
@@ -937,9 +945,15 @@ static int scsi_report_lun_scan(struct s
 	u8 *data;
=20
 	/*
-	 * Only support SCSI-3 and up devices.
+	 * Only support SCSI-3 devices unless scsi_noreportlun is set.
+	 * SCSI-2 is supported is scsi_reportlun2 is set and the host
+	 * adapter claims to support more than 8 LUNS (likely FC).=20
 	 */
-	if (sdev->scsi_level < SCSI_3)
+=09
+	if ( scsi_noreportlun ||
+	     sdev->scsi_level < SCSI_2 ||=20
+	    (sdev->scsi_level < SCSI_3 &&
+	     (!scsi_reportlun2 || sdev->host->max_lun <=3D 8)))
 		return 1;
 	if (bflags & BLIST_NOLUN)
 		return 0;
@@ -1103,9 +1117,6 @@ static int scsi_report_lun_scan(struct s
 	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	return 0;
 }
-#else
-# define scsi_report_lun_scan(sdev, blags, rescan)	(1)
-#endif	/* CONFIG_SCSI_REPORT_LUNS */
=20
 struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
 				    uint channel, uint id, uint lun)
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgs/bxmLh6hyYd04RAtpkAKDBJfrRD85xWs7Qgqf2VCUaNqlNQgCgohhD
YBDPFq4kfn1aAzuy01b01GE=
=KYPL
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
