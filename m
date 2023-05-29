Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04EFC7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjE2UWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjE2UWK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:22:10 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5354CCF;
        Mon, 29 May 2023 13:22:09 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso2769493b3a.0;
        Mon, 29 May 2023 13:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685391729; x=1687983729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8x42vvxZ3hosM7pzAt3IRC1oA+8NjrQ1GsxIUsXU/8E=;
        b=VPuSfeBFrBgo1U//iJf0eOiny93hjim/FentYpfYauSlIl4Cp9UXrVKE3r1Khpkims
         Kcnq0YvZ2mcRgCWCgkFyqWlyIyrENIXlrUIY+q1edmHEQ5QQgNWcVqDMjsmuOmFbvGg8
         SKEekEJbQ7djhWkQwIRnXiU3b7thQdgV/eqy0ZpoHVFla53Xi356xnS869l7F9IxklAm
         vkDaMQj6lNWMaxib/9hPdbhg2W/wGslqPKpexKttQz5d1LBAIZcbkjDi+1+31nMyqOWj
         i2RUlcXGgmviVTOOtS2rQm+doTG/zPC9FRec2EkiBK9/4nDSKKL2QY5xmAHEjLknwjLX
         3nMA==
X-Gm-Message-State: AC+VfDyBDvAVHS4HJmzxFiCgeD0F5EoLSDMzA3Q3IUx3W5xefFUdhir4
        vHBiHGsy7W8v9GJLwwyi6dM=
X-Google-Smtp-Source: ACHHUZ6yovYxBFXQZDWTQbxDtAeHfOczKfujmyHXJoG4QUbj5aMRK8PMVlRYrtwEnweteapn4QWgzA==
X-Received: by 2002:a05:6a20:4304:b0:111:6d42:a8ac with SMTP id h4-20020a056a20430400b001116d42a8acmr131506pzk.14.1685391728795;
        Mon, 29 May 2023 13:22:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a639313000000b0051b0e564963sm7439342pge.49.2023.05.29.13.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:22:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4 1/5] scsi: core: Rework scsi_host_block()
Date:   Mon, 29 May 2023 13:21:53 -0700
Message-Id: <20230529202157.11361-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202157.11361-1-bvanassche@acm.org>
References: <20230529202157.11361-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make scsi_host_block() easier to read by converting it to the widely used
early-return style. See also commit f983622ae605 ("scsi: core: Avoid
calling synchronize_rcu() for each device in scsi_host_block()").

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Ye Bin <yebin10@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 25489fbd94c6..5f29faa0560f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2940,11 +2940,20 @@ scsi_target_unblock(struct device *dev, enum scsi_device_state new_state)
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
@@ -2956,7 +2965,7 @@ scsi_host_block(struct Scsi_Host *shost)
 		mutex_unlock(&sdev->state_mutex);
 		if (ret) {
 			scsi_device_put(sdev);
-			break;
+			return ret;
 		}
 	}
 
@@ -2966,10 +2975,9 @@ scsi_host_block(struct Scsi_Host *shost)
 	 */
 	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
 
-	if (!ret)
-		synchronize_rcu();
+	synchronize_rcu();
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(scsi_host_block);
 
