From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] add back the missing ->slave_destroy call
Date: Sun, 21 Sep 2003 17:48:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030921154839.GA7125@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:25488 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262449AbTIUPss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Sep 2003 11:48:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Looks like the merge error still isn't fixed..


--- 1.32/drivers/scsi/scsi_sysfs.c	Sun Sep 21 10:22:28 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Sun Sep 21 10:36:43 2003
@@ -410,6 +410,8 @@
 	if (class) {
 		down_write(&class->subsys.rwsem);
 		set_bit(SDEV_DEL, &sdev->sdev_state);
+		if (sdev->host->hostt->slave_destroy)
+			sdev->host->hostt->slave_destroy(sdev);
 		if (atomic_read(&sdev->access_count))
 			device_del(&sdev->sdev_gendev);
 		up_write(&class->subsys.rwsem);
