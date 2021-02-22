Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC94C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5278A64E76
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhBVN2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:28:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:47794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhBVN1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:27:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ACE17AFCD;
        Mon, 22 Feb 2021 13:24:15 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/31] scsi: Use dummy inquiry data for the host device
Date:   Mon, 22 Feb 2021 14:23:41 +0100
Message-Id: <20210222132405.91369-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Attach the dummy inquiry data to the scsi host device and use it
to check if any given device is a scsi host device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c  | 17 +++++++++++++++--
 drivers/scsi/scsi_sysfs.c |  3 ++-
 include/scsi/scsi_host.h  |  7 ++++---
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 11aec38250ca..234b1cd6b50d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1921,9 +1921,11 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
-	if (sdev)
+	if (sdev) {
 		sdev->borken = 0;
-	else
+		sdev->inquiry = (unsigned char *)scsi_null_inquiry;
+		sdev->inquiry_len = sizeof(scsi_null_inquiry);
+	} else
 		scsi_target_reap(starget);
 	put_device(&starget->dev);
  out:
@@ -1948,3 +1950,14 @@ void scsi_free_host_dev(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
+/**
+ * scsi_device_is_host_dev - Check if a scsi device is a host device
+ * @sdev: SCSI device to test
+ *
+ * Returns: true if @sdev is a host device, false otherwise
+ */
+bool scsi_device_is_host_dev(struct scsi_device *sdev)
+{
+	return ((const unsigned char *)sdev->inquiry == scsi_null_inquiry);
+}
+EXPORT_SYMBOL_GPL(scsi_device_is_host_dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b6378c8ca783..64b51ebdca76 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -496,7 +496,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree_rcu(vpd_pg80, rcu);
 	if (vpd_pg89)
 		kfree_rcu(vpd_pg89, rcu);
-	kfree(sdev->inquiry);
+	if (!scsi_device_is_host_dev(sdev))
+		kfree(sdev->inquiry);
 	kfree(sdev);
 
 	if (parent)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e30fd963b97d..b077ad9c666b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -788,14 +788,15 @@ void scsi_host_busy_iter(struct Scsi_Host *,
 struct class_container;
 
 /*
- * These two functions are used to allocate and free a pseudo device
- * which will connect to the host adapter itself rather than any
- * physical device.  You must deallocate when you are done with the
+ * These three functions are used to allocate, free, and test for
+ * a pseudo device which will connect to the host adapter itself rather
+ * than any physical device.  You must deallocate when you are done with the
  * thing.  This physical pseudo-device isn't real and won't be available
  * from any high-level drivers.
  */
 extern void scsi_free_host_dev(struct scsi_device *);
 extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
+bool scsi_device_is_host_dev(struct scsi_device *);
 
 /*
  * DIF defines the exchange of protection information between
-- 
2.29.2

