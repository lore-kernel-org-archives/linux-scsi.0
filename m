Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE919C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbjDYXgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbjDYXgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:36:10 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894BB13C19
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:07 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-63f273b219eso3020793b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465767; x=1685057767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGbEN8fksphX2AkoHcvCP4oDdAuLD4gszYSSQp27zsk=;
        b=VH7pYcBYdUKNO/2m6Y1zgkvia9cWwzd3CSpvBWFiJJwMwKFpAWD3ehyaMaBatIU6sp
         YyE4vQrc9H6L0M+sYBctVo2dwiqvhkbPZhDAN05rK3kBTRnjExWGdKJ58xzrQpr5o/HM
         lqBv3VlO/+2T5fGmXH6HuR3Woc7IDqL4Fj/bH1ZddNvV0t7RxsIL6PxLVN20Q60POtXu
         SvdJaj8lWlpUN6gu+uzLAoOPyYAx2w3eq4IBDJ/IrG4+05XnZUZm+V9boG1OiRED9u0r
         WdyVrv3RrNj8duuedajDBhI0F3xh8Q6CZoi39/fac5/8SlRopX/erpGeC8JTNdOF5kg9
         INsQ==
X-Gm-Message-State: AAQBX9dEjBRaqcuH32H4une/srX+hFFZYQ9eAqHzl3OdwvvfmHb+c9GT
        4awYSRD5gIohrO8hEbQB/LGWrx0tPbM=
X-Google-Smtp-Source: AKy350bCpD4V84KZkU786AGCHlYu9fFPcFqevcjnJ0bEv6IjjiGuJ/l02LT2yPezI3uRQcFPXNhQfw==
X-Received: by 2002:a05:6a20:7487:b0:f5:6cb8:105 with SMTP id p7-20020a056a20748700b000f56cb80105mr10787695pzd.45.1682465766860;
        Tue, 25 Apr 2023 16:36:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm10146984pfc.143.2023.04.25.16.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:36:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 3/4] scsi: Only kick the requeue list if necessary
Date:   Tue, 25 Apr 2023 16:34:45 -0700
Message-ID: <20230425233446.1231000-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425233446.1231000-1-bvanassche@acm.org>
References: <20230425233446.1231000-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_error.c |  2 ++
 drivers/scsi/scsi_lib.c   | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6bd0cff2a117..62ae100f98ec 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2090,6 +2090,8 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * now that error recovery is done, we will need to ensure that these
 	 * requests are started.
 	 */
+	shost_for_each_device(sdev, shost)
+		blk_mq_kick_requeue_list(sdev->request_queue);
 	scsi_run_host_queues(shost);
 
 	/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e59eb0cbfc83..e616730d6295 100644
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
@@ -462,6 +461,10 @@ void scsi_requeue_run_queue(struct work_struct *work)
 	scsi_run_queue(q);
 }
 
+/*
+ * Transfer requests from the requeue_list to from where these can be dispatched
+ * and run the request queues.
+ */
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
@@ -499,6 +502,9 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 
 static void scsi_run_queue_async(struct scsi_device *sdev)
 {
+	if (scsi_host_in_recovery(cmd->device->host))
+		return;
+
 	if (scsi_target(sdev)->single_lun ||
 	    !list_empty(&sdev->host->starved_list)) {
 		kblockd_schedule_work(&sdev->requeue_work);
