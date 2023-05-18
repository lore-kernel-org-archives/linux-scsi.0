Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3871BC77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 19:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjERTcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 15:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjERTcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 15:32:09 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBF6B5
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:08 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-64d2a87b9daso400590b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684438328; x=1687030328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SXLTFsp+gjzSgG9JqJUM2xgRcPzYQQmb2LNC2tO1KA=;
        b=g+zu+JtrAPJ9GJrZgnbWCzNQyeyA3+I3ggzdBt5U/rBD7g2wDZci8+M7Ky33s7J/BL
         M/bY5FLsyTkw5zgF6optYRX9as0gT7CVmEwqdfDMuupBoRkLY1nvtbSFdfpC4vlIvkfN
         a7e+q27VPpkoN4OGl/9rzHQ8PU8NXIlmosPy6Wqd1n50ePxso9q1YCsir3wn1Qa2cZqq
         5qOXawxjJUwDFkuoDihR65TH7MD9OAkpVe8i15YIQ9fqhF7hNBuDBDmbbsmrMLvVulDD
         OH723bUul+dqOXqml+TyOcw/zvVyK7qL8w8y3NXgK2LCi0oTmp9nS9z3wT1LpOszp8Jt
         HxTQ==
X-Gm-Message-State: AC+VfDxhJsipePptWS5JLi7rZbkN4pqRJvxfWWaqqVqrISwKjm7A4Dqw
        TjnruTxsQeE41La4tMsTYQzJtQgZWjo=
X-Google-Smtp-Source: ACHHUZ4lfTNzgX1HWcDy86+WvM1ydQV1I8kPvNz1nbxg9djMiBThWFf1WG5NJnUj8+WEczY13Kg7fw==
X-Received: by 2002:a05:6a20:1602:b0:102:2de7:ee36 with SMTP id l2-20020a056a20160200b001022de7ee36mr1090100pzj.36.1684438327556;
        Thu, 18 May 2023 12:32:07 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 11-20020a63050b000000b0051afa49e07asm1619047pgf.50.2023.05.18.12.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:32:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 3/3] scsi: core: Only kick the requeue list if necessary
Date:   Thu, 18 May 2023 12:31:59 -0700
Message-ID: <20230518193159.1166304-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230518193159.1166304-1-bvanassche@acm.org>
References: <20230518193159.1166304-1-bvanassche@acm.org>
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
