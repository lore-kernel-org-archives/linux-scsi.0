From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][7/15] qlogicfas: disable irqs on exit
Date: Tue, 9 Mar 2004 10:38:31 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133831.GI651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bvgsfYmVhxWy/2TA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:6670 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261939AbUCIOGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 09:06:24 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id D59953285D
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 11:06:29 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 80E84236C0
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:30:15 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hRH-0000wK-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:38:31 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--bvgsfYmVhxWy/2TA
Content-Type: multipart/mixed; boundary="9DptZICXTlJ7FQ09"
Content-Disposition: inline


--9DptZICXTlJ7FQ09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm not sure about this. feel free to discard if you don't think it isn't
correct.

--=20
aris


--9DptZICXTlJ7FQ09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="07-qlogicfas-disable_irqs_on_exit.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:43:52.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:44:02.000000000=
 -0300
@@ -694,8 +694,12 @@
=20
 static int qlogicfas_release(struct Scsi_Host *shost)
 {
-	if (shost->irq)
+	if (shost->irq) {
+		REG1;
+		outb(0, qbase + 0xb);	/* disable ints */
+=09
 		free_irq(shost->irq, shost);
+	}
 	if (shost->dma_channel !=3D 0xff)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)

--9DptZICXTlJ7FQ09--

--bvgsfYmVhxWy/2TA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcjWRRJOudsVYbMRApF9AJ4mju+A1rJtV0mAaaLci5DX9c9D9ACgq8ZN
8j2T/MrPZAENoZCFf5e5B+k=
=VXO0
-----END PGP SIGNATURE-----

--bvgsfYmVhxWy/2TA--
