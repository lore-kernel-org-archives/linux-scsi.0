Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38EFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 18:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbiGGSVp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 14:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiGGSVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 14:21:43 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF01F53D0E
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 11:21:42 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id s27so19959931pga.13
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jul 2022 11:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oWmgzIjGoE3AdK78GpuiAPvt3/hSjVZ/gbqO7FE6B3g=;
        b=34/51sxaAB4OcE7tm5tnP077MTSrrkHpWfgi32LkId/jfdY8+bu39lNGcw5WqXwpmk
         n86/wbq+6Xw5YRfkQnA9RAD1W0vH/zISU28SLEfXDu1W91BNsLKjiwtg4+1a5I4KWtfl
         RP0n8j3bG8qPJPyg6unPj5X1EGl0/gLRL2dWR8p0Z3JI65whUmOCwxL1qvln75DqSmGG
         gu+lldLr8VuJXSXJN3yf+be4TkxVth/VQwS+x92rjiiJAA6gdCMkcirhnM5HUDh4QJSb
         AWfUiWrl+ijRgvuVLaLOrAy1+lfcTjvy8pj3mCDvRhG/iF5IiBbGcL6VuxyHvfEu1t1X
         +DGw==
X-Gm-Message-State: AJIora9mlmrs4qlNZOgn7gAb9rdsORijLFkNEwzeA2FRjBcyOong4/qT
        nxdOvjZPfJkRZrPexB4kua4=
X-Google-Smtp-Source: AGRyM1tNS3CYJ88Ox+rkl7Ez5hpfpfsJh5TePvbYgY7DdQhRMIQS6LzGZo/eXEhjJX5sihfTmdNERg==
X-Received: by 2002:a17:90b:188c:b0:1ef:9049:9f44 with SMTP id mn12-20020a17090b188c00b001ef90499f44mr6553413pjb.171.1657218102121;
        Thu, 07 Jul 2022 11:21:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n16-20020a170903111000b0016bdd124d46sm10490335plh.288.2022.07.07.11.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 11:21:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 1/2] scsi: core: Make sure that hosts outlive targets and devices
Date:   Thu,  7 Jul 2022 11:21:21 -0700
Message-Id: <20220707182122.3797-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707182122.3797-1-bvanassche@acm.org>
References: <20220707182122.3797-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

Fix the race conditions between SCSI LLD kernel module unloading and SCSI
device and target removal by making sure that SCSI hosts are destroyed after
all associated target and device objects have been freed.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: Reworked Ming's patch ]
---
 drivers/scsi/hosts.c      | 9 +++++++++
 drivers/scsi/scsi.c       | 9 ++++++---
 drivers/scsi/scsi_scan.c  | 7 +++++++
 drivers/scsi/scsi_sysfs.c | 9 ---------
 include/scsi/scsi_host.h  | 3 +++
 5 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ef6c0e37acce..e0a56a8f1f74 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -168,6 +168,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 
 	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
+	/* Prevent that new SCSI targets or SCSI devices are added. */
 	if (scsi_host_set_state(shost, SHOST_CANCEL))
 		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
 			spin_unlock_irqrestore(shost->host_lock, flags);
@@ -190,6 +191,13 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
+
+	/*
+	 * After scsi_remove_host() has returned the scsi LLD module can be
+	 * unloaded and/or the host resources can be released. Hence wait until
+	 * the dependent SCSI targets and devices are gone before returning.
+	 */
+	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -394,6 +402,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	init_waitqueue_head(&shost->targets_wq);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..086ec5b5862d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -586,10 +586,13 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	struct module *mod = sdev->host->hostt->module;
-
+	/*
+	 * Decreasing the module reference count before the device reference
+	 * count is safe since scsi_remove_host() only returns after all
+	 * devices have been removed.
+	 */
+	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
-	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a6682..00c5754f0081 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -406,9 +406,14 @@ static void scsi_target_destroy(struct scsi_target *starget)
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct device *parent = dev->parent;
+	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct scsi_target *starget = to_scsi_target(dev);
 
 	kfree(starget);
+
+	if (atomic_dec_return(&shost->target_count) == 0)
+		wake_up(&shost->targets_wq);
+
 	put_device(parent);
 }
 
@@ -521,6 +526,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	atomic_inc(&shost->target_count);
+
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 43949798a2e4..72bf5131e9d8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -450,12 +450,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
-	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
-	mod = sdev->host->hostt->module;
-
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -518,17 +515,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
-	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
-
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 667d889b92b5..339f975d356e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -689,6 +689,9 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
 
+	atomic_t		target_count;
+	wait_queue_head_t	targets_wq;
+
 	/*
 	 * Points to the transport data (if any) which is allocated
 	 * separately
