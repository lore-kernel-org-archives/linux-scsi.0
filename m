Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E912C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355968AbhKYPQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:15 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47078 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352191AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1019A1FD3C;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eyq1HeKplGRs/+Oee78lchL2tHMM9PkF+Ez+YRYbCc=;
        b=l8oHOjvFEu67uje1jjGMGZFSoCaXUV0S8UiHl1cuzwzvfPeQ/Dschuh/cgiQ3AuQPCh4k4
        tQWh7YE7Cg48gNlJGDimYTGIbuxQgiX/AKd6tWQvVGG3RyBRiXf/cIoVpQiUW2Q+tQm8Xl
        SOF7MJ/TxxGam9mB1xvWBlagkIpDDVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9eyq1HeKplGRs/+Oee78lchL2tHMM9PkF+Ez+YRYbCc=;
        b=UjwW+z3DKRTnLGldb1SAFndv/tsmxCR8jcDTaTOzAgT9i9s2Vepa/iMjzpQI14o2GSBWzz
        psiT7zsEA1m7JgBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A3EE8A3B87;
        Thu, 25 Nov 2021 15:11:01 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9316D51919EE; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/15] scsi: allocate host device
Date:   Thu, 25 Nov 2021 16:10:34 +0100
Message-Id: <20211125151048.103910-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a flag 'alloc_host_dev' to the SCSI host template and allocate
a virtual scsi device if the flag is set.
This device has the SCSI id <max_id + 1>:0, so won't clash with any
devices the HBA might allocate. It's also excluded from scanning and
will not show up in sysfs.
Intention is to use this device to send internal commands to the HBA.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c       |  8 +++++
 drivers/scsi/scsi_scan.c   | 67 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  |  3 +-
 include/scsi/scsi_device.h |  2 +-
 include/scsi/scsi_host.h   | 21 ++++++++++++
 5 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f69b77cbf538..a539fa2fb221 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -290,6 +290,14 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto out_del_dev;
 
+	if (sht->alloc_host_sdev) {
+		shost->shost_sdev = scsi_get_host_dev(shost);
+		if (!shost->shost_sdev) {
+			error = -ENOMEM;
+			goto out_del_dev;
+		}
+	}
+
 	scsi_proc_host_add(shost);
 	scsi_autopm_put_host(shost);
 	return error;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 328c0e79dfe7..e2910aa02a65 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1139,6 +1139,12 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
+	if (scsi_device_is_host_dev(sdev)) {
+		if (bflagsp)
+			*bflagsp = BLIST_NOLUN;
+		return SCSI_SCAN_LUN_PRESENT;
+	}
+
 	result = kmalloc(result_len, GFP_KERNEL);
 	if (!result)
 		goto out_free_sdev;
@@ -1755,6 +1761,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 		/* If device is already visible, skip adding it to sysfs */
 		if (sdev->is_visible)
 			continue;
+		/* Host devices should never be visible in sysfs */
+		if (scsi_device_is_host_dev(sdev))
+			continue;
 		if (!scsi_host_scan_allowed(shost) ||
 		    scsi_sysfs_add_sdev(sdev) != 0)
 			__scsi_remove_device(sdev);
@@ -1919,12 +1928,16 @@ EXPORT_SYMBOL(scsi_scan_host);
 
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
@@ -1932,5 +1945,57 @@ void scsi_forget_host(struct Scsi_Host *shost)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	/* Remove host device last, might be needed to send commands */
+	if (host_sdev)
+		__scsi_remove_device(host_sdev);
 }
 
+/**
+ * scsi_get_host_dev - Create a virtual scsi_device to the host adapter
+ * @shost: Host that needs a scsi_device
+ *
+ * Lock status: None assumed.
+ *
+ * Returns:     The scsi_device or NULL
+ *
+ * Notes:
+ *	Attach a single scsi_device to the Scsi_Host. The primary aim
+ *	for this device is to serve as a container from which valid
+ *	scsi commands can be allocated from. Each scsi command will carry
+ *	an unused/free command tag, which then can be used by the LLDD to
+ *	send internal or passthrough commands without having to find a
+ *	valid command tag internally.
+ */
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev = NULL;
+	struct scsi_target *starget;
+
+	mutex_lock(&shost->scan_mutex);
+	if (!scsi_host_scan_allowed(shost))
+		goto out;
+	starget = scsi_alloc_target(&shost->shost_gendev, 0,
+				    shost->max_id);
+	if (!starget)
+		goto out;
+
+	sdev = scsi_alloc_sdev(starget, 0, NULL);
+	if (sdev)
+		sdev->borken = 0;
+	else
+		scsi_target_reap(starget);
+	put_device(&starget->dev);
+ out:
+	mutex_unlock(&shost->scan_mutex);
+	return sdev;
+}
+EXPORT_SYMBOL(scsi_get_host_dev);
+
+/*
+ * Test if a given device is a SCSI host device
+ */
+bool scsi_device_is_host_dev(struct scsi_device *sdev)
+{
+	return sdev == sdev->host->shost_sdev;
+}
+EXPORT_SYMBOL_GPL(scsi_device_is_host_dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 61839773cc72..a6e0a70ca6f5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -500,7 +500,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree_rcu(vpd_pg80, rcu);
 	if (vpd_pg89)
 		kfree_rcu(vpd_pg89, rcu);
-	kfree(sdev->inquiry);
+	if (!scsi_device_is_host_dev(sdev))
+		kfree(sdev->inquiry);
 	kfree(sdev);
 
 	if (parent)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d1c6fc83b1e3..5d7204186831 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -604,7 +604,7 @@ static inline int scsi_device_busy(struct scsi_device *sdev)
 	return sbitmap_weight(&sdev->budget_map);
 }
 
-#define MODULE_ALIAS_SCSI_DEVICE(type) \
+#define MODULE_ALIAS_SCSI_DEVICE(type)			\
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 72e1a347baa6..6f49a8940dc4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -459,6 +459,9 @@ struct scsi_host_template {
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
+	/* True if a host sdev should be allocated */
+	unsigned alloc_host_sdev:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -704,6 +707,12 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	/*
+	 * Points to a virtual SCSI device used for sending
+	 * internal commands to the HBA.
+	 */
+	struct scsi_device *shost_sdev;
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
@@ -793,6 +802,18 @@ void scsi_host_busy_iter(struct Scsi_Host *,
 
 struct class_container;
 
+/*
+ * These functions are used to allocate and test a pseudo device
+ * which will refer to the host adapter itself rather than any
+ * physical device.  The device will be deallocated together with
+ * all other scsi devices, so there is no need to have a separate
+ * function to free it.
+ * This device will not show up in sysfs and won't be available
+ * from any high-level drivers.
+ */
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
+bool scsi_device_is_host_dev(struct scsi_device *sdev);
+
 /*
  * DIF defines the exchange of protection information between
  * initiator and SBC block device.
-- 
2.29.2

