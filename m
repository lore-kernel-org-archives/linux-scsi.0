Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACFAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 12:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhKWMZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:25:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23320 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229948AbhKWMZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Nov 2021 07:25:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AN77IjH010174;
        Tue, 23 Nov 2021 04:21:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=KLBuqmJfhtGYVkIZW7tYWG1WvRSiCf930RqyeXgozsM=;
 b=fhVt84R1ER6g343JE8yK8lE0YlhK/4o0dXkBlE+RlO1BP5HQi4wmuHjQ/uMyIH/nxuVl
 mat9g+IsLsaHExJNhg3IWgaX07a8CwVutPjG8eeKL9CBgpPFH+yPRJIic9L0kzD7wlOb
 ngE85Bbh4S7PZ9Vb8cEm/KYiyEmSXYIL6ywkYyiMv8FqJ15YyrSKCLFvVwIgt0NfabsE
 Cr1G4a57jSokKdRoO9nV7c/fP9gMcwveT09nShyCuSgyGx2Yp/diOpoKfmcIK+lGwSyq
 g/dFGxlPQVIdHOkyCs48poHHba4OWGHJJyg+teX2usGGfp2dxn2PStqnVHWUxiXQdbwf 7A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cgumj99s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 04:21:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Nov
 2021 04:21:53 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Nov 2021 04:21:53 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 999013F7045;
        Tue, 23 Nov 2021 04:21:53 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ANCLoB1008853;
        Tue, 23 Nov 2021 04:21:50 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ANCLFPP008633;
        Tue, 23 Nov 2021 04:21:15 -0800
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
Date:   Tue, 23 Nov 2021 04:21:15 -0800
Message-ID: <20211123122115.8599-1-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: X00S0esVBixQNGsPWmLWFN-UAISiZ83a
X-Proofpoint-ORIG-GUID: X00S0esVBixQNGsPWmLWFN-UAISiZ83a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When issued LUN reset under heavy i/o, we hit the qedi WARN_ON
because of a mismatch in firmware i/o cmd cleanup request count
and i/o cmd cleanup response count received. The mismatch is
because of the race caused by the postfix increment of
cmd_cleanup_cmpl.

[qedi_clearsq:1295]:18: fatal error, need hard reset, cid=0x0
WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296 qedi_clearsq+0xa5/0xd0 [qedi]
CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        W
Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 04/15/2020
Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
 RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
 RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
 R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
 R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
 FS:  0000000000000000(0000) GS:ffff9761bf800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
 Call Trace:
  qedi_ep_disconnect+0x533/0x550 [qedi]
  ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
  ? _cond_resched+0x15/0x30
  ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
  iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
  iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
  process_one_work+0x1a7/0x360
  ? create_worker+0x1a0/0x1a0
  worker_thread+0x30/0x390
  ? create_worker+0x1a0/0x1a0
  kthread+0x116/0x130
  ? kthread_flush_work_fn+0x10/0x10
  ret_from_fork+0x22/0x40
 ---[ end trace 5f1441f59082235c ]---

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 84a4204a2cb4..2eed2c6cf424 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -813,10 +813,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 
 check_cleanup_reqs:
 	if (qedi_conn->cmd_cleanup_req > 0) {
-		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
-			  "Freeing tid=0x%x for cid=0x%x\n",
-			  cqe->itid, qedi_conn->iscsi_conn_id);
-		qedi_conn->cmd_cleanup_cmpl++;
+		++qedi_conn->cmd_cleanup_cmpl;
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
+			  "Freeing tid=0x%x for cid=0x%x cleanup count=%d\n",
+			  cqe->itid, qedi_conn->iscsi_conn_id,
+			  qedi_conn->cmd_cleanup_cmpl);
 		wake_up(&qedi_conn->wait_queue);
 	} else {
 		QEDI_ERR(&qedi->dbg_ctx,
-- 
2.18.2

