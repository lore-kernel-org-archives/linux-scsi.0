From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH 3/3] Print warning for PQ3 devs
Date: Mon, 1 May 2006 02:50:36 +0200
Message-ID: <20060501005036.GF8728@tpkurt.garloff.de>
References: <20060501004457.GC8728@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m1UC1K4AOz1Ywdkx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:11411 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751245AbWEAAui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 20:50:38 -0400
Content-Disposition: inline
In-Reply-To: <20060501004457.GC8728@tpkurt.garloff.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>


--m1UC1K4AOz1Ywdkx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


=46rom: Kurt Garloff <garloff@suse.de>
Subject: Log a message if we stop scanning because dev reports PQ=3D=3D3

Some devices report a peripheral qualifier of 3 for LUN 0; with the original
code, we would still try a REPORT_LUNS scan (if SCSI level is >=3D 3 or if =
we=20
have the BLIST_REPORTLUNS2 passed in), but NOT any sequential scan.
Also, the device at LUN 0 (which is not connected according to the PQ) is n=
ot
registered with the OS.

Unfortunately, SANs exist that are SCSI-2 and do NOT support REPORT_LUNS, b=
ut
report a unknown device with PQ 3 on LUN 0. We still need to scan them, and
most probably we even need BLIST_SPARSELUN (and BLIST_LARGELUN). See the bug
reference for an infamous example.

SCSI_CHECK_LOGGING macro and warning fixes from Andrew Morton.

This patch 3/3:
If a PQ3 device is found, log a message that describes the device
(INQUIRY DATA and C:B:T:U tuple) and make a suggestion for blacklisting
it.

Signed-off-by: Kurt Garloff <garloff@suse.de>

diff -uNrp linux-2.6-hg/drivers/scsi.2/scsi_logging.h linux-2.6-hg/drivers/=
scsi/scsi_logging.h
--- linux-2.6-hg/drivers/scsi.2/scsi_logging.h	2005-07-19 03:34:43.00000000=
0 +0200
+++ linux-2.6-hg/drivers/scsi/scsi_logging.h	2006-04-27 23:03:29.000000000 =
+0200
@@ -45,10 +45,12 @@ extern unsigned int scsi_logging_level;
         ((scsi_logging_level >> (SHIFT)) & ((1 << (BITS)) - 1))
=20
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)		\
-{								\
+do {								\
         if (unlikely((SCSI_LOG_LEVEL(SHIFT, BITS)) > (LEVEL)))	\
-		(CMD);						\
-}
+		do {						\
+			CMD;					\
+		} while (0);					\
+} while (0)
 #else
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)
 #endif /* CONFIG_SCSI_LOGGING */
diff -uNrp linux-2.6-hg/drivers/scsi.2/scsi_scan.c linux-2.6-hg/drivers/scs=
i/scsi_scan.c
--- linux-2.6-hg/drivers/scsi.2/scsi_scan.c	2006-04-24 07:40:03.000000000 +=
0200
+++ linux-2.6-hg/drivers/scsi/scsi_scan.c	2006-04-27 23:05:14.000000000 +02=
00
@@ -816,6 +816,32 @@ static inline void scsi_destroy_sdev(str
 	put_device(&sdev->sdev_gendev);
 }
=20
+#ifdef CONFIG_SCSI_LOGGING
+/**=20
+ * scsi_inq_str - print INQUIRY data from min to max index,
+ * strip trailing whitespace
+ * @buf:   Output buffer with at least end-first+1 bytes of space
+ * @inq:   Inquiry buffer (input)
+ * @first: Offset of string into inq
+ * @end:   Index after last character in inq
+ */
+static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
+				   unsigned first, unsigned end)
+{
+	unsigned term =3D 0, idx;
+
+	for (idx =3D 0; idx + first < end && idx + first < inq[4] + 5; idx++) {
+		if (inq[idx+first] > ' ') {
+			buf[idx] =3D inq[idx+first];
+			term =3D idx+1;
+		} else {
+			buf[idx] =3D ' ';
+		}
+	}
+	buf[term] =3D 0;
+	return buf;
+}
+#endif
=20
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
@@ -896,9 +922,22 @@ static int scsi_probe_and_add_lun(struct
 		 * logical disk configured at sdev->lun, but there
 		 * is a target id responding.
 		 */
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-					"scsi scan: peripheral qualifier of 3,"
-					" no device added\n"));
+		SCSI_LOG_SCAN_BUS(2, sdev_printk(KERN_INFO, sdev, "scsi scan:"
+				   " peripheral qualifier of 3, device not"
+				   " added\n"))
+		if (lun =3D=3D 0) {
+			SCSI_LOG_SCAN_BUS(1, {
+				unsigned char vend[9];
+				unsigned char mod[17];
+
+				sdev_printk(KERN_INFO, sdev,
+					"scsi scan: consider passing scsi_mod."
+					"dev_flags=3D%s:%s:0x240 or 0x1000240\n",
+					scsi_inq_str(vend, result, 8, 16),
+					scsi_inq_str(mod, result, 16, 32));
+			});
+		}
+	=09
 		res =3D SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
 	}
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--m1UC1K4AOz1Ywdkx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEVVtcxmLh6hyYd04RAlP9AKDC61sEWqPSC7sBw8xJlCXM9XJYZwCgs7Ry
U2g+rZVz5Cb5ybJiaLw6BoU=
=FV2v
-----END PGP SIGNATURE-----

--m1UC1K4AOz1Ywdkx--
