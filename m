From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 12:26:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210112658.GC4010@tpkurt.garloff.de>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:24003 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265828AbUBJLcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 06:32:31 -0500
Content-Disposition: inline
In-Reply-To: <20040210110417.GB4010@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>


--6WlEvdN9Dv0WHSBl
Content-Type: multipart/mixed; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 10, 2004 at 12:04:17PM +0100, Kurt Garloff wrote:
> Hi Andrew,
>=20
> On Wed, Feb 04, 2004 at 02:45:12AM -0800, Andrew Morton wrote:
> > What to do about this?
>=20
> Apply my patch ;-)
>=20
> Find attached a patch that combines Badari's and Matthew's ideas.
> It corrects the typos in Matthew's code snippets.

Only that the patch was not attached.

Regadrs,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi-many-26.diff
Content-Disposition: attachment; filename="scsi-many-26.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/sd.c.orig	2004-01-09 07:59:49.000000000 +0100
+++ drivers/scsi/sd.c	2004-02-10 09:44:24.913264768 +0100
@@ -19,6 +19,9 @@
  *	   not being read in sd_open. Fix problem where removable media=20
  *	   could be ejected after sd_open.
  *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5.x
+ *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox=20
+ *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>:=20
+ *	   Support 256k disks (with potentially 64 partitions, TBD).
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
  *	 - setting up transfer: SCSI_LOG_HLQUEUE levels 1 and 2
@@ -61,7 +64,16 @@
  * Remaining dev_t-handling stuff
  */
 #define SD_MAJORS	16
-#define SD_DISKS	(SD_MAJORS << 4)
+/* sd_index_bits array size / disks
+ * 			32  /    256
+ * 		      4096  /  32768
+ * 		     32768  / 262144
+ */
+#ifdef CONFIG_EMBEDDED
+# define SD_DISKS	256
+#else
+# define SD_DISKS	32768	// we can raise this to 262144 if needed
+#endif
=20
 /*
  * Time out in seconds for disks and Magneto-opticals (which are slower).
@@ -121,6 +132,22 @@
 	.init_command		=3D sd_init_command,
 };
=20
+/* Major / minor to disk mapping, from Matthew Wilcox, corrected
+ * (mail to linux-scsi@vger.kernel.org from 2003-10-16)
+ *=20
+ *       major     p2    disc2   disc  p1
+ *   |............|..|..........|....|....| <- dev_t
+ *    31        20    17       8 7  4 3  0
+ *=20
+ * We allow 64 partitions per disk, by adding two more bits.
+ * Inside a major, we have 16k disks, however mapped non-
+ * contiguously. The first 16 disks are for major0, the next
+ * ones with major1, ... Disk 256 is for major0 again, disk 272=20
+ * for major1, ...=20
+ * We can't currently use the partitions beyond 16, as the
+ * genhd infrastructure expects contiguous minors.
+ */
+
 static int sd_major(int major_idx)
 {
 	switch (major_idx) {
@@ -136,6 +163,35 @@
 	}
 }
=20
+static int inv_sd_major(int major)
+{
+	switch (major) {
+	case SCSI_DISK0_MAJOR:
+		return 0;
+	case SCSI_DISK1_MAJOR ... SCSI_DISK7_MAJOR:
+		return major + 1 - SCSI_DISK1_MAJOR;
+	case SCSI_DISK8_MAJOR ... SCSI_DISK15_MAJOR:
+		return major + 8 - SCSI_DISK8_MAJOR;
+	default:
+		BUG();
+		return 0;	/* shut up gcc */
+	}
+}
+
+unsigned int dev_to_sd_nr(unsigned int dev) {
+	return  ((dev >> 4) & 15) | (inv_sd_major(dev >> 20) << 4) |
+		(dev & 0x3ff00);
+}
+
+unsigned int dev_to_sd_part(unsigned int dev) {
+	return  (dev & 15) | ((dev >> 14) & 0x30);
+}
+
+unsigned int make_sd_dev(unsigned int sd_nr, unsigned int part) {
+	return  (part & 0xf) | ((part & 0x30) << 14) | ((sd_nr & 0xf) << 4) |
+		(sd_major((sd_nr & 0xf0) >> 4) << 20) | (sd_nr & 0x3ff00);
+}
+
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kobj);
=20
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
@@ -1297,7 +1353,7 @@
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	u32 index;
-	int error;
+	int error, devno;
=20
 	error =3D -ENODEV;
 	if ((sdp->type !=3D TYPE_DISK) && (sdp->type !=3D TYPE_MOD))
@@ -1315,6 +1371,12 @@
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
@@ -1335,16 +1397,23 @@
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

--aT9PWwzfKXlsBJM1--

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKMABxmLh6hyYd04RAtIdAJ9qrS91xy1O2GLTH8bqPVqL3HQEegCfQ0rC
cMZjk5HjCbi8GOUAZgbqigo=
=Q84w
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
