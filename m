From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/9] Improve error messages in scsi_sysfs_add_sdev()
Date: Wed, 23 May 2007 10:55:17 +0200
Message-ID: <20070523085517.187C2D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:49705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762914AbXEWIzW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:55:22 -0400
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
index 67a38a1..2df7108 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -740,12 +740,14 @@ int scsi_sysfs_add_sdev(struct scsi_devi
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

