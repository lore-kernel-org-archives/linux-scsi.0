Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099D6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF6A61244
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhIOJ1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 05:27:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232032AbhIOJ1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 05:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631697963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TKj9UapW4Cs20G2qgKI7vWmWbVaMt9DtUbGdfEmdReY=;
        b=U2idf3GTb6ASRpjIqupyg6ZB+VhhOwDpLYHN4KczC7wawCE8Yj1PBYvhNcbxJTCTnXTSca
        EYWGcI+xI8vTthUC15sg4YcqHZjmaHS5d2BgT95hS0h6yh6hmsC1af4ENnOe95b0qU1gRr
        yMkICuQjDl9+3Ba7duPsphhsHs613uQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-QOXR3RS5MQSfXHKJuKdIUg-1; Wed, 15 Sep 2021 05:26:02 -0400
X-MC-Unique: QOXR3RS5MQSfXHKJuKdIUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6CA51926DA3;
        Wed, 15 Sep 2021 09:26:00 +0000 (UTC)
Received: from localhost (ovpn-12-59.pek2.redhat.com [10.72.12.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A8F60C7F;
        Wed, 15 Sep 2021 09:25:56 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH] scsi: core: cleanup request queue before releasing gendisk
Date:   Wed, 15 Sep 2021 17:25:47 +0800
Message-Id: <20210915092547.990285-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

gendisk instance has to be released after request queue is cleaned up
because bdi is referred from gendisk since commit edb0872f44ec ("block:
move the bdi from the request_queue to the gendisk").

For sd and sr, gendisk can be removed in the release handler(sd_remove/
sr_remove) of sdev->sdev_gendev, which is triggered in device_del(sdev->sdev_gendev)
in __scsi_remove_device(), when the request queue isn't cleaned up yet.

So kernel oops could be triggered when referring bdi via gendisk.

Fix the issue by moving blk_cleanup_queue() into sd_remove() and
sr_remove().

Fixes: edb0872f44ec ("block: move the bdi from the request_queue to the gendisk")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_priv.h   | 6 ++++++
 drivers/scsi/scsi_sysfs.c  | 3 ++-
 drivers/scsi/sd.c          | 2 ++
 drivers/scsi/sr.c          | 4 +++-
 include/scsi/scsi_device.h | 1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 6d9152031a40..6aef88d772a3 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -145,6 +145,12 @@ extern void __scsi_remove_device(struct scsi_device *);
 extern struct bus_type scsi_bus_type;
 extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
+static inline void scsi_sysfs_cleanup_sdev(struct scsi_device *sdev)
+{
+	sdev->request_queue_cleaned = true;
+	blk_cleanup_queue(sdev->request_queue);
+}
+
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
 extern void scsi_netlink_init(void);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..9d54fc9c89ea 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1463,7 +1463,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	scsi_device_set_state(sdev, SDEV_DEL);
 	mutex_unlock(&sdev->state_mutex);
 
-	blk_cleanup_queue(sdev->request_queue);
+	if (!sdev->request_queue_cleaned)
+		blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
 	if (sdev->host->hostt->slave_destroy)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cbd9999f93a6..8132f9833488 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3498,6 +3498,8 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
+	scsi_sysfs_cleanup_sdev(to_scsi_device(dev));
+
 	free_opal_dev(sdkp->opal_dev);
 
 	mutex_lock(&sd_ref_mutex);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8b17b35283aa..ef85940f3168 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -64,7 +64,7 @@
 
 #include "scsi_logging.h"
 #include "sr.h"
-
+#include "scsi_priv.h"
 
 MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
 MODULE_LICENSE("GPL");
@@ -1045,6 +1045,8 @@ static int sr_remove(struct device *dev)
 	del_gendisk(cd->disk);
 	dev_set_drvdata(dev, NULL);
 
+	scsi_sysfs_cleanup_sdev(to_scsi_device(dev));
+
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	mutex_unlock(&sr_ref_mutex);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09a17f6e93a7..d102bc2c423b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -207,6 +207,7 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	unsigned request_queue_cleaned:1; /* Request queue has been cleaned up */
 
 	bool offline_already;		/* Device offline message logged */
 
-- 
2.31.1

