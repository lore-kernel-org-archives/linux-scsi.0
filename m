Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C7CC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 23:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjEDXvQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 19:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjEDXvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 19:51:15 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860E912E8F
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 16:51:13 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1aaec6f189cso7821985ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 16:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683244273; x=1685836273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSdj1gKKC/HzoWTj9GEbdbZJmfBJJsK5g1c/vX2YoJk=;
        b=icCCxFnul/rO90z3dJ5eZ9woeE3S4uFrOnzdDlfHsv/2qqrit7emVRBaFFL8Puo1FU
         HGbZkprbFyhcY+OZ328+YRuQm51RUYXpwrYqZ995ydC3Wfos6IL7f50RI6N1MuZRLEP+
         PkL3VUPoWsb1q/7nfEdLRGf8ShKestcseMmFwLovkmhDQa8OoR/47F8S05GhKnDt6813
         if+PL0HtbH2aZdk7Ix+RciSKfG5b/60EolAefZoEt9P/8kwbz/uoxMfugFf7rbM9YGr0
         YHGoSX/gZICbbbw6bdwJ4UrGKOljgykK8h1Pso9NlHi0WwbYd+KwvsdZFo3YIg9jVBYT
         qMpg==
X-Gm-Message-State: AC+VfDyZiZdOr+V3jW96bqxVH3Ldp2fe/6qaZmuiudaZ2Oo8R7Iz5rwE
        Yi+JHwMfcumfiPSj/5DhKXraYHTcIqw=
X-Google-Smtp-Source: ACHHUZ5FdsUM9bgVsJUTVax4IvN9bMtYBDkcfmB21DUoBAaxlLcX81k0giropRNXeL6wLbuEQDq4rw==
X-Received: by 2002:a17:902:ea09:b0:1ab:1878:845b with SMTP id s9-20020a170902ea0900b001ab1878845bmr6512790plg.26.1683244272963;
        Thu, 04 May 2023 16:51:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902758d00b001aad4be4503sm143169pll.2.2023.05.04.16.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:51:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/5] scsi: core: Rework scsi_host_block()
Date:   Thu,  4 May 2023 16:50:48 -0700
Message-Id: <20230504235052.4423-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230504235052.4423-1-bvanassche@acm.org>
References: <20230504235052.4423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make scsi_host_block() easier to read by converting it to the widely used
early-return style. This patch reworks code introduced by commit
f983622ae605 ("scsi: core: Avoid calling synchronize_rcu() for each device
in scsi_host_block()").

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Ye Bin <yebin10@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7c569a42aa4..758a57616dd3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2939,11 +2939,20 @@ scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
 }
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
+/**
+ * scsi_host_block - Try to transition all logical units to the SDEV_BLOCK state
+ * @shost: device to block
+ *
+ * Pause SCSI command processing for all logical units associated with the SCSI
+ * host and wait until pending scsi_queue_rq() calls have finished.
+ *
+ * Returns zero if successful or a negative error code upon failure.
+ */
 int
 scsi_host_block(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
-	int ret = 0;
+	int ret;
 
 	/*
 	 * Call scsi_internal_device_block_nowait so we can avoid
@@ -2955,7 +2964,7 @@ scsi_host_block(struct Scsi_Host *shost)
 		mutex_unlock(&sdev->state_mutex);
 		if (ret) {
 			scsi_device_put(sdev);
-			break;
+			return ret;
 		}
 	}
 
@@ -2965,10 +2974,9 @@ scsi_host_block(struct Scsi_Host *shost)
 	 */
 	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
 
-	if (!ret)
-		synchronize_rcu();
+	synchronize_rcu();
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(scsi_host_block);
 
