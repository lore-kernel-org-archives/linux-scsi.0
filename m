From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix scsi add-single-device
Date: 26 Jan 2003 12:00:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043604061.12324.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ppDl/KKb4jsUN5NdsXiL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA31552
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jan 2003 10:01:03 -0800
Received: from mulgrave-w.il.steeleye.com (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id KAA31403
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jan 2003 10:01:00 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-ppDl/KKb4jsUN5NdsXiL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



There was a logic typo in the abstraction of scsi_add_single_device()
that meant it could never work.

The attached patch fixes it.

James


--=-ppDl/KKb4jsUN5NdsXiL
Content-Description: 
Content-Disposition: attachment; filename=scsi.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=ISO-8859-1

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher=
.
# This patch includes the following deltas:
#	           ChangeSet	1.958   -> 1.959 =20
#	drivers/scsi/scsi_scan.c	1.52    -> 1.53  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/01/26	jejb@mulgrave.(none)	1.959
# [SCSI] make echo scsi add-single-device x x x x > /proc/scsi/scsi work ag=
ain
#=20
# Correct the logic error making it fail
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sun Jan 26 11:58:46 2003
+++ b/drivers/scsi/scsi_scan.c	Sun Jan 26 11:58:46 2003
@@ -1758,7 +1758,7 @@
 	shost =3D scsi_host_hn_get(host);
 	if (!shost)
 		return -ENODEV;
-	if(scsi_find_device(shost, channel, id, lun) !=3D NULL)
+	if(scsi_find_device(shost, channel, id, lun) =3D=3D NULL)
 		goto out;
=20
 	if (scsi_probe_and_add_lun(shost, NULL, channel, id, lun, NULL) =3D=3D

--=-ppDl/KKb4jsUN5NdsXiL--

