From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] sd: Check if parent is still present before proceeding with probing
Date: Tue, 12 Dec 2017 09:57:50 +0100
Message-ID: <1513069072-32514-3-git-send-email-hare@suse.de>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752258AbdLLI55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:57:57 -0500
In-Reply-To: <1513069072-32514-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When a new SCSI disk is created we should be checking if the parent
device is actually present before proceeding with probing.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab75ebd..228b0b62 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3399,6 +3399,10 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
+
+	if (!get_device(dev))
+		goto out_free_index;
+
 	sdkp->dev.parent = dev;
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
@@ -3407,7 +3411,6 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_free_index;
 
-	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-- 
1.8.5.6
