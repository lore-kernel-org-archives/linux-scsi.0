From: Kurt Garloff <garloff@suse.de>
Subject: SCSI sense buffer size -> 96
Date: Tue, 30 Mar 2004 18:59:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040330165954.GL3886@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qo7zVO9a9OQ5oQtr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:33925 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263757AbUC3Q76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 11:59:58 -0500
Received: from hermes.suse.de (Hermes.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id 048003AB5D9
	for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2004 18:59:55 +0200 (CEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--qo7zVO9a9OQ5oQtr
Content-Type: multipart/mixed; boundary="enGqbSaueFq5omEL"
Content-Disposition: inline


--enGqbSaueFq5omEL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

some SCSI devices need more than 64bytes of sense buffer.
I know about one: The IBM MagStar tapes report the necessity to be
cleaned at bytes 70 and report 96 bytes in total.

Attached patch increases the sense buffer size to 96 bytes.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--enGqbSaueFq5omEL
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi-sensebuf-96.diff
Content-Disposition: attachment; filename=scsi-sensebuf-96
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.4.i386/include/scsi/scsi_cmnd.h.orig	2004-03-11 03:55:36.0000=
00000 +0100
+++ linux-2.6.4.i386/include/scsi/scsi_cmnd.h	2004-03-30 09:18:46.887390456=
 +0200
@@ -112,7 +112,7 @@
 	struct request *request;	/* The command we are
 				   	   working on */
=20
-#define SCSI_SENSE_BUFFERSIZE 	64
+#define SCSI_SENSE_BUFFERSIZE 	96
 	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUES=
T SENSE
 						 * when CHECK CONDITION is
 						 * received on original command=20

--enGqbSaueFq5omEL--

--qo7zVO9a9OQ5oQtr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAaaeKxmLh6hyYd04RAiYyAKCbYjHmKXHrfX5n0ANGywCpf51nrwCgnwN3
aH5Jc6dJDgih0p2G7EsqSjk=
=LVc+
-----END PGP SIGNATURE-----

--qo7zVO9a9OQ5oQtr--
