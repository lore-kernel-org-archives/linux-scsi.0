Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE15C7EE2A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjEQWYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjEQWYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:24:08 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152C31B5
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:08 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-24e01ba9e03so1092211a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362247; x=1686954247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dZcwxtfcD8Fe17tSglc1QdlV0KH+SGvkZJrbqOzBVcA=;
        b=RJah39kltf2uVzh39ujDAhOaFB60nMo0uK2bvIqzwzIBsFEhpphW5AMCfq5PCyI7o/
         hocCnghRfLqgbrBJgy6S3O4soY/6ZO6vrW/PO6GwLE/dc19ooSBewACnGSE2fF9PT0sR
         iwFhW1aMW8Ap0gjy1aBvZYPMmq3BI/TXO3z/y+j4JkWdYk8vt6s6e037rOd+uKe6lMfg
         QHqgRBfOz9XAplibHLcNvsKyu61PpD54QXYyRjDwipnZoQ51OSbuZbim+NO0zL+xjUtL
         vbTk0ogZQjfejH5yd7sBT7KVbFsOcVMCVs6zLcq8lxIlGwZUCZ2wZ6jf5EZWkIq3ytt3
         HaLw==
X-Gm-Message-State: AC+VfDzuVyTmLrxAblsaK0JsPdrbgFGY3KPpZL83ytIf2nCViiaEO6yg
        2SgBuKLRvIT6/m8iw+9Ciqs=
X-Google-Smtp-Source: ACHHUZ7TLJXlWfVrI/tIqx8zezz17hTm6e2OGlbhngL55fiflq8atuf/Z9qlR4IMdd0oAzjZNnjXAQ==
X-Received: by 2002:a17:90a:ee94:b0:247:6022:9595 with SMTP id i20-20020a17090aee9400b0024760229595mr322447pjz.45.1684362247487;
        Wed, 17 May 2023 15:24:07 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d32-20020a17090a6f2300b0024df6bbf5d8sm66273pjk.30.2023.05.17.15.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:24:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/4] scsi: core: Support setting BLK_MQ_F_BLOCKING
Date:   Wed, 17 May 2023 15:23:57 -0700
Message-ID: <20230517222359.1066918-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517222359.1066918-1-bvanassche@acm.org>
References: <20230517222359.1066918-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep. This
patch is similar to a patch posted last year by Mike Christie. See also
https://lore.kernel.org/all/20220308003957.123312-2-michael.christie@oracle.com/

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 10 +++-------
 include/scsi/scsi_host.h |  3 +++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 758a57616dd3..894af68babc2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1982,6 +1982,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
+	if (shost->hostt->queuecommand_may_block)
+		tag_set->flags |= BLK_MQ_F_BLOCKING;
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
@@ -2968,13 +2970,7 @@ scsi_host_block(struct Scsi_Host *shost)
 		}
 	}
 
-	/*
-	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
-	 * calling synchronize_rcu() once is enough.
-	 */
-	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
-
-	synchronize_rcu();
+	blk_mq_wait_quiesce_done(&shost->tag_set);
 
 	return 0;
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0f29799efa02..37a8a2608dc2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -458,6 +458,9 @@ struct scsi_host_template {
 	/* True if the host uses host-wide tagspace */
 	unsigned host_tagset:1;
 
+	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
+	unsigned queuecommand_may_block:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
