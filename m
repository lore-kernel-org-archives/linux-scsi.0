Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60427C6379D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F8A22384
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 03:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKPDFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 22:05:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39845 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgKPDFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 22:05:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id p68so1415628pga.6;
        Sun, 15 Nov 2020 19:05:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBxpkiMjxwD+IRn41vyX5xWhB8DClldowR9a4K9oHbk=;
        b=eLDl1MlWT7z6cIUDS9CGNoiT1v1sWg2OTnrpBI+lZ40MRfdqBWuH9p+yK8PF4GSTfT
         1fnRqU54g2vXBCr9oAr1TWZ5+iBpfPcgPMLxFJRfA6R99ggGVwAgzYLxekSWoiaiX9jQ
         HOjR/kC80qVILba9RYCUAgaDbjV8yxLGw60d+J8xRtLR7eYqTd+YbNfcm4s8w0q7q6sc
         e2g9YMTinQLB52s8EDJjLC/HOQ92CM/wBUxM4Ync9oTafJbl6yMryXGuCIw6boVBzR/c
         Phz5pKODuXuExstUrGTb65HkbSoo2ytRnQO8GIbiOW+IWFydUzJytO6qejoz+tjv8o9b
         JtCw==
X-Gm-Message-State: AOAM530KHhk3cG6KwVm0/iLoZoFWpOFiwYchFvCOjFoEUEQjxBRJTg+z
        gDyFZb3mpdQhyvLJdL6WuDw=
X-Google-Smtp-Source: ABdhPJxhg5qQ69TckhvT+TZCfSAVkm0WCWj/uHzz6NuQWHDL7LjRtj7uWuM0emzFQO92Ds8oA93zkw==
X-Received: by 2002:a63:540c:: with SMTP id i12mr11677491pgb.32.1605495911820;
        Sun, 15 Nov 2020 19:05:11 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r3sm17148131pjl.23.2020.11.15.19.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:05:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v2 2/9] ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Sun, 15 Nov 2020 19:04:52 -0800
Message-Id: <20201116030459.13963-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116030459.13963-1-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RQF_PREEMPT is used for two different purposes in the legacy IDE code:
1. To mark power management requests.
2. To mark requests that should preempt another request. An (old)
   explanation of that feature is as follows:
   "The IDE driver in the Linux kernel normally uses a series of busywait
   delays during its initialization. When the driver executes these
   busywaits, the kernel does nothing for the duration of the wait. The
   time spent in these waits could be used for other initialization
   activities, if they could be run concurrently with these waits.

   More specifically, busywait-style delays such as udelay() in module
   init functions inhibit kernel preemption because the Big Kernel Lock
   is held, while yielding APIs such as schedule_timeout() allow preemption.
   This is true because the kernel handles the BKL specially and releases
   and reacquires it across reschedules allowed by the current thread.

   This IDE-preempt specification requires that the driver eliminate these
   busywaits and replace them with a mechanism that allows other work to
   proceed while the IDE driver is initializing."

Since I haven't found an implementation of (2), do not set the PREEMPT
flag for sense requests. This patch causes sense requests to be
postponed while a drive is suspended instead of being submitted to
ide_queue_rq().

If it would ever be necessary to restore the IDE PREEMPT functionality,
that can be done by introducing a new flag in struct ide_request.

This patch is a first step towards removing the PREEMPT flag from the
block layer.

Cc: David S. Miller <davem@davemloft.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ide/ide-atapi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2162bc80f09e..013ad33fbbc8 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -223,7 +223,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	sense_rq->rq_disk = rq->rq_disk;
 	sense_rq->cmd_flags = REQ_OP_DRV_IN;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
-	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
 	req->cmd[4] = cmd_len;
