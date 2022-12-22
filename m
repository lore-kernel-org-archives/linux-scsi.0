Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6186BC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 04:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiLVEkL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiLVEjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 23:39:46 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85941A396
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:44 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM4OKMm020309
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=mGgWOwdS4cD/HuDVjZaEYeJuy01viF0b9A/M1+I5ZVI=;
 b=ZRwoE8bxa7Kp/FjbQ12OpkTU9vaRvS7bsep8KXa1ig23E/OyQi3Hjl+mDW8zyKdsYhv0
 2cFuWhNNYrFozcC3ZkKZdvO51t9YBahX9bv9nJcXCTXGOYlyFcy1Tpnn+i9bdXgPc5XV
 2Xma0gjkk0RQJMKvuqy6QpJ+wusHLs4dp1tM9xgUeSQX12h9VLuvt9uYYd7VCLAMnPVd
 LKq8d9mejxYa6qSfYgf5AmrGVNbb0vAvACCv3Luma1p3UzmBdHY1gnxR4K0YvRxicQyo
 X6Xn0LQZpOkhYIawezyMysxvIryApYBVxrECa8QF2XrSqzRPK0m6N4Jg1fpkqkpayRPB 0Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mhe5rsdhc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 21 Dec
 2022 20:39:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 21 Dec 2022 20:39:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3A6655B694E;
        Wed, 21 Dec 2022 20:39:41 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 06/10] qla2xxx: edif - Fix stall session after app start
Date:   Wed, 21 Dec 2022 20:39:29 -0800
Message-ID: <20221222043933.2825-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
References: <20221222043933.2825-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: C4XwvVrHBcVuz2r5P5mJpkpEUPEz-cyB
X-Proofpoint-ORIG-GUID: C4XwvVrHBcVuz2r5P5mJpkpEUPEz-cyB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_01,2022-12-21_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For N2N, qla2x00_wait_for_sess_deletion call flushes
a session which accidentally clear the scan_flag and thus prevents
re-login to occur and causes session to stall.

Use session delete to avoid the accidental clearing of scan_flag.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 56 ++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 8374cbe8993b..4ed94745fee5 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -479,6 +479,49 @@ void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport)
 	spin_unlock_irqrestore(&ha->sadb_lock, flags);
 }
 
+/**
+ * qla_delete_n2n_sess_and_wait: search for N2N session, tear it down and
+ *    wait for tear down to complete.  In N2N topology, there is only one
+ *    session being active in tracking the remote device.
+ * @vha: host adapter pointer
+ * return code:  0 - found the session and completed the tear down.
+ *	1 - timeout occurred.  Caller to use link bounce to reset.
+ */
+static int qla_delete_n2n_sess_and_wait(scsi_qla_host_t *vha)
+{
+	struct fc_port *fcport;
+	int rc = -EIO;
+	ulong expire = jiffies + 23 * HZ;
+
+	if (!N2N_TOPO(vha->hw))
+		return 0;
+
+	fcport = NULL;
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (!fcport->n2n_flag)
+			continue;
+
+		ql_dbg(ql_dbg_disc, fcport->vha, 0x2016,
+		       "%s reset sess at app start \n", __func__);
+
+		qla_edif_sa_ctl_init(vha, fcport);
+		qlt_schedule_sess_for_deletion(fcport);
+
+		while (time_before_eq(jiffies, expire)) {
+			if (fcport->disc_state != DSC_DELETE_PEND) {
+				rc = 0;
+				break;
+			}
+			msleep(1);
+		}
+
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		break;
+	}
+
+	return rc;
+}
+
 /**
  * qla_edif_app_start:  application has announce its present
  * @vha: host adapter pointer
@@ -518,18 +561,17 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			fcport->n2n_link_reset_cnt = 0;
 
 		if (vha->hw->flags.n2n_fw_acc_sec) {
-			list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list)
-				qla_edif_sa_ctl_init(vha, fcport);
-
+			bool link_bounce = false;
 			/*
 			 * While authentication app was not running, remote device
 			 * could still try to login with this local port.  Let's
-			 * clear the state and try again.
+			 * reset the session, reconnect and re-authenticate.
 			 */
-			qla2x00_wait_for_sess_deletion(vha);
+			if (qla_delete_n2n_sess_and_wait(vha))
+				link_bounce = true;
 
-			/* bounce the link to get the other guy to relogin */
-			if (!vha->hw->flags.n2n_bigger) {
+			/* bounce the link to start login */
+			if (!vha->hw->flags.n2n_bigger || link_bounce) {
 				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
 				qla2xxx_wake_dpc(vha);
 			}
-- 
2.19.0.rc0

