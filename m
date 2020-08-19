Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E64CC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B436208A9
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHSP0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:26:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39926 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728785AbgHSPZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:33 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6A4E5B11DB585D6BBB3D;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:51 +0800
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
Subject: [PATCH v8 11/18] null_blk: Support shared tag bitmap
Date:   Wed, 19 Aug 2020 23:20:29 +0800
Message-ID: <1597850436-116171-12-git-send-email-john.garry@huawei.com>
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

Support a shared tag bitmap, whereby request tags are unique over all
submission queues, and not just per submission queue.

As such, per device total queue depth is normally hw_queue_depth *
submit_queues, but hw_queue_depth when set. And a similar story for when
shared_tags is set, where that is the queue depth over all null blk
devices.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/block/null_blk_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 47a9dad880af..19c04e074880 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -164,6 +164,10 @@ static bool shared_tags;
 module_param(shared_tags, bool, 0444);
 MODULE_PARM_DESC(shared_tags, "Share tag set between devices for blk-mq");
 
+static bool g_shared_tag_bitmap;
+module_param_named(shared_tag_bitmap, g_shared_tag_bitmap, bool, 0444);
+MODULE_PARM_DESC(shared_tag_bitmap, "Use shared tag bitmap for all submission queues for blk-mq");
+
 static int g_irqmode = NULL_IRQ_SOFTIRQ;
 
 static int null_set_irqmode(const char *str, const struct kernel_param *kp)
@@ -1692,6 +1696,8 @@ static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
 	set->flags = BLK_MQ_F_SHOULD_MERGE;
 	if (g_no_sched)
 		set->flags |= BLK_MQ_F_NO_SCHED;
+	if (g_shared_tag_bitmap)
+		set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
 	set->driver_data = NULL;
 
 	if ((nullb && nullb->dev->blocking) || g_blocking)
-- 
2.26.2

