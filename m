From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][12/15] qlogicfas: move common definitions to qlogicfas.h
Date: Tue, 9 Mar 2004 10:42:08 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309134208.GN651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qicHaSekiYEWE95x"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:36553 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261937AbUCINtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:49:14 -0500
Received: from panda.sul.com.br (panda.sul.com.br [200.219.150.4])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id i29Dn9m23781
	for <linux-scsi@vger.kernel.org>; Tue, 9 Mar 2004 05:49:09 -0800
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 53476326F0
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:48:53 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 4DAA0236C4
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:33:53 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hUn-0000wv-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:42:09 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--qicHaSekiYEWE95x
Content-Type: multipart/mixed; boundary="I/wet25DnWlSyk1C"
Content-Disposition: inline


--I/wet25DnWlSyk1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--I/wet25DnWlSyk1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="12-qlogicfas-move_common_definitions_to_header.patch"
Content-Transfer-Encoding: quoted-printable

diff -urN linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/dri=
vers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:52:14.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:52:24.000000000=
 -0300
@@ -38,87 +38,6 @@
    are deemed to be part of the source code.
=20
 */
-/*----------------------------------------------------------------*/
-/* Configuration */
-
-/* Set the following to 2 to use normal interrupt (active high/totempole-
-   tristate), otherwise use 0 (REQUIRED FOR PCMCIA) for active low, open
-   drain */
-
-#define QL_INT_ACTIVE_HIGH 2
-
-/* Set the following to max out the speed of the PIO PseudoDMA transfers,
-   again, 0 tends to be slower, but more stable.  */
-
-#define QL_TURBO_PDMA 1
-
-/* This should be 1 to enable parity detection */
-
-#define QL_ENABLE_PARITY 1
-
-/* This will reset all devices when the driver is initialized (during boot=
up).
-   The other linux drivers don't do this, but the DOS drivers do, and after
-   using DOS or some kind of crash or lockup this will bring things back
-   without requiring a cold boot.  It does take some time to recover from a
-   reset, so it is slower, and I have seen timeouts so that devices weren't
-   recognized when this was set. */
-
-#define QL_RESET_AT_START 0
-
-/* crystal frequency in megahertz (for offset 5 and 9)
-   Please set this for your card.  Most Qlogic cards are 40 Mhz.  The
-   Control Concepts ISA (not VLB) is 24 Mhz */
-
-#define XTALFREQ	40
-
-/**********/
-/* DANGER! modify these at your own risk */
-/* SLOWCABLE can usually be reset to zero if you have a clean setup and
-   proper termination.  The rest are for synchronous transfers and other
-   advanced features if your device can transfer faster than 5Mb/sec.
-   If you are really curious, email me for a quick howto until I have
-   something official */
-/**********/
-
-/*****/
-/* config register 1 (offset 8) options */
-/* This needs to be set to 1 if your cabling is long or noisy */
-#define SLOWCABLE 1
-
-/*****/
-/* offset 0xc */
-/* This will set fast (10Mhz) synchronous timing when set to 1
-   For this to have an effect, FASTCLK must also be 1 */
-#define FASTSCSI 0
-
-/* This when set to 1 will set a faster sync transfer rate */
-#define FASTCLK 0	/*(XTALFREQ>25?1:0)*/
-
-/*****/
-/* offset 6 */
-/* This is the sync transfer divisor, XTALFREQ/X will be the maximum
-   achievable data rate (assuming the rest of the system is capable
-   and set properly) */
-#define SYNCXFRPD 5	/*(XTALFREQ/5)*/
-
-/*****/
-/* offset 7 */
-/* This is the count of how many synchronous transfers can take place
-	i.e. how many reqs can occur before an ack is given.
-	The maximum value for this is 15, the upper bits can modify
-	REQ/ACK assertion and deassertion during synchronous transfers
-	If this is 0, the bus will only transfer asynchronously */
-#define SYNCOFFST 0
-/* for the curious, bits 7&6 control the deassertion delay in 1/2 cycles
-	of the 40Mhz clock. If FASTCLK is 1, specifying 01 (1/2) will
-	cause the deassertion to be early by 1/2 clock.  Bits 5&4 control
-	the assertion delay, also in 1/2 clocks (FASTCLK is ignored here). */
-
-/*----------------------------------------------------------------*/
-#ifdef PCMCIA
-#undef QL_INT_ACTIVE_HIGH
-#define QL_INT_ACTIVE_HIGH 0
-#endif
=20
 #include <linux/module.h>
 #include <linux/blkdev.h>		/* to get disk capacity */
@@ -141,35 +60,18 @@
 #include "qlogicfas.h"
=20
 /*----------------------------------------------------------------*/
-/* driver state info, local to driver */
-static int qlcfg5 =3D (XTALFREQ << 5);	/* 15625/512 */
-static int qlcfg6 =3D SYNCXFRPD;
-static int qlcfg7 =3D SYNCOFFST;
-static int qlcfg8 =3D (SLOWCABLE << 7) | (QL_ENABLE_PARITY << 4);
-static int qlcfg9 =3D ((XTALFREQ + 4) / 5);
-static int qlcfgc =3D (FASTCLK << 3) | (FASTSCSI << 4);
+int qlcfg5 =3D (XTALFREQ << 5);	/* 15625/512 */
+int qlcfg6 =3D SYNCXFRPD;
+int qlcfg7 =3D SYNCOFFST;
+int qlcfg8 =3D (SLOWCABLE << 7) | (QL_ENABLE_PARITY << 4);
+int qlcfg9 =3D ((XTALFREQ + 4) / 5);
+int qlcfgc =3D (FASTCLK << 3) | (FASTSCSI << 4);
=20
 static char qlogicfas_name[] =3D "qlogicfas";
=20
 int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
=20
 /*----------------------------------------------------------------*/
-/* The qlogic card uses two register maps - These macros select which one =
*/
-#define REG0 ( outb( inb( qbase + 0xd ) & 0x7f , qbase + 0xd ), outb( 4 , =
qbase + 0xd ))
-#define REG1 ( outb( inb( qbase + 0xd ) | 0x80 , qbase + 0xd ), outb( 0xb4=
 | QL_INT_ACTIVE_HIGH , qbase + 0xd ))
-
-/* following is watchdog timeout in microseconds */
-#define WATCHDOG 5000000
-
-/*----------------------------------------------------------------*/
-/* the following will set the monitor border color (useful to find
-   where something crashed or gets stuck at and as a simple profiler) */
-
-#if 0
-#define rtrc(i) {inb(0x3da);outb(0x31,0x3c0);outb((i),0x3c0);}
-#else
-#define rtrc(i) {}
-#endif
=20
 /*----------------------------------------------------------------*/
 /* local functions */
@@ -531,7 +433,7 @@
 	(icmd->scsi_done) (icmd);
 }
=20
-static irqreturn_t do_ql_ihandl(int irq, void *dev_id, struct pt_regs *reg=
s)
+irqreturn_t do_ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *host =3D dev_id;
diff -urN linux-2.6.3-applied/drivers/scsi/qlogicfas.h linux-2.6.3-work/dri=
vers/scsi/qlogicfas.h
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.h	2004-03-05 18:52:14.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.h	2004-03-05 18:52:24.000000000=
 -0300
@@ -1,6 +1,89 @@
 /* to be used by qlogicfas and qlogic_cs */
 #ifndef __QLOGICFAS_H
 #define __QLOGICFAS_H
+
+/*----------------------------------------------------------------*/
+/* Configuration */
+
+/* Set the following to 2 to use normal interrupt (active high/totempole-
+   tristate), otherwise use 0 (REQUIRED FOR PCMCIA) for active low, open
+   drain */
+
+#define QL_INT_ACTIVE_HIGH 2
+
+/* Set the following to max out the speed of the PIO PseudoDMA transfers,
+   again, 0 tends to be slower, but more stable.  */
+
+#define QL_TURBO_PDMA 1
+
+/* This should be 1 to enable parity detection */
+
+#define QL_ENABLE_PARITY 1
+
+/* This will reset all devices when the driver is initialized (during boot=
up).
+   The other linux drivers don't do this, but the DOS drivers do, and after
+   using DOS or some kind of crash or lockup this will bring things back
+   without requiring a cold boot.  It does take some time to recover from a
+   reset, so it is slower, and I have seen timeouts so that devices weren't
+   recognized when this was set. */
+
+#define QL_RESET_AT_START 0
+
+/* crystal frequency in megahertz (for offset 5 and 9)
+   Please set this for your card.  Most Qlogic cards are 40 Mhz.  The
+   Control Concepts ISA (not VLB) is 24 Mhz */
+
+#define XTALFREQ	40
+
+/**********/
+/* DANGER! modify these at your own risk */
+/* SLOWCABLE can usually be reset to zero if you have a clean setup and
+   proper termination.  The rest are for synchronous transfers and other
+   advanced features if your device can transfer faster than 5Mb/sec.
+   If you are really curious, email me for a quick howto until I have
+   something official */
+/**********/
+
+/*****/
+/* config register 1 (offset 8) options */
+/* This needs to be set to 1 if your cabling is long or noisy */
+#define SLOWCABLE 1
+
+/*****/
+/* offset 0xc */
+/* This will set fast (10Mhz) synchronous timing when set to 1
+   For this to have an effect, FASTCLK must also be 1 */
+#define FASTSCSI 0
+
+/* This when set to 1 will set a faster sync transfer rate */
+#define FASTCLK 0	/*(XTALFREQ>25?1:0)*/
+
+/*****/
+/* offset 6 */
+/* This is the sync transfer divisor, XTALFREQ/X will be the maximum
+   achievable data rate (assuming the rest of the system is capable
+   and set properly) */
+#define SYNCXFRPD 5	/*(XTALFREQ/5)*/
+
+/*****/
+/* offset 7 */
+/* This is the count of how many synchronous transfers can take place
+	i.e. how many reqs can occur before an ack is given.
+	The maximum value for this is 15, the upper bits can modify
+	REQ/ACK assertion and deassertion during synchronous transfers
+	If this is 0, the bus will only transfer asynchronously */
+#define SYNCOFFST 0
+/* for the curious, bits 7&6 control the deassertion delay in 1/2 cycles
+	of the 40Mhz clock. If FASTCLK is 1, specifying 01 (1/2) will
+	cause the deassertion to be early by 1/2 clock.  Bits 5&4 control
+	the assertion delay, also in 1/2 clocks (FASTCLK is ignored here). */
+
+/*----------------------------------------------------------------*/
+#ifdef PCMCIA
+#undef QL_INT_ACTIVE_HIGH
+#define QL_INT_ACTIVE_HIGH 0
+#endif
+
 struct qlogicfas_priv {
 	 int		qbase;		/* Port */
 	 int		qinitid;	/* initiator ID */
@@ -10,5 +93,29 @@
 	 Scsi_Cmnd 	*qlcmd;		/* current command being processed */
 };
 typedef struct qlogicfas_priv *qlogicfas_priv_t;
+
+extern int qlcfg5;
+extern int qlcfg6;
+extern int qlcfg7;
+extern int qlcfg8;
+extern int qlcfg9;
+extern int qlcfgc;
+
+/* The qlogic card uses two register maps - These macros select which one =
*/
+#define REG0 ( outb( inb( qbase + 0xd ) & 0x7f , qbase + 0xd ), outb( 4 , =
qbase + 0xd ))
+#define REG1 ( outb( inb( qbase + 0xd ) | 0x80 , qbase + 0xd ), outb( 0xb4=
 | QL_INT_ACTIVE_HIGH , qbase + 0xd ))
+
+/* following is watchdog timeout in microseconds */
+#define WATCHDOG 5000000
+
+/*----------------------------------------------------------------*/
+/* the following will set the monitor border color (useful to find
+   where something crashed or gets stuck at and as a simple profiler) */
+
+#if 0
+#define rtrc(i) {inb(0x3da);outb(0x31,0x3c0);outb((i),0x3c0);}
+#else
+#define rtrc(i) {}
+#endif
 #endif	/* __QLOGICFAS_H */
=20

--I/wet25DnWlSyk1C--

--qicHaSekiYEWE95x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcmwRRJOudsVYbMRAhqiAJ9lE2TgmP9BKU8H9ir7RA0Ky+z/fgCeIk7B
rViYMHMDuwla+NbqLz3QZmY=
=4xa1
-----END PGP SIGNATURE-----

--qicHaSekiYEWE95x--
