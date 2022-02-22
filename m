Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6699C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiBVOPg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiBVOPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:15:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296C216042B;
        Tue, 22 Feb 2022 06:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qlBq0quQBLmflOWrdVNgjhjHl3CU6RGZgtshLkP6Yq8=; b=HE5QfPbJ7pt1ZIDoQuaVMGBQ3E
        wxdRkVOcC/VESDX5WUBhQZVodmxZtZqv9XY0zft9L/GGadwFeiqe5eNTUpPl94ynR+ymoBaUNsfik
        pS6rDHquJaa1bM00TyGm96Pm6ekSabuV6DvAEwDQOCHiv2Im34mBnIt4OPRM+52LYkukLUshxMne1
        Rnaft6ZyIxcvQt/i3tm0zKbxII2uIDlKXHqZjWnVgttcOw12yh13bvUU6vnek6BVl4b7M8yKvnI6E
        w8U89taI0HzktwRFVosOpDIfJdbn5/eR2fDOdLwvo3ZPDQMj7oKkdCt3rhhkzUvCTqsdarUF1PFH8
        U4IKmgVw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwV-009qFN-3P; Tue, 22 Feb 2022 14:15:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/12] sd: make use of ->free_disk to simplify refcounting
Date:   Tue, 22 Feb 2022 15:14:42 +0100
Message-Id: <20220222141450.591193-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implement the ->free_disk method to to put struct scsi_disk when the last
gendisk reference count goes away.  This removes the need to clear
->private_data and thus freeze the queue on unbind.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 89 ++++++++---------------------------------------
 1 file changed, 15 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2a1e19e871d30..4eaa5deafc3dc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -121,11 +121,6 @@ static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
 
-/* This semaphore is used to mediate the 0->1 reference get in the
- * face of object destruction (i.e. we can't allow a get on an
- * object after last put) */
-static DEFINE_MUTEX(sd_ref_mutex);
-
 static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_cdb_pool;
 static mempool_t *sd_page_pool;
@@ -663,33 +658,6 @@ static int sd_major(int major_idx)
 	}
 }
 
-static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
-{
-	struct scsi_disk *sdkp = NULL;
-
-	mutex_lock(&sd_ref_mutex);
-
-	if (disk->private_data) {
-		sdkp = scsi_disk(disk);
-		if (scsi_device_get(sdkp->device) == 0)
-			get_device(&sdkp->dev);
-		else
-			sdkp = NULL;
-	}
-	mutex_unlock(&sd_ref_mutex);
-	return sdkp;
-}
-
-static void scsi_disk_put(struct scsi_disk *sdkp)
-{
-	struct scsi_device *sdev = sdkp->device;
-
-	mutex_lock(&sd_ref_mutex);
-	put_device(&sdkp->dev);
-	scsi_device_put(sdev);
-	mutex_unlock(&sd_ref_mutex);
-}
-
 #ifdef CONFIG_BLK_SED_OPAL
 static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 		size_t len, bool send)
@@ -1418,17 +1386,15 @@ static bool sd_need_revalidate(struct block_device *bdev,
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct scsi_disk *sdkp = scsi_disk_get(bdev->bd_disk);
-	struct scsi_device *sdev;
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
 	int retval;
 
-	if (!sdkp)
+	if (scsi_device_get(sdev))
 		return -ENXIO;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
 
-	sdev = sdkp->device;
-
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -1473,7 +1439,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 
 error_out:
-	scsi_disk_put(sdkp);
+	scsi_device_put(sdkp->device);
 	return retval;	
 }
 
@@ -1502,7 +1468,7 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
 
-	scsi_disk_put(sdkp);
+	scsi_device_put(sdkp->device);
 }
 
 static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
@@ -1616,7 +1582,7 @@ static int media_not_present(struct scsi_disk *sdkp,
  **/
 static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
-	struct scsi_disk *sdkp = scsi_disk_get(disk);
+	struct scsi_disk *sdkp = disk->private_data;
 	struct scsi_device *sdp;
 	int retval;
 	bool disk_changed;
@@ -1679,7 +1645,6 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	 */
 	disk_changed = sdp->changed;
 	sdp->changed = 0;
-	scsi_disk_put(sdkp);
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
@@ -1887,6 +1852,13 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_clear	= sd_pr_clear,
 };
 
+static void scsi_disk_free_disk(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = disk->private_data;
+
+	put_device(&sdkp->dev);
+}
+
 static const struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
@@ -1898,6 +1870,7 @@ static const struct block_device_operations sd_fops = {
 	.unlock_native_capacity	= sd_unlock_native_capacity,
 	.report_zones		= sd_zbc_report_zones,
 	.get_unique_id		= sd_get_unique_id,
+	.free_disk		= scsi_disk_free_disk,
 	.pr_ops			= &sd_pr_ops,
 };
 
@@ -3623,9 +3596,8 @@ static int sd_probe(struct device *dev)
  **/
 static int sd_remove(struct device *dev)
 {
-	struct scsi_disk *sdkp;
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	sdkp = dev_get_drvdata(dev);
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->dev);
@@ -3634,48 +3606,17 @@ static int sd_remove(struct device *dev)
 
 	free_opal_dev(sdkp->opal_dev);
 
-	mutex_lock(&sd_ref_mutex);
-	dev_set_drvdata(dev, NULL);
 	put_device(&sdkp->dev);
-	mutex_unlock(&sd_ref_mutex);
-
 	return 0;
 }
 
-/**
- *	scsi_disk_release - Called to free the scsi_disk structure
- *	@dev: pointer to embedded class device
- *
- *	sd_ref_mutex must be held entering this routine.  Because it is
- *	called on last put, you should always use the scsi_disk_get()
- *	scsi_disk_put() helpers which manipulate the semaphore directly
- *	and never do a direct put_device.
- **/
 static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
-	struct gendisk *disk = sdkp->disk;
-	struct request_queue *q = disk->queue;
 
 	ida_free(&sd_index_ida, sdkp->index);
-
-	/*
-	 * Wait until all requests that are in progress have completed.
-	 * This is necessary to avoid that e.g. scsi_end_request() crashes
-	 * due to clearing the disk->private_data pointer. Wait from inside
-	 * scsi_disk_release() instead of from sd_release() to avoid that
-	 * freezing and unfreezing the request queue affects user space I/O
-	 * in case multiple processes open a /dev/sd... node concurrently.
-	 */
-	blk_mq_freeze_queue(q);
-	blk_mq_unfreeze_queue(q);
-
-	disk->private_data = NULL;
-	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
-
 	sd_zbc_release_disk(sdkp);
-
 	kfree(sdkp);
 }
 
-- 
2.30.2

