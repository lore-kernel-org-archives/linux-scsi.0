From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] 6/6: llun_blklst
Date: Sun, 18 Apr 2004 21:00:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418190004.GI4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K1SnTjlYS/YgcDEx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:60325 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263632AbUDRTAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:00:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--K1SnTjlYS/YgcDEx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Feature.

This patch alloes the user to set the flags BLIST_LARGELUN|BLIST_SPARSELUN =
for
single devices (up to 8) by specifying=20
llun_blklst=3DC,B,T[C,B,T[,...]
where C,B,T is the host controller number, the channel number and the SCSI =
target
ID of the SCSI device resp.

This is mainly useful for arrays that report as SCSI-2, where REPORT_LUNS i=
s=20
not used. It's more selective than the global scsi_sparselun and _largelun
paramters.

--- linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c.orig	2004-04-16 19:30=
:43.289826000 +0200
+++ linux-2.6.5.noreplunhost/drivers/scsi/scsi_scan.c	2004-04-16 19:45:53.4=
81044579 +0200
@@ -142,6 +142,56 @@ MODULE_PARM_DESC(scsi_inq_timeout,=20
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 6. Some non-compliant devices need more.");
=20
+#define MAX_LLUN_BLKLEN 8
+static int llun_blklst[3*MAX_LLUN_BLKLEN] =3D {
+	-1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1 };
+
+MODULE_PARM(llun_blklst, "3-24i");
+MODULE_PARM_DESC(llun_blklst, "SCSI-2 devs (C,B,T) that need LARGELUN|SPAR=
SELUN support");
+
+static int __init llun_blklst_setup(char *str)
+{
+	unsigned int tmp;
+	int i =3D 0;
+	do {
+		int rc;
+		if (get_option(&str, &tmp) =3D=3D 2)
+			llun_blklst[i++] =3D tmp;
+		else=20
+			break;
+		if (get_option(&str, &tmp) =3D=3D 2)
+			llun_blklst[i++] =3D tmp;
+		else=20
+			break;
+		if ((rc =3D get_option(&str, &tmp)) >=3D 1)
+			llun_blklst[i++] =3D tmp;
+		if (rc !=3D 2)
+			break;
+	} while (1);
+	return i;
+}
+__setup("llun_blklst=3D", llun_blklst_setup);
+
+static inline int is_on_llun_blklst (int hostno, int channel, int target)
+{
+	int i;
+	for (i =3D 0; i < MAX_LLUN_BLKLEN; ++i) {
+		if (llun_blklst[i*3] =3D=3D -1)
+			break;
+		if (llun_blklst[i*3+0] =3D=3D hostno  &&
+		    llun_blklst[i*3+1] =3D=3D channel &&
+		    llun_blklst[i*3+2] =3D=3D target) {
+			printk (KERN_DEBUG "Found c%ib%it%i on llun_blklst\n",
+				hostno, channel, target);
+			return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sreq:	used to send the command
@@ -847,7 +897,8 @@ static void scsi_sequential_lun_scan(str
 	 * override the other settings, and scan all of them. Normally,
 	 * SCSI-3 devices should be scanned via the REPORT LUNS.
 	 */
-	if (bflags & BLIST_SPARSELUN || scsi_sparselun) {
+	if (bflags & BLIST_SPARSELUN || scsi_sparselun ||=20
+	    is_on_llun_blklst(shost->host_no, channel, id)) {
 		max_dev_lun =3D min(shost->max_lun, max_scsi_sparseluns?=20
 				  max_scsi_sparseluns: max_scsi_luns);
 		sparse_lun =3D 1;
@@ -893,7 +944,8 @@ static void scsi_sequential_lun_scan(str
 	 * Do not scan SCSI-2 or lower device past LUN 7, unless
 	 * BLIST_LARGELUN.
 	 */
-	if (scsi_level < SCSI_3 && !(bflags & BLIST_LARGELUN) && !scsi_largelun)
+	if (scsi_level < SCSI_3 && !(bflags & BLIST_LARGELUN) && !scsi_largelun &&
+	    !is_on_llun_blklst(shost->host_no, channel, id))
 		max_dev_lun =3D min(8U, max_dev_lun);
=20
 	/*
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--K1SnTjlYS/YgcDEx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgtA0xmLh6hyYd04RAn3TAJ9+9GYIRkC+EYOpEh7tDGcc0tp0vwCePMcn
wlLI8Ymex/y3hJC9ZGJLdtM=
=Ec0V
-----END PGP SIGNATURE-----

--K1SnTjlYS/YgcDEx--
