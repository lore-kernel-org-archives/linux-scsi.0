Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C6AC49EAB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B27C613EE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhFXRU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 13:20:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232077AbhFXRUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 13:20:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OH9rt3017573
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 10:18:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=RDff8/0XJMKVaBSW0ldmwLnLaxRX4x91BxQp/+2pWD8=;
 b=M8LKCsoyIx5/SoaXgvVPex0Yw9vP2BgRl7haGIYBKr+D7Cpy4tBwQAnY8ff64rxGkZ7V
 8ZC3oILfTZojj05Q7v1VvJWAj8VHNUVUlt246tcN9/Vueg19KhmxD8MwZLyWnz4VBd+Z
 K1NZI5mbYQ60PnJKOZ07+MI0TKlaI2aMb030B3ymtUzpvoWjg3m4LdiZ9CcKWJ+PH52k
 zbMklB/tScBjFAAwYLZTW82lmgYdq+sZmq3MpA/e7FOM4QS/vvJY/XOsR5bgsFpMoy0E
 9yNUwkdf/mVt14LTMXMX4I20jLJAm7maR1oypF8/eQcrAMfI9jRfYtgHYCp4dRAhxm5K jg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39cgc8bk82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 10:18:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Jun
 2021 10:18:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 24 Jun 2021 10:18:27 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 59BEF5B695F;
        Thu, 24 Jun 2021 10:18:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15OHIRPR000643;
        Thu, 24 Jun 2021 10:18:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15OHIR2c000634;
        Thu, 24 Jun 2021 10:18:27 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH] qedf: Added check to synchronize abort and flush
Date:   Thu, 24 Jun 2021 10:18:02 -0700
Message-ID: <20210624171802.598-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dbpqlN1zR2HMT3UgSjxEpjKq_zM-R1EN
X-Proofpoint-GUID: dbpqlN1zR2HMT3UgSjxEpjKq_zM-R1EN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -Issue
  Race condition between qedf_cleanup_fcport() and
  qedf_process_error_detect()->qedf_initiate_abts().

 Above race condition leads to below call trace.

 [2069091.203145] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
 [2069091.213100] IP: [<ffffffffc0666cc6>] qedf_process_error_detect+0x96/0x130 [qedf]
 [2069091.223391] PGD 1943049067 PUD 194304e067 PMD 0
 [2069091.233420] Oops: 0000 [#1] SMP
 [2069091.361820] CPU: 1 PID: 14751 Comm: kworker/1:46 Kdump: loaded Tainted: P           OE  ------------   3.10.0-1160.25.1.el7.x86_64 #1
 [2069091.388474] Hardware name: HPE Synergy 480 Gen10/Synergy 480 Gen10 Compute Module, BIOS I42 04/08/2020
 [2069091.402148] Workqueue: qedf_io_wq qedf_fp_io_handler [qedf]
 [2069091.415780] task: ffff9bb9f5190000 ti: ffff9bacaef9c000 task.ti: ffff9bacaef9c000
 [2069091.429590] RIP: 0010:[<ffffffffc0666cc6>]  [<ffffffffc0666cc6>] qedf_process_error_detect+0x96/0x130 [qedf]
 [2069091.443666] RSP: 0018:ffff9bacaef9fdb8  EFLAGS: 00010246
 [2069091.457692] RAX: 0000000000000000 RBX: ffff9bbbbbfb18a0 RCX: ffffffffc0672310
 [2069091.471997] RDX: 00000000000005de RSI: ffffffffc066e7f0 RDI: ffff9beb3f4538d8
 [2069091.486130] RBP: ffff9bacaef9fdd8 R08: 0000000000006000 R09: 0000000000006000
 [2069091.500321] R10: 0000000000001551 R11: ffffb582996ffff8 R12: ffffb5829b39cc18
 [2069091.514779] R13: ffff9badab380c28 R14: ffffd5827f643900 R15: 0000000000000040
 [2069091.529472] FS:  0000000000000000(0000) GS:ffff9beb3f440000(0000) knlGS:0000000000000000
 [2069091.543926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [2069091.558942] CR2: 0000000000000030 CR3: 000000193b9a2000 CR4: 00000000007607e0
 [2069091.573424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [2069091.587876] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [2069091.602007] PKRU: 00000000
 [2069091.616010] Call Trace:
 [2069091.629902]  [<ffffffffc0663969>] qedf_process_cqe+0x109/0x2e0 [qedf]
 [2069091.643941]  [<ffffffffc0663b66>] qedf_fp_io_handler+0x26/0x60 [qedf]
 [2069091.657948]  [<ffffffff85ebddcf>] process_one_work+0x17f/0x440
 [2069091.672111]  [<ffffffff85ebeee6>] worker_thread+0x126/0x3c0
 [2069091.686057]  [<ffffffff85ebedc0>] ? manage_workers.isra.26+0x2a0/0x2a0
 [2069091.700033]  [<ffffffff85ec5da1>] kthread+0xd1/0xe0
 [2069091.713891]  [<ffffffff85ec5cd0>] ? insert_kthread_work+0x40/0x40

 Fix: Added check in qedf_process_error_detect().
 When flush is active, let the cmds be completed from the cleanup contex.

Signed-off-by: Javed Hasan <jhasan@marvell.com>

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 6184bc485811..5096e4cb7ad2 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1515,9 +1515,19 @@ void qedf_process_error_detect(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 {
 	int rval;
 
+	if (io_req == NULL) {
+		QEDF_INFO(NULL, QEDF_LOG_IO, "io_req is NULL.\n");
+		return;
+	}
+
+	if (io_req->fcport == NULL) {
+		QEDF_INFO(NULL, QEDF_LOG_IO,  "fcport is NULL.\n");
+		return;
+	}
+
 	if (!cqe) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
-			  "cqe is NULL for io_req %p\n", io_req);
+			"cqe is NULL for io_req %p\n", io_req);
 		return;
 	}
 
@@ -1533,6 +1543,16 @@ void qedf_process_error_detect(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		  le32_to_cpu(cqe->cqe_info.err_info.rx_buf_off),
 		  le32_to_cpu(cqe->cqe_info.err_info.rx_id));
 
+	/* When flush is active, let the cmds be flushed out from the cleanup context */
+	if (test_bit(QEDF_RPORT_IN_TARGET_RESET, &io_req->fcport->flags) ||
+		(test_bit(QEDF_RPORT_IN_LUN_RESET, &io_req->fcport->flags) &&
+		 io_req->sc_cmd->device->lun == (u64)io_req->fcport->lun_reset_lun)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			"Dropping EQE for xid=0x%x as fcport is flushing",
+			io_req->xid);
+		return;
+	}
+
 	if (qedf->stop_io_on_error) {
 		qedf_stop_all_io(qedf);
 		return;
-- 
2.18.2

