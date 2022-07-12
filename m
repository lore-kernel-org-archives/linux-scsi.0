Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39C5C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiGLWTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiGLWTr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:19:47 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C3332EF8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:46 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso578023pjh.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7t/LiMMlcRYUk+orrbi6bYOidjg0HO2tcia+QqtEDE=;
        b=zZkNoewAaUbItlp5fu6LQu3919ZUHMqPB0R4QHFwvkhTRer4TlQN2rBfH2sOlSSDkr
         ldluJQbHawgr6qkXkdty7yQADjqijmWr0kR2ZTemau1yEIUHO0JLo7/fxnGmHTYcrXKV
         7DQyVANX+048mv5rJgg7FtGXrDavUTBajdxqTNOG8WYdwaD34wc6qNRa7PpXJqyXwvGR
         BBh5KpQlk0PKbWWUNgbvJ17IiL3c1Dw01GpAFUE5V7jWzYPX7VgK+bUMGqEatgRV5tWY
         Gep7TbjKlqvvF5INuPbNoa9kTS6gW979IGR6xajmQ3NCgkWOTreRXY+32x7NXSu6SsNG
         5OPw==
X-Gm-Message-State: AJIora/NNljhsS3oqv1k3fL1fJ9Wj5EMjyAw6Cq8LsMvoVmMS+i4368Z
        ARRi1/fq7wzaoFhRqc2xvVE=
X-Google-Smtp-Source: AGRyM1uxQQGrXIr+7eVnADsghlYDzhSdo/AhLZuiPli9g2atpM4Hc9MzvhapFPTN96NNTASC3NKgOw==
X-Received: by 2002:a17:902:d395:b0:16b:e5e9:ac59 with SMTP id e21-20020a170902d39500b0016be5e9ac59mr189255pld.74.1657664386064;
        Tue, 12 Jul 2022 15:19:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b0040d0a57be02sm6640192pgh.31.2022.07.12.15.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:19:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v4 1/4] scsi: core: Make sure that targets outlive devices
Date:   Tue, 12 Jul 2022 15:19:33 -0700
Message-Id: <20220712221936.1199196-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
In-Reply-To: <20220712221936.1199196-1-bvanassche@acm.org>
References: <20220712221936.1199196-1-bvanassche@acm.org>
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
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
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
