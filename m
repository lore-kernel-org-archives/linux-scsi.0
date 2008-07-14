From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] sd: update index allocation and use ida instead of idr
Date: Mon, 14 Jul 2008 14:59:30 +0900
Message-ID: <487AEB42.8020209@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYGNF7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 01:59:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>

Update index allocation as follows.

* sd_index_idr is used only for ID allocation and mapping
  functionality is not used.  Use more memory efficient ida instead.

* idr and ida have their own locks inside them and don't need them for
  operation.  Drop it.

* index wasn't freed if probing failed after index allocation.  fix
  it.

* ida allocation should be repeated if it fails with -EAGAIN.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
This patch will be depended on by later block layer updates.  If the
block layer changes get acked.  I think it'll be best to route this
patch through blk tree.  Thanks.

 drivers/scsi/sd.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..c330f16 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -99,8 +99,7 @@ static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
-static DEFINE_IDR(sd_index_idr);
-static DEFINE_SPINLOCK(sd_index_lock);
+static DEFINE_IDA(sd_index_ida);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
@@ -1646,18 +1645,20 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	if (!idr_pre_get(&sd_index_idr, GFP_KERNEL))
-		goto out_put;
+	do {
+		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
+			goto out_put;
 
-	spin_lock(&sd_index_lock);
-	error = idr_get_new(&sd_index_idr, NULL, &index);
-	spin_unlock(&sd_index_lock);
+		error = ida_get_new(&sd_index_ida, &index);
+	} while (error == -EAGAIN);
 
-	if (index >= SD_MAX_DISKS)
-		error = -EBUSY;
 	if (error)
 		goto out_put;
 
+	error = -EBUSY;
+	if (index >= SD_MAX_DISKS)
+		goto out_free_index;
+
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1678,7 +1679,7 @@ static int sd_probe(struct device *dev)
 	strncpy(sdkp->dev.bus_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
 
 	if (device_add(&sdkp->dev))
-		goto out_put;
+		goto out_free_index;
 
 	get_device(&sdp->sdev_gendev);
 
@@ -1720,6 +1721,8 @@ static int sd_probe(struct device *dev)
 
 	return 0;
 
+ out_free_index:
+	ida_remove(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -1769,9 +1772,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	idr_remove(&sd_index_idr, sdkp->index);
-	spin_unlock(&sd_index_lock);
+	ida_remove(&sd_index_ida, sdkp->index);
 
 	disk->private_data = NULL;
 	put_disk(disk);
-- 
1.5.4.5

