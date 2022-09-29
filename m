Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE82C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiI2WqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiI2Wph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:37 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9FF63AF
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:43 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id r8-20020a17090a560800b00205eaaba073so2672065pjf.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mBpdDy9J/eQ+4T5DAwBleE+5EWJWfVngpI443pompXc=;
        b=fGPssS17M2KXt+hN2iigj5PZrw35UVIBaklGHm4EHo11WZ/iJMkeLBh3Th03lOzvqi
         vbiETC4jYp+HVX7EyWUeUuswrYnUTJDQfl0TeDfBnTgdKlKbpBWyriyjedW4F9dqzk2n
         QvxT5dfVOmhNGs+2phRTi9eMZQWP+5vKWP9vAnqWUZgFGPYggsQroOMJgYBEcVxQJj27
         KURlSDC9W1pk8BjSI2vwHq40zc1WE41U+Ogb8jbS5uRPxVv9E2UGUHjL1Cm3KjOTkPnO
         dRjkwE/XIzDLrs8MJbP4B9s8vl9wFP3FTv3FwuNTmvjvmSxbpMcUljjDgPLT+xN/MWcH
         WlGA==
X-Gm-Message-State: ACrzQf0vfGxz02nM5sephoUA8947bMhjTRTRspQik6UawwmUiSG5DOZr
        QuqilaXYzCdJ1TAyMGZt1Aw=
X-Google-Smtp-Source: AMsMyM6yvrTdyeJrXJnEdYGnScbds12z/NIoeS9pCuNAZn/NAwglcViFRVoZcWLaweDg/FXZf+l4Ow==
X-Received: by 2002:a17:902:ecd2:b0:178:3b53:ebf7 with SMTP id a18-20020a170902ecd200b001783b53ebf7mr5380436plh.28.1664491483172;
        Thu, 29 Sep 2022 15:44:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 5/8] scsi: core: Rework scsi_single_lun_run()
Date:   Thu, 29 Sep 2022 15:44:18 -0700
Message-Id: <20220929224421.587465-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929224421.587465-1-bvanassche@acm.org>
References: <20220929224421.587465-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use __starget_for_each_device() instead of open-coding
starget_for_each_device(). This patch removes code that calls
scsi_device_put() from atomic context.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 473d9403f0c1..da1e6f9f9221 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -302,6 +302,18 @@ static void scsi_kick_queue(struct request_queue *q)
 	blk_mq_run_hw_queues(q, false);
 }
 
+/*
+ * Kick the queue of SCSI device @sdev if @sdev != current_sdev. Called with
+ * interrupts disabled.
+ */
+static void scsi_kick_sdev_queue(struct scsi_device *sdev, void *data)
+{
+	struct scsi_device *current_sdev = data;
+
+	if (sdev != current_sdev)
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 /*
  * Called for single_lun devices on IO completion. Clear starget_sdev_user,
  * and call blk_run_queue for all the scsi_devices on the target -
@@ -312,7 +324,6 @@ static void scsi_kick_queue(struct request_queue *q)
 static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
 	struct Scsi_Host *shost = current_sdev->host;
-	struct scsi_device *sdev, *tmp;
 	struct scsi_target *starget = scsi_target(current_sdev);
 	unsigned long flags;
 
@@ -329,22 +340,9 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	scsi_kick_queue(current_sdev->request_queue);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (starget->starget_sdev_user)
-		goto out;
-	list_for_each_entry_safe(sdev, tmp, &starget->devices,
-			same_target_siblings) {
-		if (sdev == current_sdev)
-			continue;
-		if (scsi_device_get(sdev))
-			continue;
-
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_kick_queue(sdev->request_queue);
-		spin_lock_irqsave(shost->host_lock, flags);
-
-		scsi_device_put(sdev);
-	}
- out:
+	if (!starget->starget_sdev_user)
+		__starget_for_each_device(starget, current_sdev,
+					  scsi_kick_sdev_queue);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
