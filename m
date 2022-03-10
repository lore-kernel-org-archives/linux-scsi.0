Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F02AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbiCJJ1g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240757AbiCJJ11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEB1139CE2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dlxJ024974
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=V7BooIvhQSx60xQhwfsJYznAa3Cd7av//EZWI2mbcD8=;
 b=eR7M6fMI3OEyWD9NVRNp1S+l4U50OnqItE3R5Z6l37d7SnNVFrMogfAlxfh/g/Un53qu
 Wt0IZp1mRobg79IQGGkNEURZn69VYSeUWVNQ1PQJRCXBlc97xnvslBOKTcCGneD68htz
 LsQLKLfrVrg3kvlXIZkEoGiJHPNy8DDK65OgeSHbCNnqxeZDlErAyvR8L8CAh/ZK56LQ
 /jN4PzUzpfasAiALwuUtNDXweYMPl6Rm+lZ/RbqPHXuGVzMf0GDD59bqDN6nmVbhWc0u
 J2Kk5m3xULRaKI8UG8JSSIwAks0HVpmivKlmsnn+hBBTgWK83SaUag9AtgGliGnHw17+ cg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7x-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7D2673F7062;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QN1t023017;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QNpc023016;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 08/13] qla2xxx: Fix laggy FC remote port session recovery
Date:   Thu, 10 Mar 2022 01:25:59 -0800
Message-ID: <20220310092604.22950-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: nxN1nU9YMfJPCHhl85KwYIORK3nPAV2d
X-Proofpoint-ORIG-GUID: nxN1nU9YMfJPCHhl85KwYIORK3nPAV2d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For session recovery, driver relies on the dpc thread to
initiate certain operation. The dpc thread runs exclusively
without the Mailbox interface being occupied. Recent code change
for heartbeat check via mailbox cmd 0 is causing the dpc thread
from carrying out its operation. This patch allows the higher
priority error recovery to run first before running the lower priority
heartbeat check.

Cc: stable@vger.kernel.org
Fixes: d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_os.c  | 20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 25b884701267..2de5920126ca 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4621,6 +4621,7 @@ struct qla_hw_data {
 	struct workqueue_struct *wq;
 	struct work_struct heartbeat_work;
 	struct qlfc_fw fw_buf;
+	unsigned long last_heartbeat_run_jiffies;
 
 	/* FCP_CMND priority support */
 	struct qla_fcp_prio_cfg *fcp_prio_cfg;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d572a76d0fa0..89c7ac36a41a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7218,7 +7218,7 @@ static bool qla_do_heartbeat(struct scsi_qla_host *vha)
 	return do_heartbeat;
 }
 
-static void qla_heart_beat(struct scsi_qla_host *vha)
+static void qla_heart_beat(struct scsi_qla_host *vha, u16 dpc_started)
 {
 	struct qla_hw_data *ha = vha->hw;
 
@@ -7228,8 +7228,19 @@ static void qla_heart_beat(struct scsi_qla_host *vha)
 	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
 		return;
 
-	if (qla_do_heartbeat(vha))
+	/*
+	 * dpc thread cannot run if heartbeat is running at the same time.
+	 * We also do not want to starve heartbeat task. Therefore, do
+	 * heartbeat task at least once every 5 seconds.
+	 */
+	if (dpc_started &&
+	    time_before(jiffies, ha->last_heartbeat_run_jiffies + 5 * HZ))
+		return;
+
+	if (qla_do_heartbeat(vha)) {
+		ha->last_heartbeat_run_jiffies = jiffies;
 		queue_work(ha->wq, &ha->heartbeat_work);
+	}
 }
 
 /**************************************************************************
@@ -7420,6 +7431,8 @@ qla2x00_timer(struct timer_list *t)
 		start_dpc++;
 	}
 
+	/* borrowing w to signify dpc will run */
+	w = 0;
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||
@@ -7452,9 +7465,10 @@ qla2x00_timer(struct timer_list *t)
 		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags),
 		    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags));
 		qla2xxx_wake_dpc(vha);
+		w = 1;
 	}
 
-	qla_heart_beat(vha);
+	qla_heart_beat(vha, w);
 
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
-- 
2.19.0.rc0

