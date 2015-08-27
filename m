From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/10] scsi_dh: don't allow to detach device handlers at runtime
Date: Thu, 27 Aug 2015 14:17:01 +0200
Message-ID: <1440677823-11695-9-git-send-email-hare@suse.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbbH0MRH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:17:07 -0400
In-Reply-To: <1440677823-11695-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

The I/O submission and completion pathes call into the device handler
without any synchronization agains detachment.  So disallow detaching
device handlers at runtime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_dh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 489083c..954ca5e 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -180,8 +180,10 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 			/*
 			 * Detach from a device handler
 			 */
-			scsi_dh_handler_detach(sdev);
-			err = 0;
+			sdev_printk(KERN_WARNING, sdev,
+				    "can't detach handler %s.\n",
+				    sdev->handler->name);
+			err = -EINVAL;
 		} else if (!strncmp(buf, "activate", 8)) {
 			/*
 			 * Activate a device handler
-- 
1.8.5.6

