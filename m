Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5A8C77B7F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 23:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjECXHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 19:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjECXHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 19:07:12 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9677A8D
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 16:07:11 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-63b4bf2d74aso4133306b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 16:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155231; x=1685747231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3tDY/U8HCExb5CoLpw2PAmlBPqhNdqgt9QEMBrECLpc=;
        b=VkcSG/bmGSjqWBVWFHMCpmQNiuY7vv5zsjjYjK/D3J6L6hlHLDgKk/i95CtNSBVWUB
         Sm/sDYr4t2wMiWMBwhKsHn1L4vRJuZI0216el6Ef6txvmDoOoWcvIC96UJcG6Rj8Q4Fg
         3KNiLr2CDZOZqTgUpEtXEcmn6uwinV2MN+qDMxNE8ANifQ8sDiMqe5BqpzK9L0v4dwFn
         Ej1zOtkySa+ntNiRlDR6qOAPORGOkXActSMfWSe11pa3pjw8Ujxpvrb/yaCAZtJJc1tE
         A3omoJC1NJkmLCN0vAq5Tkx2h2YlDyKHYHx5TzYJAAl5Gp4b6fbdfzdkUeVkdULiZPai
         28ag==
X-Gm-Message-State: AC+VfDxLbYQMAwISIv9zeOFhibSjzvq2lUfJAgbbn68KDmL0CwhkMhJf
        Dkq+5ecMTfNwKVGIzpBvqMA=
X-Google-Smtp-Source: ACHHUZ4ZuXdydCNNCwKD0kXxlioEBwQiWYlw1QAkUZBCgeX472By4S2mke6rEw37rA0tv8i9NEKXAg==
X-Received: by 2002:a05:6a00:1a4d:b0:641:d9b:a444 with SMTP id h13-20020a056a001a4d00b006410d9ba444mr194391pfv.31.1683155230652;
        Wed, 03 May 2023 16:07:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2c3b:81e:ce21:2437])
        by smtp.gmail.com with ESMTPSA id u3-20020a056a00158300b0063f3aac78b9sm19531603pfk.79.2023.05.03.16.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:07:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 4/5] scsi: core: Only kick the requeue list if necessary
Date:   Wed,  3 May 2023 16:06:53 -0700
Message-ID: <20230503230654.2441121-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
In-Reply-To: <20230503230654.2441121-1-bvanassche@acm.org>
References: <20230503230654.2441121-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_lib.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e59eb0cbfc83..a34390d35f1d 100644
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
@@ -462,10 +461,16 @@ void scsi_requeue_run_queue(struct work_struct *work)
 	scsi_run_queue(q);
 }
 
+/*
+ * Transfer requests from the requeue_list to from where these can be dispatched
+ * and run the request queues.
+ */
 void scsi_run_host_queues(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
 
+	shost_for_each_device(sdev, shost)
+		blk_mq_kick_requeue_list(sdev->request_queue);
 	shost_for_each_device(sdev, shost)
 		scsi_run_queue(sdev->request_queue);
 }
@@ -499,6 +504,9 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 
 static void scsi_run_queue_async(struct scsi_device *sdev)
 {
+	if (scsi_host_in_recovery(sdev->host))
+		return;
+
 	if (scsi_target(sdev)->single_lun ||
 	    !list_empty(&sdev->host->starved_list)) {
 		kblockd_schedule_work(&sdev->requeue_work);
