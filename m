Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21797C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC9120897
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgHSPZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:25:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9781 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726894AbgHSPZG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:06 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6DC731556ACDD80C64D7;
        Wed, 19 Aug 2020 23:25:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:52 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 15/18] scsi: scsi_debug: Support host tagset
Date:   Wed, 19 Aug 2020 23:20:33 +0800
Message-ID: <1597850436-116171-16-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When host_max_queue is set (> 0), set the Scsi_Host.host_tagset such that
blk-mq will use a hostwide tagset over all SCSI host submission queues.

This means that we may expose all submission queues and always use the hwq
chosen by blk-mq.

And since if sdebug_host_max_queue is set, sdebug_max_queue is fixed to the
same value, we can simplify how sdebug_driver_template.can_queue is set.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/scsi_debug.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 064ed680c053..4238baa2b34b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4698,19 +4698,14 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u16 hwq;
+	u32 tag = blk_mq_unique_tag(cmnd->request);
 
-	if (sdebug_host_max_queue) {
-		/* Provide a simple method to choose the hwq */
-		hwq = smp_processor_id() % submit_queues;
-	} else {
-		u32 tag = blk_mq_unique_tag(cmnd->request);
+	hwq = blk_mq_unique_tag_to_hwq(tag);
 
-		hwq = blk_mq_unique_tag_to_hwq(tag);
+	pr_debug("tag=%#x, hwq=%d\n", tag, hwq);
+	if (WARN_ON_ONCE(hwq >= submit_queues))
+		hwq = 0;
 
-		pr_debug("tag=%#x, hwq=%d\n", tag, hwq);
-		if (WARN_ON_ONCE(hwq >= submit_queues))
-			hwq = 0;
-	}
 	return sdebug_q_arr + hwq;
 }
 
@@ -7347,10 +7342,7 @@ static int sdebug_driver_probe(struct device *dev)
 
 	sdbg_host = to_sdebug_host(dev);
 
-	if (sdebug_host_max_queue)
-		sdebug_driver_template.can_queue = sdebug_host_max_queue;
-	else
-		sdebug_driver_template.can_queue = sdebug_max_queue;
+	sdebug_driver_template.can_queue = sdebug_max_queue;
 	if (!sdebug_clustering)
 		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
 
@@ -7367,11 +7359,11 @@ static int sdebug_driver_probe(struct device *dev)
 	}
 	/*
 	 * Decide whether to tell scsi subsystem that we want mq. The
-	 * following should give the same answer for each host. If the host
-	 * has a limit of hostwide max commands, then do not set.
+	 * following should give the same answer for each host.
 	 */
-	if (!sdebug_host_max_queue)
-		hpnt->nr_hw_queues = submit_queues;
+	hpnt->nr_hw_queues = submit_queues;
+	if (sdebug_host_max_queue)
+		hpnt->host_tagset = 1;
 
 	sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
-- 
2.26.2

