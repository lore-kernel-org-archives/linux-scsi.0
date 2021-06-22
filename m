Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC30EC4743C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 02:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8FCB61026
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 02:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhFVCtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 22:49:18 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:36453 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhFVCtR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 22:49:17 -0400
Received: by mail-pj1-f48.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so861958pjn.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 19:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w3jY+Bm3pRUXISnP0Fs23eGIOPYAxdJGl49SCNpREqE=;
        b=nXf+8nCqbisPto5pB1yjiFxxA6fycsveiY7SltZxaYwrfjvMQXr22O26K9qPz2rFJ0
         v5GLyvC1LvWl0c/cCBDFSKiLSxYh/J4KWMHJH/c9Zdcf8Abq/NRbdj4M121o+n7ou7vN
         1kMSdtYJ/58tSwaNG6bIVT/7p4IaVJBUwrf2uxMXtweHxgkoR9525bdsphb1fP4idlS8
         TkFFy6cBqWjVklGg2UvXUU9NcDcqI5gOhMu4wPjdiHXVswMyK+t4VT2JPEqGRrzqbRYr
         LZaR7BaqiB4+BFeLBg2ZUF+l1c2LRzs4k0E7o7pLBRuyshU9SHc9qASmuxk5MuuIkqb1
         byrQ==
X-Gm-Message-State: AOAM531+YqtkKeMYKZBMMviEVN7GhcvzULwCN8UK9WucqUPIp5BRwHBY
        50ewMKMhaLW7IWHyqOCdB12UQcszqh8=
X-Google-Smtp-Source: ABdhPJx+yK7lx+0TlEuiNaLh1WjfLYFnocvqWc+DDUf5eiT2IbBUPWS4W8P6HB/lMPKOPTNlpA3ZcA==
X-Received: by 2002:a17:90a:c791:: with SMTP id gn17mr1239330pjb.221.1624330021192;
        Mon, 21 Jun 2021 19:47:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s24sm512039pju.9.2021.06.21.19.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 19:47:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Ed Tsai <ed.tsai@mediatek.com>
Subject: [PATCH] scsi: Inline scsi_mq_alloc_queue()
Date:   Mon, 21 Jun 2021 19:46:54 -0700
Message-Id: <20210622024654.12543-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since scsi_mq_alloc_queue() only has one caller, inline it. This change
was suggested by Christoph Hellwig.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 12 ------------
 drivers/scsi/scsi_priv.h |  1 -
 drivers/scsi/scsi_scan.c | 12 ++++++++----
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b994baf87c2..d1f0ad7c4c36 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1897,18 +1897,6 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.get_rq_budget_token = scsi_mq_get_rq_budget_token,
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
index 75d6f23e4fff..eae2235f79b5 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -91,7 +91,6 @@ extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
-extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5ce45ef9808f..b059bf2b61d4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -217,6 +217,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 {
 	unsigned int depth;
 	struct scsi_device *sdev;
+	struct request_queue *q;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
@@ -266,16 +267,19 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
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
 
 	depth = sdev->host->cmd_per_lun ?: 1;
 
