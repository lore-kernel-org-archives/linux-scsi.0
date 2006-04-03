From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH 2/3] Better log messages for PQ3 devs
Date: Mon, 3 Apr 2006 15:18:35 +0200
Message-ID: <20060403131835.GY26303@tpkurt.garloff.de>
References: <20060329201020.GG7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aQ0PHH3iiKbaMI5N"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:38790 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751554AbWDCNSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 09:18:38 -0400
Content-Disposition: inline
In-Reply-To: <20060329201020.GG7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>


--aQ0PHH3iiKbaMI5N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

wrapped the lines at column 80 as suggested by Matthew and used
sedv_printk as suggested by James.

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Tolerate PQ 3 at LUN 0 for scanning
Patch-mainline:=20
References: 158532

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

This patch 2/3:
If a PQ3 device is found, log a message that describes the device
(INQUIRY DATA and C:B:T:U tuple) and make a suggestion for blacklisting
it.

Acked-by:=20
Signed-off-by: Kurt Garloff <garloff@suse.de>

Index: linux-2.6.16/drivers/scsi/scsi_scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.16.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.16/drivers/scsi/scsi_scan.c
@@ -795,8 +795,31 @@ static inline void scsi_destroy_sdev(str
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 }
=20
+/**=20
+ * scsi_inq_str - print INQUIRY data from min to max index,
+ * strip trailing whitespace
+ * @buf:   Output buffer with at least end-first+1 bytes of space
+ * @inq:   Inquiry buffer (input)
+ * @first: Offset of string into inq
+ * @end:   Index after last character in inq
+ */
+static unsigned char* scsi_inq_str(unsigned char* buf, unsigned char *inq,
+				   unsigned first, unsigned end)
+{
+	unsigned term =3D 0, idx;
+	for (idx =3D 0; idx+first < end && idx+first < inq[4]+5; ++idx) {
+		if (inq[idx+first] > 0x20) {
+			buf[idx] =3D inq[idx+first];
+			term =3D idx+1;
+		} else {
+			buf[idx] =3D ' ';
+		}
+	}
+	buf[term] =3D 0;
+	return buf;
+}
=20
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
@@ -875,11 +898,20 @@ static int scsi_probe_and_add_lun(struct
 		 * For disks, this implies that there is no
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
+			unsigned char vend[9], mod[17];
+			SCSI_LOG_SCAN_BUS(1, sdev_printk(KERN_INFO, sdev,
+					"scsi scan: consider passing scsi_mod."
+					"dev_flags=3D%s:%s:0x240 or 0x800240\n",
+					scsi_inq_str(vend, result, 8, 16),
+					scsi_inq_str(mod, result, 16, 32)));
+		}
+	=09
 		res =3D SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
 	}
=20
--=20
Kurt Garloff, Head Architect Linux R&D, Novell Inc.

--aQ0PHH3iiKbaMI5N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEMSCrxmLh6hyYd04RAtKEAJ45NQFa/vo/tp+iinQfHkgchmy5FQCfb0yW
hn4xcAU6nwZ3BtNwY211aTU=
=Ti98
-----END PGP SIGNATURE-----

--aQ0PHH3iiKbaMI5N--
