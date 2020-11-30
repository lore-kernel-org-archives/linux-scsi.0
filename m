Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E15C83011
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2839720771
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgK3CrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:10 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35850 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgK3CrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:10 -0500
Received: by mail-pl1-f195.google.com with SMTP id r2so5672368pls.3;
        Sun, 29 Nov 2020 18:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L9bMMO9PLHWj2MaCkKXM22x7qw+mqsaR/qfG6E0Sag8=;
        b=Jcdsbpw0pmxN5VUAFk7Lu+nQJlat4dE4HSdCoNq2gJ2AVtZloomv4OcyhR5xZKbyIB
         dd5H7Aic8NFAZzXBWwzYeL7FFksGSBVtXcQep5EVcjd1e45q/9SGt+W2/fGrT+qMxypV
         M0zNpXE/eqNIOYQEDuBr4PFtg9K0rsxMyU19hR9glJxZ/ay0T/yBgiF5J1fXwTzxGFAq
         3bxUMS3UdgUXxyN5t6Kq8oOf3mOdWisQPPdXMfLVdJC6o2+ZQymVJZRtH2JXyWaXZCQ/
         IrN1LVUnXXF+MgTk9qm6aLN8MrMteHvNZvmo51E9CVKsBfUirECBxwxJXFCl8SJCmqXc
         hI+Q==
X-Gm-Message-State: AOAM5317Q+kapGvmO10BN8X7Su3kUnRzwSmOd1S/xdtCRI1o4CZHsaYj
        /tYXWimV7bnhpjOS76lYmbk=
X-Google-Smtp-Source: ABdhPJypsp/jGB9VdBi6zZ4uaJD0Ls1LCxAHHQ0IB9jT11HRJOa/TZ1ASPMTtcFmQASWDKjuv8FOsg==
X-Received: by 2002:a17:902:d716:b029:da:10c1:51b5 with SMTP id w22-20020a170902d716b02900da10c151b5mr16783188ply.50.1606704388827;
        Sun, 29 Nov 2020 18:46:28 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v4 3/9] ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Sun, 29 Nov 2020 18:46:09 -0800
Message-Id: <20201130024615.29171-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
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
