From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] sysfs: unique_id in hex
Date: Mon, 9 Feb 2004 16:56:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209155619.GR3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KAk/33nSS6LK84p9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:62893 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262128AbUBIQBT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 11:01:19 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>


--KAk/33nSS6LK84p9
Content-Type: multipart/mixed; boundary="7Rldj+JZnTQmDdGi"
Content-Disposition: inline


--7Rldj+JZnTQmDdGi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

the unique ID field is filled by most host adapters with their IO port.
The io port is printed in hex in /proc/ioports.
Thus we should probably do the same in
sys/classes/scsi_host/hostX/unique_id

Consider applying the attached patch.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--7Rldj+JZnTQmDdGi
Content-Type: text/plain; charset=us-ascii
Content-Description: scsi_sysfs-uniqueid-hex.diff
Content-Disposition: attachment; filename="scsi_sysfs-uniqueid-hex.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/scsi_sysfs.c	2004-02-09 16:29:30.226170112 +0100
+++ drivers/scsi/scsi_sysfs.c.new	2004-02-09 16:30:31.640833664 +0100
@@ -94,7 +94,7 @@
 };
 static CLASS_DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
=20
-shost_rd_attr(unique_id, "%u\n");
+shost_rd_attr(unique_id, "0x%x\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");

--7Rldj+JZnTQmDdGi--

--KAk/33nSS6LK84p9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ62ixmLh6hyYd04RAmTLAJ4pExPYgfJWVjtCOqmN9CAB6yKMmwCgo8oK
lh8Cx/T16fbb1iIvy2B66GE=
=ek4H
-----END PGP SIGNATURE-----

--KAk/33nSS6LK84p9--
