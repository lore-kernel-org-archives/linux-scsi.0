From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] 3/6: allow host adapters to avoid REPORT_LUNS
Date: Sun, 18 Apr 2004 20:58:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418185848.GF4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:38821 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263853AbUDRTAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Martin Peschke3 <MPESCHKE@de.ibm.com>


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Feature.

This patch introduces a field in the per SCSI host struct that allows
host adapters to switch off the user of REPORT_LUNS during SCSI scanning.
Some host adapters/devices may not cope with the way Linux maps the 8byte=
=20
LUNS to a 32bit number and may provide their own mechanism. zfcp (S/390)=20
is known to do this.

 drivers/scsi/scsi_scan.c |    1 +
 include/scsi/scsi_host.h |    6 ++++++
 2 files changed, 7 insertions(+)

diff -uNrp linux-2.6.5.replun2/drivers/scsi/scsi_scan.c linux-2.6.5.noreplu=
nhost/drivers/scsi/scsi_scan.c
--- linux-2.6.5.replun2/drivers/scsi/scsi_scan.c	2004-04-15 22:36:53.844309=
095 +0200
+++ linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c	2004-04-15 22:42:48.5=
44207185 +0200
@@ -951,6 +951,7 @@ static int scsi_report_lun_scan(struct s
 	 */
 =09
 	if ( scsi_noreportlun ||
+	     sdev->host->no_reportlun ||
 	     sdev->scsi_level < SCSI_2 ||=20
 	    (sdev->scsi_level < SCSI_3 &&
 	     (!scsi_reportlun2 || sdev->host->max_lun <=3D 8)))
Files linux-2.6.5.replun2/drivers/scsi/.scsi_scan.c.swp and linux-2.6.5.nor=
eplunhost/drivers/scsi/.scsi_scan.c.swp differ
diff -uNrp linux-2.6.5.replun2/include/scsi/scsi_host.h linux-2.6.5.noreplu=
nhost/include/scsi/scsi_host.h
--- linux-2.6.5.replun2/include/scsi/scsi_host.h	2004-04-04 05:36:25.000000=
000 +0200
+++ linux-2.6.5.noreplunhost/include/scsi/scsi_host.h	2004-04-15 22:41:20.8=
13609917 +0200
@@ -459,6 +459,12 @@ struct Scsi_Host {
 	unsigned reverse_ordering:1;
=20
 	/*
+	 * True for host adapters that dislike REPORT_LUN as they
+	 * use a different mapping of 8byte LUNs to (long) integers
+	 */
+	unsigned no_reportlun:1;
+
+	/*
 	 * Host has rejected a command because it was busy.
 	 */
 	unsigned int host_blocked;
Files linux-2.6.5.replun2/include/scsi/.scsi_host.h.swp and linux-2.6.5.nor=
eplunhost/include/scsi/.scsi_host.h.swp differ
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgs/nxmLh6hyYd04RAtYMAJ9ZV1icCxWWss4u61fFekaZ1bBazgCgjF+a
qjB2gDERQHyI7v1gh8nCI+g=
=1o0T
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
