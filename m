From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][1/15] qlogicfas: use a static string as name
Date: Tue, 9 Mar 2004 10:33:23 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133323.GC651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:58121 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261920AbUCINhU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:37:20 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 50791327EF
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:37:33 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id CF8A1236BF
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:25:07 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hMJ-0000vW-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:33:23 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--4zI0WCX1RcnW9Hbu
Content-Type: multipart/mixed; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="01-qlogicfas-use_qlogicfas_name.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 17:53:14.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:14:34.000000000=
 -0300
@@ -161,6 +161,8 @@
 static int qlcfg9 =3D ((XTALFREQ + 4) / 5);
 static int qlcfgc =3D (FASTCLK << 3) | (FASTSCSI << 4);
=20
+static char qlogicfas_name[] =3D "qlogicfas";
+
 int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
=20
 /*----------------------------------------------------------------*/
@@ -609,7 +611,7 @@
=20
 	if (!qbase) {
 		for (qbase =3D 0x230; qbase < 0x430; qbase +=3D 0x100) {
-			if (!request_region(qbase, 0x10, "qlogicfas"))
+			if (!request_region(qbase, 0x10, qlogicfas_name))
 				continue;
 			REG1;
 			if (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) =3D=3D 7)
@@ -668,7 +670,7 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
=20
-	if (qlirq >=3D 0 && !request_irq(qlirq, do_ql_ihandl, 0, "qlogicfas", NUL=
L))
+	if (qlirq >=3D 0 && !request_irq(qlirq, do_ql_ihandl, 0, qlogicfas_name, =
NULL))
 		host->can_queue =3D 1;
 #endif
 	hreg =3D scsi_register(host, 0);	/* no host data */
@@ -796,8 +798,8 @@
  */
 Scsi_Host_Template qlogicfas_driver_template =3D {
 	.module			=3D THIS_MODULE,
-	.name			=3D "qlogicfas",
-	.proc_name		=3D "qlogicfas",
+	.name			=3D qlogicfas_name,
+	.proc_name		=3D qlogicfas_name,
 	.detect			=3D qlogicfas_detect,
 	.release		=3D qlogicfas_release,
 	.info			=3D qlogicfas_info,

--5QAgd0e35j3NYeGe--

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcejRRJOudsVYbMRAsn7AJ0cnTzMrvECLDlCciQF21t48z/gXgCeLAoy
mkCfkM8PPWdy1yqwJU55RJE=
=4G8z
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
