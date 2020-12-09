Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6DEC2BB40
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7FD923B77
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgLIFbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 00:31:05 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38537 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbgLIFas (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 00:30:48 -0500
Received: by mail-pj1-f67.google.com with SMTP id j13so277058pjz.3;
        Tue, 08 Dec 2020 21:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04Btu7lbOuaVvM3R+6/4SYZzVRJYUH5aY8lm7YPXAKg=;
        b=Z8aj5Z6mw1be3jte3nEVpoGPE2mkpE8wln6hk9KOPbFtQynN+3x7kQqDNszrTGRQl4
         TsVhQlekQ4mWsHlA83nwTn5HYWYYVeWjxabJ54Orz9XBupe9Sk9HXM2zjKPLcAjHZgLy
         U15usT7bSZPbvWQKVs3zXKrW+cZueUg3AKyWVZhvceOARWkuY8Y5EBFN69DpyqvKxVLX
         bTFprD4Dfv+enLBDJC9z9UEa2GqlHrb808tILshwkGbEbiojhDBDAjsdzXAZvTQVI/au
         nTKuqRfbEl9Ufcb2rAm6IrlXz79xVtHaxI/03OtZu1Gy0NszfQurEM6S6hQe6/yzVpJX
         vsPw==
X-Gm-Message-State: AOAM531CLJLrXpq2iBDGWwgdrdx0MDIe6CBHTExNJeYTYwzpUHTI7NdZ
        PdlQbw7XCG45cPFaI7md+nOyH13gIkk=
X-Google-Smtp-Source: ABdhPJxXqh+72aStnba/hvJQp+DMUZSkXW4knXFjbU1f3lvD0tzShjQ32/nGqcy9PmOUU204ipfBbA==
X-Received: by 2002:a17:90b:a53:: with SMTP id gw19mr702961pjb.216.1607491806797;
        Tue, 08 Dec 2020 21:30:06 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 77sm753097pfv.16.2020.12.08.21.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:30:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v5 3/8] ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Tue,  8 Dec 2020 21:29:46 -0800
Message-Id: <20201209052951.16136-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209052951.16136-1-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
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
   is held, while yielding APIs such as schedule_timeout() allow
   preemption. This is true because the kernel handles the BKL specially
   and releases and reacquires it across reschedules allowed by the
   current thread.

   This IDE-preempt specification requires that the driver eliminate these
   busywaits and replace them with a mechanism that allows other work to
   proceed while the IDE driver is initializing."

Since I haven't found an implementation of (2), do not set the PREEMPT
flag for sense requests. This patch causes sense requests to be
postponed while a drive is suspended instead of being submitted to
ide_queue_rq().

If it would ever be necessary to restore the IDE PREEMPT functionality,
that can be done by introducing a new flag in struct ide_request.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ide/ide-atapi.c | 1 -
 drivers/ide/ide-io.c    | 5 -----
 2 files changed, 6 deletions(-)

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
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1a53c7a75224..c210ea3bd02f 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -515,11 +515,6 @@ blk_status_t ide_issue_rq(ide_drive_t *drive, struct request *rq,
 		 * above to return us whatever is in the queue. Since we call
 		 * ide_do_request() ourselves, we end up taking requests while
 		 * the queue is blocked...
-		 * 
-		 * We let requests forced at head of queue with ide-preempt
-		 * though. I hope that doesn't happen too much, hopefully not
-		 * unless the subdriver triggers such a thing in its own PM
-		 * state machine.
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    ata_pm_request(rq) == 0 &&
