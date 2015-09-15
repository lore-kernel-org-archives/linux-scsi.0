From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 13/17] Update the SCSI disk driver to use ida helper functions.
Date: Tue, 15 Sep 2015 09:46:13 -0700
Message-ID: <e21b683ed63452966a04fab599f5626b66fbe5ba.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/sd.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4fada0..60b2ad918208 100644
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
@@ -3063,10 +3053,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
-	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
+
+	ida_put_index(&sd_index_ida, &sd_index_lock, sdkp->index);
 
 	blk_integrity_unregister(disk);
 	disk->private_data = NULL;
-- 
2.1.4
