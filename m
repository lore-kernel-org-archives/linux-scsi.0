Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE02DC04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 22:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiG1WT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiG1WTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 18:19:12 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E54F79697
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:04 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id w185so3097892pfb.4
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gLt9gE5yPo5TLuy53BACvWqAE7E7cvrEaZ3l+CvCU6Y=;
        b=aoF8q28O1434MDeWTphuVaoGqfCQM8SjzBWfO1x/IbMOJEiDj++T4lKVY2DjdFvz16
         nLM54gFp/XUytsK4yI7tKFr9e91Wv8rGFmh8HGUe9JF9nmeHB/I4xQHqrfV/V62Nt1op
         P3Y45hdLGmuvb+Au/K7pUPs9NOS2/rXan5G5OTVLEPr2dnVjlHdq+/PeaydZsDN8EAxC
         O2fP2A347dBaleFAi3SApoIv2gAAGfulbPZH9B+nCunVHhssxdM1POt6OXDgb56CbzXq
         3kLExoKm+wy2NB+vfHHiF8RPXbuSFmgJdChobMTgQYim/oyVqiM/2Ivg29+vNuMYmBtD
         AkKg==
X-Gm-Message-State: AJIora+X/JEoi0Ox35FAza7of5CAE0lfkxsitULFXeyUT+uYxM14MUj1
        ITo9sGNnRSCN6pBnqKV6is8=
X-Google-Smtp-Source: AGRyM1vvhfrNGZZrXuUSRqBIL8GDoPjRKY8j9EA+TO4ceKYRBsnhhWl4FPnMwUs92DoISGRuJaJmzw==
X-Received: by 2002:a05:6a00:244a:b0:52b:e9a8:cb14 with SMTP id d10-20020a056a00244a00b0052be9a8cb14mr638904pfj.32.1659046743956;
        Thu, 28 Jul 2022 15:19:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b0016dc8932725sm1556709plk.285.2022.07.28.15.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:19:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 1/4] scsi: core: Make sure that targets outlive devices
Date:   Thu, 28 Jul 2022 15:18:48 -0700
Message-Id: <20220728221851.1822295-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
In-Reply-To: <20220728221851.1822295-1-bvanassche@acm.org>
References: <20220728221851.1822295-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prevents that the following sequence triggers a kernel crash:
* Deletion of a SCSI device is requested via sysfs. Device removal takes
  some time because blk_cleanup_queue() is waiting for the SCSI error
  handler.
* The SCSI target associated with that SCSI device is removed.
* scsi_remove_target() returns and its caller frees the resources
  associated with the SCSI target.
* The error handler makes progress and invokes an LLD callback that
  dereferences the SCSI target pointer.

Reported-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c   |  2 ++
 drivers/scsi/scsi_sysfs.c  | 20 +++++++++++++++++---
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a6682..4c1efd6a3b0c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -521,6 +521,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	init_waitqueue_head(&starget->sdev_wq);
+
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 43949798a2e4..1bc9c26fe1d4 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -443,7 +443,9 @@ static void scsi_device_cls_release(struct device *class_dev)
 
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = container_of(work, struct scsi_device,
+						ew.work);
+	struct scsi_target *starget = sdev->sdev_target;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -452,8 +454,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	unsigned long flags;
 	struct module *mod;
 
-	sdev = container_of(work, struct scsi_device, ew.work);
-
 	mod = sdev->host->hostt->module;
 
 	scsi_dh_release_device(sdev);
@@ -516,6 +516,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
+	if (starget && atomic_dec_return(&starget->sdev_count) == 0)
+		wake_up(&starget->sdev_wq);
+
 	if (parent)
 		put_device(parent);
 	module_put(mod);
@@ -1535,6 +1538,14 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * After scsi_remove_target() returns its caller can remove resources
+	 * associated with @starget, e.g. an rport or session. Wait until all
+	 * devices associated with @starget have been removed to prevent that
+	 * a SCSI error handling callback function triggers a use-after-free.
+	 */
+	wait_event(starget->sdev_wq, atomic_read(&starget->sdev_count) == 0);
 }
 
 /**
@@ -1645,6 +1656,9 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	atomic_inc(&starget->sdev_count);
+
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
 	 * the target.  Target will be held in CREATED state until something
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7cf5f3b7589f..190d2081f4c6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -309,6 +309,8 @@ struct scsi_target {
 	struct list_head	devices;
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
+	atomic_t		sdev_count;
+	wait_queue_head_t	sdev_wq;
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
