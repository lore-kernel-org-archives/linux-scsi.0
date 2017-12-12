From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] scsi: add missing get_device() return value checks
Date: Tue, 12 Dec 2017 09:57:51 +0100
Message-ID: <1513069072-32514-4-git-send-email-hare@suse.de>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46995 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752262AbdLLI55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:57:57 -0500
In-Reply-To: <1513069072-32514-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We need to validate that get_device() succeeded, otherwise
we'll end up working with invalid devices.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_scan.c | 14 ++++++++++++--
 drivers/scsi/sd.c        |  8 +++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index be5e919..18edfd7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -245,6 +245,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
+	if (!sdev->sdev_gendev.parent) {
+		kfree(sdev);
+		return NULL;
+	}
 	sdev->sdev_target = starget;
 
 	/* usually NULL and set by ->slave_alloc instead */
@@ -366,7 +370,8 @@ static struct scsi_target *__scsi_find_target(struct device *parent,
 		}
 	}
 	if (found_starget)
-		get_device(&found_starget->dev);
+		if (!get_device(&found_starget->dev))
+			found_starget = NULL;
 
 	return found_starget;
 }
@@ -436,6 +441,10 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	device_initialize(dev);
 	kref_init(&starget->reap_ref);
 	dev->parent = get_device(parent);
+	if (!dev->parent) {
+		kfree(starget);
+		return NULL;
+	}
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
@@ -469,7 +478,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 			return NULL;
 		}
 	}
-	get_device(dev);
+	/* No good way to recover here; keep fingers crossed */
+	WARN_ON(!get_device(dev));
 
 	return starget;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 228b0b62..abbab17 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -619,10 +619,12 @@ static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
 
 	if (disk->private_data) {
 		sdkp = scsi_disk(disk);
-		if (scsi_device_get(sdkp->device) == 0)
-			get_device(&sdkp->dev);
-		else
+		if (scsi_device_get(sdkp->device))
+			sdkp = NULL;
+		else if (!get_device(&sdkp->dev)) {
+			scsi_device_put(sdkp->device);
 			sdkp = NULL;
+		}
 	}
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
-- 
1.8.5.6
