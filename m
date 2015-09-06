From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 2/6] SCSI: Update sd driver to use new ida helper functions
Date: Sun,  6 Sep 2015 10:59:30 -0700
Message-ID: <41766f9cdb4b831c310413203b41f57bb784ef24.1441416572.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbbIFR7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 13:59:45 -0400
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

This simplifies the calling sequence to
acquire and to release an ida-managed index.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/sd.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4fada0..0f855e48bc1d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2948,15 +2948,7 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	do {
-		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
-			goto out_put;
-
-		spin_lock(&sd_index_lock);
-		error = ida_get_new(&sd_index_ida, &index);
-		spin_unlock(&sd_index_lock);
-	} while (error == -EAGAIN);
-
+	error = ida_get_index(&sd_index_ida, &sd_index_lock, &index);
 	if (error) {
 		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
 		goto out_put;
@@ -3001,9 +2993,7 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	ida_put_index(&sd_index_ida, &sd_index_lock, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -3064,9 +3054,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
+	ida_put_index(&sd_index_ida, &sd_index_lock, sdkp->index);
 
 	blk_integrity_unregister(disk);
 	disk->private_data = NULL;
-- 
2.1.4

