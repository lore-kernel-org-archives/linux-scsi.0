Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3392EC64E8A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C5B212CC
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgKWDSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:18:09 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42185 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgKWDSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:18:08 -0500
Received: by mail-pg1-f195.google.com with SMTP id w16so569661pga.9;
        Sun, 22 Nov 2020 19:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FmQMTp0lq+P9F4DPfJwhzTIRpyhMssjxK7MCOpsx9a8=;
        b=Vggof01lu+w+NBOqzpLjm2Va5k0Hzrdyi2OVy4de/yKGAUSgRaUfSnwM9TXPpvXauL
         c8KdvUldVraibIjsb9S0NrVB2LyAmrSo0I21AB5FMFCAiUeuBr+FSsc5Oy0uVSRcuY2d
         871jt/0F5xZzgGi+Bupox9S1bYPO9s4Z204+gDXQz5MzKhGKQ0KByNZDyoM1m5fkMbH+
         rO7mrzEoOakfW5rxzsGdJlwhZl0S41sRbTBZfsv5bEhxP1F5f9YZuI9z/aUferEuYP4m
         B2nJ1+FuGI+9ts0nt/B4NvCCQLQnpkmmmB2kKIOu4qPCQoAJMf9cncwvWeWmfunRbiE4
         scbg==
X-Gm-Message-State: AOAM531QYbvI0J/75DvCK5DpigSSZmsq0nVXjPIud/wutxkfV5L/NNd9
        fVPtRodB6uXCj5HB6Y4uugY=
X-Google-Smtp-Source: ABdhPJzPP5qUavAY0EVdsr2dCB6LzwQHaQkCad0S4ONr4WSZR5pSiYECWKATB+yYuqSRK9IBkqeKaQ==
X-Received: by 2002:aa7:86c9:0:b029:18b:b0c:53e5 with SMTP id h9-20020aa786c90000b029018b0b0c53e5mr23183332pfo.57.1606101487376;
        Sun, 22 Nov 2020 19:18:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:18:06 -0800 (PST)
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
Subject: [PATCH v3 5/9] scsi: Do not wait for a request in scsi_eh_lock_door()
Date:   Sun, 22 Nov 2020 19:17:45 -0800
Message-Id: <20201123031749.14912-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123031749.14912-1-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
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

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
