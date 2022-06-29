Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A0BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 23:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiF2X4V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiF2X4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 19:56:17 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20172FFEA
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 16:56:14 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so1033163pjl.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 16:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tdhxj9S6ner+YcYKbqTbN5cq18Icg6VtwCC5orIZL2E=;
        b=qYLWoYxyCrqiXqseU3b9/IbjdrBqMZGnVi47h1O9CMgMCCkTa4tRX1F6ey1ld86Yrq
         9Ja1bmdSFXjeGlP0TvANod3cANIh1ldTpZRe5GFKCdzDb7vyDW+d1JyvJFeKas53CqJW
         YbVlinzDoF5YpJ0FnsWn5RAXjgdRUwPwOXc2n7IX9vzfXD96bP9SVIoV3rsIhD+ij/j/
         1VW37docG99aepnUQRaDgrDJ1i6rC2Fy1br84jAN0KIqob6+L6RrU5tAbCiSsqDCve8D
         GmLE3uiIcWy+SuZN1ou1eufawPo3+JAPR+W3m8uos94VAtBmZQPuyUqH6D7OMEx69ll9
         arFA==
X-Gm-Message-State: AJIora9S3e++tSyAJ1q3TtQLknb5ecdVyTHpOKMoZXUGM1sVMqUdwNch
        M3IjNCnRK1YtUgz+EnC28h0=
X-Google-Smtp-Source: AGRyM1svfMHtS0oSYIIl2dR66zUE/UE2L39t1KfLZ91mTQmrJKzlrYy07khjETUh7kpcvH2jZFRBhg==
X-Received: by 2002:a17:90a:af98:b0:1ef:1d10:c052 with SMTP id w24-20020a17090aaf9800b001ef1d10c052mr6396938pjq.111.1656546974065;
        Wed, 29 Jun 2022 16:56:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3841:49ce:cba5:1586])
        by smtp.gmail.com with ESMTPSA id s5-20020a170902988500b00161947ecc82sm11932222plp.199.2022.06.29.16.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 16:56:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/2] scsi: core: Move the definition of SCSI_QUEUE_DELAY
Date:   Wed, 29 Jun 2022 16:56:05 -0700
Message-Id: <20220629235606.2787919-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220629235606.2787919-1-bvanassche@acm.org>
References: <20220629235606.2787919-1-bvanassche@acm.org>
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
