From: Arjan van de Ven <arjanv@redhat.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: Mon, 29 Dec 2003 19:38:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072723117.4233.4.camel@laptop.fenrus.com>
References: <B179AE41C1147041AA1121F44614F0B060ED8F@AVEXCH02.qlogic.org>
	 <1072719168.1878.34.camel@mulgrave>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VoCxmdOrkZP0FidgEfY8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:12679 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S264923AbTL2SjA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 13:39:00 -0500
In-Reply-To: <1072719168.1878.34.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


--=-VoCxmdOrkZP0FidgEfY8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> - Multi Pathing.  This really doesn't belong in the kernel
> - The odd ioctl set to the qla device...I'd much rather see something
> more standard that all FC drivers can use.
>=20
> James
>=20

this patch wants adding too; down_interruptible() is the wrong thing to
do here (in case a signal hits you sooo do the wrong thing and corrupt
the semaphore)

--- linux-2.6.0/drivers/scsi/qla2xxx/qla_mbx.c~=20
+++ linux-2.6.0/drivers/scsi/qla2xxx/qla_mbx.c=20
@@ -175,7 +175,7 @@
                /* Wait for either the timer to expire
                 * or the mbox completion interrupt
                 */
-               down_interruptible(&ha->mbx_intr_sem);
+               down(&ha->mbx_intr_sem);
 =20
                DEBUG11(printk("qla2x00_mailbox_command:"
                    "waking up."


--=-VoCxmdOrkZP0FidgEfY8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/8HStxULwo51rQBIRAub/AJ0aLL+JRwkuwXIRMVPRWD1zYAZK8ACgqzA4
Yeo/WKNWscfj+r+BbBiCm2E=
=Rssa
-----END PGP SIGNATURE-----

--=-VoCxmdOrkZP0FidgEfY8--
