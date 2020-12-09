Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA9CC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A6A023B77
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgLIFbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 00:31:00 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46627 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgLIFat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 00:30:49 -0500
Received: by mail-pl1-f193.google.com with SMTP id v3so323633plz.13;
        Tue, 08 Dec 2020 21:30:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9PAa4uvnthw1irmoOC8T38RyKP9VHz19jIArD7aDop8=;
        b=BSFx7CzqD/M71teGksmlLzvHc+9zMh5apP5O+KXoar94mcMoJSY0V0BeRgoAy58JaC
         fd8QYwN5VVmyJfhC/2JFVlQWu4priThkKyYHfQH6dYHFlZ6Gg7QmlgOFfpooWqvr7Fvx
         VC64uwTCE7HJ4ypLDjYTmhMBkmhaHkhEF3TQTPUJ6AuDjqRwFwnb30nu2gvrVWL70oA+
         5C2UkxCBD1r10+qkNC+hnUIoJ9ka6WBYUndtPCNDGckCYyza1sOcuc+pUM6wdhZXVZ0G
         62Cx2IIMdsBY3NuJ53tEveyXd2FMEdUL95+75TW0fL5FwLDKam4fQWM8UOkdONHXVY20
         FghQ==
X-Gm-Message-State: AOAM530RIqbvov9ufN+ircX9mUKrlHA9slrQsFgr13MYfB6DHyqEIIZD
        9ENabiA4Ukt8tKbKnYEXelM=
X-Google-Smtp-Source: ABdhPJwOdBu8JAcI0LCjbKhKlKInInlGJ7MFYTM+xVdM0aAjELU98TeTga24/CKvZZEYLpshLa+TmQ==
X-Received: by 2002:a17:90a:dd46:: with SMTP id u6mr710832pjv.162.1607491808915;
        Tue, 08 Dec 2020 21:30:08 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 77sm753097pfv.16.2020.12.08.21.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:30:08 -0800 (PST)
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
Subject: [PATCH v5 4/8] ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
Date:   Tue,  8 Dec 2020 21:29:47 -0800
Message-Id: <20201209052951.16136-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209052951.16136-1-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is another step that prepares for the removal of RQF_PREEMPT.

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
