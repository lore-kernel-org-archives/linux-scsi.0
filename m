Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5E0C71155
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C5D72137B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgKWDSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:18:11 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:33505 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgKWDSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:18:06 -0500
Received: by mail-pl1-f178.google.com with SMTP id t18so8175452plo.0;
        Sun, 22 Nov 2020 19:18:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pD2rDilaSgc9ISe5zrMqS5hBmqhHwv5HvRHlevWYJQ8=;
        b=UD1WlwJr2Aa3hP3yhtLmakB2g7zaIHA9Qcj+fFWQilPu3L19YFqNGwLn74BFF1eAX+
         3UCdIygnX+q1EpOTObqkXvFiSk6WN8SxFMxWPB8aogSn7mQYsekKfgUjEdPe9+rrXA4a
         GK4rrRJk2ats3+7tswSAwTCCdd4p4wMqHlk+1IpKTPpD7M68JwIrqkM62NCyZGpcjbGi
         JrF3DrmgRMduWkT26uO67fSsIf5jISUJstxkd4+ZJrkGM1cngK50/CTgt3aDwVpIXN+i
         2if9XN1nrKY6jRfYxMCu3dvIGTWubIEYUohkvL0zZL6JQmqAn1B+R/sNH5Hg8RD9MMli
         ZFzQ==
X-Gm-Message-State: AOAM530/kcOra2bDZelqhwJyBKmVOdxBHijpItGMCgESyRYGHWBrxYJe
        Fe9YGG5I5O6xwb0sIaQ1or0=
X-Google-Smtp-Source: ABdhPJxEDjSxmIrGL/BE9gvaoV+8iv1RckEIMZNbQoqYKRDpDpvNOiGOcdpcTJP8tQfwfaQ97fOJfA==
X-Received: by 2002:a17:902:8e84:b029:d7:eb0d:2fe6 with SMTP id bg4-20020a1709028e84b02900d7eb0d2fe6mr22940325plb.16.1606101485303;
        Sun, 22 Nov 2020 19:18:05 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:18:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v3 4/9] scsi: Inline scsi_mq_alloc_queue()
Date:   Sun, 22 Nov 2020 19:17:44 -0800
Message-Id: <20201123031749.14912-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123031749.14912-1-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since scsi_mq_alloc_queue() only has one caller, inline it. This change
was suggested by Christoph Hellwig.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 12 ------------
 drivers/scsi/scsi_priv.h |  1 -
 drivers/scsi/scsi_scan.c | 12 ++++++++----
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a7252df74c7b..b5449efc7283 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1881,18 +1881,6 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.map_queues	= scsi_map_queues,
 };
 
-struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
-{
-	sdev->request_queue = blk_mq_init_queue(&sdev->host->tag_set);
-	if (IS_ERR(sdev->request_queue))
-		return NULL;
-
-	sdev->request_queue->queuedata = sdev;
-	__scsi_init_queue(sdev->host, sdev->request_queue);
-	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, sdev->request_queue);
-	return sdev->request_queue;
-}
-
 int scsi_mq_setup_tags(struct Scsi_Host *shost)
 {
 	unsigned int cmd_size, sgl_size;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 180636d54982..e34755986b47 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -90,7 +90,6 @@ extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
-extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..43416e7259a7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -216,6 +216,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 					   u64 lun, void *hostdata)
 {
 	struct scsi_device *sdev;
+	struct request_queue *q;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
@@ -265,16 +266,19 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 */
 	sdev->borken = 1;
 
-	sdev->request_queue = scsi_mq_alloc_queue(sdev);
-	if (!sdev->request_queue) {
+	q = blk_mq_init_queue(&sdev->host->tag_set);
+	if (IS_ERR(q)) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
 	}
-	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
-	sdev->request_queue->queuedata = sdev;
+	sdev->request_queue = q;
+	q->queuedata = sdev;
+	__scsi_init_queue(sdev->host, q);
+	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
+	WARN_ON_ONCE(!blk_get_queue(q));
 
 	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
 					sdev->host->cmd_per_lun : 1);
