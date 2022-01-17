Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B3EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jan 2022 13:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiAQNyC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:54:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235917AbiAQNyC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Jan 2022 08:54:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20H99moL014239;
        Mon, 17 Jan 2022 05:54:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qhx8xrjXuNG0h+cpvnS82tj+vaIcmEjalzbqqKBNpKU=;
 b=IABGHCPoOu1SelFkJMDDnlMagwYbL/e2aoDCSLfzEhoZSfI9L9TRshHIqmCw3Yc4S8a3
 OGaS1f1pcbGyfJDscHSaAJO8UnWiwkMgTwza18UA7c5696PzFY2xsRcLDLWh9VmN5Z8g
 RibBVEUJwRaenb9nT+8M146YJJW5BxpIXWOEP0+GGDHwSEbiSnEDcR9UJWv5aAadXkDv
 5a6lhlnxegf5wRrtaQxR1oA7Txk7JD5LsFRmw2QSm84Nhxkfdg73h/ngm/iep4Grzpfz
 i54rqpTumVVtHRUwDeNh4NcCkmLgpIGBnUSrzHOuNTZ4NPrtuRWtnaAOtFzPJOulTs9u gQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dn5gg8pyt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 05:54:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 05:53:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 17 Jan 2022 05:53:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9BDB05B692E;
        Mon, 17 Jan 2022 05:53:57 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20HDrqE6006303;
        Mon, 17 Jan 2022 05:53:52 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20HDriLJ006302;
        Mon, 17 Jan 2022 05:53:44 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <loberman@redhat.com>,
        <jpittman@redhat.com>, <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 1/3] qedf: Add stag_work to all the vports
Date:   Mon, 17 Jan 2022 05:53:09 -0800
Message-ID: <20220117135311.6256-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220117135311.6256-1-njavali@marvell.com>
References: <20220117135311.6256-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: z5_KT6wY2SMtAxrF2kVjD0ApZBSavnq7
X-Proofpoint-GUID: z5_KT6wY2SMtAxrF2kVjD0ApZBSavnq7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_06,2022-01-14_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Call trace seen when creating NPIV ports, only 32 out of 64 show online.
stag work was not initialized for vport, hence initialize the stag work.

WARNING: CPU: 8 PID: 645 at kernel/workqueue.c:1635 __queue_delayed_work+0x68/0x80
CPU: 8 PID: 645 Comm: kworker/8:1 Kdump: loaded Tainted: G IOE    --------- --
 4.18.0-348.el8.x86_64 #1
Hardware name: Dell Inc. PowerEdge MX740c/0177V9, BIOS 2.12.2 07/09/2021
Workqueue: events fc_lport_timeout [libfc]
RIP: 0010:__queue_delayed_work+0x68/0x80
Code: 89 b2 88 00 00 00 44 89 82 90 00 00 00 48 01 c8 48 89 42 50 41 81
f8 00 20 00 00 75 1d e9 60 24 07 00 44 89 c7 e9 98 f6 ff ff <0f> 0b eb
c5 0f 0b eb a1 0f 0b eb a7 0f 0b eb ac 44 89 c6 e9 40 23
RSP: 0018:ffffae514bc3be40 EFLAGS: 00010006
RAX: ffff8d25d6143750 RBX: 0000000000000202 RCX: 0000000000000002
RDX: ffff8d2e31383748 RSI: ffff8d25c000d600 RDI: ffff8d2e31383788
RBP: ffff8d2e31380de0 R08: 0000000000002000 R09: ffff8d2e31383750
R10: ffffffffc0c957e0 R11: ffff8d2624800000 R12: ffff8d2e31380a58
R13: ffff8d2d915eb000 R14: ffff8d25c499b5c0 R15: ffff8d2e31380e18
FS:  0000000000000000(0000) GS:ffff8d2d1fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fd0484b8b8 CR3: 00000008ffc10006 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
  queue_delayed_work_on+0x36/0x40
  qedf_elsct_send+0x57/0x60 [qedf]
  fc_lport_enter_flogi+0x90/0xc0 [libfc]
  fc_lport_timeout+0xb7/0x140 [libfc]
  process_one_work+0x1a7/0x360
  ? create_worker+0x1a0/0x1a0
  worker_thread+0x30/0x390
  ? create_worker+0x1a0/0x1a0
  kthread+0x116/0x130
  ? kthread_flush_work_fn+0x10/0x10
  ret_from_fork+0x35/0x40
 ---[ end trace 008f00f722f2c2ff ]--

Initialize stag work for all the vports.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cdc66e2a9488..3a5ce540cfc4 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1864,6 +1864,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vport_qedf->cmd_mgr = base_qedf->cmd_mgr;
 	init_completion(&vport_qedf->flogi_compl);
 	INIT_LIST_HEAD(&vport_qedf->fcports);
+	INIT_DELAYED_WORK(&vport_qedf->stag_work, qedf_stag_change_work);
 
 	rc = qedf_vport_libfc_config(vport, vn_port);
 	if (rc) {
-- 
2.23.1

