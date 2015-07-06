From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/9] scsi_dh: don't allow to detach device handlers at runtime
Date: Mon,  6 Jul 2015 16:15:04 +0200
Message-ID: <1436192105-44064-9-git-send-email-hare@suse.de>
References: <1436192105-44064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbGFOPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 10:15:11 -0400
In-Reply-To: <1436192105-44064-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>

From: Christoph Hellwig <hch@lst.de>

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
1.8.5.2

