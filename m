Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07E9C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A419722CE3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="d994C2O6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389924AbfHWJxZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28086 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389897AbfHWJxZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nXCj002590
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=tRc/ui7l2tfouzcFCV+EQPkYLs4RspLgfRgX1D0g3nw=;
 b=d994C2O6x+SpeUbg0RJU+CoiCESOSIzF6vWjWrKLXErn706dGDMRRGwD6h/CjVZNwuJ1
 USOSxxR1Tq0FQv77G/6Kk2V3gPi3Omzr9NILNvvbM5Z6trmU9IkZ3WjHiZNXtUkjHf6w
 Sk6z5GSNbmmMzs4HqMgl26GyBLeaYeNFEusvAGtEKvTkyz9apoZjCSOjsMsAAx5rccTJ
 raYz9YUa79HNyFU6vbA4Yf38of0hV+JIo3sitCJ8zceUTCckFMVZpPA84Hp/Is4OE6ga
 gWajNinyVwtoqkhyP+SW5Vo0x4pQndXLCUzAAXaES/noiU1GESnmq0W55GSq+khwGnrI ig== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad4075t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:24 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:23 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id ECB013F703F;
        Fri, 23 Aug 2019 02:53:22 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9rMgr007925;
        Fri, 23 Aug 2019 02:53:22 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9rMZQ007924;
        Fri, 23 Aug 2019 02:53:22 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 13/14] qedf: Fix race betwen fipvlan request and response path.
Date:   Fri, 23 Aug 2019 02:52:43 -0700
Message-ID: <20190823095244.7830-14-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a race b/w fipvlan request and response path.
=====
qedf_fcoe_process_vlan_resp:113]:2: VLAN response, vid=0xffd.
qedf_initiate_fipvlan_req:165]:2: vlan = 0x6ffd already set.
qedf_set_vlan_id:139]:2: Setting vlan_id=0ffd prio=3.
======

The request thread sees that vlan is already set and fails to
call ctrl_link_up.

Fix:
- while setting vlan_id use local variable and before setting vlan_id.
- call fcoe_ctlr_link_up in next iteration of fipvlan request.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 0856d13..9c24f38 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -111,16 +111,18 @@
 
 void qedf_set_vlan_id(struct qedf_ctx *qedf, int vlan_id)
 {
-	qedf->vlan_id = vlan_id;
-	qedf->vlan_id |= qedf->prio << VLAN_PRIO_SHIFT;
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "Setting vlan_id=%04x "
-		   "prio=%d.\n", vlan_id, qedf->prio);
+	int vlan_id_tmp = 0;
+
+	vlan_id_tmp = vlan_id  | (qedf->prio << VLAN_PRIO_SHIFT);
+	qedf->vlan_id = vlan_id_tmp;
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+		  "Setting vlan_id=0x%04x prio=%d.\n",
+		  vlan_id_tmp, qedf->prio);
 }
 
 /* Returns true if we have a valid vlan, false otherwise */
 static bool qedf_initiate_fipvlan_req(struct qedf_ctx *qedf)
 {
-	int rc;
 
 	while (qedf->fipvlan_retries--) {
 		/* This is to catch if link goes down during fipvlan retries */
@@ -136,7 +138,10 @@ static bool qedf_initiate_fipvlan_req(struct qedf_ctx *qedf)
 
 		if (qedf->vlan_id > 0) {
 			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
-				  "vlan = 0x%x already set.\n", qedf->vlan_id);
+				  "vlan = 0x%x already set, calling ctlr_link_up.\n",
+				  qedf->vlan_id);
+			if (atomic_read(&qedf->link_state) == QEDF_LINK_UP)
+				fcoe_ctlr_link_up(&qedf->ctlr);
 			return true;
 		}
 
@@ -144,13 +149,7 @@ static bool qedf_initiate_fipvlan_req(struct qedf_ctx *qedf)
 			   "Retry %d.\n", qedf->fipvlan_retries);
 		init_completion(&qedf->fipvlan_compl);
 		qedf_fcoe_send_vlan_req(qedf);
-		rc = wait_for_completion_timeout(&qedf->fipvlan_compl,
-		    1 * HZ);
-		if (rc > 0 &&
-		    (atomic_read(&qedf->link_state) == QEDF_LINK_UP)) {
-			fcoe_ctlr_link_up(&qedf->ctlr);
-			return true;
-		}
+		wait_for_completion_timeout(&qedf->fipvlan_compl, 1 * HZ);
 	}
 
 	return false;
-- 
1.8.3.1

