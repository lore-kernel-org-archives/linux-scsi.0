From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: handle ->slave_configure return value
Date: Fri, 17 Feb 2006 12:11:29 +0100
Message-ID: <20060217111128.GA28379@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:4842 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750954AbWBQLLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 06:11:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

When =AD>slave_configure fails the scsi midlayer should handle it.


Index: linux-2.6/drivers/scsi/scsi_scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/scsi/scsi_scan.c	2006-01-15 21:45:28.0000000=
00 +0100
+++ linux-2.6/drivers/scsi/scsi_scan.c	2006-02-14 20:35:30.000000000 +0=
100
@@ -770,8 +770,20 @@
=20
 	transport_configure_device(&sdev->sdev_gendev);
=20
-	if (sdev->host->hostt->slave_configure)
-		sdev->host->hostt->slave_configure(sdev);
+	if (sdev->host->hostt->slave_configure) {
+		int ret =3D sdev->host->hostt->slave_configure(sdev);
+		if (ret) {
+			/*
+			 * if LLDD reports slave not present, don't clutter
+			 * console with alloc failure messages
+			 */
+			if (ret !=3D -ENXIO) {
+				sdev_printk(KERN_ERR, sdev,
+					"failed to configure device\n");
+			}
+			return SCSI_SCAN_NO_RESPONSE;
+		}
+	}
=20
 	/*
 	 * Ok, the device is now all set up, we can
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
