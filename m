Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FC7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69FC56121F
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhJFV45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 17:56:57 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:50887 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJFV44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 17:56:56 -0400
Received: by mail-pj1-f51.google.com with SMTP id k23so3293919pji.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 14:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EzExf2XwGTUZAuOjWQSxwN0vomL2tEkWlLwb5Z+D8+U=;
        b=gk27CgH9uDlDK2+OvN9z2Gkx+sAUzjSRhp9C683YuTy1THhRAs9H4/5X5ZHbouR4OY
         IPXIruR6s9Oo5tDhUFFlWQ4bz8sKtVg8gpKhHR1OrEWfodskrhGC+sWPuyi8uniLl4aQ
         U/SgmrJEAzjMS2kuc56SBjavWVVFdNahzDpbM70fQpxL3vvHz+/GS71iv3lZc1yz6ta+
         Wb5pC7BoUZsdIF/YLrHOZLsLeVL7qBfVgddnho90GQhDgxDSqb/9CYEkSBEp7NHA7V+i
         PG3KQ7j9Oy7Kl5+/1JTb0SvIy4R7tfaSn8JN41BA8Ty5QLSw/HaT4uJ913KZXstjFKNX
         HXwQ==
X-Gm-Message-State: AOAM532GbJtf8LZU5NAvIo8BHuQVlqwaG5Rwau1ukAQNjW0+Ghfv8wjs
        cVGYZV0yaWbKoT/vyT9VXZE=
X-Google-Smtp-Source: ABdhPJw9b2rvPt5blzN85ERKiOKmmWK3OA+Qz2Sq5Z6YszQpkJqKQ9QNr1p05HcyfBqjH4mfuoJzNg==
X-Received: by 2002:a17:902:a385:b0:13e:99e9:17f3 with SMTP id x5-20020a170902a38500b0013e99e917f3mr424804pla.65.1633557304006;
        Wed, 06 Oct 2021 14:55:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7a81:1c54:a610:d139])
        by smtp.gmail.com with ESMTPSA id x7sm5902586pjl.55.2021.10.06.14.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 14:55:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/3] scsi: pm: Rely on the device driver core for async power management
Date:   Wed,  6 Oct 2021 14:54:51 -0700
Message-Id: <20211006215453.3318929-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
In-Reply-To: <20211006215453.3318929-1-bvanassche@acm.org>
References: <20211006215453.3318929-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of implementing asynchronous resume support in the SCSI core,
rely on the device driver core for resuming SCSI devices asynchronously.
Instead of only supporting asynchronous resumes, also support asynchronous
suspends.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c      |  1 +
 drivers/scsi/scsi.c       |  8 -------
 drivers/scsi/scsi_pm.c    | 44 ++-------------------------------------
 drivers/scsi/scsi_priv.h  |  4 +---
 drivers/scsi/scsi_scan.c  | 17 +++++++++++++++
 drivers/scsi/scsi_sysfs.c |  1 +
 drivers/scsi/sd.c         |  1 -
 7 files changed, 22 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f0cafb..b8362700a9de 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -475,6 +475,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
 	shost->shost_gendev.type = &scsi_host_type;
+	scsi_enable_async_suspend(&shost->shost_gendev);
 
 	device_initialize(&shost->shost_dev);
 	shost->shost_dev.parent = &shost->shost_gendev;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..ed9753f54b8a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -86,14 +86,6 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
-/*
- * Domain for asynchronous system resume operations.  It is marked 'exclusive'
- * to avoid being included in the async_synchronize_full() that is invoked by
- * dpm_resume().
- */
-ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
-EXPORT_SYMBOL(scsi_sd_pm_domain);
-
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd)
 {
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea37ecb..50b6bad4df79 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -56,9 +56,6 @@ static int scsi_dev_type_suspend(struct device *dev,
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err;
 
-	/* flush pending in-flight resume operations, suspend is synchronous */
-	async_synchronize_full_domain(&scsi_sd_pm_domain);
-
 	err = scsi_device_quiesce(to_scsi_device(dev));
 	if (err == 0) {
 		err = cb(dev, pm);
@@ -123,48 +120,11 @@ scsi_bus_suspend_common(struct device *dev,
 	return err;
 }
 
-static void async_sdev_resume(void *dev, async_cookie_t cookie)
-{
-	scsi_dev_type_resume(dev, do_scsi_resume);
-}
-
-static void async_sdev_thaw(void *dev, async_cookie_t cookie)
-{
-	scsi_dev_type_resume(dev, do_scsi_thaw);
-}
-
-static void async_sdev_restore(void *dev, async_cookie_t cookie)
-{
-	scsi_dev_type_resume(dev, do_scsi_restore);
-}
-
 static int scsi_bus_resume_common(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
-	async_func_t fn;
-
-	if (!scsi_is_sdev_device(dev))
-		fn = NULL;
-	else if (cb == do_scsi_resume)
-		fn = async_sdev_resume;
-	else if (cb == do_scsi_thaw)
-		fn = async_sdev_thaw;
-	else if (cb == do_scsi_restore)
-		fn = async_sdev_restore;
-	else
-		fn = NULL;
-
-	if (fn) {
-		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
-
-		/*
-		 * If a user has disabled async probing a likely reason
-		 * is due to a storage enclosure that does not inject
-		 * staggered spin-ups.  For safety, make resume
-		 * synchronous as well in that case.
-		 */
-		if (strncmp(scsi_scan_type, "async", 5) != 0)
-			async_synchronize_full_domain(&scsi_sd_pm_domain);
+	if (scsi_is_sdev_device(dev)) {
+		scsi_dev_type_resume(dev, cb);
 	} else {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 6d9152031a40..2d9de5a165ae 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -116,7 +116,7 @@ extern void scsi_exit_procfs(void);
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
-extern char scsi_scan_type[];
+void scsi_enable_async_suspend(struct device *dev);
 extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, u64, enum scsi_scan_mode);
@@ -170,8 +170,6 @@ static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM */
 
-extern struct async_domain scsi_sd_pm_domain;
-
 /* scsi_dh.c */
 #ifdef CONFIG_SCSI_DH
 void scsi_dh_add_device(struct scsi_device *sdev);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0d0381df25f7..c86152f9c47a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -122,6 +122,22 @@ struct async_scan_data {
 	struct completion prev_finished;
 };
 
+/**
+ * scsi_enable_async_suspend - Enable async suspend and resume
+ */
+void scsi_enable_async_suspend(struct device *dev)
+{
+	/*
+	 * If a user has disabled async probing a likely reason is due to a
+	 * storage enclosure that does not inject staggered spin-ups. For
+	 * safety, make resume synchronous as well in that case.
+	 */
+	if (strncmp(scsi_scan_type, "async", 5) != 0)
+		return;
+	/* Enable asynchronous suspend and resume. */
+	device_enable_async_suspend(dev);
+}
+
 /**
  * scsi_complete_async_scans - Wait for asynchronous scans to complete
  *
@@ -454,6 +470,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
+	scsi_enable_async_suspend(dev);
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..b598dfcbb67d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1616,6 +1616,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
+	scsi_enable_async_suspend(&sdev->sdev_gendev);
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 71fa70b42c2b..78ebccd9d106 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3500,7 +3500,6 @@ static int sd_remove(struct device *dev)
 	sdkp = dev_get_drvdata(dev);
 	scsi_autopm_get_device(sdkp->device);
 
-	async_synchronize_full_domain(&scsi_sd_pm_domain);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
