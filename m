From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][10/15] qlogic_cs: don't call qlogic_release on fail
Date: Tue, 9 Mar 2004 10:40:21 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309134021.GL651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xMJbWctQEcNQiBqK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:19984 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261524AbUCIOWz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 09:22:55 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 2147C32677
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 11:23:10 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id BE2CA236C5
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:32:05 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hT3-0000wh-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:40:21 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--xMJbWctQEcNQiBqK
Content-Type: multipart/mixed; boundary="FoibaoN3dya3u5fy"
Content-Disposition: inline


--FoibaoN3dya3u5fy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--FoibaoN3dya3u5fy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="10-qlogic_cs-dont_call_qlogic_release_on_fail.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.3-=
work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:47:=
17.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:47:26.=
000000000 -0300
@@ -267,7 +267,11 @@
=20
 cs_failed:
 	cs_error(link->handle, last_fn, last_ret);
-	qlogic_release(link);
+	link->dev =3D NULL;
+	pcmcia_release_configuration(link->handle);
+	pcmcia_release_io(link->handle, &link->io);
+	pcmcia_release_irq(link->handle, &link->irq);
+	link->state &=3D ~DEV_CONFIG;
 	return;
=20
 }				/* qlogic_config */

--FoibaoN3dya3u5fy--

--xMJbWctQEcNQiBqK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATclFRRJOudsVYbMRArJvAKDFPSLdjdJq7BzXz6/pk7p88KCA2wCaA+8Z
8u4gPB80nPmzoyRj/hgRUG8=
=5UAz
-----END PGP SIGNATURE-----

--xMJbWctQEcNQiBqK--
