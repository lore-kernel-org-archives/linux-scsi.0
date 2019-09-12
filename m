Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E7C4CEC8
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269352081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kD5N7GFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfILSJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:09:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15722 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbfILSJc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI9Plf019909;
        Thu, 12 Sep 2019 11:09:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Q0F3yFlvFx+AkoFTUZ3dHVDDUMGMSZWjC8R029eVGRc=;
 b=kD5N7GFVayWY+vIuaQD3nmDyDk9qoByqGCGaGycjoDJxbTvCzbK9lG7rnwAD9NU/6A7o
 0fCQr4j0gUeHLwWaH0RLKUygazxSSUAZT4mWzxZByh4bj3mEzP3yolB7xlBG5VoWiUzU
 G9U7RXioXCPMmz/XO7QtTcNRoYwQ9tgiWROmPA20LcAS+TUdwUbXAaoOwwZAT6LVjrxc
 7H4F3kJ/pogAnL3aMDGAUKnEZseXt8R1x3PWFhvBhq6qGiLMGVUahjB8dsHPIIRlGz80
 H5vtmyPBsBze+A+/MJWzIhGphEK80cHAjQ6r+WZ45b7/PtYm03iJXUjc3kX26uZNgF7U 9A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uytdfg5nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:09:30 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:09:28 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:09:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 92D1C3F703F;
        Thu, 12 Sep 2019 11:09:28 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CI9SwF006483;
        Thu, 12 Sep 2019 11:09:28 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CI9See006482;
        Thu, 12 Sep 2019 11:09:28 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 03/14] qla2xxx: Fix stale mem access on driver unload
Date:   Thu, 12 Sep 2019 11:09:07 -0700
Message-ID: <20190912180918.6436-4-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On driver unload, 'remove_one' thread  was allow to
advance, while session cleanup still lag behind.
This patch ensure session deletion will finish before
remove_one can advance.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c     |  1 +
 drivers/scsi/qla2xxx/qla_target.c | 21 ++++++++-------------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 51154c049385..42980e52fb41 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1118,6 +1118,7 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 	qla2x00_mark_all_devices_lost(vha, 0);
 
 	wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha), 10*HZ);
+	flush_workqueue(vha->hw->wq);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b58ecd2d7fb6..b5315be00b4d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -953,7 +953,7 @@ void qlt_free_session_done(struct work_struct *work)
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 	bool logout_started = false;
-	scsi_qla_host_t *base_vha;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	struct qlt_plogi_ack_t *own =
 		sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
 
@@ -1105,6 +1105,7 @@ void qlt_free_session_done(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	sess->free_pending = 0;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
@@ -1113,17 +1114,8 @@ void qlt_free_session_done(struct work_struct *work)
 	if (tgt && (tgt->sess_count == 0))
 		wake_up_all(&tgt->waitQ);
 
-	if (vha->fcport_count == 0)
-		wake_up_all(&vha->fcport_waitQ);
-
-	base_vha = pci_get_drvdata(ha->pdev);
-
-	sess->free_pending = 0;
-
-	if (test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags))
-		return;
-
-	if ((!tgt || !tgt->tgt_stop) && !LOOP_TRANSITION(vha)) {
+	if (!test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags) &&
+	    (!tgt || !tgt->tgt_stop) && !LOOP_TRANSITION(vha)) {
 		switch (vha->host->active_mode) {
 		case MODE_INITIATOR:
 		case MODE_DUAL:
@@ -1136,6 +1128,9 @@ void qlt_free_session_done(struct work_struct *work)
 			break;
 		}
 	}
+
+	if (vha->fcport_count == 0)
+		wake_up_all(&vha->fcport_waitQ);
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
@@ -1165,7 +1160,7 @@ void qlt_unreg_sess(struct fc_port *sess)
 	sess->last_login_gen = sess->login_gen;
 
 	INIT_WORK(&sess->free_work, qlt_free_session_done);
-	schedule_work(&sess->free_work);
+	queue_work(sess->vha->hw->wq, &sess->free_work);
 }
 EXPORT_SYMBOL(qlt_unreg_sess);
 
-- 
2.12.0

