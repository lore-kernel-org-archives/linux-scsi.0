Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435F2C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjEQWYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEQWYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:24:08 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395CC469B
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:07 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1ae557aaf1dso10393805ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362247; x=1686954247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Ftpk2ZfoAUloir0cIz3f8LsSSZvajSoIJfmYvdvx4E=;
        b=PFN9ruQYa2ZkTHL7GJryACypGJQeKFWvKrShGLIN7jtS/eVvy7f+Pq6/40S8czKGK5
         7e9QPfbomB5b2lvJSvI7HYO7ViAfuc0gv5ZlFphMRlHbPtSqBGecH9ttp+ocBuX+MYU6
         F2o2h4OcDaj1viDcicDlosAqaw/N4r6GMZ07UY0lQAxLy7EGSnaYW2g/fUJHiYJoWDy9
         yD3Cvzekw5yaROQi5cm8dvVSCv7mlvZngp1L/HaIFmu6GC0HBKRFWn+G0ePYNGxHyU4A
         +vZIgXetlzPDOigvSkAsT906EfpPy3ABA9TS5hCBuhhjwLNTXECXGw6vgaQY471XRMEw
         hiJA==
X-Gm-Message-State: AC+VfDwWjqi8NROpo4JqDQRLLP4rpDm27bMw9M6T8VKVVhvo6amuISm9
        oIkeIdJ0jWvlvaauUupxLu8=
X-Google-Smtp-Source: ACHHUZ4HZ8K/h34f5uT2HTGMtpnm38uu9V8lIUty3h7zd/AC2fSDuaCzZdMMs5vxZ19veKuFcaYKcQ==
X-Received: by 2002:a17:903:18e:b0:1ad:bccc:af6a with SMTP id z14-20020a170903018e00b001adbcccaf6amr234949plg.56.1684362246645;
        Wed, 17 May 2023 15:24:06 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d32-20020a17090a6f2300b0024df6bbf5d8sm66273pjk.30.2023.05.17.15.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:24:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 1/4] scsi: core: Rework scsi_host_block()
Date:   Wed, 17 May 2023 15:23:56 -0700
Message-ID: <20230517222359.1066918-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517222359.1066918-1-bvanassche@acm.org>
References: <20230517222359.1066918-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make scsi_host_block() easier to read by converting it to the widely used
early-return style. See also commit f983622ae605 ("scsi: core: Avoid
calling synchronize_rcu() for each device in scsi_host_block()").

Reviewed-by: Mike Christie <michael.christie@oracle.com>
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
 
