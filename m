Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB7DC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 11:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D320620786
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 11:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHRLFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 07:05:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgHRLFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 07:05:08 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3AD0686DAFEEDC458BC7;
        Tue, 18 Aug 2020 19:05:01 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 19:04:50 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <bvanassche@acm.org>, <sudhakar.panneerselvam@oracle.com>,
        <mlombard@redhat.com>, <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        <wubo40@huawei.com>
Subject: [PATCH] target:iscsi-target:Fix null pointer access while logout the iscsi session
Date:   Tue, 18 Aug 2020 19:16:10 +0800
Message-ID: <1597749370-631500-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

When I use fio to test the iscsi volumes and logout of the iscsi session
at the same time, the following crash occurs:

[24912.893443] BUG: unable to handle kernel NULL pointer dereference at 0000000000000140
[24912.893748] Oops: 0002 [#1] SMP PTI
[24912.893883] CPU: 3 PID: 239032 Comm: kworker/3:2 Kdump: loaded Tainted:  
[24912.894316] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
[24912.894773] Workqueue: target_completion target_complete_ok_work [target_core_mod]
[24912.895065] RIP: 0010:sbitmap_queue_clear+0x2a/0x70
[24912.895328] Code: 41 54 41 89 f4 55 89 d5 53 48 89 fb 8b 4f 04 89 f0 d3 e8 48 8d 3c
[24912.895906] RSP: 0018:ffff9eb14129bdf0 EFLAGS: 00010206
[24912.896268] RAX: 000000000000001b RBX: ffff9065367f23c0 RCX: 0000000000000005
[24912.896591] RDX: 0000000000000000 RSI: 000000000000003b RDI: 00000000000000c0
[24912.896919] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[24912.897556] R10: ffff9064bf6261e0 R11: 0000000000000100 R12: 000000000000003b
[24912.897913] R13: 0000000000000000 R14: 0000000000000000 R15: ffff906518610c18
[24912.897916] FS:  0000000000000000(0000) GS:ffff90653ad80000(0000) knlGS:0000000000000000
[24912.898988] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[24912.899410] CR2: 0000000000000140 CR3: 0000000127c0a004 CR4: 00000000000206e0
[24912.899830] Call Trace:
[24912.900278]  target_release_cmd_kref+0x11d/0x2b0 [target_core_mod]
[24912.900727]  target_put_sess_cmd+0x23/0x30 [target_core_mod]
[24912.901181]  target_complete_ok_work+0xc2/0x370 [target_core_mod]
[24912.901649]  ? __schedule+0x304/0x930
[24912.902921]  process_one_work+0x195/0x390
[24912.903396]  worker_thread+0x30/0x390
[24912.903866]  ? process_one_work+0x390/0x390
[24912.904355]  kthread+0x10d/0x130
[24912.904835]  ? kthread_flush_work_fn+0x10/0x10
[24912.905335]  ret_from_fork+0x35/0x40

The iscsi-target thread executes the logout operation, 
deletes the session,and releases the sess_tag_pool without waiting 
for all cmds to complete. When the cmds is completed, the target_complete
worker put the tag to sess_tag_pool, the sess_tag_pool has been released 
at this time, So accessed the NULL pointer.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c968961..a8ea4a7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4387,6 +4387,8 @@ int iscsit_close_session(struct iscsi_session *sess)
 		}
 	}
 
+	target_sess_cmd_list_set_waiting(sess->se_sess);
+	target_wait_for_sess_cmds(sess->se_sess);
 	transport_deregister_session(sess->se_sess);
 
 	if (sess->sess_ops->ErrorRecoveryLevel == 2)
-- 
1.8.3.1

