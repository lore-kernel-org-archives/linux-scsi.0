Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A098BC433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F1F20658
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgGGNgh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:36:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727987AbgGGNgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 09:36:37 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EB6522FB409E8D5BD4F2;
        Tue,  7 Jul 2020 21:36:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 7 Jul 2020 21:36:16 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>,
        <dgilbert@interlog.com>, <ming.lei@redhat.com>,
        <kashyap.desai@broadcom.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 1/2] scsi: scsi_debug: Add check for sdebug_max_queue during module init
Date:   Tue, 7 Jul 2020 21:32:30 +0800
Message-ID: <1594128751-212234-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1594128751-212234-1-git-send-email-john.garry@huawei.com>
References: <1594128751-212234-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sdebug_max_queue should not exceed SDEBUG_CANQUEUE, otherwise crashes like
this can be triggered by passing an out-of-range value:

Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.16.01 03/15/2019 
 pstate: 20400009 (nzCv daif +PAN -UAO BTYPE=--) 
 pc : schedule_resp+0x2a4/0xa70 [scsi_debug] 
 lr : schedule_resp+0x52c/0xa70 [scsi_debug] 
 sp : ffff800022ab36f0 
 x29: ffff800022ab36f0 x28: ffff0023a935a610 
 x27: ffff800008e0a648 x26: 0000000000000003 
 x25: ffff0023e84f3200 x24: 00000000003d0900 
 x23: 0000000000000000 x22: 0000000000000000 
 x21: ffff0023be60a320 x20: ffff0023be60b538 
 x19: ffff800008e13000 x18: 0000000000000000 
 x17: 0000000000000000 x16: 0000000000000000 
 x15: 0000000000000000 x14: 0000000000000000 
 x13: 0000000000000000 x12: 0000000000000000 
 x11: 0000000000000000 x10: 0000000000000000 
 x9 : 0000000000000001 x8 : 0000000000000000 
 x7 : 0000000000000000 x6 : 00000000000000c1 
 x5 : 0000020000200000 x4 : dead0000000000ff 
 x3 : 0000000000000200 x2 : 0000000000000200 
 x1 : ffff800008e13d88 x0 : 0000000000000000 
 Call trace: 
schedule_resp+0x2a4/0xa70 [scsi_debug] 
scsi_debug_queuecommand+0x2c4/0x9e0 [scsi_debug] 
scsi_queue_rq+0x698/0x840
__blk_mq_try_issue_directly+0x108/0x228
blk_mq_request_issue_directly+0x58/0x98
blk_mq_try_issue_list_directly+0x5c/0xf0 
blk_mq_sched_insert_requests+0x18c/0x200 
blk_mq_flush_plug_list+0x11c/0x190 
blk_flush_plug_list+0xdc/0x110 
blk_finish_plug+0x38/0x210 
blkdev_direct_IO+0x450/0x4d8 
generic_file_read_iter+0x84/0x180
blkdev_read_iter+0x3c/0x50 
aio_read+0xc0/0x170
io_submit_one+0x5c8/0xc98
__arm64_sys_io_submit+0x1b0/0x258
el0_svc_common.constprop.3+0x68/0x170
do_el0_svc+0x24/0x90 
el0_sync_handler+0x13c/0x1a8 
el0_sync+0x158/0x180 
 Code: 528847e0 72a001e0 6b00003f 540018cd (3941c340)

In addition, it should not be less than 1.

So add checks for these, and fail the module init for those cases.

Fixes: c483739430f10 ("scsi_debug: add multiple queue support")
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/scsi_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4692f5b6ad13..68534a23866e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6613,6 +6613,12 @@ static int __init scsi_debug_init(void)
 		pr_err("submit_queues must be 1 or more\n");
 		return -EINVAL;
 	}
+
+	if ((sdebug_max_queue > SDEBUG_CANQUEUE) || (sdebug_max_queue <= 0)) {
+		pr_err("max_queue must be in range [1, %d]\n", SDEBUG_CANQUEUE);
+		return -EINVAL;
+	}
+
 	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
 			       GFP_KERNEL);
 	if (sdebug_q_arr == NULL)
-- 
2.26.2

