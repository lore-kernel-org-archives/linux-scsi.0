From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 2/2] qla1280: Drop host_lock while requesting firmware
Date: Sun, 23 Aug 2009 16:38:22 +0100
Message-ID: <1251041902.16001.251.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Rtbwy6CT1Qk88cCvTkkd"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46254 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521AbZHWPiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Aug 2009 11:38:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Jaswinder Singh Rajput <jaswinderrajput@gmail.com>


--=-Rtbwy6CT1Qk88cCvTkkd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

request_firmware() may sleep and it appears to be safe to release the
spinlock here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Scott Bailey <scott.bailey@hp.com> tested this change to the two
separate functions qla1280_load_firmware_{pio,dma}() in 2.6.30.  I'm not
adding Tested-by since he didn't test this exact code.

Ben.

 drivers/scsi/qla1280.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 4951344..492492d 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1803,8 +1803,10 @@ qla1280_load_firmware(struct scsi_qla_host *ha)
 	if (err)
 		return err;
=20
+	spin_unlock_irq(ha->host->host_lock);
 	err =3D request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
 			       &ha->pdev->dev);
+	spin_lock_irq(ha->host->host_lock);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       ql1280_board_tbl[ha->devnum].fwname, err);
--=20
1.6.3.3


--=-Rtbwy6CT1Qk88cCvTkkd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKkWJp79ZNCRIGYgcRAjQHAKCoOGdxRHNIdmB2IkDQygBm26V+DwCeJ/Hj
gRJ2r5rzcC/QS3mwihPi5uM=
=GbSL
-----END PGP SIGNATURE-----

--=-Rtbwy6CT1Qk88cCvTkkd--
