From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] fix access_count check in scsi_remove_device
Date: Mon, 29 Sep 2003 16:38:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030929163804.A27526@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:51371 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262989AbTI2XiJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 19:38:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Patch against 2.6.0-test6.

Add a missing '!' to the check of access_count in scsi_remove_device.

Hit this while trying to delete a scsi_device via sysfs, the first delete
had no affect, and left the sysfs scsi_device in place, a second delete
oopsed.

--- bleed-2.5/drivers/scsi/scsi_sysfs.c-orig	Mon Sep 29 12:21:09 2003
+++ bleed-2.5/drivers/scsi/scsi_sysfs.c	Mon Sep 29 16:19:22 2003
@@ -412,7 +412,7 @@
 		set_bit(SDEV_DEL, &sdev->sdev_state);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		if (atomic_read(&sdev->access_count))
+		if (!atomic_read(&sdev->access_count))
 			device_del(&sdev->sdev_gendev);
 		up_write(&class->subsys.rwsem);
 	}

-- Patrick Mansfield
