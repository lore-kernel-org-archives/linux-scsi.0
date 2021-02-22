Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43A9C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65A5364E74
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhBVN21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:28:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:47812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhBVN1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:27:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AFBD7AFD2;
        Mon, 22 Feb 2021 13:24:15 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/31] scsi: revamp host device handling
Date:   Mon, 22 Feb 2021 14:23:42 +0100
Message-Id: <20210222132405.91369-9-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ensure that the host device is excluded from scanning by setting
the BLIST_NOLUN flag, and avoid it being presented in sysfs.
Also move the device id from using the ->this_id value as target
id (which is a bit odd as it's typically is set to -1 anyway) to
using ->max_channel + 1 as the channel number and '0' as the
target id.
With that the host device is now handled like any other scsi device,
which means we can drop the scsi_put_host_dev() function and let
scsi_forget_host() etc handle the deallocation.
We only need to ensure that the host device is deallocated last
is the driver might need it to send commands during teardown.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/scsi_scan.c    | 55 +++++++++++++++++++------------------
 include/scsi/scsi_host.h    | 13 +++++----
 3 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d92cec12454c..e70d87c5342b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -195,6 +195,7 @@ static struct {
 	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
+	{"LINUX", "VIRTUALLUN", NULL, BLIST_NOLUN},
 	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
 	{"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 234b1cd6b50d..573cf3a3ca28 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1094,6 +1094,15 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
+	if (scsi_device_is_host_dev(sdev)) {
+		bflags = scsi_get_device_flags(sdev,
+					       sdev->vendor,
+					       sdev->model);
+		if (bflagsp)
+			*bflagsp = bflags;
+		return SCSI_SCAN_LUN_PRESENT;
+	}
+
 	result = kmalloc(result_len, GFP_KERNEL |
 			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
 	if (!result)
@@ -1712,6 +1721,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 		/* If device is already visible, skip adding it to sysfs */
 		if (sdev->is_visible)
 			continue;
+		/* Host devices should never be visible in sysfs */
+		if (scsi_device_is_host_dev(sdev))
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
@@ -1876,12 +1888,16 @@ EXPORT_SYMBOL(scsi_scan_host);
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *host_sdev = NULL;
 	unsigned long flags;
 
  restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (scsi_device_is_host_dev(sdev)) {
+			host_sdev = sdev;
+			continue;
+		}
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1889,10 +1905,13 @@ void scsi_forget_host(struct Scsi_Host *shost)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	/* Remove host device last, might be needed to send commands */
+	if (host_sdev)
+		__scsi_remove_device(host_sdev);
 }
 
 /**
- * scsi_get_host_dev - Create a scsi_device that points to the host adapter itself
+ * scsi_get_host_dev - Create a virtual scsi_device to the host adapter
  * @shost: Host that needs a scsi_device
  *
  * Lock status: None assumed.
@@ -1900,13 +1919,12 @@ void scsi_forget_host(struct Scsi_Host *shost)
  * Returns:     The scsi_device or NULL
  *
  * Notes:
- *	Attach a single scsi_device to the Scsi_Host - this should
- *	be made to look like a "pseudo-device" that points to the
- *	HA itself.
- *
- *	Note - this device is not accessible from any high-level
- *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach.
+ *	Attach a single scsi_device to the Scsi_Host. The primary aim
+ *	for this device is to serve as a container from which valid
+ *	scsi commands can be allocated from. Each scsi command will carry
+ *	an unused/free command tag, which then can be used by the LLDD to
+ *	send internal or passthrough commands without having to find a
+ *	valid command tag internally.
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
@@ -1916,7 +1934,8 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 	mutex_lock(&shost->scan_mutex);
 	if (!scsi_host_scan_allowed(shost))
 		goto out;
-	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
+	starget = scsi_alloc_target(&shost->shost_gendev,
+				    shost->max_channel + 1, 0);
 	if (!starget)
 		goto out;
 
@@ -1934,22 +1953,6 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
 
-/**
- * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
- * @sdev: Host device to be freed
- *
- * Lock status: None assumed.
- *
- * Returns:     Nothing
- */
-void scsi_free_host_dev(struct scsi_device *sdev)
-{
-	BUG_ON(sdev->id != sdev->host->this_id);
-
-	__scsi_remove_device(sdev);
-}
-EXPORT_SYMBOL(scsi_free_host_dev);
-
 /**
  * scsi_device_is_host_dev - Check if a scsi device is a host device
  * @sdev: SCSI device to test
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b077ad9c666b..ecc2d9dcfdf3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -788,14 +788,15 @@ void scsi_host_busy_iter(struct Scsi_Host *,
 struct class_container;
 
 /*
- * These three functions are used to allocate, free, and test for
- * a pseudo device which will connect to the host adapter itself rather
- * than any physical device.  You must deallocate when you are done with the
- * thing.  This physical pseudo-device isn't real and won't be available
+ * These functions are used to allocate and test a pseudo device
+ * which will refer to the host adapter itself rather than any
+ * physical device.  The device will be deallocated together with
+ * all other scsi devices, so there is no need to have a separate
+ * function to free it.
+ * This device will not show up in sysfs and won't be available
  * from any high-level drivers.
  */
-extern void scsi_free_host_dev(struct scsi_device *);
-extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
 bool scsi_device_is_host_dev(struct scsi_device *);
 
 /*
-- 
2.29.2

