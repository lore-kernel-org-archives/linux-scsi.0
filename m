Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F782C77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjE2U0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjE2U0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:26:48 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F37CF
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:46 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-256531ad335so1920260a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392006; x=1687984006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8x42vvxZ3hosM7pzAt3IRC1oA+8NjrQ1GsxIUsXU/8E=;
        b=OEsT2IRFfShw7KdLQCnNTfjf4YiTgyS/M5niY/4Hov1L9dwLyHypTYeSw40E/9ut9g
         7JLrBiXzuYbdtgrIsyLNpdBmtQ3Z0ggE3pvz4aZ389R333K3LxWUpz82mP5bpNAzu7m7
         pKk0en6lMLgqG3uQu/7mnoaydUEDXqc3SX1z/OjLMunu/DG2xS8RWLhFQoqHfqo7WBoB
         Udepr3Bdbe33rpWsH0S4JJU7Xjmgca/ELRhJiGriT99QqD99JYyUhS59Fvv0zIL850uY
         +CFZV56dUqfOou8QCX+S+8NRrSHug+bzV2CJH6GgubVw88SZ/TEfIC4Qw5r5U68B7ESQ
         21lQ==
X-Gm-Message-State: AC+VfDx8jMLWM0kO/dH6yJCg6F+Tp+YlHsi9Eh1pv7eX8GsVemZbLH60
        sAOkshQ/dEQXfguELq+a4X0=
X-Google-Smtp-Source: ACHHUZ6HLXPwX7CkN9UCkkzMO5q4D22RUrvsQNPC6MhFRZuu9pZTMwJ21BGPIRwADQA91itKDvM+Hw==
X-Received: by 2002:a17:902:c94a:b0:1a6:8ed5:428a with SMTP id i10-20020a170902c94a00b001a68ed5428amr369049pla.22.1685392006130;
        Mon, 29 May 2023 13:26:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903245200b001b027221393sm4957237pls.43.2023.05.29.13.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:26:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 1/5] scsi: core: Rework scsi_host_block()
Date:   Mon, 29 May 2023 13:26:36 -0700
Message-Id: <20230529202640.11883-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202640.11883-1-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
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
 
