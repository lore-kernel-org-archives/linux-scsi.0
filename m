From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] 5/6: scsi_inq_timeout
Date: Sun, 18 Apr 2004 20:59:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418185957.GH4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fd5uyaI9j6xoeUBo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:56741 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263924AbUDRTAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Feature.

Introduce a new SCSI scanning boot/module parameter
scsi_inq_timeout=3DN
which sets the timeout used when the INQUIRY is send in the SCSI=20
scanning procedure to N seconds. (Half a second is added, so 0 is safe.)
This is useful, because some devices need an excessive amount of time to=20
recover from the bootup SCSI reset.
Also changes the default for PPC64, as some largely used crap chip there
requires it.

Note that the second INQUIRY (with more than 36 bytes) only gets half=20
the amount of seconds, the long delay for the first is only due to the=20
recovery needed from the initial bus reset.

--- linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c.orig	2004-04-15 22:51=
:08.000000000 +0200
+++ linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c	2004-04-16 19:30:43.2=
89826746 +0200
@@ -125,6 +125,22 @@ MODULE_PARM_DESC(scsi_allow_ghost_device
 		 "allow devices marked as being offline to be accessed anyway "
 		 "(0 =3D off, else allow ghosts on lun 0 through allow_ghost_devices - 1=
");
=20
+/* Some AChip ARC765 based DVD-ROM's take 15 or more seconds
+ * to reset.  A scan will fail if made right after a reset.
+ * It's completely broken device behaviour: SCSI specification
+ * says devices need to be able to respond to INQUIRY always
+ * (after a selection timeout ... of 250ms).
+ */
+#ifdef __powerpc64__
+static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+25;
+#else
+static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+3;
+#endif
+
+module_param_named(scsi_inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUS=
R);
+MODULE_PARM_DESC(scsi_inq_timeout,=20
+		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
+		 " Default is 6. Some non-compliant devices need more.");
=20
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
@@ -376,7 +392,7 @@ static void scsi_probe_lun(struct scsi_r
=20
 	memset(inq_result, 0, 36);
 	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
-		      SCSI_TIMEOUT + 4 * HZ, 3);
+		      HZ/2 + HZ*scsi_inq_timeout, 3);
=20
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
 			" code 0x%x\n", sreq->sr_result ?
@@ -425,7 +441,7 @@ static void scsi_probe_lun(struct scsi_r
 		memset(inq_result, 0, possible_inq_resp_len);
 		scsi_wait_req(sreq, (void *) scsi_cmd,
 			      (void *) inq_result,
-			      possible_inq_resp_len, SCSI_TIMEOUT + 4 * HZ, 3);
+			      possible_inq_resp_len, (1+scsi_inq_timeout)*(HZ/2), 3);
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
 				" %s with code 0x%x\n", sreq->sr_result ?
 				"failed" : "successful", sreq->sr_result));
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--fd5uyaI9j6xoeUBo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgtAtxmLh6hyYd04RAnTaAKDaTN6tqcXhmZ4dyNOXefmnLzmjXwCgmZw9
x0BDplRFj5aKwZSHKKqFgMM=
=cU6i
-----END PGP SIGNATURE-----

--fd5uyaI9j6xoeUBo--
