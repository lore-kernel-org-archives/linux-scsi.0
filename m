Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3512C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 06:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjJ3GuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 02:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjJ3GuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 02:50:02 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C95CC0
        for <linux-scsi@vger.kernel.org>; Sun, 29 Oct 2023 23:49:53 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39TKgRlu031497
        for <linux-scsi@vger.kernel.org>; Sun, 29 Oct 2023 23:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=LV2gpbmb2sVMLHy0vSeWEooGsaWhfyHiEHcDCzh2/c8=;
 b=HNQ8uGPsBCkAWNl5CpD15ZTrv8MNZxIEJcFR7odKoojpL6DLxUziJuINq2YDbDEhdpm6
 rF8gd+FXRXo8r24RtOnbXUOQZhbf5WXh7xfziicib8WzdSZ5q+EFtVDTyXS0PBrKhStY
 dZDLfFqeyjJpzgDbGZWx5HmG15VvJIb4u4mg4K04ORvVrb8CvQ4QcogYz3gUNCR7ap/U
 O0AQAMoyejLkTMLNWCaK6Lkh9If20FyCAmiSIzddrcImfdfL3+ZAZ2zZRx1SYWPWosq3
 NLHVhBx9xK9YMdbHSxQEsQ43tv4GZ3mnySVdGP3mPT3RhainkeNGfonUQdWtDI6N722Q 3w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3u11tp4u1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 29 Oct 2023 23:49:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 29 Oct
 2023 23:49:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 29 Oct 2023 23:49:31 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id C048A3F703F;
        Sun, 29 Oct 2023 23:49:29 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH] qla2xxx: fix system crash due to bad pointer access
Date:   Mon, 30 Oct 2023 12:19:12 +0530
Message-ID: <20231030064912.37912-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: qS1udEtW86WN98UhR6MzxH8UfFON2vTw
X-Proofpoint-ORIG-GUID: qS1udEtW86WN98UhR6MzxH8UfFON2vTw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_05,2023-10-27_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User experience system crash when running AER error injection.
The perturbation cause the abort all IO path to trigger. The driver
assume all IO in this path are FCP only. Instead, there
are both NVME & FCP IO's. Due to the false assumption, system
crash is the result. Add additional check to see if IO is
FCP or not before access.

PID: 999019  TASK: ff35d769f24722c0  CPU: 53  COMMAND: "kworker/53:1"
 0 [ff3f78b964847b58] machine_kexec at ffffffffae86973d
 1 [ff3f78b964847ba8] __crash_kexec at ffffffffae9be29d
 2 [ff3f78b964847c70] crash_kexec at ffffffffae9bf528
 3 [ff3f78b964847c78] oops_end at ffffffffae8282ab
 4 [ff3f78b964847c98] exc_page_fault at ffffffffaf2da502
 5 [ff3f78b964847cc0] asm_exc_page_fault at ffffffffaf400b62
   [exception RIP: qla2x00_abort_srb+444]
   RIP: ffffffffc07b5f8c  RSP: ff3f78b964847d78  RFLAGS: 00010046
   RAX: 0000000000000282  RBX: ff35d74a0195a200  RCX: ff35d76886fd03a0
   RDX: 0000000000000001  RSI: ffffffffc07c5ec8  RDI: ff35d74a0195a200
   RBP: ff35d76913d22080   R8: ff35d7694d103200   R9: ff35d7694d103200
   R10: 0000000100000000  R11: ffffffffb05d6630  R12: 0000000000010000
   R13: ff3f78b964847df8  R14: ff35d768d8754000  R15: ff35d768877248e0
   ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 6 [ff3f78b964847d70] qla2x00_abort_srb at ffffffffc07b5f84 [qla2xxx]
 7 [ff3f78b964847de0] __qla2x00_abort_all_cmds at ffffffffc07b6238 [qla2xxx]
 8 [ff3f78b964847e38] qla2x00_abort_all_cmds at ffffffffc07ba635 [qla2xxx]
 9 [ff3f78b964847e58] qla2x00_terminate_rport_io at ffffffffc08145eb [qla2xxx]
10 [ff3f78b964847e70] fc_terminate_rport_io at ffffffffc045987e [scsi_transport_fc]
11 [ff3f78b964847e88] process_one_work at ffffffffae914f15
12 [ff3f78b964847ed0] worker_thread at ffffffffae9154c0
13 [ff3f78b964847f10] kthread at ffffffffae91c456
14 [ff3f78b964847f50] ret_from_fork at ffffffffae8036ef

Cc: stable@vger.kernel.org
Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7e103d711825..d24410944f7d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1837,8 +1837,16 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
-			sp->done(sp, res);
+		switch (sp->type) {
+		case SRB_SCSI_CMD:
+			if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
+				sp->done(sp, res);
+			break;
+		default:
+			if (ret_cmd)
+				sp->done(sp, res);
+			break;
+		}
 	} else {
 		sp->done(sp, res);
 	}
-- 
2.23.1

