Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9ABC00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 22:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiHUWFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 18:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiHUWFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 18:05:20 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AFA13F7A
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:19 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id m15so1185511pjj.3
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BNKAEzSk3SNjegg5rWXH/+ZNTw8DhVQ+LI3LGlP9G4g=;
        b=N6o2Pn7nEF1MbXt5QC+3EiKA40Pn2AEnieJeZMFUTVxu5OvLvvv5qfEfXGBflF1R28
         2NIgtHNVoA9rNCiBVdPzowSY/B3ypBmOR375WvKti0vSvGpFapk3BpyW0GY4HwsoJrlU
         bedE7yfdMSNKXExOQn5AzrmpARw0N/09npRdIFVTWJfK1f4ZJB5yxXGz2zSlx59FMI5T
         WtacnYOS8NvUiCauVQu/aKV2hWF5qhIYTUC03LgHvHYQgI2Cke0qKEi/BLvvtT2ScB6C
         O41v4c7qnUe9TIhQAPHq6/a/tqas15Sy0jboL9vybZsb4tlu7U5fXbhN12NMzL51CmSW
         NJug==
X-Gm-Message-State: ACgBeo0s/PlvUlZPlzEKWQe9m66hK5o0hpbQ6G5MToe+WRz8ksv3vHGO
        eIbIi4R+CO6+Ff1zSvHTxAw=
X-Google-Smtp-Source: AA6agR4s4XZk6eZeKGNm6siq5mN5zueKUVxhH650wzytsRttUGJ99zEUtDhavLc8T6SV2HNlD8Izxg==
X-Received: by 2002:a17:903:489:b0:172:abe8:fed1 with SMTP id jj9-20020a170903048900b00172abe8fed1mr17591316plb.71.1661119519265;
        Sun, 21 Aug 2022 15:05:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b0016c09a0ef87sm3110994plg.255.2022.08.21.15.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 15:05:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Subject: [PATCH 3/4] scsi: core: Revert "Make sure that hosts outlive targets"
Date:   Sun, 21 Aug 2022 15:05:01 -0700
Message-Id: <20220821220502.13685-4-bvanassche@acm.org>
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
Fixes: 16728aaba62e ("scsi: core: Make sure that hosts outlive targets")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 8 --------
 drivers/scsi/scsi_scan.c | 7 -------
 include/scsi/scsi_host.h | 3 ---
 3 files changed, 18 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 20c1f5420ba6..26bf3b153595 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -190,13 +190,6 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
-
-	/*
-	 * After scsi_remove_host() has returned the scsi LLD module can be
-	 * unloaded and/or the host resources can be released. Hence wait until
-	 * the dependent SCSI targets and devices are gone before returning.
-	 */
-	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -406,7 +399,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
-	init_waitqueue_head(&shost->targets_wq);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ac6059702d13..4c1efd6a3b0c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -406,14 +406,9 @@ static void scsi_target_destroy(struct scsi_target *starget)
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct device *parent = dev->parent;
-	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct scsi_target *starget = to_scsi_target(dev);
 
 	kfree(starget);
-
-	if (atomic_dec_return(&shost->target_count) == 0)
-		wake_up(&shost->targets_wq);
-
 	put_device(parent);
 }
 
@@ -528,8 +523,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
 	init_waitqueue_head(&starget->sdev_wq);
 
-	atomic_inc(&shost->target_count);
-
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index aa7b7496c93a..b6e41ee3d566 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -690,9 +690,6 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
 
-	atomic_t		target_count;
-	wait_queue_head_t	targets_wq;
-
 	/*
 	 * Points to the transport data (if any) which is allocated
 	 * separately
