Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7C0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiFGEqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiFGEqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533C6D19E6
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:44 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXafq025411
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=SGpUu2mVNBZ83Y9vygB5LxFrGxpZfcVfWeVjSIDr0XI=;
 b=LT2rg7YpMCktRs3/+aVId1I6qZlGe1aSHufjPbR+u58DOyAV+DLMwmMXzK6tTyEgd+C7
 pTHPvASLorjWJOxxIQTEk4z9enoEOxows2McI4lqOkQc57hlB7NVfPH1p89dAqCVgL+b
 vl3g0A/n4XnouElR0r3lctrxfda7KKJujQXsvV1gujkWGm5MBTtSoGzG/+CnTO2jQgtn
 bvvDJyzqi9SpMvzK74VuR5f2PGfNhas55JEk2DWgkZ3Jhqytfn17u5rsHmSDx7N3HVA7
 3Rd03le+zrlmz6R6CS30/zZE03rxnFsHH9zuYhOPjDfO2VU/iKAVEGV0Ql9uxquT9o1O CQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8e-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 21:46:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 16DF23F7075;
        Mon,  6 Jun 2022 21:46:41 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 05/11] qla2xxx: edif: Fix potential stuck session in sa update
Date:   Mon, 6 Jun 2022 21:46:21 -0700
Message-ID: <20220607044627.19563-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gj2DXi-tIssBMys8CtK2phX1Z-Jdk5ku
X-Proofpoint-GUID: gj2DXi-tIssBMys8CtK2phX1Z-Jdk5ku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

When a thread is in the process of reestablish
a session, a flag is set to prevent multiple threads/triggers from
doing the same task. This flag was left on, where any attempt to
relogin was locked out. Clear this flag, if the attempt has failed.

Fixes: dd30706e73b70 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index dca54ece4726..c9f6ec49b0b4 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2331,6 +2331,7 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 
 static void qla_noop_sp_done(srb_t *sp, int res)
 {
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
@@ -2355,7 +2356,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		    "sa_ctl allocation failed\n");
-		return -ENOMEM;
+		rval =  -ENOMEM;
+		goto done;
 	}
 
 	fcport = sa_ctl->fcport;
@@ -2365,7 +2367,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sp) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		 "SRB allocation failed\n");
-		return -ENOMEM;
+		rval = -ENOMEM;
+		goto done;
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
@@ -2394,9 +2397,17 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 
 	rval = qla2x00_start_sp(sp);
 
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
+		goto done_free_sp;
+	}
 
+	return rval;
+done_free_sp:
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
+	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
-- 
2.19.0.rc0

