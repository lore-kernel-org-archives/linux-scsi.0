Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7108C83017
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95CDB2087D
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgK3CrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:14 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52015 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgK3CrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:14 -0500
Received: by mail-pj1-f68.google.com with SMTP id r20so397247pjp.1;
        Sun, 29 Nov 2020 18:46:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/BAMz2CYvfGS5mHYfgF/debVAmENTs8RcHIS0BLCRE=;
        b=blp3ClspGjPIfRVPjBnp9YY6/JWfUknFjMh+oroRtF/P796EEyx1aP8OrYITmn/SrS
         DZinbLSSxDdGvAzUXJz869ZYUOD6NDckb9P8psbKmSCX0zPu/vY78bgwL+faKt8OB2cF
         jmpakyw1emaP6EfjKtGWilgomBzPSO3wtxI9rwzueXBi6jJjN/XywZw7UnUweTl4O3de
         wXZaYTc0TkfMTLyqukuoMYl93YsE4pPX5odfplYUgBVe4Q9cRwzpIQns6N+VC9/AP/md
         OwbvEhL7YuAjnk8KptPwTC8ah86DeiLb50TWEA5hZj8JClZWCgBkzNv7tysnqGQnmx3A
         zI1A==
X-Gm-Message-State: AOAM532rbW4L/sNFlNq+oB9JWcLoBASFr/M8VSM1myXi+FHeXfSOaiwq
        6xqBRIQOLxdW3SvkpHDRzlU=
X-Google-Smtp-Source: ABdhPJwVIZrAn+WXwvUCw81oOt5ne9jRKZ0UkaewnWLMgQ2sH96yj9G+yLkkHzT9dCsAajJgkkrUSg==
X-Received: by 2002:a17:902:7607:b029:da:62c8:e206 with SMTP id k7-20020a1709027607b02900da62c8e206mr7086658pll.1.1606704393072;
        Sun, 29 Nov 2020 18:46:33 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:32 -0800 (PST)
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
Subject: [PATCH v4 5/9] scsi: Do not wait for a request in scsi_eh_lock_door()
Date:   Sun, 29 Nov 2020 18:46:11 -0800
Message-Id: <20201130024615.29171-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_eh_lock_door() is the only function in the SCSI error handler that
calls blk_get_request(). It is not guaranteed that a request is available
when scsi_eh_lock_door() is called. Hence pass the BLK_MQ_REQ_NOWAIT flag
to blk_get_request().

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
