Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC41EC64E69
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7BDB206F9
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgKPDFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 22:05:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45003 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgKPDFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 22:05:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id e21so11862989pgr.11;
        Sun, 15 Nov 2020 19:05:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mO/VUISba9ztqA4TxsbuCnsx2OLzOyMZ243ibr3yzvc=;
        b=aeMGJhHu/EaE2Gs8ebNRdtF/F7DBNIsvGLfOON7npk8JSHJ/ygJgfN1JNQeaz0rAFv
         N8YGn69dg829m+bZs9CA0sncNg2R5aRR76GVzM3GdlJCRmvnfOAeDjuFbT4gOxhLgLLx
         Q4akvvhm7ZqO/oI8dO+TiOjBc8eXKkgbJ1c/K7/EaK+JGYWtz4N5Vy+K4eynf+Daa1So
         2t72H00dGhH+6bbw7k0k+8Dq0Q3TPqjYo9jc+ZmpTJNRWhvnetiXOY4U3mKfR4j26jbH
         MGcWXrdbqi9o77acPnCAV/8vANZBNcZk2kFmGwKdq8l2opyW9LZq2ykHjyrxuLP/dPBo
         mn2w==
X-Gm-Message-State: AOAM532DXQ138fN3TrSY8D3NQF8XV8bbOYlciq0siFDQvTSRuphHZU9V
        exBEwb0mhzyqPabHurzDSLA=
X-Google-Smtp-Source: ABdhPJyLpYuyN0wFT6vx4L4fY5j+n/zZ4yHt4V6+3ATWJFrWBxdUPgfVjJqf4lt0D7y4yOSasVX90w==
X-Received: by 2002:a17:90b:1496:: with SMTP id js22mr7836795pjb.85.1605495915767;
        Sun, 15 Nov 2020 19:05:15 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r3sm17148131pjl.23.2020.11.15.19.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:05:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v2 4/9] scsi: Rework scsi_mq_alloc_queue()
Date:   Sun, 15 Nov 2020 19:04:54 -0800
Message-Id: <20201116030459.13963-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116030459.13963-1-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not modify sdev->request_queue. Remove the sdev->request_queue
assignment. That assignment is superfluous because scsi_mq_alloc_queue()
only has one caller and that caller calls scsi_mq_alloc_queue() as follows:

	sdev->request_queue = scsi_mq_alloc_queue(sdev);

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e4f9ed355be6..ff480fa6261e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1883,14 +1883,15 @@ static const struct blk_mq_ops scsi_mq_ops = {
 
 struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
 {
-	sdev->request_queue = blk_mq_init_queue(&sdev->host->tag_set);
-	if (IS_ERR(sdev->request_queue))
+	struct request_queue *q = blk_mq_init_queue(&sdev->host->tag_set);
+
+	if (IS_ERR(q))
 		return NULL;
 
-	sdev->request_queue->queuedata = sdev;
-	__scsi_init_queue(sdev->host, sdev->request_queue);
-	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, sdev->request_queue);
-	return sdev->request_queue;
+	q->queuedata = sdev;
+	__scsi_init_queue(sdev->host, q);
+	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
+	return q;
 }
 
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
