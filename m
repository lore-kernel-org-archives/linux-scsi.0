Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8508C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiI0Snz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiI0Snv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:43:51 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8491C1C4800
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:45 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id s206so10195470pgs.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=R3OzMiYJLOTGRxZPN+YV+Z6KrkVcZa9EpMLGP1Zjei4=;
        b=G095iJnmFK6VxnFRcezSBodxGU+1m2KfZqWF4AiYa857EdyumOFHJyw3bSe/LeSUz6
         +bW1WjDfBgBV79Ev8hu6WMaI2w/5zEu7ekcYsR5c5NPbot20BzYZh+w6e/+p4M5A6CWP
         lz+hYf//o5HG4PIz7L37S8ek+Jby2BPgJetMQcGiVj4aM0S8iBukMwiS6/+LoNVUN8sI
         03uSzpGPFTI3lvwK87Xyp9Z74EvAiCsowPs8+2ANCh/lHnzc7C6FWfWo/qZY+ibU9G7v
         pB3nzTJxV/sYE6bBMBIV1pkAlKSW7LsaZjupTuIbhEHR9x5boA/AgFRVfut0U2Gqa9kA
         HwuA==
X-Gm-Message-State: ACrzQf0De8PpmkL+mkKZwuQu6RUhOGHys3tjjp54f5TLeYQg/mTDSqYl
        KqlIs2eaRazv8Do9jk9Wny4=
X-Google-Smtp-Source: AMsMyM51AxjGfCqdGYUE0RtvIexsfmUP+kkojLyVeAYGIbxGG6b+qvTKbxTccq1NncPwUqwLDRv5cw==
X-Received: by 2002:a05:6a00:84d:b0:542:4254:17ef with SMTP id q13-20020a056a00084d00b00542425417efmr30161671pfk.31.1664304224629;
        Tue, 27 Sep 2022 11:43:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:43:43 -0700 (PDT)
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
Subject: [PATCH v2 3/8] scsi: core: Support failing requests while recovering
Date:   Tue, 27 Sep 2022 11:43:04 -0700
Message-Id: <20220927184309.2223322-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_lib.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 473d9403f0c1..ecd2ce3815df 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1337,9 +1337,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 				   struct scsi_device *sdev,
 				   struct scsi_cmnd *cmd)
 {
-	if (scsi_host_in_recovery(shost))
-		return 0;
-
 	if (atomic_read(&shost->host_blocked) > 0) {
 		if (scsi_host_busy(shost) > 0)
 			goto starved;
@@ -1727,6 +1724,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	ret = BLK_STS_RESOURCE;
 	if (!scsi_target_queue_ready(shost, sdev))
 		goto out_put_budget;
+	if (unlikely(scsi_host_in_recovery(shost))) {
+		if (req->cmd_flags & REQ_FAILFAST_MASK)
+			ret = BLK_STS_OFFLINE;
+		goto out_dec_target_busy;
+	}
 	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
 		goto out_dec_target_busy;
 
