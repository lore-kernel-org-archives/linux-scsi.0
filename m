From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 1/5] SCSI: sd: simplify ida usage
Date: Thu,  1 Oct 2015 11:59:05 -0700
Message-ID: <c832f76821c18fa953ff539b6e852bfd2cdc24b8.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Simplify ida index allocation and removal by
using the ida_simple_* helper functions.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/sd.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4fada0..3d77ac8f0d4c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -118,7 +118,6 @@ static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(const struct scsi_disk *, const char *, int);
 
-static DEFINE_SPINLOCK(sd_index_lock);
 static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
@@ -2948,19 +2947,12 @@ static int sd_probe(struct device *dev)
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
-	if (error) {
+	error = ida_simple_get(&sd_index_ida, 0, 0, GFP_KERNEL);
+	if (error < 0) {
 		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
 		goto out_put;
 	}
+	index = error;
 
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error) {
@@ -3001,9 +2993,7 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -3064,9 +3054,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
+	ida_simple_remove(&sd_index_ida, sdkp->index);
 
 	blk_integrity_unregister(disk);
 	disk->private_data = NULL;
-- 
2.1.4
