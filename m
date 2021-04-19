Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD05C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 16:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98ACA61369
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 16:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhDSQL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 12:11:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16481 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhDSQL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 12:11:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FPBZ900Z1zrdkk;
        Tue, 20 Apr 2021 00:08:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 20 Apr 2021 00:10:43 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <dgilbert@interlog.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: core: Cap initial sdev queue depth at shost.can_queue
Date:   Tue, 20 Apr 2021 00:06:24 +0800
Message-ID: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
exceed shost.can_queue.

However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
initial sdev queue depth greater than can_queue.

Stop this happened by capping initial sdev queue depth at can_queue.

Signed-off-by: John Garry <john.garry@huawei.com>
---
Topic originally discussed at:
https://lore.kernel.org/linux-scsi/85dec8eb-8eab-c7d6-b0fb-5622747c5499@interlog.com/T/#m5663d0cac657d843b93d0c9a2374f98fc04384b9

Last idea there was to error/warn in scsi_add_host() for cmd_per_lun >
can_queue. However, such a shost driver could still configure the sdev
queue depth to be sound value at .slave_configure callback, so now thinking
the orig patch better.

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9f1b7f3c650a..8de2f830bcdc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -277,7 +277,11 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
 	sdev->request_queue->queuedata = sdev;
 
-	depth = sdev->host->cmd_per_lun ?: 1;
+	if (sdev->host->cmd_per_lun)
+		depth = min_t(unsigned int, sdev->host->cmd_per_lun,
+			      sdev->host->can_queue);
+	else
+		depth = 1;
 
 	/*
 	 * Use .can_queue as budget map's depth because we have to
-- 
2.26.2

