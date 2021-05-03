Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B461AC43461
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 857F66127A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhECPEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:40890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhECPEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83A4BB1BC;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/18] scsi: revamp host device handling
Date:   Mon,  3 May 2021 17:03:22 +0200
Message-Id: <20210503150333.130310-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210503150333.130310-1-hare@suse.de>
References: <20210503150333.130310-1-hare@suse.de>
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
index 55fa7f7317a2..0b6753c1dd4d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1113,6 +1113,15 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1731,6 +1740,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 		/* If device is already visible, skip adding it to sysfs */
 		if (sdev->is_visible)
 			continue;
+		/* Host devices should never be visible in sysfs */
+		if (scsi_device_is_host_dev(sdev))
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
@@ -1895,12 +1907,16 @@ EXPORT_SYMBOL(scsi_scan_host);
 
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
@@ -1908,10 +1924,13 @@ void scsi_forget_host(struct Scsi_Host *shost)
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
@@ -1919,13 +1938,12 @@ void scsi_forget_host(struct Scsi_Host *shost)
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
@@ -1935,7 +1953,8 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 	mutex_lock(&shost->scan_mutex);
 	if (!scsi_host_scan_allowed(shost))
 		goto out;
-	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
+	starget = scsi_alloc_target(&shost->shost_gendev,
+				    shost->max_channel + 1, 0);
 	if (!starget)
 		goto out;
 
@@ -1953,22 +1972,6 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
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
index f492e9034a62..f115150559ca 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -804,14 +804,15 @@ void scsi_host_busy_iter(struct Scsi_Host *,
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

