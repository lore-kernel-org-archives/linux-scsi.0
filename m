Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1028EC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03852075A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgLBN3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:29:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727114AbgLBN3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:29:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DP4be002241
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:28:28 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8g4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:28:28 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:28:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:28:26 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 87F2D3F703F;
        Wed,  2 Dec 2020 05:28:26 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DSQXA020099;
        Wed, 2 Dec 2020 05:28:26 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DSQSR020090;
        Wed, 2 Dec 2020 05:28:26 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 12/15] qla2xxx: Fix the call trace for flush workqueue
Date:   Wed, 2 Dec 2020 05:23:09 -0800
Message-ID: <20201202132312.19966-13-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

The call trace was because workqueue was allocated without any
flags, added WQ_MEM_RECLAIM as flag while allocation.

kernel: workqueue: WQ_MEM_RECLAIM
kblockd:blk_mq_run_work_fn is flushing !WQ_MEM_RECLAIM qla2xxx_wq:0x0
kernel: WARNING: CPU: 0 PID: 2475 at
kernel/workqueue.c:2593 check_flush_dependency+0x110/0x130
kernel: CPU: 0 PID: 2475 Comm: kworker/0:1H Kdump:
loaded Tainted: G           OE    --------- -  - 4.18.0-193.el8.x86_64 #1
kernel: Hardware name: HPE ProLiant XL170r Gen10/ProLiant XL170r Gen10, BIOS U38 05/21/2019
kernel: Workqueue: kblockd blk_mq_run_work_fn
kernel: RIP: 0010:check_flush_dependency+0x110/0x130
kernel: Code: ff ff 48 8b 50 18 48 8d 8b b0 00 00 00 49 89 e8 48 81 c6 b0 00 00 00 48 c7 c7 00 1e e9
	95 c6 05 dc 9a 2f 01 01 e8 1a 42 fe ff <0f> 0b e9 0a ff ff ff 80 3d ca 9a 2f 01 0 0 75 95 e9 41 ff ff ff 90
kernel: RSP: 0018:ffffa40f48b2baf8 EFLAGS: 00010282
kernel: RAX: 0000000000000000 RBX: ffff946795282600 RCX: 0000000000000000
kernel: RDX: 000000000000005f RSI: ffffffff96a1af7f RDI: 0000000000000246
kernel: RBP: 0000000000000000 R08: ffffffff96a1af20 R09: 0000000000029480
kernel: R10: 00080c89bb3e7462 R11: 00000000000009ab R12: ffff946773628000
kernel: R13: 0000000000000282 R14: 0000000000000246 R15: ffffa40f48b2bb40
kernel: FS: 	0000000000000000(0000) 	GS:ffff94679fa00000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00005570c4b60110 CR3: 000000029140a005 CR4: 00000000007606f0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kernel: PKRU: 55555554
kernel: Call Trace:
kernel: flush_workqueue+0x13a/0x440
kernel: qla2x00_wait_for_sess_deletion+0x1d6/0x200 [qla2xxx]
kernel: ? finish_wait+0x80/0x80
kernel: qla2xxx_disable_port+0x2b/0x30 [qla2xxx]
kernel: qla2x00_process_vendor_specific+0x1dc9/0x2d20 [qla2xxx]
kernel: ? blk_rq_map_sg+0x195/0x570
kernel: qla24xx_bsg_request+0x1a3/0xf90 [qla2xxx]

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f9c8ae9d669e..a75edba2b334 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3265,7 +3265,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "req->req_q_in=%p req->req_q_out=%p rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
-	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
 	if (unlikely(!ha->wq)) {
 		ret = -ENOMEM;
 		goto probe_failed;
-- 
2.19.0.rc0

