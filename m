From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][2/15] qlogic_cs: use a static string as name
Date: Tue, 9 Mar 2004 10:34:23 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133423.GD651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:1802 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261926AbUCINl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:41:59 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 3C48B32846
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:38:38 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 880DB2308A
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:26:07 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hNH-0000vf-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:34:23 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--rWhLK7VZz0iBluhq
Content-Type: multipart/mixed; boundary="HeFlAV5LIbMFYYuh"
Content-Disposition: inline


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="02-qlogic_cs-use_qlogic_name.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.3-=
work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 17:53:=
13.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:36:06.=
000000000 -0300
@@ -60,6 +60,8 @@
 extern struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *);
 extern int qlogicfas_bus_reset(Scsi_Cmnd *);
=20
+static char *qlogic_name =3D "qlogic_cs";
+
 #ifdef PCMCIA_DEBUG
 static int pc_debug =3D PCMCIA_DEBUG;
 MODULE_PARM(pc_debug, "i");
@@ -247,9 +249,11 @@
 	else
 		qlogicfas_preset(link->io.BasePort1, link->irq.AssignedIRQ);
=20
+	qlogicfas_driver_template.name =3D qlogic_name;
+	qlogicfas_driver_template.proc_name =3D qlogic_name;
 	host =3D __qlogicfas_detect(&qlogicfas_driver_template);
 	if (!host) {
-		printk(KERN_INFO "qlogic_cs: no SCSI devices found\n");
+		printk(KERN_INFO "%s: no SCSI devices found\n", qlogic_name);
 		goto out;
 	}
=20
@@ -340,7 +344,7 @@
 static struct pcmcia_driver qlogic_cs_driver =3D {
 	.owner		=3D THIS_MODULE,
 	.drv		=3D {
-		.name	=3D "qlogic_cs",
+	.name		=3D "qlogic_cs",
 	},
 	.attach		=3D qlogic_attach,
 	.detach		=3D qlogic_detach,

--HeFlAV5LIbMFYYuh--

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcfeRRJOudsVYbMRAgiYAJ4vEaDGRbah3b75xkN9JubINvTmpgCaA9kj
Q5gra4P9nuMkbxnc+7sTB24=
=Sa3W
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
