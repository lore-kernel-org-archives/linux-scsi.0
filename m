From: Kurt Garloff <garloff@suse.de>
Subject: PATCH 5/5: scsi-scan-inq-timeout
Date: Wed, 21 Apr 2004 16:14:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421141456.GW28633@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R10gueRtU1pFqy+X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:26801 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262952AbUDUOPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:15:24 -0400
Content-Disposition: inline
In-Reply-To: <20040421134511.GP28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--R10gueRtU1pFqy+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Feature

Make the timeout for INQUIRY during SCSI scan adjustable via boot parameter.
Note that the second INQUIRY does use a shorter timeout, as the long timeout
is for recovery from the initial reset, not because existing devices would
take so long to answer INQUIRY. SPC3 says that INQUIRY should be available
right away, but real life is different unfortunately.

diff -uNrp linux-2.6.5.dontattachoffl/drivers/scsi/scsi_scan.c linux-2.6.5.=
inq_timeout/drivers/scsi/scsi_scan.c
--- linux-2.6.5.dontattachoffl/drivers/scsi/scsi_scan.c	2004-04-21 14:28:13=
=2E000000000 +0200
+++ linux-2.6.5.inq_timeout/drivers/scsi/scsi_scan.c	2004-04-21 14:32:04.00=
0000000 +0200
@@ -94,6 +94,13 @@ MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
=20
+static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+3;
+
+module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(inq_timeout,=20
+		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
+		 " Default is 5. Some non-compliant devices need more.");
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sreq:	used to send the command
@@ -344,7 +351,7 @@ static void scsi_probe_lun(struct scsi_r
=20
 	memset(inq_result, 0, 36);
 	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
-		      SCSI_TIMEOUT + 4 * HZ, 3);
+		      HZ/2 + HZ*scsi_inq_timeout, 3);
=20
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
 			" code 0x%x\n", sreq->sr_result ?
@@ -393,7 +400,7 @@ static void scsi_probe_lun(struct scsi_r
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

--R10gueRtU1pFqy+X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhoHgxmLh6hyYd04RAp7eAJ9BtQ4mSAjNOUNUtkkXMWVa7y/txgCdFfZg
oRZkzMgKvfUGSIwA3063HS8=
=uMs5
-----END PGP SIGNATURE-----

--R10gueRtU1pFqy+X--
