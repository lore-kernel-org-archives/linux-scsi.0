From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][14/15] qlogicfas: finish to convert to new scsi driver model
Date: Tue, 9 Mar 2004 10:43:38 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309134338.GP651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AouxlZHmRoNegvUM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:11786 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261938AbUCINt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:49:26 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 18D3C327AE
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:49:20 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 3767B236C7
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:35:23 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hWE-0000xC-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:43:38 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--AouxlZHmRoNegvUM
Content-Type: multipart/mixed; boundary="/+TVfO13bGamJ+u9"
Content-Disposition: inline


--/+TVfO13bGamJ+u9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--/+TVfO13bGamJ+u9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="14-qlogicfas-convert_to_new_scsi_driver_model.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-08 21:12:49.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-09 10:09:13.000000000=
 -0300
@@ -467,6 +467,7 @@
 	return 0;
 }
=20
+#ifndef PCMCIA
 /*
  *	Look for qlogic card and init if found=20
  */
@@ -561,6 +562,7 @@
 	priv->qbase =3D qbase;
 	priv->qlirq =3D qlirq;
 	priv->qinitid =3D qinitid;
+	priv->shost =3D hreg;
=20
 	sprintf(priv->qinfo,
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
@@ -589,6 +591,7 @@
 }
=20
 #define MAX_QLOGICFAS	8
+static qlogicfas_priv_t cards;
 static int iobase[MAX_QLOGICFAS];
 static int irq[MAX_QLOGICFAS] =3D { [0 ... MAX_QLOGICFAS-1] =3D -1 };
 MODULE_PARM(iobase, "1-" __MODULE_STRING(MAX_QLOGICFAS) "i");
@@ -598,14 +601,20 @@
=20
 int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
 {
+	struct Scsi_Host	*shost;
+	qlogicfas_priv_t	priv;
 	int	i,
 		num =3D 0;
=20
 	for (i =3D 0; i < MAX_QLOGICFAS; i++) {
-		if (__qlogicfas_detect(sht, iobase[num], irq[num]) =3D=3D NULL) {
+		shost =3D __qlogicfas_detect(sht, iobase[num], irq[num]);
+		if (shost =3D=3D NULL) {
 			/* no more devices */
 			break;
 		}
+		priv =3D (qlogicfas_priv_t)&(shost->hostdata[0]);
+		priv->next =3D cards;
+		cards =3D priv;
 		num++;
 	}
=20
@@ -632,6 +641,7 @@
=20
 	return 0;
 }
+#endif	/* ifndef PCMCIA */
=20
 /*=20
  *	Return bios parameters=20
@@ -722,8 +732,6 @@
 	.module			=3D THIS_MODULE,
 	.name			=3D qlogicfas_name,
 	.proc_name		=3D qlogicfas_name,
-	.detect			=3D qlogicfas_detect,
-	.release		=3D qlogicfas_release,
 	.info			=3D qlogicfas_info,
 	.queuecommand		=3D qlogicfas_queuecommand,
 	.eh_abort_handler	=3D qlogicfas_abort,
@@ -739,6 +747,25 @@
 };
=20
 #ifndef PCMCIA
-#define driver_template qlogicfas_driver_template
-#include "scsi_module.c"
-#endif
+static __init int qlogicfas_init(void)
+{
+	if (!qlogicfas_detect(&qlogicfas_driver_template)) {
+		/* no cards found */
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static __exit void qlogicfas_exit(void)
+{
+	qlogicfas_priv_t	priv;
+
+	for (priv =3D cards; priv !=3D NULL; priv =3D priv->next)
+		qlogicfas_release(priv->shost);
+}
+
+module_init(qlogicfas_init);
+module_exit(qlogicfas_exit);
+#endif	/* ifndef PCMCIA */
+
diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.h linux-2.6.3-work/driv=
ers/scsi/qlogicfas.h
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.h	2004-03-08 21:12:49.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.h	2004-03-09 10:01:45.000000000=
 -0300
@@ -84,6 +84,8 @@
 #define QL_INT_ACTIVE_HIGH 0
 #endif
=20
+struct qlogicfas_priv;
+typedef struct qlogicfas_priv *qlogicfas_priv_t;
 struct qlogicfas_priv {
 	 int		qbase;		/* Port */
 	 int		qinitid;	/* initiator ID */
@@ -91,8 +93,9 @@
 	 int		qlirq;		/* IRQ being used */
 	 char		qinfo[80];	/* description */
 	 Scsi_Cmnd 	*qlcmd;		/* current command being processed */
+	 struct Scsi_Host	*shost;	/* pointer back to host */
+	 qlogicfas_priv_t	next;	/* next private struct */
 };
-typedef struct qlogicfas_priv *qlogicfas_priv_t;
=20
 extern int qlcfg5;
 extern int qlcfg6;

--/+TVfO13bGamJ+u9--

--AouxlZHmRoNegvUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcoKRRJOudsVYbMRAphMAKCTS2WOBcxm9eG5wZ8F2a69yXPG8gCeL4MO
ncNs7io50rYZ8Lwereqc5Z0=
=ssZU
-----END PGP SIGNATURE-----

--AouxlZHmRoNegvUM--
