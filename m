From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Fri, 13 Feb 2004 01:05:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213000538.GA2400@tpkurt.garloff.de>
References: <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:64901 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266585AbUBMAFm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 19:05:42 -0500
Content-Disposition: inline
In-Reply-To: <20040212150035.GN1780@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com


--XOIedfhf+7KOe/yw
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2004 at 04:00:35PM +0100, Kurt Garloff wrote:
> Expect a patch later.=20

Attached.
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi-many-26-4.diff
Content-Disposition: attachment; filename="scsi-many-26-4.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/sd.c.orig	2004-01-09 07:59:49.000000000 +0100
+++ drivers/scsi/sd.c	2004-02-13 00:58:05.000000000 +0100
@@ -19,6 +19,9 @@
  *	   not being read in sd_open. Fix problem where removable media=20
  *	   could be ejected after sd_open.
  *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5.x
+ *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox=20
+ *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>:=20
+ *	   Support 32k/1M disks.
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
  *	 - setting up transfer: SCSI_LOG_HLQUEUE levels 1 and 2
@@ -61,7 +64,7 @@
  * Remaining dev_t-handling stuff
  */
 #define SD_MAJORS	16
-#define SD_DISKS	(SD_MAJORS << 4)
+#define SD_DISKS	32768	/* anything between 256 and 262144 */
=20
 /*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
@@ -121,6 +124,20 @@
 	.init_command		=3D sd_init_command,
 };
=20
+/* Device no to disk mapping:
+ *=20
+ *       major         disc2     disc  p1
+ *   |............|.............|....|....| <- dev_t
+ *    31        20 19          8 7  4 3  0
+ *=20
+ * Inside a major, we have 16k disks, however mapped non-
+ * contiguously. The first 16 disks are for major0, the next
+ * ones with major1, ... Disk 256 is for major0 again, disk 272=20
+ * for major1, ...=20
+ * As we stay compatible with our numbering scheme, we can reuse=20
+ * the well-know SCSI majors 8, 65--71, 136--143.
+ */
+
 static int sd_major(int major_idx)
 {
 	switch (major_idx) {
@@ -136,6 +153,14 @@
 	}
 }
=20
+static unsigned int make_sd_dev(unsigned int sd_nr, unsigned int part)
+{
+	return  (part & 0xf) | ((sd_nr & 0xf) << 4) |
+		(sd_major((sd_nr & 0xf0) >> 4) << 20) | (sd_nr & 0xfff00);
+}
+
+/* reverse mapping dev -> (sd_nr, part) not currently needed */
+
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kobj);
=20
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
@@ -1297,7 +1322,7 @@
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	u32 index;
-	int error;
+	int error, devno;
=20
 	error =3D -ENODEV;
 	if ((sdp->type !=3D TYPE_DISK) && (sdp->type !=3D TYPE_MOD))
@@ -1315,6 +1340,12 @@
 	kobject_init(&sdkp->kobj);
 	sdkp->kobj.ktype =3D &scsi_disk_kobj_type;
=20
+	/* Note: We can accomodate 64 partitions, but the genhd code
+	 * assumes partitions allocate consecutive minors, which they don't.
+	 * So for now stay with max 16 partitions and leave two spare bits.=20
+	 * Later, we may change the genhd code and the alloc_disk() call
+	 * and the ->minors assignment here. 	KG, 2004-02-10
+	 */=20
 	gd =3D alloc_disk(16);
 	if (!gd)
 		goto out_free;
@@ -1335,16 +1366,23 @@
 	sdkp->index =3D index;
 	sdkp->openers =3D 0;
=20
-	gd->major =3D sd_major(index >> 4);
-	gd->first_minor =3D (index & 15) << 4;
+	devno =3D make_sd_dev(index, 0);
+	gd->major =3D MAJOR(devno);
+	gd->first_minor =3D MINOR(devno);
 	gd->minors =3D 16;
 	gd->fops =3D &sd_fops;
=20
-	if (index >=3D 26) {
+	if (index < 26) {
+		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
+	} else if (index < (26*27)) {
 		sprintf(gd->disk_name, "sd%c%c",
-			'a' + index/26-1,'a' + index % 26);
+			'a' + index / 26 - 1,'a' + index % 26);
 	} else {
-		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
+		const unsigned int m1 =3D (index / 26 - 1) / 26 - 1;
+		const unsigned int m2 =3D (index / 26 - 1) % 26;
+		const unsigned int m3 =3D  index % 26;
+		sprintf(gd->disk_name, "sd%c%c%c",
+			'a' + m1, 'a' + m2, 'a' + m3);
 	}
=20
 	strcpy(gd->devfs_name, sdp->devfs_name);

--huq684BweRXVnRxX--

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFALBTSxmLh6hyYd04RAnYpAKCQqDsHSkPdEUuZcJR4grY8+JvLXQCeIr/B
x44wVIGkwBeSVdc70wKb0Ik=
=CWSL
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
