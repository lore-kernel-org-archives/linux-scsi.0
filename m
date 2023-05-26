Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A7CC77B7A
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 17:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242649AbjEZRaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjEZRaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 13:30:16 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597D0F3
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:12 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ae3f6e5d70so9512545ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122212; x=1687714212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8x42vvxZ3hosM7pzAt3IRC1oA+8NjrQ1GsxIUsXU/8E=;
        b=BcpDl1lWCBXnBMM9zJ0/QtM+fzEjltIBVL1goreu7N91Kic0Y7TR7zNl6bnnc8rCpR
         3K8pGHHoqVfRXIwcEjd96tMN+MTURPWn92Ngre/CUcSrylzo7G2LSIR7qqmQcuTAIiOH
         PSQnjiFAAzcekeYPgZZI/iUcGT7HIUcMnWLM/L+05RP+05ZQeNIHkYiWezG+Q3MPYE5g
         LoYf2ir4pZH/msjnxeQ41IRtsw0KLDQYnfeVw+iqljmITWEDBdPG8xVVzk2D3/8arT/E
         yNQUh31HbzTHTgfY2sOnzpKSWeIKrNzxj812ABYvQcl6kQBoGhM83fjH4e1FR2y0n/fZ
         GhlQ==
X-Gm-Message-State: AC+VfDyRQKYf7Vks6aPRi19w3PXEhBRXwV4JSFNwuiiAibBS2i66+7vI
        MVLKlQKwC0GbRxCGILRT5ak=
X-Google-Smtp-Source: ACHHUZ4coYEXBMBxHB8chCbYS3M4F/EyFajBnIZMNHZkSJGCFIq74D8Zo7MW0CCNOp8ctnHLSuK8Fg==
X-Received: by 2002:a17:902:da82:b0:1a6:d9de:1887 with SMTP id j2-20020a170902da8200b001a6d9de1887mr3745236plx.53.1685122211582;
        Fri, 26 May 2023 10:30:11 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001ac7c725c1asm3519156plf.6.2023.05.26.10.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:30:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 1/4] scsi: core: Rework scsi_host_block()
Date:   Fri, 26 May 2023 10:29:46 -0700
Message-ID: <20230526173007.1627017-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
In-Reply-To: <20230526173007.1627017-1-bvanassche@acm.org>
References: <20230526173007.1627017-1-bvanassche@acm.org>
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
 
