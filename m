From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] Scsi_Disk struct
Date: Sun, 14 Jul 2002 00:09:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020713220932.GA22674@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Dave Jones <davej@suse.de>


--KDt/GgjP6HVcx58l
Content-Type: multipart/mixed; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

looking at sd.h, struct scsi_disk, I guess I'm looking at code back from
1992. The author obviously did not have 64bit archs in mind. A pointer (8b)
after an unsigned (4b) :-O

The attached patch does reduce the size from 13(->16) to 11(->12) on 32bit
archs and from 21(->24) to 15(->16) bytes on 64bit archs.
Makes 512 saved bytes for 32bit and 1024 saved bytes on 64bit archs for 128
SCSI disks (which is currently max.)
Not a whole lot, but will also save some cache lines on heavy I/O.

Patch against 2.4.19rc1.
Similar patch against 2.5 trivial ...

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-sd-struct-2419rc1.diff"
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.18.S18.scsiswitch/drivers/scsi/sd.h	Sat Jul 13 19:21:42 2002
+++ linux-2.4.18.S18.scsimany/drivers/scsi/sd.h	Sat Jul 13 23:14:46 2002
@@ -24,13 +24,13 @@
 #endif
=20
 typedef struct scsi_disk {
-	unsigned capacity;	/* size in blocks */
 	Scsi_Device *device;
-	unsigned char ready;	/* flag ready for FLOPTICAL */
-	unsigned char write_prot;	/* flag write_protect for rmvable dev */
-	unsigned char sector_bit_size;	/* sector_size =3D 2 to the  bit size powe=
r */
-	unsigned char sector_bit_shift;		/* power of 2 sectors per FS block */
+	unsigned capacity;		/* size in blocks */
+	unsigned char sector_bit_size;	/* sector_size =3D 2 to the bit size power=
 */
+	unsigned char sector_bit_shift;	/* power of 2 sectors per FS block */
 	unsigned has_part_table:1;	/* has partition table */
+	unsigned ready:1;		/* flag ready for FLOPTICAL */
+	unsigned write_prot:1;		/* flag write_protect for rmvable dev */
 } Scsi_Disk;
=20
 extern int revalidate_scsidisk(kdev_t dev, int maxusage);

--SkvwRMAIpAhPCcCJ--

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9MKUcxmLh6hyYd04RAhc4AJ0e44gHZQldLUhnT/FC1Y968eu2QgCgzczU
SLwpAJwvYWHRbcySpUpf3A4=
=NqEE
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
