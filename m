Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1800AC64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD37A22263
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgKPDFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 22:05:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42543 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgKPDFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 22:05:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id 131so2111331pfb.9;
        Sun, 15 Nov 2020 19:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iEm1L/1xTunB5Bi4Sc1aPphA3G474y7ilmOOODhkU2E=;
        b=ZPxtNTBeeuCd8aTx1stvJV63hlp1CpmKyr1uQrmufUSStH+zPQtmZGfG/+59ydy/Op
         SmNJZvUq6pqFaMQjLpJpXmmcIKirSg9TMZj6y7mvajszfBt3Rwt2oRot7RMRcAIkI1jC
         RyXUvyPMx0BZzRVe/7WawAwcFwqIraoJriABaUix26kTuwDs4om2W0SguzMCo+pdRjWK
         Y3Ckw+5pEgWAjdJYR4YxdmTgIjGa4ldSbQfsN7VWtFu8lR82VH8yrWOabixBYydqs4DJ
         LQC1hZodeL9ctLkXr17KQ7tgajA1ib8LmyQ/PwGj583pRZWUmeW5LMU2OLZIAI4aCa65
         OFwg==
X-Gm-Message-State: AOAM5310pPblFGIfDLKwgBFxHi2PeX2g3wlaIkfthoJ5sgyVmHXwrSGQ
        HxkOd16abYk7oJmSTZ6PUAY=
X-Google-Smtp-Source: ABdhPJyjeSxvVm5IGFzxJYSH+QFNnZjdUr43f9e2y4+Bl/w+qSH5NOKZGrx7rl9yDZTkgfha8+e9mA==
X-Received: by 2002:a63:2ad0:: with SMTP id q199mr157689pgq.257.1605495917683;
        Sun, 15 Nov 2020 19:05:17 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r3sm17148131pjl.23.2020.11.15.19.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:05:16 -0800 (PST)
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
Subject: [PATCH v2 5/9] scsi: Do not wait for a request in scsi_eh_lock_door()
Date:   Sun, 15 Nov 2020 19:04:55 -0800
Message-Id: <20201116030459.13963-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116030459.13963-1-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_eh_lock_door() is the only function in the SCSI error handler that
calls blk_get_request(). It is not guaranteed that a request is available
when scsi_eh_lock_door() is called. Hence pass the BLK_MQ_REQ_NOWAIT flag
to blk_get_request(). This patch has a second purpose, namely preventing
that scsi_eh_lock_door() deadlocks if sdev->request_queue is frozen and if
a SCSI command is submitted to a SCSI device through a second request
queue that has not been frozen. A later patch will namely modify the SPI
DV code such that sdev->requeust_queue is frozen during domain validation.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d94449188270..6de6e1bf3dcb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1993,7 +1993,12 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct request *req;
 	struct scsi_request *rq;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, 0);
+	/*
+	 * It is not guaranteed that a request is available nor that
+	 * sdev->request_queue is unfrozen. Hence the BLK_MQ_REQ_NOWAIT below.
+	 */
+	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
+			      BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	rq = scsi_req(req);
