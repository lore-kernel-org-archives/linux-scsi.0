From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][3/15] qlogicfas: kill QL_USE_IRQ
Date: Tue, 9 Mar 2004 10:35:00 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133500.GE651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tcC6YSqBgqqkz7Sb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:6926 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261942AbUCIOGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 09:06:24 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id CAB843285C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 11:06:29 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id E6F13236BF
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:26:44 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hNs-0000vp-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:35:00 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--tcC6YSqBgqqkz7Sb
Content-Type: multipart/mixed; boundary="L+ofChggJdETEG3Y"
Content-Disposition: inline


--L+ofChggJdETEG3Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--L+ofChggJdETEG3Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="03-qlogicfas-kill_ql_use_irq.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:39:03.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:39:27.000000000=
 -0300
@@ -48,11 +48,6 @@
=20
 #define QL_INT_ACTIVE_HIGH 2
=20
-/* Set the following to 1 to enable the use of interrupts.  Note that 0 te=
nds
-   to be more stable, but slower (or ties up the system more) */
-
-#define QL_USE_IRQ 1
-
 /* Set the following to max out the speed of the PIO PseudoDMA transfers,
    again, 0 tends to be slower, but more stable.  */
=20
@@ -502,8 +497,6 @@
 	return (result << 16) | (message << 8) | (status & STATUS_MASK);
 }
=20
-#if QL_USE_IRQ
-
 /*
  *	Interrupt handler=20
  */
@@ -543,10 +536,6 @@
 	return IRQ_HANDLED;
 }
=20
-#endif
-
-#if QL_USE_IRQ
-
 /*
  *	Queued command
  */
@@ -568,12 +557,6 @@
 	ql_icmd(cmd);
 	return 0;
 }
-#else
-int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
-{
-	return 1;
-}
-#endif
=20
 #ifdef PCMCIA
=20
@@ -643,7 +626,6 @@
 	REG0;
 #endif
=20
-#if QL_USE_IRQ
 	/*
 	 *	IRQ probe - toggle pin and check request pending=20
 	 */
@@ -672,7 +654,7 @@
=20
 	if (qlirq >=3D 0 && !request_irq(qlirq, do_ql_ihandl, 0, qlogicfas_name, =
NULL))
 		host->can_queue =3D 1;
-#endif
+
 	hreg =3D scsi_register(host, 0);	/* no host data */
 	if (!hreg)
 		goto err_release_mem;

--L+ofChggJdETEG3Y--

--tcC6YSqBgqqkz7Sb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcgERRJOudsVYbMRAtQ0AKCdVbUElPoDDU7p8kvDQ5RkYM0uLQCdGpGJ
uIyny+dR/f7gyn8JA90XXIY=
=Rhe+
-----END PGP SIGNATURE-----

--tcC6YSqBgqqkz7Sb--
