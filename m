Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B14C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjEQXJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjEQXJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:09:50 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A465276
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:37 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-64d11974b45so145494b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364977; x=1686956977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SXLTFsp+gjzSgG9JqJUM2xgRcPzYQQmb2LNC2tO1KA=;
        b=dH+PSz5y7jaQ6rwaocE3mBcw3daaJnd6qxpval0X8oIlAogpLjEo8blchwol/H9XYS
         ZHb7lkrQXJii8wtD+h61TWKRC6R9mZ0TMmYJAoItX9pvXhX+XLU02IN1piY6flWTmP9m
         sRa/yZonnNDIaSeueVSzK/qGTeSLGpMT9HQSM9jvUgF7jwPifwo+qYBvn89NIEPx/IwV
         ehEFJFJq1H0xmD9bwkEPTT82QLnK7H+Rh2OrKtaEcHuKzScsLhqRMcC9IPSBY5Y5fx9S
         N9W+xNMsJrM0/JIpOmeQZ3O/VP35+eakLY0TOdEEqFrrp77bpxhqLbJ+bvonfdbC3gb1
         sK1g==
X-Gm-Message-State: AC+VfDyZ8XeE2uA8J/ivUor3RBODk0dIOT8HMMGI6ke5/vTvrDDn3nLE
        vUYzruOkesfDjnp4Ex56g84=
X-Google-Smtp-Source: ACHHUZ5xUmhGjf5OSM6z+FdH1grxavG1CmgJxdLZ9YGX7Lcbf7eXv6K6tM+16KUHo1iWCLOpySBflw==
X-Received: by 2002:a05:6a21:9991:b0:104:7a4c:6ca6 with SMTP id ve17-20020a056a21999100b001047a4c6ca6mr27035099pzb.13.1684364976546;
        Wed, 17 May 2023 16:09:36 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e9-20020a656789000000b005286ea6190esm15080694pgr.20.2023.05.17.16.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:09:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 3/4] scsi: core: Only kick the requeue list if necessary
Date:   Wed, 17 May 2023 16:09:26 -0700
Message-ID: <20230517230927.1091124-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517230927.1091124-1-bvanassche@acm.org>
References: <20230517230927.1091124-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of running the request queue of each device associated with a
host every 3 ms (BLK_MQ_RESOURCE_DELAY) while host error handling is in
progress, run the request queue after error handling has finished.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e59eb0cbfc83..e4f34217b879 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -122,11 +122,9 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd, unsigned long msecs)
 		WARN_ON_ONCE(true);
 	}
 
-	if (msecs) {
-		blk_mq_requeue_request(rq, false);
+	blk_mq_requeue_request(rq, false);
+	if (!scsi_host_in_recovery(cmd->device->host))
 		blk_mq_delay_kick_requeue_list(rq->q, msecs);
-	} else
-		blk_mq_requeue_request(rq, true);
 }
 
 /**
@@ -165,7 +163,8 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	 */
 	cmd->result = 0;
 
-	blk_mq_requeue_request(scsi_cmd_to_rq(cmd), true);
+	blk_mq_requeue_request(scsi_cmd_to_rq(cmd),
+			       !scsi_host_in_recovery(cmd->device->host));
 }
 
 /**
@@ -449,6 +448,7 @@ static void scsi_run_queue(struct request_queue *q)
 	if (!list_empty(&sdev->host->starved_list))
 		scsi_starved_list_run(sdev->host);
 
+	blk_mq_kick_requeue_list(q);
 	blk_mq_run_hw_queues(q, false);
 }
 
@@ -499,6 +499,9 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 
 static void scsi_run_queue_async(struct scsi_device *sdev)
 {
+	if (scsi_host_in_recovery(sdev->host))
+		return;
+
 	if (scsi_target(sdev)->single_lun ||
 	    !list_empty(&sdev->host->starved_list)) {
 		kblockd_schedule_work(&sdev->requeue_work);
