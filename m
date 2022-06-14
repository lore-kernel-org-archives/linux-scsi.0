Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1713CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 07:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354557AbiFNHaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 03:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbiFNHaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 03:30:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8A33EA83
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 00:30:03 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E5SfxW006033
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 00:30:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=byN7/OPYfMo9Vt04/3RTPl76mDg6KMEeBHeYWHlx2e4=;
 b=C3vUsw9i1tKwwXPOg+VAuBoIBqNqN9sbk+ukZjGK1iEwEKrX5dEoZfBMS5lm17SW5rpT
 vOmg3LDQ1NQUiOooWbOqG2nYzMhkC8+ZZ4hBsMmDqmGvneBeC6naj4xRiLyF3HpTFM1f
 cbTY42doiVbtgKFFPmJa5UxqqnMOk5N/Uxmyl5nQPcpGBIA6TZ66d+5S8Wi0Jr2fHiV2
 dzgtL5/HsI3vax3xTYr5fKYgi3NOLTfX1p0FbpL1sN/x/QXGxtzpckm9oRitdirXNWsy
 CnPvOmMeH8hKqOby/TjcTaHriNQ4v8lRx6sgXBNkhfsLMJyCt11zqmOHZQ/idi+rCigd 3A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gmtjp2bjh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 00:30:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jun
 2022 00:29:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 14 Jun 2022 00:29:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 819073F7090;
        Tue, 14 Jun 2022 00:29:59 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/11] qla2xxx: Fix losing target when it reappears during delete
Date:   Tue, 14 Jun 2022 00:29:49 -0700
Message-ID: <20220614072953.16462-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220614072953.16462-1-njavali@marvell.com>
References: <20220614072953.16462-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: DVd61J9utGYwZ1CDZffDlJPbSslVv4oo
X-Proofpoint-ORIG-GUID: DVd61J9utGYwZ1CDZffDlJPbSslVv4oo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_02,2022-06-13_01,2022-02-23_01
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

