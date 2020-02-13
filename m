Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C31C2BA83
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 15:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 508EF217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 15:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgBMPfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:35:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:37674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388138AbgBMPcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 10:32:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1C291AF0E;
        Thu, 13 Feb 2020 15:32:09 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] ch: fixup refcounting imbalance for SCSI devices
Date:   Thu, 13 Feb 2020 16:32:05 +0100
Message-Id: <20200213153207.123357-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213153207.123357-1-hare@suse.de>
References: <20200213153207.123357-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI device is required to be present during ch_probe()
and ch_open(). But the SCSI device itself is only checked during
ch_open(), so it's anyones guess if it had been present during
ch_probe(). And consequently we can't reliably detach it during
ch_release(), as ch_remove() might have been called first.
So initialize the changer device during ch_probe(), and
take a reference to the SCSI device during both ch_probe()
and ch_open().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ed5f4a6ae270..974afb4bd5fe 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -569,6 +569,7 @@ static void ch_destroy(struct kref *ref)
 {
 	scsi_changer *ch = container_of(ref, scsi_changer, ref);
 
+	ch->device = NULL;
 	kfree(ch->dt);
 	kfree(ch);
 }
@@ -594,14 +595,17 @@ ch_open(struct inode *inode, struct file *file)
 	spin_lock(&ch_index_lock);
 	ch = idr_find(&ch_index_idr, minor);
 
-	if (NULL == ch || scsi_device_get(ch->device)) {
+	if (NULL == ch || !kref_get_unless_zero(&ch->ref)) {
 		spin_unlock(&ch_index_lock);
 		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
-	kref_get(&ch->ref);
 	spin_unlock(&ch_index_lock);
-
+	if (scsi_device_get(ch->device)) {
+		kref_put(&ch->ref, ch_destroy);
+		mutex_unlock(&ch_mutex);
+		return -ENXIO;
+	}
 	file->private_data = ch;
 	mutex_unlock(&ch_mutex);
 	return 0;
@@ -938,6 +942,12 @@ static int ch_probe(struct device *dev)
 
 	ch->minor = ret;
 	sprintf(ch->name,"ch%d",ch->minor);
+	ret = scsi_device_get(sd);
+	if (ret) {
+		sdev_printk(KERN_WARNING, sd, "ch%d: failed to get device\n",
+			    ch->minor);
+		goto remove_idr;
+	}
 
 	class_dev = device_create(ch_sysfs_class, dev,
 				  MKDEV(SCSI_CHANGER_MAJOR, ch->minor), ch,
@@ -946,7 +956,7 @@ static int ch_probe(struct device *dev)
 		sdev_printk(KERN_WARNING, sd, "ch%d: device_create failed\n",
 			    ch->minor);
 		ret = PTR_ERR(class_dev);
-		goto remove_idr;
+		goto put_device;
 	}
 
 	mutex_init(&ch->lock);
@@ -964,6 +974,8 @@ static int ch_probe(struct device *dev)
 	return 0;
 destroy_dev:
 	device_destroy(ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR, ch->minor));
+put_device:
+	scsi_device_put(sd);
 remove_idr:
 	idr_remove(&ch_index_idr, ch->minor);
 free_ch:
@@ -977,9 +989,11 @@ static int ch_remove(struct device *dev)
 
 	spin_lock(&ch_index_lock);
 	idr_remove(&ch_index_idr, ch->minor);
+	dev_set_drvdata(dev, NULL);
 	spin_unlock(&ch_index_lock);
 
 	device_destroy(ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR,ch->minor));
+	scsi_device_put(ch->device);
 	kref_put(&ch->ref, ch_destroy);
 	return 0;
 }
-- 
2.16.4

