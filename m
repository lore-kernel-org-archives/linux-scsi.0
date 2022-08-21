Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCC9C00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 22:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiHUWF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 18:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiHUWFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 18:05:23 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22B013F7A
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:21 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo12189158pjd.3
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tMvkLpSPx0ef1ALnoiT9QUhcN0pT/j+rXogH1XEEfV8=;
        b=xS5xVXCaR3hUWQSaReY6eetDJ9MZ8s73XvdOUZGr86a3/uiY2++TPjYywsBOF6BG2X
         6Yk6hUIMyGAdTsTdUqOETTkWVIEV1CSlB+QFJgJD6VAjWwDkTGroM2VwFcuBJoZpvGfD
         6XK/rDWug9I/8BQt3L7lXzS4w07OMSZHQAp88TEkjB2foWARW2gXTz1xFGCPjhJzjfLo
         Y+qTZq+b2R9MVd210MGtbHHVtAzS5Ns+vgt2oe98t5PrIcvRvy5cluuiDbK4T+tl7140
         UdsG4v/eEZh5VvZc5/tqOTD8R3TH9GLUNRvUOtJCb0y+pMMvNvqZHJu2cGQNSLi301zL
         C2UA==
X-Gm-Message-State: ACgBeo0M9LbVx6cMCg4Gk/WmExrvl4dJokI4+MNsHgax8p4W0DMVViYT
        Li6Ri99c6g/HpwtIkedeoaE=
X-Google-Smtp-Source: AA6agR5QNHduz5BMQIgHRvAW9vmWCrlt/yX4VcTWMKrMPGpT9zPr4FAfS73FOqfK3hZ/3vQmpxMn3Q==
X-Received: by 2002:a17:90a:c702:b0:1fb:2beb:9606 with SMTP id o2-20020a17090ac70200b001fb2beb9606mr2727700pjt.158.1661119521245;
        Sun, 21 Aug 2022 15:05:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b0016c09a0ef87sm3110994plg.255.2022.08.21.15.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 15:05:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Subject: [PATCH 4/4] scsi: core: Revert "Make sure that targets outlive devices"
Date:   Sun, 21 Aug 2022 15:05:02 -0700
Message-Id: <20220821220502.13685-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220821220502.13685-1-bvanassche@acm.org>
References: <20220821220502.13685-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Revert the patch series "Call blk_mq_free_tag_set() earlier" because it
introduces a deadlock if the scsi_remove_host() caller holds a reference
on a device, target or host.

Reported-by: syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Fixes: fe442604199e ("scsi: core: Make sure that targets outlive devices")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c   |  2 --
 drivers/scsi/scsi_sysfs.c  | 20 +++-----------------
 include/scsi/scsi_device.h |  2 --
 3 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4c1efd6a3b0c..91ac901a6682 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -521,8 +521,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
-	init_waitqueue_head(&starget->sdev_wq);
-
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 282b32781e8c..aa70d9282161 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -443,9 +443,7 @@ static void scsi_device_cls_release(struct device *class_dev)
 
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
-	struct scsi_device *sdev = container_of(work, struct scsi_device,
-						ew.work);
-	struct scsi_target *starget = sdev->sdev_target;
+	struct scsi_device *sdev;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -454,6 +452,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	unsigned long flags;
 	struct module *mod;
 
+	sdev = container_of(work, struct scsi_device, ew.work);
+
 	mod = sdev->host->hostt->module;
 
 	scsi_dh_release_device(sdev);
@@ -516,9 +516,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
-	if (starget && atomic_dec_return(&starget->sdev_count) == 0)
-		wake_up(&starget->sdev_wq);
-
 	if (parent)
 		put_device(parent);
 	module_put(mod);
@@ -1538,14 +1535,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	/*
-	 * After scsi_remove_target() returns its caller can remove resources
-	 * associated with @starget, e.g. an rport or session. Wait until all
-	 * devices associated with @starget have been removed to prevent that
-	 * a SCSI error handling callback function triggers a use-after-free.
-	 */
-	wait_event(starget->sdev_wq, atomic_read(&starget->sdev_count) == 0);
 }
 
 /**
@@ -1656,9 +1645,6 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	atomic_inc(&starget->sdev_count);
-
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
 	 * the target.  Target will be held in CREATED state until something
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3113471ca375..2493bd65351a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -309,8 +309,6 @@ struct scsi_target {
 	struct list_head	devices;
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
-	atomic_t		sdev_count;
-	wait_queue_head_t	sdev_wq;
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
