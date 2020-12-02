Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D984C64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A93682075A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgLBN3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:29:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727991AbgLBN3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:29:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DQc6u021228
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:28:52 -0800
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50a4f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:28:52 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:28:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:28:50 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A64B53F703F;
        Wed,  2 Dec 2020 05:28:50 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DSoxB020103;
        Wed, 2 Dec 2020 05:28:50 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DSo6N020102;
        Wed, 2 Dec 2020 05:28:50 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 13/15] qla2xxx: If fcport is undergoing deletion return IO with retry
Date:   Wed, 2 Dec 2020 05:23:10 -0800
Message-ID: <20201202132312.19966-14-njavali@marvell.com>
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

Driver unload with IOs causes server to crash.
Return IO with retry if fcport undergoing deletion.

CPU: 44 PID: 35008 Comm: qla2xxx_4_dpc Kdump: loaded Tainted: G
OE  X   5.3.18-22-default #1 SLE15-SP2 (unreleased)
Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 07/16/2020
RIP: 0010:dma_direct_unmap_sg+0x24/0x60
Code: 4c 8b 04 24 eb b9 0f 1f 44 00 00 85 d2 7e 4e 41 57
      4d 89 c7 41 56 41 89 ce 41 55 49 89 fd 41 54 41 89 d4 55 31 ed 53 48 89
      f3 <8b> 53 18 48 8b 73 10 4d 89 f8 44 89 f1 4c 89 ef 83 c5 01 e8 44 ff
RSP: 0018:ffffc0c661037d88 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: 000000000000001d RSI: 0000000000000000 RDI: ffff9a51ee53b0b0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff9a51ee53b0b0
R10: ffffc0c646463dc8 R11: ffff9a4a067087c8 R12: 000000000000001d
R13: ffff9a51ee53b0b0 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff9a523f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 000000043740a004 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
qla2xxx_qpair_sp_free_dma+0x20d/0x3c0 [qla2xxx]
qla2xxx_qpair_sp_compl+0x35/0x90 [qla2xxx]
__qla2x00_abort_all_cmds+0x180/0x390 [qla2xxx]
? qla24xx_process_purex_list+0x100/0x100 [qla2xxx]
qla2x00_abort_all_cmds+0x5e/0x80 [qla2xxx]
qla2x00_do_dpc+0x317/0xa30 [qla2xxx]
kthread+0x10d/0x130
? kthread_park+0xa0/0xa0
ret_from_fork+0x35/0x40

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a75edba2b334..be9d10092dd3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -884,8 +884,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			goto qc24_fail_command;
 	}
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	if (!fcport || fcport->deleted) {
+		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
@@ -966,8 +966,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		goto qc24_fail_command;
 	}
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	if (!fcport || fcport->deleted) {
+		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
-- 
2.19.0.rc0

