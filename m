From: Kurt Garloff <garloff@suse.de>
Subject: PATCH 2/5: scsi-scan-blist_replun
Date: Wed, 21 Apr 2004 16:12:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421141234.GT28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cjNiBkmi8s9yAE0W"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:21167 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262909AbUDUOO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:14:27 -0400
Content-Disposition: inline
In-Reply-To: <20040421134511.GP28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--cjNiBkmi8s9yAE0W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Cleanup/Feature

Remove CONFIG_SCSI_REPORT_LUNS config option.
Instead provide BLIST_NOREPORTLUN that can be passed as default_dev_flags
(but also per device if needed).
Provide BLIST_REPORTLUN2 that allows trying to use REPORT_LUNS for SCSI-2
devices, if they are connected to a host adapter supporting more than 8 LUNs
(and thus avoiding the usual USB crap to render this feature useless when
used with default_dev_flags).

diff -uNrp linux-2.6.5.depr-forcelun/drivers/scsi/Kconfig linux-2.6.5.replu=
n/drivers/scsi/Kconfig
--- linux-2.6.5.depr-forcelun/drivers/scsi/Kconfig	2004-04-21 14:23:23.0000=
00000 +0200
+++ linux-2.6.5.replun/drivers/scsi/Kconfig	2004-04-21 14:16:15.000000000 +=
0200
@@ -170,17 +170,6 @@ config SCSI_MULTI_LUN
 	  so most people can say N here. The max_luns boot/module parameter=20
 	  allows to override this setting.
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
diff -uNrp linux-2.6.5.depr-forcelun/drivers/scsi/scsi_scan.c linux-2.6.5.r=
eplun/drivers/scsi/scsi_scan.c
--- linux-2.6.5.depr-forcelun/drivers/scsi/scsi_scan.c	2004-04-20 21:54:37.=
000000000 +0200
+++ linux-2.6.5.replun/drivers/scsi/scsi_scan.c	2004-04-21 14:26:31.0000000=
00 +0200
@@ -80,7 +80,6 @@ module_param_named(max_luns, max_scsi_lu
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
=20
-#ifdef CONFIG_SCSI_REPORT_LUNS
 /*
  * max_scsi_report_luns: the maximum number of LUNS that will be
  * returned from the REPORT LUNS command. 8 times this value must
@@ -88,13 +87,12 @@ MODULE_PARM_DESC(max_luns,
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
=20
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
@@ -860,7 +858,6 @@ static void scsi_sequential_lun_scan(str
 			return;
 }
=20
-#ifdef CONFIG_SCSI_REPORT_LUNS
 /**
  * scsilun_to_int: convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
@@ -921,9 +918,14 @@ static int scsi_report_lun_scan(struct s
 	u8 *data;
=20
 	/*
-	 * Only support SCSI-3 and up devices.
-	 */
-	if (sdev->scsi_level < SCSI_3)
+	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
+	 * Also allow SCSI-2 if BLIST_REPORTLUN2 is set and host adapter does
+	 * support more than 8 LUNs.
+	 */
+	if ((bflags & BLIST_NOREPORTLUN) ||=20
+	     sdev->scsi_level < SCSI_2 ||
+	    (sdev->scsi_level < SCSI_3 &&=20
+	     (!(bflags & BLIST_REPORTLUN2) || sdev->host->max_lun <=3D 8)) )
 		return 1;
 	if (bflags & BLIST_NOLUN)
 		return 0;
@@ -1087,9 +1089,6 @@ static int scsi_report_lun_scan(struct s
 	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	return 0;
 }
-#else
-# define scsi_report_lun_scan(sdev, blags, rescan)	(1)
-#endif	/* CONFIG_SCSI_REPORT_LUNS */
=20
 struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
 				    uint channel, uint id, uint lun)
diff -uNrp linux-2.6.5.depr-forcelun/include/scsi/scsi_devinfo.h linux-2.6.=
5.replun/include/scsi/scsi_devinfo.h
--- linux-2.6.5.depr-forcelun/include/scsi/scsi_devinfo.h	2004-04-21 14:24:=
40.000000000 +0200
+++ linux-2.6.5.replun/include/scsi/scsi_devinfo.h	2004-04-21 14:25:37.0000=
00000 +0200
@@ -20,4 +20,7 @@
 #define BLIST_MS_SKIP_PAGE_08	0x2000	/* do not send ms page 0x08 */
 #define BLIST_MS_SKIP_PAGE_3F	0x4000	/* do not send ms page 0x3f */
 #define BLIST_USE_10_BYTE_MS	0x8000	/* use 10 byte ms before 6 byte ms */
+#define BLIST_NOREPORTLUN	0x10000	/* don't try REPORT_LUNS scan (SCSI-3 de=
vs) */
+#define BLIST_REPORTLUN2	0x20000	/* try REPORT_LUNS even for SCSI-2 devs
+					   (if HBA supports more than 8 LUNs) */
 #endif
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--cjNiBkmi8s9yAE0W
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhoFSxmLh6hyYd04RAh/+AJ9q0E2K2AFNNDiL84CvBvj/1zCspACfV2HS
YxnlwEjUG6WnnIojzbrrPTw=
=auwr
-----END PGP SIGNATURE-----

--cjNiBkmi8s9yAE0W--
