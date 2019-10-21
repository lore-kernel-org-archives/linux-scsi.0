Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D088CA9EB7
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F030C20873
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfJUQZz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4700 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727017AbfJUQZy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:54 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 22564B877CD0003EFF71;
        Tue, 22 Oct 2019 00:25:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:17 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 04/18] scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()
Date:   Tue, 22 Oct 2019 00:22:01 +0800
Message-ID: <1571674935-108326-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
References: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For IOs from upper layer, preemption may be disabled as it may be called
by function __blk_mq_delay_run_hw_queue which will call get_cpu() (it
disables preemption). So if flags HISI_SAS_REJECT_CMD_BIT is set in
function hisi_sas_task_exec(), it may disable preempt twice after down()
and up() which will cause following call trace:

BUG: scheduling while atomic: fio/60373/0x00000002
Call trace:
dump_backtrace+0x0/0x150
show_stack+0x24/0x30
dump_stack+0xa0/0xc4
__schedule_bug+0x68/0x88
__schedule+0x4b8/0x548
schedule+0x40/0xd0
schedule_timeout+0x200/0x378
__down+0x78/0xc8
down+0x54/0x70
hisi_sas_task_exec.isra.10+0x598/0x8d8 [hisi_sas_main]
hisi_sas_queue_command+0x28/0x38 [hisi_sas_main]
sas_queuecommand+0x168/0x1b0 [libsas]
scsi_queue_rq+0x2ac/0x980
blk_mq_dispatch_rq_list+0xb0/0x550
blk_mq_do_dispatch_sched+0x6c/0x110
blk_mq_sched_dispatch_requests+0x114/0x1d8
__blk_mq_run_hw_queue+0xb8/0x130
__blk_mq_delay_run_hw_queue+0x1c0/0x220
blk_mq_run_hw_queue+0xb0/0x128
blk_mq_sched_insert_requests+0xdc/0x208
blk_mq_flush_plug_list+0x1b4/0x3a0
blk_flush_plug_list+0xdc/0x110
blk_finish_plug+0x3c/0x50
blkdev_direct_IO+0x404/0x550
generic_file_read_iter+0x9c/0x848
blkdev_read_iter+0x50/0x78
aio_read+0xc8/0x170
io_submit_one+0x1fc/0x8d8
__arm64_sys_io_submit+0xdc/0x280
el0_svc_common.constprop.0+0xe0/0x1e0
el0_svc_handler+0x34/0x90
el0_svc+0x10/0x14
...

To solve the issue, check preemptible() to avoid disabling preempt
multiple when flag HISI_SAS_REJECT_CMD_BIT is set.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 621eebbeacd6..a7bac5dc389a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -587,7 +587,13 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	dev = hisi_hba->dev;
 
 	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags))) {
-		if (in_softirq())
+		/*
+		 * For IOs from upper layer, it may already disable preempt
+		 * in the IO path, if disable preempt again in down(),
+		 * function schedule() will report schedule_bug(), so check
+		 * preemptible() before goto down().
+		 */
+		if (!preemptible())
 			return -EINVAL;
 
 		down(&hisi_hba->sem);
-- 
2.17.1

