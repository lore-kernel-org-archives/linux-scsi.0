From: Kurt Garloff <garloff@suse.de>
Subject: PATCH 1/5: scsi-scan-deprecate-forcelun
Date: Wed, 21 Apr 2004 16:10:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421141021.GS28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uw+RRa3pmtkgiNaD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:4780 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262969AbUDUOMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:12:19 -0400
Content-Disposition: inline
In-Reply-To: <20040421134511.GP28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--Uw+RRa3pmtkgiNaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Cleanup

Mark BLIST_FORCELUN as deprecated, as we don't want to collect a list
of perfectly working multi-LUN devices with BLIST_FORCELUN. Instead
document max_luns boot/module parameter.

diff -uNrp linux-2.6.5.scsi-orig/drivers/scsi/Kconfig linux-2.6.5.depr-forc=
elun/drivers/scsi/Kconfig
--- linux-2.6.5.scsi-orig/drivers/scsi/Kconfig	2004-04-21 14:17:50.00000000=
0 +0200
+++ linux-2.6.5.depr-forcelun/drivers/scsi/Kconfig	2004-04-21 14:23:23.0000=
00000 +0200
@@ -167,8 +167,8 @@ config SCSI_MULTI_LUN
 	  can say Y here to force the SCSI driver to probe for multiple LUNs.
 	  A SCSI device with multiple LUNs acts logically like multiple SCSI
 	  devices. The vast majority of SCSI devices have only one LUN, and
-	  so most people can say N here and should in fact do so, because it
-	  is safer.
+	  so most people can say N here. The max_luns boot/module parameter=20
+	  allows to override this setting.
=20
 config SCSI_REPORT_LUNS
 	bool "Build with SCSI REPORT LUNS support"
diff -uNrp linux-2.6.5.scsi-orig/include/scsi/scsi_devinfo.h linux-2.6.5.de=
pr-forcelun/include/scsi/scsi_devinfo.h
--- linux-2.6.5.scsi-orig/include/scsi/scsi_devinfo.h	2004-04-04 05:36:14.0=
00000000 +0200
+++ linux-2.6.5.depr-forcelun/include/scsi/scsi_devinfo.h	2004-04-21 14:24:=
40.000000000 +0200
@@ -4,7 +4,8 @@
  * Flags for SCSI devices that need special treatment
  */
 #define BLIST_NOLUN     	0x001	/* Only scan LUN 0 */
-#define BLIST_FORCELUN  	0x002	/* Known to have LUNs, force scanning */
+#define BLIST_FORCELUN  	0x002	/* Known to have LUNs, force scanning,
+					   deprecated: Use max_luns=3DN */
 #define BLIST_BORKEN    	0x004	/* Flag for broken handshaking */
 #define BLIST_KEY       	0x008	/* unlock by special command */
 #define BLIST_SINGLELUN 	0x010	/* Do not use LUNs in parallel */

--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--Uw+RRa3pmtkgiNaD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhoDNxmLh6hyYd04RAu55AKCFqQk4nVl9JqgNz/QZBBrJYb7MwACfawBw
Lp95zwk8O8i2MEFAu9tBI0E=
=TIS5
-----END PGP SIGNATURE-----

--Uw+RRa3pmtkgiNaD--
