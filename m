Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74239C43219
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiB0RWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiB0RWi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:22:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A256C958;
        Sun, 27 Feb 2022 09:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wHMk0ScO9g0I2E9THrpBZnshEWpzfzcffqqibI6Z61Q=; b=h14QmrC2AEE1lhF8k3AEQLnIC+
        Drnrb0C4NviKlR23G+hXMtqzL/tvGhyUm5JnFReqoq+nFR/RZqO/mZ9QBQSmHsO7y29PrbUlhjGJX
        cXerzin+WNnEREawZiyusfG2cV/zpkDHLv4xqUp9SL4MJEan02+DoIZQaZDnwGPfPlst0IqmJKp07
        u9LAooJrV6KVmhAvTu+pdo2eAmnSdxuKdlOPOWeTGSvQfHlLoytKL2Bxcf1gbecIRsoV9YXyXI2J0
        xmoG4ShXR2lpVEPKcHVCHrysCMQPVENt0ADe2VlEIkMd8DPsuQ1WRtcBLttAj2RrndFWGuKVRv/bh
        F2MLIVVA==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONF9-009rzF-OC; Sun, 27 Feb 2022 17:22:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/14] sd: rename the scsi_disk.dev field
Date:   Sun, 27 Feb 2022 18:21:34 +0100
Message-Id: <20220227172144.508118-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
References: <20220227172144.508118-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dev is very hard to grab for.  Give the field a more descriptive name and
documents it's purpose.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 22 +++++++++++-----------
 drivers/scsi/sd.h | 10 ++++++++--
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2a1e19e871d30..7479e7cb36b43 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -672,7 +672,7 @@ static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
 	if (disk->private_data) {
 		sdkp = scsi_disk(disk);
 		if (scsi_device_get(sdkp->device) == 0)
-			get_device(&sdkp->dev);
+			get_device(&sdkp->disk_dev);
 		else
 			sdkp = NULL;
 	}
@@ -685,7 +685,7 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	struct scsi_device *sdev = sdkp->device;
 
 	mutex_lock(&sd_ref_mutex);
-	put_device(&sdkp->dev);
+	put_device(&sdkp->disk_dev);
 	scsi_device_put(sdev);
 	mutex_unlock(&sd_ref_mutex);
 }
@@ -3529,14 +3529,14 @@ static int sd_probe(struct device *dev)
 					     SD_MOD_TIMEOUT);
 	}
 
-	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = get_device(dev);
-	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
+	device_initialize(&sdkp->disk_dev);
+	sdkp->disk_dev.parent = get_device(dev);
+	sdkp->disk_dev.class = &sd_disk_class;
+	dev_set_name(&sdkp->disk_dev, "%s", dev_name(dev));
 
-	error = device_add(&sdkp->dev);
+	error = device_add(&sdkp->disk_dev);
 	if (error) {
-		put_device(&sdkp->dev);
+		put_device(&sdkp->disk_dev);
 		goto out;
 	}
 
@@ -3577,7 +3577,7 @@ static int sd_probe(struct device *dev)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
-		put_device(&sdkp->dev);
+		put_device(&sdkp->disk_dev);
 		goto out;
 	}
 
@@ -3628,7 +3628,7 @@ static int sd_remove(struct device *dev)
 	sdkp = dev_get_drvdata(dev);
 	scsi_autopm_get_device(sdkp->device);
 
-	device_del(&sdkp->dev);
+	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
@@ -3636,7 +3636,7 @@ static int sd_remove(struct device *dev)
 
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
-	put_device(&sdkp->dev);
+	put_device(&sdkp->disk_dev);
 	mutex_unlock(&sd_ref_mutex);
 
 	return 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 303aa1c23aefb..7625a90b0fa69 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -69,7 +69,13 @@ enum {
 
 struct scsi_disk {
 	struct scsi_device *device;
-	struct device	dev;
+
+	/*
+	 * This device is mostly just used to show a bunch of attributes in a
+	 * weird place.  In doubt don't add any new users, and most importantly
+	 * don't use if for any actual refcounting.
+	 */
+	struct device	disk_dev;
 	struct gendisk	*disk;
 	struct opal_dev *opal_dev;
 #ifdef CONFIG_BLK_DEV_ZONED
@@ -126,7 +132,7 @@ struct scsi_disk {
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 };
-#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
+#define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
-- 
2.30.2

