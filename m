From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] scsi_dh: don't allow to detach device handlers at runtime
Date: Sun, 10 May 2015 20:41:00 +0200
Message-ID: <1431283260-13406-9-git-send-email-hch@lst.de>
References: <1431283260-13406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbEJSml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2015 14:42:41 -0400
In-Reply-To: <1431283260-13406-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

The I/O submission and completion pathes call into the device handler
without any synchronization agains detachment.  So disallow detaching
device handlers at runtime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_dh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 8cae1c9..336dc54 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -179,8 +179,9 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 			/*
 			 * Detach from a device handler
 			 */
-			scsi_dh_handler_detach(sdev);
-			err = 0;
+			sdev_printk(KERN_WARNING, sdev,
+				"can't detach handler %s.\n", buf);
+			err = -EINVAL;
 		} else if (!strncmp(buf, "activate", 8)) {
 			/*
 			 * Activate a device handler
-- 
1.9.1

