Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFC2C2BBD0
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6FE2078E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgIFBWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:22:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37555 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgIFBWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:22:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id 5so6288928pgl.4;
        Sat, 05 Sep 2020 18:22:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zNmCyy6ivp4eV7ApzxKeikqTVDZSR+WYUSDFmWd4lTE=;
        b=MvrlORMaSMtagb7nE8RwrddzqW1pQV9L9XWaYwQCaoJo+pg3FKtrHmweDpDfhxSfoD
         T57YDLwTOOlrPxcbUtLALD8va+WWPiloqIkOKwJOQg+aEq9fZQHtmgBum1hrLsLNej61
         qFAr7++d6qXwXpMYYX/Ezm+/3raocYi/WnkdVunBnFmikFImnRAOHCU9t9uvyASU2L7E
         ItptIMN0ZdOtNToQTLliP3D3FXJ3zJ06shd1E/NfQ85bLmwJdo0Il1Y0wcHL24WLh7N3
         Q52CjMKnWdMHiSY4soQ5OK4ZmwioYpayUu5ZYpD2Y7c4ypZ07Fxelp47iyD5/9mkCJh+
         39dg==
X-Gm-Message-State: AOAM532qqHv9XMt1k7xjsjHUI1+0l4IjETd3HEHHH40uRcujPAMPxoq0
        yXWMUbVMazNsx0gjJZxVbfQ=
X-Google-Smtp-Source: ABdhPJzpgK+/WcXSi3oFu5sBkK+EOMWLCcdC2r2AdVpQafAK+NJ7L1nilAxgAMjwYblxCiKOqadxwQ==
X-Received: by 2002:a63:5b42:: with SMTP id l2mr12014555pgm.197.1599355354547;
        Sat, 05 Sep 2020 18:22:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:33 -0700 (PDT)
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
Subject: [PATCH 5/9] scsi: Do not wait for a request in scsi_eh_lock_door()
Date:   Sat,  5 Sep 2020 18:22:15 -0700
Message-Id: <20200906012219.17893-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is not guaranteed that a request is available when scsi_eh_lock_door()
is called. Hence pass the BLK_MQ_REQ_NOWAIT flag to blk_get_request().
This patch has a second purpose, namely preventing that
scsi_eh_lock_door() deadlocks if sdev->request_queue is frozen and if a
SCSI command is submitted to a SCSI device through a second request queue
that has not been frozen.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b197291c631a..f7604d930e3c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1979,7 +1979,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct request *req;
 	struct scsi_request *rq;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, 0);
+	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
+			      BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	rq = scsi_req(req);
