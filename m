Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8982C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiGLWTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiGLWTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:19:50 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C574532EF8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:48 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id e132so8834661pgc.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2VpnzpxPX3Pmo2QoyyBQCVYsbY7t6a8XWBDIqfLwcI=;
        b=OdR21mxyXx1dY9gBH9c3106D971gPUteOitAZkm2Yvyw8N6tNwpJn2kf8JDkVstEVn
         mY+V21GHLPTF8jfELo31M1vvACIg3Yo6CzG/C1vIP7+7hp5bnWva/Ylfzs63A5z5RVzT
         20AT4zqtyds/hS4AedxtTVkuz+abBJqtTDpd+Olv9UKO8Y61Xm3Q02Z5pEZG2p+KrPfb
         v7sAt9mryWEWJPrlYYJ5TtgDkTdQA+swC2d6vvMbcbAusodjccwBwnUZIqoUxBKYcHmK
         ylCcYQu/Hc1oJ0t8V6dlYD4XipCAeat2mJFahA20/vDxmI8+89CsXPAEB/9FZpp37Hd/
         sBjg==
X-Gm-Message-State: AJIora8K+OiWHCmqElY23WNP3uE0rNQJXZo1s4pCcIMOGDaoVtgRpoIH
        S4NnlpUBAuHTFHeGyRjnfnArsHkCHFI=
X-Google-Smtp-Source: AGRyM1uvt6cAmBctGapSp5CPN/mP/gkVJ3qbkxAySvLyBLCO8E2DrgnDvf9b3REX9CwJDaY42QAuUg==
X-Received: by 2002:a63:2bc4:0:b0:419:7b8c:210a with SMTP id r187-20020a632bc4000000b004197b8c210amr330099pgr.439.1657664388018;
        Tue, 12 Jul 2022 15:19:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b0040d0a57be02sm6640192pgh.31.2022.07.12.15.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:19:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v4 2/4] scsi: core: Make sure that hosts outlive targets
Date:   Tue, 12 Jul 2022 15:19:34 -0700
Message-Id: <20220712221936.1199196-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
In-Reply-To: <20220712221936.1199196-1-bvanassche@acm.org>
References: <20220712221936.1199196-1-bvanassche@acm.org>
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
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: Reworked Ming's patch and split it ]
---
 drivers/scsi/hosts.c     | 8 ++++++++
 drivers/scsi/scsi_scan.c | 7 +++++++
 include/scsi/scsi_host.h | 3 +++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ef6c0e37acce..8fa98c8d0ee0 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -190,6 +190,13 @@ void scsi_remove_host(struct Scsi_Host *shost)
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
 
@@ -394,6 +401,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	init_waitqueue_head(&shost->targets_wq);
 
 	index = ida_alloc(&host_index_ida, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4c1efd6a3b0c..ac6059702d13 100644
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
 
@@ -523,6 +528,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
 	init_waitqueue_head(&starget->sdev_wq);
 
+	atomic_inc(&shost->target_count);
+
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
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
