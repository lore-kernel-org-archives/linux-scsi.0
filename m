From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] unique_id for ide-scsi
Date: Mon, 9 Feb 2004 16:54:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209155440.GQ3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ixDgnS8AC6zwmyK0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:11179 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262687AbUBIPym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 10:54:42 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Willem Riede <osst@riede.org>, James Bottomley <James.Bottomley@steeleye.com>


--ixDgnS8AC6zwmyK0
Content-Type: multipart/mixed; boundary="a+0P3INHs7aeI7wh"
Content-Disposition: inline


--a+0P3INHs7aeI7wh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

most scsi host adapters do fill in their ioport into thos host's=20
unique_id field.
ide-scsi does not. The attached patch changes it.

Caveats: It puts the first PATA port there, the SATA port are not
 considered. Are there SATA chips that don't have PATA ports?

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--a+0P3INHs7aeI7wh
Content-Type: text/plain; charset=us-ascii
Content-Description: ide-scsi-unique-id.diff
Content-Disposition: attachment; filename="ide-scsi-unique-id.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/ide-scsi.c.orig	2004-01-09 07:59:45.000000000 +0100
+++ drivers/scsi/ide-scsi.c	2004-02-09 16:26:24.033475704 +0100
@@ -967,6 +967,7 @@
=20
 	host->max_id =3D 1;
 	host->max_lun =3D 1;
+	host->unique_id =3D drive->hwif->hw.io_ports[0];
 	drive->driver_data =3D host;
 	idescsi =3D scsihost_to_idescsi(host);
 	idescsi->drive =3D drive;

--a+0P3INHs7aeI7wh--

--ixDgnS8AC6zwmyK0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ60/xmLh6hyYd04RAvwaAJ9rUuDCMUDJQcMLo35MOtCoHC8o4ACeL2Tf
GZX2bxkMZgPXrFwDPTrQGJU=
=HrHr
-----END PGP SIGNATURE-----

--ixDgnS8AC6zwmyK0--
