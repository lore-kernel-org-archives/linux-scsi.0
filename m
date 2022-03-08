Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F340C4321E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbiCHFxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237449AbiCHFxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BF11FCC6;
        Mon,  7 Mar 2022 21:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hJeqyUHmsPbFplsMKP9CPrSZ3RWVJMmkYTfvXkgnPLQ=; b=MgPJ99B2Y1kJHvenp1BerxyymB
        3+/goUuNgPu3GYVBgM3pzHnIPpt03PmMdeH9jGkYGVhsBtTSyuG12QIN21iIEQOPggemtgnBq8f+1
        Ir+xdXSZvewc5Bwjxf/bRy4P4RfqkvcKJLlUE3QO3tKnUzMZm8vuxPEV6lw3uSEUf0quXjoB/isDm
        7lzg8MLVrlOV+s8AI7sqdTGrQE0tLs/i7G9FFPIWVEHM2GLaquKBjSFKj2ZjevDo2cf8fyA+3JsJP
        dqLAWBQaBGpxAyY0aw65gy/v0NJBuyhd752HLegJf2J2ojVdKgZ7v45VT8Df3roK0c3xV/oFz/Nzc
        NWWkZdCg==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSlY-002ilQ-ER; Tue, 08 Mar 2022 05:52:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 04/14] sd: rename the scsi_disk.dev field
Date:   Tue,  8 Mar 2022 06:51:50 +0100
Message-Id: <20220308055200.735835-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308055200.735835-1-hch@lst.de>
References: <20220308055200.735835-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dev is very hard to grep for.  Give the field a more descriptive name and
documents its purpose.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 22 +++++++++++-----------
 drivers/scsi/sd.h |  9 +++++++--
 2 files changed, 18 insertions(+), 13 deletions(-)

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
index 303aa1c23aefb..0a33a4b68ffbc 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -69,7 +69,12 @@ enum {
 
 struct scsi_disk {
 	struct scsi_device *device;
-	struct device	dev;
+
+	/*
+	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
+	 * but otherwise not really needed.  Do not use for refcounting.
+	 */
+	struct device	disk_dev;
 	struct gendisk	*disk;
 	struct opal_dev *opal_dev;
 #ifdef CONFIG_BLK_DEV_ZONED
@@ -126,7 +131,7 @@ struct scsi_disk {
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 };
-#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
+#define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
-- 
2.30.2

