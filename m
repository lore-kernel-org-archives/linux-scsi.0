Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADDFC61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 09:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbjBUJTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 04:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbjBUJTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 04:19:04 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0365586
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 01:19:03 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L7rIuv019139;
        Tue, 21 Feb 2023 01:18:53 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nvkax0xrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 01:18:53 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 21 Feb
 2023 01:18:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 21 Feb 2023 01:18:51 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8D8343F7040;
        Tue, 21 Feb 2023 01:18:51 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <linux-nvme@lists.infradead.org>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] nvme-fc: initialize nvme fc ctrl ops
Date:   Tue, 21 Feb 2023 01:18:42 -0800
Message-ID: <20230221091842.28219-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: CiIQuzVIVAegA3BQIa1ypUt6N0XfFBbl
X-Proofpoint-GUID: CiIQuzVIVAegA3BQIa1ypUt6N0XfFBbl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_05,2023-02-20_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The system crashed while performing qla2xxx nvme discovery with
below call trace,

qla2xxx [0000:21:00.0]-2102:12: qla_nvme_register_remote: traddr=nn-0x245e00a098f4684a:pn-0x245f00a098f4684a PortID:5a247a
qla2xxx [0000:21:00.0]-2102:12: qla_nvme_register_remote: traddr=nn-0x245e00a098f4684a:pn-0x246100a098f4684a PortID:5a2d6e
BUG: kernel NULL pointer dereference, address: 0000000000000010
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 61 PID: 6064 Comm: nvme Kdump: loaded Not tainted 6.2.0-rc1 #3
Hardware name: Dell Inc. PowerEdge R7525/0590KW, BIOS 2.5.6 10/06/2021
RIP: 0010:nvme_alloc_admin_tag_set+0x51/0x120 [nvme_core]
Code: 00 00 00 00 81 c1 b0 00 00 00 48 c7 86 a8 00 00 00 00 00 00 00
      c1 e9 03 f3 48 ab 4c 89 46 38 c7 46 44 1e 00 00 00 48 8b 45 30
      <f6> 40 10 01 74 07 c7 46 48 01 00 00 00 8b 45 5c c7 43 58 40 00 00
RSP: 0018:ffffafe6cd7cbd10 EFLAGS: 00010212
RAX: 0000000000000000 RBX: ffff898e0c39c050 RCX: 0000000000000000
RDX: 00000000000001d8 RSI: ffff898e0c39c050 RDI: ffff898e0c39c100
RBP: ffff898e0c39c398 R08: ffffffffc0afe1a0 R09: ffff896ed602a600
R10: 0000000000000010 R11: f000000000000000 R12: ffff898e06ea2600
R13: ffff898e070ffbc0 R14: ffff898e0c39c040 R15: ffff898e0c39c398
FS:  00007f9368279780(0000) GS:ffff89ad7fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000210c570000 CR4: 0000000000350ee0
Call Trace:
nvme_fc_init_ctrl+0x328/0x460 [nvme_fc]
nvme_fc_create_ctrl+0x1b0/0x260 [nvme_fc]
nvmf_create_ctrl+0x141/0x240 [nvme_fabrics]
nvmf_dev_write+0x81/0xe0 [nvme_fabrics]
vfs_write+0xc5/0x3b0
? syscall_exit_work+0x103/0x130
? syscall_exit_to_user_mode+0x12/0x30
ksys_write+0x5f/0xe0
do_syscall_64+0x5c/0x90
? exc_page_fault+0x62/0x150
entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f936813e967
Code: 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f
      1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05
      <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
SP: 002b:00007fff4197a468 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000560862447d40 RCX: 00007f936813e967
RDX: 000000000000012b RSI: 0000560862447d40 RDI: 0000000000000003
RBP: 0000000000000003 R08: 000000000000012b R09: 0000560862447d40
R10: 0000000000000000 R11: 0000000000000246 R12: 00005608624473f0
R13: 000000000000012b R14: 00007f93682e6100 R15: 00007f93682e613d

Initialize the nvme_fc_ctrl_ops before allocating the nvme admin
tag set.

Fixes: 6dfba1c09c10 ("nvme-fc: use the tagset alloc/free helpers")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/nvme/host/fc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 4564f16a0b20..6c0125eb2a0f 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3521,13 +3521,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	nvme_fc_init_queue(ctrl, 0);
 
-	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
-			&nvme_fc_admin_mq_ops,
-			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
-				    ctrl->lport->ops->fcprqst_priv_sz));
-	if (ret)
-		goto out_free_queues;
-
 	/*
 	 * Would have been nice to init io queues tag set as well.
 	 * However, we require interaction from the controller
@@ -3539,6 +3532,13 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 	if (ret)
 		goto out_cleanup_tagset;
 
+	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
+			&nvme_fc_admin_mq_ops,
+			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
+				    ctrl->lport->ops->fcprqst_priv_sz));
+	if (ret)
+		goto out_free_queues;
+
 	/* at this point, teardown path changes to ref counting on nvme ctrl */
 
 	spin_lock_irqsave(&rport->lock, flags);
-- 
2.23.1

