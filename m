Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8229EC2BBD0
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AEA72078D
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgIFBWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:22:38 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55586 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgIFBWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:22:34 -0400
Received: by mail-pj1-f65.google.com with SMTP id 2so4928373pjx.5;
        Sat, 05 Sep 2020 18:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ANaPiRraLfr6n4U/66UyxGfWJxU8nSzRyu2C/bkpmnk=;
        b=ZcNWyMR+AxAvVwqRy8dvgc/RX917XQn8r0jZ8iaCO4dDIMmaW0nb8AbY6xZESr88q6
         p1FQMtZmsqbC6sp1c5i7MHB+xVhu312a5T4lZ6g9l3QmGsHUfJDNoQr9fJ3HGcZAoUPR
         R2JwE2V25ZefQmzgpROQiN6hFn6b0mJh29rOWU/2n/4+OSG0cWt1R/7zBf8wYT1NR/ml
         t6VHUFaiWk2TOzBTrl5Y0IiArV4398fPHNhEpbYjT28G08NF2p590aapLPPhkjF6l1Wy
         /oy3tlzhJgEe4An5wlsqeEB3u7vcGbgSZErGwaHA9YbqCmOmuXN134fo/DKbQQIv3fJW
         GXZA==
X-Gm-Message-State: AOAM530SRbu1JdOMf89Pc2sXU5C+v+JekwfTtTBwUvpAEB0kE91o7e8v
        SGGpnz+UWkD8tBkD3An7Hwo=
X-Google-Smtp-Source: ABdhPJxi0di/Xn6xlL5HOHv6uPb5cKKOVcDFjZGH2JAQHccFuwnjdG3mPGQNbCp/j25UV2dJ1AaZWA==
X-Received: by 2002:a17:90a:5a:: with SMTP id 26mr14131707pjb.0.1599355353074;
        Sat, 05 Sep 2020 18:22:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4/9] scsi: Rework scsi_mq_alloc_queue()
Date:   Sat,  5 Sep 2020 18:22:14 -0700
Message-Id: <20200906012219.17893-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not modify sdev->request_queue. Remove the sdev->request_queue
assignment. That assignment is superfluous because scsi_mq_alloc_queue()
only has one caller and that caller calls scsi_mq_alloc_queue() as follows:

	sdev->request_queue = scsi_mq_alloc_queue(sdev);

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 760976f27634..9e3c2930ce40 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1854,14 +1854,15 @@ static const struct blk_mq_ops scsi_mq_ops = {
 
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
