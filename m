From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/11] Improve error messages in scsi_sysfs_add_sdev()
Date: Mon, 18 Jun 2007 11:01:35 +0200
Message-ID: <20070618090135.353ADD44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbXFRJBg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:01:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


When we fail to add a device to the driver core, only the very
helpful message 'error X' is displayed.
Print out some meaningful messages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed72086..a31104f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -721,12 +721,14 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		put_device(sdev->sdev_gendev.parent);
-		printk(KERN_INFO "error 1\n");
+		sdev_printk(KERN_INFO, sdev,
+			    "failed to add device (error %d)\n", error);
 		return error;
 	}
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
-		printk(KERN_INFO "error 2\n");
+		sdev_printk(KERN_INFO, sdev,
+			    "failed to add class device (error %d)\n", error);
 		goto clean_device;
 	}
 
-- 
1.4.3.4

