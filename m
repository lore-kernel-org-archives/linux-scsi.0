Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4E2C8301D
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F7320771
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgK3CrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:18 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40954 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgK3CrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:17 -0500
Received: by mail-pj1-f65.google.com with SMTP id t12so432897pjq.5;
        Sun, 29 Nov 2020 18:46:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VEU+xCwmLM+BtzvRP5JXTk9ZPc+wm9/yMiB5hxhuJk0=;
        b=MvIh6KFIeZw/NvNX/DS8J+hQMnNvMWfyFbPyTXUHu/FJ5kX8IW/uw8l6Fa43H3V6YJ
         CFaEY5w8MPuifN7HScmVM/vXnQ4ljcp3U1XqN+6mKvwEeY4lVleaQYkkOr8WkyahsY7W
         Dvdbl77RW7yBhNWpgmjMEWZUKyzL+lBr5YREPYAOd6dwFZQw4GRxF3+vIhSu2xnkRp/u
         Q26C2FHsxYa+9O9fGA49c/yYpqy8gaUtMDk5Ft4cxrxQKLZ/pbhmMj+L5aY52KIUJMqp
         lB3WOfbJ+7KkdTukGSErBmx69/f/bhoAQBaYzvS+ES0Cwf/NxZSlcyW8xHXABo7oDffM
         RLYg==
X-Gm-Message-State: AOAM532hnWTMmBaF3NKbv2n4pC6y0Hk5k2f3Fz4eSRW8hPztmEd9eMxp
        DMtXgLH5sPFVdo/A9YGlu34=
X-Google-Smtp-Source: ABdhPJxeHWlCShqBgl1RlcInuRhMcfTWzGXDC79erLCIRyaWbXT/fj9BT/a9YIp70TQ/nQHay7KcwA==
X-Received: by 2002:a17:90a:d086:: with SMTP id k6mr23638224pju.141.1606704390962;
        Sun, 29 Nov 2020 18:46:30 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:30 -0800 (PST)
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
Subject: [PATCH v4 4/9] ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
Date:   Sun, 29 Nov 2020 18:46:10 -0800
Message-Id: <20201130024615.29171-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is another step that prepares for the removal of RQF_PREEMPT.

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
 drivers/ide/ide-io.c | 2 +-
 drivers/ide/ide-pm.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c210ea3bd02f..4867b67b60d6 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -518,7 +518,7 @@ blk_status_t ide_issue_rq(ide_drive_t *drive, struct request *rq,
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    ata_pm_request(rq) == 0 &&
-		    (rq->rq_flags & RQF_PREEMPT) == 0) {
+		    (rq->rq_flags & RQF_PM) == 0) {
 			/* there should be no pending command at this point */
 			ide_unlock_port(hwif);
 			goto plug_device;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 192e6c65d34e..82ab308f1aaf 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -77,7 +77,7 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PREEMPT);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	ide_req(rq)->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
