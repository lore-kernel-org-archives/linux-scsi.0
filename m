From: Matt Domsch <Matt_Domsch@dell.com>
Subject: MODULE_VERSION for scsi drivers
Date: Mon, 26 Apr 2004 23:09:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427040923.GA9901@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:17797 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S263745AbUD0ELO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 00:11:14 -0400
Received: from lists.us.dell.com (localhost.localdomain [127.0.0.1])
	by lists.us.dell.com (8.12.10/8.12.10/Dell.IT.3.31.03) with ESMTP id i3R49N8o010120
	for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2004 23:09:23 -0500
Received: (from mdomsch@localhost)
	by lists.us.dell.com (8.12.10/8.12.10/Submit) id i3R49NGZ010118
	for linux-scsi@vger.kernel.org; Mon, 26 Apr 2004 23:09:23 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Now that the MODULE_VERSION() macro is in 2.6, I'd love to see all
modules implement it.  So before I go touch all the SCSI drivers, I
thought I'd bounce this off the list.

There are a few drivers with version strings that look like this:
 #define VERSION "1.10 (23/01/2003 2.5.57)"

In the new world order, I think they need to look more like this:
 #define DRV_VERSION "2.5.57"
 #define DRV_DATE "23/01/2003"
and print both strings if it's interesting to do so, but the date
stays out of the MODULE_VERSION(DRV_VERSION).

Thoughts?  Patch below against Linus's BK-cur covers a the a* drivers,
plus a few I care specifically about.
-Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

=3D=3D=3D=3D=3D drivers/scsi/a2091.c 1.13 vs edited =3D=3D=3D=3D=3D
--- 1.13/drivers/scsi/a2091.c	Sat Sep 27 10:17:28 2003
+++ edited/drivers/scsi/a2091.c	Mon Apr 26 22:21:06 2004
@@ -258,3 +258,4 @@
 }
=20
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/a3000.c 1.12 vs edited =3D=3D=3D=3D=3D
--- 1.12/drivers/scsi/a3000.c	Thu Sep 25 18:33:56 2003
+++ edited/drivers/scsi/a3000.c	Mon Apr 26 22:22:03 2004
@@ -243,3 +243,4 @@
 }
=20
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/advansys.c 1.38 vs edited =3D=3D=3D=3D=3D
--- 1.38/drivers/scsi/advansys.c	Tue Feb  3 23:29:29 2004
+++ edited/drivers/scsi/advansys.c	Mon Apr 26 22:23:49 2004
@@ -18570,3 +18570,4 @@
     }
 }
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(ASC_VERSION);
=3D=3D=3D=3D=3D drivers/scsi/aha152x.c 1.43 vs edited =3D=3D=3D=3D=3D
--- 1.43/drivers/scsi/aha152x.c	Mon Jan 26 11:51:08 2004
+++ edited/drivers/scsi/aha152x.c	Mon Apr 26 22:25:24 2004
@@ -351,6 +351,7 @@
 MODULE_AUTHOR("J=EF=BF=BDrgen Fischer");
 MODULE_DESCRIPTION(AHA152X_REVID);
 MODULE_LICENSE("GPL");
+MODULE_VERSION("2.7");
=20
 #if !defined(PCMCIA)
 #if defined(MODULE)
=3D=3D=3D=3D=3D drivers/scsi/aha1542.c 1.34 vs edited =3D=3D=3D=3D=3D
--- 1.34/drivers/scsi/aha1542.c	Fri Jan 23 17:50:19 2004
+++ edited/drivers/scsi/aha1542.c	Mon Apr 26 22:28:09 2004
@@ -1809,7 +1809,7 @@
 	return 0;
 }
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION("");
=20
 static Scsi_Host_Template driver_template =3D {
 	.proc_name		=3D "aha1542",
=3D=3D=3D=3D=3D drivers/scsi/aha1740.c 1.28 vs edited =3D=3D=3D=3D=3D
--- 1.28/drivers/scsi/aha1740.c	Mon Oct 27 07:23:22 2003
+++ edited/drivers/scsi/aha1740.c	Mon Apr 26 22:30:13 2004
@@ -705,3 +705,4 @@
 module_exit (aha1740_exit);
=20
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/aic7xxx_old.c 1.52 vs edited =3D=3D=3D=3D=3D
--- 1.52/drivers/scsi/aic7xxx_old.c	Thu Mar 25 08:44:41 2004
+++ edited/drivers/scsi/aic7xxx_old.c	Mon Apr 26 22:19:44 2004
@@ -11138,7 +11138,7 @@
 #include "aic7xxx_old/aic7xxx_proc.c"
=20
 MODULE_LICENSE("Dual BSD/GPL");
-
+MODULE_VERSION(AIC7XXX_C_VERSION);
=20
 static Scsi_Host_Template driver_template =3D {
 	.proc_info		=3D aic7xxx_proc_info,
=3D=3D=3D=3D=3D drivers/scsi/amiga7xx.c 1.9 vs edited =3D=3D=3D=3D=3D
--- 1.9/drivers/scsi/amiga7xx.c	Sat Jan 10 20:18:15 2004
+++ edited/drivers/scsi/amiga7xx.c	Mon Apr 26 22:32:57 2004
@@ -29,6 +29,7 @@
 #include "53c7xx.h"
 #include "amiga7xx.h"
=20
+MODULE_VERSION("");
=20
 static int amiga7xx_register_one(Scsi_Host_Template *tpnt,
 				 unsigned long address)
=3D=3D=3D=3D=3D drivers/scsi/ata_piix.c 1.15 vs edited =3D=3D=3D=3D=3D
--- 1.15/drivers/scsi/ata_piix.c	Tue Mar 23 11:35:45 2004
+++ edited/drivers/scsi/ata_piix.c	Mon Apr 26 22:33:52 2004
@@ -204,6 +204,7 @@
 MODULE_DESCRIPTION("SCSI low-level driver for Intel PIIX/ICH ATA controlle=
rs");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
=20
 /**
  *	piix_pata_cbl_detect - Probe host controller cable detect info
=3D=3D=3D=3D=3D drivers/scsi/atari_scsi.c 1.10 vs edited =3D=3D=3D=3D=3D
--- 1.10/drivers/scsi/atari_scsi.c	Fri May  2 14:49:04 2003
+++ edited/drivers/scsi/atari_scsi.c	Mon Apr 26 22:53:04 2004
@@ -1161,3 +1161,4 @@
 #include "scsi_module.c"
=20
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/atp870u.c 1.29 vs edited =3D=3D=3D=3D=3D
--- 1.29/drivers/scsi/atp870u.c	Tue Feb  3 23:29:29 2004
+++ edited/drivers/scsi/atp870u.c	Mon Apr 26 22:56:01 2004
@@ -37,6 +37,8 @@
 #include "hosts.h"
 #include "atp870u.h"
=20
+#define DRV_VERSION "2.6-ac"
+
 /*
  *   static const char RCSid[] =3D "$Header: /usr/src/linux/kernel/blk_drv=
/scsi/RCS/atp870u.c,v 1.0 1997/05/07 15:22:00 root Exp root $";
  */
@@ -2617,7 +2619,7 @@
 	if (offset =3D=3D 0) {
 		memset(buff, 0, sizeof(buff));
 	}
-	size +=3D sprintf(BLS, "ACARD AEC-671X Driver Version: 2.6+ac\n");
+	size +=3D sprintf(BLS, "ACARD AEC-671X Driver Version: %s\n", DRV_VERSION=
);
 	len +=3D size;
 	pos =3D begin + len;
 	size =3D 0;
@@ -2672,6 +2674,7 @@
 }
=20
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
=20
 static Scsi_Host_Template atp870u_template =3D {
 	.module			=3D THIS_MODULE,
=3D=3D=3D=3D=3D drivers/scsi/megaraid.c 1.62 vs edited =3D=3D=3D=3D=3D
--- 1.62/drivers/scsi/megaraid.c	Thu Feb 19 18:32:21 2004
+++ edited/drivers/scsi/megaraid.c	Mon Apr 26 22:03:19 2004
@@ -56,6 +56,7 @@
 MODULE_AUTHOR ("LSI Logic Corporation");
 MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
 MODULE_LICENSE ("GPL");
+MODULE_VERSION("2.00.3");
=20
 static unsigned int max_cmd_per_lun =3D DEF_CMD_PER_LUN;
 MODULE_PARM(max_cmd_per_lun, "i");
=3D=3D=3D=3D=3D drivers/scsi/aacraid/linit.c 1.28 vs edited =3D=3D=3D=3D=3D
--- 1.28/drivers/scsi/aacraid/linit.c	Tue Mar 16 02:57:16 2004
+++ edited/drivers/scsi/aacraid/linit.c	Mon Apr 26 22:05:04 2004
@@ -59,6 +59,7 @@
 		   "Adaptec Advanced Raid Products, "
 		   "and HP NetRAID-4M SCSI driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(AAC_DRIVER_VERSION);
=20
=20
 int nondasd =3D -1;
=3D=3D=3D=3D=3D drivers/scsi/aic7xxx/aic79xx_osm.c 1.52 vs edited =3D=3D=3D=
=3D=3D
--- 1.52/drivers/scsi/aic7xxx/aic79xx_osm.c	Wed Feb 18 21:42:35 2004
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c	Mon Apr 26 22:12:46 2004
@@ -429,6 +429,7 @@
 #ifdef MODULE_LICENSE
 MODULE_LICENSE("Dual BSD/GPL");
 #endif
+MODULE_VERSION(AIC79XX_DRIVER_VERSION);
 MODULE_PARM(aic79xx, "s");
 MODULE_PARM_DESC(aic79xx,
 "period delimited, options string.\n"
=3D=3D=3D=3D=3D drivers/scsi/aic7xxx/aic7xxx_osm.c 1.49 vs edited =3D=3D=3D=
=3D=3D
--- 1.49/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Feb 18 21:42:35 2004
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Mon Apr 26 22:13:37 2004
@@ -450,6 +450,7 @@
 #ifdef MODULE_LICENSE
 MODULE_LICENSE("Dual BSD/GPL");
 #endif
+MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
 MODULE_PARM(aic7xxx, "s");
 MODULE_PARM_DESC(aic7xxx,
 "period delimited, options string.\n"
=3D=3D=3D=3D=3D drivers/scsi/arm/acornscsi.c 1.37 vs edited =3D=3D=3D=3D=3D
--- 1.37/drivers/scsi/arm/acornscsi.c	Sun Feb  8 10:36:58 2004
+++ edited/drivers/scsi/arm/acornscsi.c	Mon Apr 26 22:37:33 2004
@@ -3128,3 +3128,4 @@
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("AcornSCSI driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/arm/arxescsi.c 1.24 vs edited =3D=3D=3D=3D=3D
--- 1.24/drivers/scsi/arm/arxescsi.c	Sun Feb  8 10:31:49 2004
+++ edited/drivers/scsi/arm/arxescsi.c	Mon Apr 26 22:43:13 2004
@@ -53,6 +53,7 @@
 #define CSTATUS_IRQ	(1 << 0)
=20
 #define VERSION "1.10 (23/01/2003 2.5.57)"
+#define DRV_VERSION "2.5.57"
=20
 /*
  * Function: int arxescsi_dma_setup(host, SCpnt, direction, min_type)
@@ -399,4 +400,4 @@
 MODULE_AUTHOR("Stefan Hanske");
 MODULE_DESCRIPTION("ARXESCSI driver for Acorn machines");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION(DRV_VERSION);
=3D=3D=3D=3D=3D drivers/scsi/arm/cumana_1.c 1.21 vs edited =3D=3D=3D=3D=3D
--- 1.21/drivers/scsi/arm/cumana_1.c	Fri Jul 18 09:43:19 2003
+++ edited/drivers/scsi/arm/cumana_1.c	Mon Apr 26 22:45:12 2004
@@ -354,3 +354,4 @@
=20
 MODULE_DESCRIPTION("Cumana SCSI-1 driver for Acorn machines");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/arm/cumana_2.c 1.31 vs edited =3D=3D=3D=3D=3D
--- 1.31/drivers/scsi/arm/cumana_2.c	Sun Feb  8 10:31:49 2004
+++ edited/drivers/scsi/arm/cumana_2.c	Mon Apr 26 22:44:43 2004
@@ -67,6 +67,7 @@
  * Version
  */
 #define VERSION "1.00 (13/11/2002 2.5.47)"
+#define DRV_VERSION "2.5.47"
=20
 /*
  * Use term=3D0,1,0,0,0 to turn terminators on/off
@@ -566,3 +567,4 @@
 MODULE_PARM(term, "1-8i");
 MODULE_PARM_DESC(term, "SCSI bus termination");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
=3D=3D=3D=3D=3D drivers/scsi/arm/ecoscsi.c 1.21 vs edited =3D=3D=3D=3D=3D
--- 1.21/drivers/scsi/arm/ecoscsi.c	Fri Jul 18 09:43:19 2003
+++ edited/drivers/scsi/arm/ecoscsi.c	Mon Apr 26 22:45:50 2004
@@ -235,4 +235,5 @@
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Econet-SCSI driver for Acorn machines");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=20
=3D=3D=3D=3D=3D drivers/scsi/arm/eesox.c 1.32 vs edited =3D=3D=3D=3D=3D
--- 1.32/drivers/scsi/arm/eesox.c	Sun Feb  8 10:31:49 2004
+++ edited/drivers/scsi/arm/eesox.c	Mon Apr 26 22:46:35 2004
@@ -62,6 +62,7 @@
 #define EESOX_DMADATA		0x3800
=20
 #define VERSION "1.10 (17/01/2003 2.5.59)"
+#define DRV_VERSION "2.5.59"
=20
 /*
  * Use term=3D0,1,0,0,0 to turn terminators on/off
@@ -676,4 +677,4 @@
 MODULE_PARM(term, "1-8i");
 MODULE_PARM_DESC(term, "SCSI bus termination");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION(DRV_VERSION);
=3D=3D=3D=3D=3D drivers/scsi/arm/fas216.c 1.26 vs edited =3D=3D=3D=3D=3D
--- 1.26/drivers/scsi/arm/fas216.c	Sat Sep 20 09:08:01 2003
+++ edited/drivers/scsi/arm/fas216.c	Mon Apr 26 22:47:26 2004
@@ -3047,3 +3047,4 @@
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Generic FAS216/NCR53C9x driver core");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/arm/msgqueue.c 1.5 vs edited =3D=3D=3D=3D=3D
--- 1.5/drivers/scsi/arm/msgqueue.c	Thu May 15 19:33:17 2003
+++ edited/drivers/scsi/arm/msgqueue.c	Mon Apr 26 22:48:18 2004
@@ -169,3 +169,4 @@
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("SCSI message queue handling");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/arm/oak.c 1.22 vs edited =3D=3D=3D=3D=3D
--- 1.22/drivers/scsi/arm/oak.c	Fri Jul 18 09:43:19 2003
+++ edited/drivers/scsi/arm/oak.c	Mon Apr 26 22:49:04 2004
@@ -213,4 +213,4 @@
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("Oak SCSI driver");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/arm/powertec.c 1.30 vs edited =3D=3D=3D=3D=3D
--- 1.30/drivers/scsi/arm/powertec.c	Sun Feb  8 10:31:50 2004
+++ edited/drivers/scsi/arm/powertec.c	Mon Apr 26 22:49:47 2004
@@ -477,3 +477,4 @@
 MODULE_PARM(term, "1-8i");
 MODULE_PARM_DESC(term, "SCSI bus termination");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/arm/queue.c 1.11 vs edited =3D=3D=3D=3D=3D
--- 1.11/drivers/scsi/arm/queue.c	Tue May 27 14:47:20 2003
+++ edited/drivers/scsi/arm/queue.c	Mon Apr 26 22:50:25 2004
@@ -317,3 +317,4 @@
 MODULE_AUTHOR("Russell King");
 MODULE_DESCRIPTION("SCSI command queueing");
 MODULE_LICENSE("GPL");
+MODULE_VERSION("");
=3D=3D=3D=3D=3D drivers/scsi/qla2xxx/qla_os.c 1.16 vs edited =3D=3D=3D=3D=3D
--- 1.16/drivers/scsi/qla2xxx/qla_os.c	Wed Apr 21 15:42:05 2004
+++ edited/drivers/scsi/qla2xxx/qla_os.c	Mon Apr 26 22:10:18 2004
@@ -4551,3 +4551,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic Fibre Channel HBA Driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAjdzzIavu95Lw/AkRApg2AJ4iHeRqMihHgmkAcGqfF5+tpi/PpwCfaJKf
/MnmhIQa2+RoN0uOb5QdOW0=
=i767
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
