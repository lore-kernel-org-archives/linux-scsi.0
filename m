From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Sun, 18 Apr 2004 20:59:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418185950.GG4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:54181 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263879AbUDRTAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Feature.

scsi_allow_ghost_devices=3DN
This patch introduces a boot/module parameter that allows the user to tell
the kernel to NOT set the first N devices to offline despite they would
normally be. Needed for some EMC multipathing devices.
This parameter is even documented in EMC docs as both RH and SUSE had
such a parameter in their 2.4 vendor kernels :-/

--- linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c.orig	2004-04-15 22:42=
:48.544207000 +0200
+++ linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c	2004-04-15 22:51:08.2=
91252857 +0200
@@ -119,6 +119,12 @@ module_param_named(scsi_reportlun2, scsi
 MODULE_PARM_DESC(scsi_reportlun2,
 		 "Use REPORT_LUNs for scanning SCSI-2 devs as well");
=20
+static unsigned int scsi_allow_ghost_devices;
+module_param_named(scsi_allow_ghost_devices ,scsi_allow_ghost_devices, int=
, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scsi_allow_ghost_devices,=20
+		 "allow devices marked as being offline to be accessed anyway "
+		 "(0 =3D off, else allow ghosts on lun 0 through allow_ghost_devices - 1=
");
+
=20
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
@@ -573,7 +579,8 @@ static int scsi_add_lun(struct scsi_devi
 	 * otherwise, offline devices still get an sd allocated, and they
 	 * use up an sd slot.
 	 */
-	if (((inq_result[0] >> 5) & 7) =3D=3D 1) {
+	if (((inq_result[0] >> 5) & 7) =3D=3D 1 &&
+	    (sdev->lun >=3D scsi_allow_ghost_devices)) {
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: peripheral"
 				" qualifier of 1, device offlined\n"));
 		sdev->online =3D FALSE;
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgtAmxmLh6hyYd04RAvPQAJ9biy3ctV6JjuIHJtCYGcDh83TFUgCg2FZ1
QywUqiuiBO8Egke9QFn4Ywo=
=Q8l1
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--
