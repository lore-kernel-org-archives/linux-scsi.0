Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21045C001DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 07:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbjGNHBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbjGNHBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 03:01:30 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306342709
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:29 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DKHHBA008637
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=ufncz1ZGI2asviX0HAlJonQuS0D4dB657qCkJlVVc9M=;
 b=ksvZvwcsRx6N22pISA0GRBnnCVF5ZLHVDfBpmfs3wlRICD5xqiAKuVf0K/x4NQwnF3i4
 FwZ7d0eToE4aRyX++gnqvxAvBwbROe8Rov0Ap2O0A/QSyR1KRnFwmMGp7RvpOmq8TkEW
 iuTWgJ9hdZ7IN+MatypW41IUKpmHbUyr7XyWQEsAZp/Gx7gb8rLSh1dR2ArM8aDXjg14
 0CipneUhlCXfRjruRfn0TGRlhqyYaoLVYfNy1TVRVoGSG3WdCRvQUXNA2x19eoQCNjoR
 7xBTKpVOWJN4LFdxo+zNqTPFVkcJw0NqTcjZexIEXW/6Qkbx5ZZHHfQfOnaE4vpcbT6C HQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3rtptx9ry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Jul
 2023 00:01:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 14 Jul 2023 00:01:26 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 8F61F3F7067;
        Fri, 14 Jul 2023 00:01:24 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 08/10] qla2xxx: Fix TMF leak through
Date:   Fri, 14 Jul 2023 12:31:02 +0530
Message-ID: <20230714070104.40052-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com>
References: <20230714070104.40052-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Lz14C09ln2PnzflsJzzgp9o_Ie7tVPC3
X-Proofpoint-ORIG-GUID: Lz14C09ln2PnzflsJzzgp9o_Ie7tVPC3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Task management can retry up to 5 times when FW resource
becomes bottle neck. Between the retry, there is a short sleep.
Current code assumes the chip has not reset or session has
not change.

Check for chip reset or session change before sending Task management.

Cc: stable@vger.kernel.org
Fixes: 9803fb5d2759 (“scsi: qla2xxx: Fix task management cmd failure”)
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 06c4e5215789..40897d0958c4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2038,10 +2038,14 @@ static void qla_marker_sp_done(srb_t *sp, int res)
 	complete(&tmf->u.tmf.comp);
 }
 
-#define  START_SP_W_RETRIES(_sp, _rval) \
+#define  START_SP_W_RETRIES(_sp, _rval, _chip_gen, _login_gen) \
 {\
 	int cnt = 5; \
 	do { \
+		if (_chip_gen != sp->vha->hw->chip_reset || _login_gen != sp->fcport->login_gen) {\
+			_rval = EINVAL; \
+			break; \
+		} \
 		_rval = qla2x00_start_sp(_sp); \
 		if (_rval == EAGAIN) \
 			msleep(1); \
@@ -2064,6 +2068,7 @@ qla26xx_marker(struct tmf_arg *arg)
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 	fc_port_t *fcport = arg->fcport;
+	u32 chip_gen, login_gen;
 
 	if (TMF_NOT_READY(arg->fcport)) {
 		ql_dbg(ql_dbg_taskm, vha, 0x8039,
@@ -2073,6 +2078,9 @@ qla26xx_marker(struct tmf_arg *arg)
 		return QLA_SUSPENDED;
 	}
 
+	chip_gen = vha->hw->chip_reset;
+	login_gen = fcport->login_gen;
+
 	/* ref: INIT */
 	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
@@ -2090,7 +2098,7 @@ qla26xx_marker(struct tmf_arg *arg)
 	tm_iocb->u.tmf.loop_id = fcport->loop_id;
 	tm_iocb->u.tmf.vp_index = vha->vp_idx;
 
-	START_SP_W_RETRIES(sp, rval);
+	START_SP_W_RETRIES(sp, rval, chip_gen, login_gen);
 
 	ql_dbg(ql_dbg_taskm, vha, 0x8006,
 	    "Async-marker hdl=%x loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d rval %d.\n",
@@ -2159,6 +2167,9 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 		return QLA_SUSPENDED;
 	}
 
+	chip_gen = vha->hw->chip_reset;
+	login_gen = fcport->login_gen;
+
 	/* ref: INIT */
 	sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
 	if (!sp)
@@ -2176,7 +2187,7 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 	tm_iocb->u.tmf.flags = arg->flags;
 	tm_iocb->u.tmf.lun = arg->lun;
 
-	START_SP_W_RETRIES(sp, rval);
+	START_SP_W_RETRIES(sp, rval, chip_gen, login_gen);
 
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
 	    "Async-tmf hdl=%x loop-id=%x portid=%06x ctrl=%x lun=%lld qp=%d rval=%x.\n",
@@ -2195,9 +2206,6 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 	}
 
 	if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
-		chip_gen = vha->hw->chip_reset;
-		login_gen = fcport->login_gen;
-
 		jif = jiffies;
 		if (qla_tmf_wait(arg)) {
 			ql_log(ql_log_info, vha, 0x803e,
-- 
2.23.1

