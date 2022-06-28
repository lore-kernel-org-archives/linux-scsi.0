Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83158C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 22:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiF1WY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF1WYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 18:24:42 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F003B3FA
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 15:21:39 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id e63so13497930pgc.5
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 15:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tdhxj9S6ner+YcYKbqTbN5cq18Icg6VtwCC5orIZL2E=;
        b=cX2CtdLFxmNEza7aqxFj34WCwyDULGzWYtgQAweFJGsvaMeVgVh+LM/QsK3vH08lIG
         YRLzjDa9AkscqWAsceRZ23VPULHvLP0GmsU8hN51TkOk2bjW9UH4mo6+VvnNeCV8KI4K
         zwAgt1gI7XBXpe860Ql68gR577YRlnj1jmsqvU8t19RKrKAe3t4RnmHgCR+1osZ1qU2w
         PXOyvXdRrLWcDmcs/bwagdyhQOLGTO9CCoZiU14ekNhGKkWz1r0ltEI7chFtr1LKLBem
         A/iRZPxXloF4K59kRkW8RG8mlMPw9y0Kg9S17K9MHqaPvHPlpEUxKzXWfhR3vR6e97mu
         7kNg==
X-Gm-Message-State: AJIora9Nrp010I01qF5lo1XMp6QTj5J/ksix6OeYPxORPbel1QyBvxSM
        5sD3DySblXfLEvfPxgV7+aI=
X-Google-Smtp-Source: AGRyM1soVEnGFiB3VeHz3ATrt/wia7Viyw09Y3BQXbggtjPYQOQJjc9u4Wa5PdFXiHvvwNChbnjieQ==
X-Received: by 2002:a63:4741:0:b0:40d:4e20:6662 with SMTP id w1-20020a634741000000b0040d4e206662mr127152pgk.520.1656454898982;
        Tue, 28 Jun 2022 15:21:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a294900b001eaae89de5fsm413599pjf.1.2022.06.28.15.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 15:21:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] scsi: core: Move the definition of SCSI_QUEUE_DELAY
Date:   Tue, 28 Jun 2022 15:21:29 -0700
Message-Id: <20220628222131.14780-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628222131.14780-1-bvanassche@acm.org>
References: <20220628222131.14780-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of SCSI_QUEUE_DELAY to just above the function that
uses it.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6ffc9e4258a8..2aca0a838ca5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -75,13 +75,6 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 	return ret;
 }
 
-/*
- * When to reinvoke queueing after a resource shortage. It's 3 msecs to
- * not change behaviour from the previous unplug mechanism, experimentation
- * may prove this needs changing.
- */
-#define SCSI_QUEUE_DELAY	3
-
 static void
 scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 {
@@ -1648,6 +1641,13 @@ static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 	sbitmap_put(&sdev->budget_map, budget_token);
 }
 
+/*
+ * When to reinvoke queueing after a resource shortage. It's 3 msecs to
+ * not change behaviour from the previous unplug mechanism, experimentation
+ * may prove this needs changing.
+ */
+#define SCSI_QUEUE_DELAY 3
+
 static int scsi_mq_get_budget(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
