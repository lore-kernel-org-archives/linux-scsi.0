Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A855AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJRUan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJRUad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:30:33 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD856647DF
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:20 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id q1so14290293pgl.11
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwIbGLiuZXIVrQS613fVUgRhpG6gP+e1rIUIpvDyBRw=;
        b=OdmI7cWG2fgmBWklnL4pUJxDnzZH1zHuvOppvzMPBLZLNP4RbNv1Cw9caDLGYZaXnh
         JDfm3sSEBmh5UMpxtNpn3L/kxYqvOjMbCLqZr2AkP9S9CNAJ9nS54b7/+gxXvV5V0INI
         c9Gvnrkma665119nl9qMsY/x8rmuF76HKQZGUEI/awzaWvWXfEVB3Ifl4UiQ/qAj1i+C
         p7D54KlrAnlA8Hl6WAY/gbnoF/5m3NlqFD4nn/0hdGFTEunjekeeh7/j7Y4KQWTaFnQZ
         lFUrVWNV8tFbq91gxmyFbPMgx+GkGa6G3vXz+yTlqOsnGZNVitcDpTgcyI439oJbMew8
         ngSg==
X-Gm-Message-State: ACrzQf0Cq6Daoqg0izTkQoVpQAF5VwmE1mXTasapYMuDfZr5XlET3M6B
        YTjjUD56KFPg4bv5GTV1CPo=
X-Google-Smtp-Source: AMsMyM5t0HwuYneWvE6B3XkU381cxD1bhM8XlRCI5HNncAxajnxIENZWbzfkiQx3DfnpQxqZq4M3dQ==
X-Received: by 2002:a62:cfc2:0:b0:565:cbcd:b0a3 with SMTP id b185-20020a62cfc2000000b00565cbcdb0a3mr4751720pfg.73.1666125020132;
        Tue, 18 Oct 2022 13:30:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:30:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 03/10] scsi: core: Support failing requests while recovering
Date:   Tue, 18 Oct 2022 13:29:51 -0700
Message-Id: <20221018202958.1902564-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current behavior for SCSI commands submitted while error recovery
is ongoing is to retry command submission after error recovery has
finished. See also the scsi_host_in_recovery() check in
scsi_host_queue_ready(). Add support for failing SCSI commands while
host recovery is in progress. This functionality will be used to fix a
deadlock in the UFS driver.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 8 +++++---
 include/scsi/scsi_cmnd.h | 3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa96d3cfdfa3..ec890865abae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1341,9 +1341,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 				   struct scsi_device *sdev,
 				   struct scsi_cmnd *cmd)
 {
-	if (scsi_host_in_recovery(shost))
-		return 0;
-
 	if (atomic_read(&shost->host_blocked) > 0) {
 		if (scsi_host_busy(shost) > 0)
 			goto starved;
@@ -1732,6 +1729,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	ret = BLK_STS_RESOURCE;
 	if (!scsi_target_queue_ready(shost, sdev))
 		goto out_put_budget;
+	if (unlikely(scsi_host_in_recovery(shost))) {
+		if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
+			ret = BLK_STS_OFFLINE;
+		goto out_dec_target_busy;
+	}
 	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
 		goto out_dec_target_busy;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7d3622db38ed..c2cb5f69635c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -52,8 +52,9 @@ struct scsi_pointer {
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_INITIALIZED	(1 << 1)
 #define SCMD_LAST		(1 << 2)
+#define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
