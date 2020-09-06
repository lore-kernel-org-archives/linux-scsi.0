Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64851C2D0A8
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F0420E65
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgIFBWb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:22:31 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43027 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFBWa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:22:30 -0400
Received: by mail-pl1-f195.google.com with SMTP id y6so2838530plk.10;
        Sat, 05 Sep 2020 18:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBxpkiMjxwD+IRn41vyX5xWhB8DClldowR9a4K9oHbk=;
        b=MA0Ziz8djkgkMyA9tOpuf5yFiMjToq2BLlrw6b3P7+lR4RPaAvGGsijopd1EPgeF4Z
         c34bcgmCznLki1KpKmCITqZNUcpGqWW+vxjDL0yJaSurIhFjpIgkWtkG82axfH7OznpZ
         joxmbKHBLO2zWMaWR52KUz3lGd0f7SVYlK7QsQ1nQsktoVnKtW9EtCus9i8zMFgY//Qg
         +5HJpy3/nblyQMn6l6/+deaA8YeuHo9edacsquIlfc1s5wHtmKEWY1ZmtOg0lb0spNqv
         kG05SBBO47+wG3QS06LVPr86aTVgsteW1KGmCIy97gsk7M+APiI7NqDnDGii4BWqIoQ6
         C5mA==
X-Gm-Message-State: AOAM532F4EH0JkvoItH34dpu6vTGuQBV1EKu1EF4JTWzqwRJavR8WLKC
        8kXkQTNMZm9T4yszGY39ApY=
X-Google-Smtp-Source: ABdhPJwoIMtvOpDsg6UTyCd0hUXSX1uEqT9KJWuRMHOj0yEX0nWRCqXjcFmR2sOmzmvcG2ycrSBDXg==
X-Received: by 2002:a17:90a:d703:: with SMTP id y3mr14635755pju.183.1599355350066;
        Sat, 05 Sep 2020 18:22:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>,
        "David S . Miller" <davem@davemloft.net>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 2/9] ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Sat,  5 Sep 2020 18:22:12 -0700
Message-Id: <20200906012219.17893-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
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
