From: Paul Wagland <paul@wagland.net>
Subject: [PATCH] fix for missing proc dir in megaraid driver.
Date: Tue, 17 Feb 2004 23:48:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077058085.1897.4.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-37j30UdXesX67PZa9QYL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.xs4all.nl ([194.109.24.11]:51717 "EHLO
	smtp-out1.xs4all.nl") by vger.kernel.org with ESMTP id S266650AbUBQWsK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 17:48:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>


--=-37j30UdXesX67PZa9QYL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This applies against 2.6.2. and resolves the problem of the missing
/proc/megaraid/* entries. The problem was that the megaraid directory
was getting created after it was used. Sometime in the next few days I
will also send through the work I have done to convert to sysfs.

Hope this helps,
Paul
patch follows:


diff --recursive --unified linux-2.6.2/drivers/scsi/megaraid.c linux-2.6.2.=
megaraid/drivers/scsi/megaraid.c
--- linux-2.6.2/drivers/scsi/megaraid.c	2004-02-09 22:56:09.000000000 +0100
+++ linux-2.6.2.megaraid/drivers/scsi/megaraid.c	2004-02-17 23:38:41.000000=
000 +0100
@@ -5118,17 +5118,20 @@
 	if (max_mbox_busy_wait > MBOX_BUSY_WAIT)
 		max_mbox_busy_wait =3D MBOX_BUSY_WAIT;
=20
-	error =3D pci_module_init(&megaraid_pci_driver);
-	if (error)=20
-		return error;
-=09
 #ifdef CONFIG_PROC_FS
 	mega_proc_dir_entry =3D proc_mkdir("megaraid", &proc_root);
 	if (!mega_proc_dir_entry) {
 		printk(KERN_WARNING
 				"megaraid: failed to create megaraid root\n");
 	}
 #endif
+	error =3D pci_module_init(&megaraid_pci_driver);
+	if (error) {
+#ifdef CONFIG_PROC_FS
+		remove_proc_entry("megaraid", &proc_root);
+#endif
+		return error;
+	}
=20
 	/*
 	 * Register the driver as a character device, for applications


--=-37j30UdXesX67PZa9QYL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAMpoltch0EvEFvxURAlOKAJ9Sb8rF1lZ1odAVsICHkikSeSH7iACgojQI
X8be9bIWcdIItey4tL0vSy0=
=UDF2
-----END PGP SIGNATURE-----

--=-37j30UdXesX67PZa9QYL--

