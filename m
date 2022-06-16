Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA533C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358637AbiFPFfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358565AbiFPFfP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688155AEF0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9tAg014579
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=byN7/OPYfMo9Vt04/3RTPl76mDg6KMEeBHeYWHlx2e4=;
 b=S97+fgP6gaShy7TYGrNZTdR/iW/FPdFQn6yXGXBFE3Tl4fYc0q22RtS0mr8vapjrBqIe
 zhM7svoeAR/yJBYlg1LEyXFhrlmZjRxnhLqXrvSi9BJ280Ij5/Lj3RJOpqnSAobYjbjl
 jku+wCfLWX2A07bve2SbMC8sAYRfpa2TpEFIJAJqFz+VhnpUgnJt9XPpopSbcbjW33t3
 7bPlTIDiamNuMHdlyS/PAOn7/Q7dvT57moVkIMjgBqLvnw9nz27PtRBOrFt8tXlsVE3l
 X3APGQODP7IpWJuquWSTFh9idp9s3OIujNg+EH2RjVr4MmNxBm/46bdy53q33EWtyuDE QA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jun
 2022 22:35:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 84CA33F7075;
        Wed, 15 Jun 2022 22:35:12 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 07/11] qla2xxx: Fix losing target when it reappears during delete
Date:   Wed, 15 Jun 2022 22:35:04 -0700
Message-ID: <20220616053508.27186-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7zmqfhKtE0oBub1x2vXLYGC6jNfMRiG_
X-Proofpoint-GUID: 7zmqfhKtE0oBub1x2vXLYGC6jNfMRiG_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

FC target disappeared during port perturbation tests
due to a race that tramples target state.
Fix the issue by adding state checks before proceeding.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8b87fefda423..feca9e44b21c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2714,17 +2714,24 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
-	/* Now that the rport has been deleted, set the fcport state to
-	   FCS_DEVICE_DEAD */
-	qla2x00_set_fcport_state(fcport, FCS_DEVICE_DEAD);
+
+	/*
+	 * Now that the rport has been deleted, set the fcport state to
+	 * FCS_DEVICE_DEAD, if the fcport is still lost.
+	 */
+	if (fcport->scan_state != QLA_FCPORT_FOUND)
+		qla2x00_set_fcport_state(fcport, FCS_DEVICE_DEAD);
 
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
 	 * all local references.
 	 */
 	spin_lock_irqsave(host->host_lock, flags);
-	fcport->rport = fcport->drport = NULL;
-	*((fc_port_t **)rport->dd_data) = NULL;
+	/* Confirm port has not reappeared before clearing pointers. */
+	if (rport->port_state != FC_PORTSTATE_ONLINE) {
+		fcport->rport = fcport->drport = NULL;
+		*((fc_port_t **)rport->dd_data) = NULL;
+	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
@@ -2757,9 +2764,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	/*
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
+	 *
+	 * Attempt to cleanup only lost devices.
 	 */
 	if (fcport->loop_id != FC_NO_LOOP_ID) {
-		if (IS_FWI2_CAPABLE(fcport->vha->hw)) {
+		if (IS_FWI2_CAPABLE(fcport->vha->hw) &&
+		    fcport->scan_state != QLA_FCPORT_FOUND) {
 			if (fcport->loop_id != FC_NO_LOOP_ID)
 				fcport->logout_on_delete = 1;
 
@@ -2769,7 +2779,7 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 				       __LINE__);
 				qlt_schedule_sess_for_deletion(fcport);
 			}
-		} else {
+		} else if (!IS_FWI2_CAPABLE(fcport->vha->hw)) {
 			qla2x00_port_logout(fcport->vha, fcport);
 		}
 	}
-- 
2.19.0.rc0

