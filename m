From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][6/15] qlogicfas: begin to convert qlogicfas to new driver model
Date: Tue, 9 Mar 2004 10:37:16 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133715.GH651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vxa5joy26gVGOrvU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:7438 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261947AbUCIOGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 09:06:25 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id AFD0832859
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 11:06:29 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 666D6236C2
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:29:00 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hQ4-0000wA-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:37:16 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--Vxa5joy26gVGOrvU
Content-Type: multipart/mixed; boundary="dzI2QqkSBOAresgT"
Content-Disposition: inline


--dzI2QqkSBOAresgT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--dzI2QqkSBOAresgT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="06-qlogicfas-begin_to_convert_to_new_mode.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:43:00.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:42:33.000000000=
 -0300
@@ -652,10 +652,7 @@
 	} else
 		printk(KERN_INFO "Ql: Using preset IRQ %d\n", qlirq);
=20
-	if (qlirq >=3D 0 && !request_irq(qlirq, do_ql_ihandl, 0, qlogicfas_name, =
NULL))
-		host->can_queue =3D 1;
-
-	hreg =3D scsi_register(host, 0);	/* no host data */
+	hreg =3D scsi_host_alloc(host, 0);	/* no host data */
 	if (!hreg)
 		goto err_release_mem;
 	hreg->io_port =3D qbase;
@@ -669,14 +666,25 @@
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
 	host->name =3D qlogicfas_name;
=20
+	if (request_irq(qlirq, do_ql_ihandl, 0, qlogicfas_name, hreg))
+		goto free_scsi_host;
+
+	if (scsi_add_host(hreg, NULL))
+		goto free_interrupt;
+
+	scsi_scan_host(hreg);
+
 	return hreg;
=20
+free_interrupt:
+	free_irq(qlirq, hreg);
+
+free_scsi_host:
+	scsi_host_put(hreg);
+
 err_release_mem:
 	release_region(qbase, 0x10);
-	if (host->can_queue)
-		free_irq(qlirq, do_ql_ihandl);
-	return NULL;;
-
+	return NULL;
 }
=20
 int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
@@ -687,12 +695,14 @@
 static int qlogicfas_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	if (shost->dma_channel !=3D 0xff)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
-	scsi_unregister(shost);
+	scsi_remove_host(shost);
+	scsi_host_put(shost);
+
 	return 0;
 }
=20

--dzI2QqkSBOAresgT--

--Vxa5joy26gVGOrvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATciLRRJOudsVYbMRApQzAKCnNMFC+Gi6pN3W8DhckOJOCFZHBACfWEMu
/LjdlLDRqDKesttSuSdhw4I=
=gm0A
-----END PGP SIGNATURE-----

--Vxa5joy26gVGOrvU--
