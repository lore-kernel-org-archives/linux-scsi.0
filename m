From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] Make errors printed from scsi_sysfs_add_sdev() mean something.
Date: Tue, 23 Dec 2008 23:19:00 +0100
Message-ID: <20081223221859.GA541@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:47438 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYLWW1y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 17:27:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

This is an updated version of patch I wrote long time ago, but looks li=
ke
it didn't get far. Patch against linux-2.6.git. And yes - printk() line=
s
are longer than 80 chars - it shouldn't matter here (grep is happy ;).

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 93c28f3..7a3389c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -872,12 +872,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	error =3D device_add(&sdev->sdev_gendev);
 	if (error) {
 		put_device(sdev->sdev_gendev.parent);
-		printk(KERN_INFO "error 1\n");
+		printk(KERN_ERR "sysfs: SCSI device registration failed: %d\n", erro=
r);
 		return error;
 	}
 	error =3D device_add(&sdev->sdev_dev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		printk(KERN_ERR "sysfs: SCSI class device registration failed: %d\n"=
, error);
 		goto clean_device;
 	}
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
