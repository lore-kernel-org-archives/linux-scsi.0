Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7FFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 11:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E315C60F0F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 11:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhJZL45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 07:56:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230523AbhJZL44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 07:56:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QAMn6S014732
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 04:54:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=z1DL9Qf2h1/0JnwNCsTPAIhIjkXllQfubqPaMbpthjM=;
 b=Vynd1CAaU76OiXgLeWMd5Q3I+jBBPJTPlZY1xSFtpd4+t9XXwoQcoL3pnaTD15RLeLVg
 /qvYL6bD0z7Gic8ihXoId+NrNkJ/fvAsv3nPOYRd3fK3YmJ865hSeaL0V2+G+JkUfu+b
 PDplSZw6V45dl9TtsQbtIIS99s57qaLyzyk7f3fN4WS3d6/HSA3op49B4sbLV+nD87Xy
 GD335sGqrT+YaUQcaUUC93DVhnSDAfRnUnOA5nzsCn05Lfc/cHV3tFQpzsv0iiU0KMYW
 /cPC6yO0Y11arFf+G2exGI+dDk3UJiutEhy1nYG+jp3tG2xkcqR11Wv8uOsDtY3B7kLk yg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8gc0f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 04:54:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 04:54:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 04:54:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B63073F7072;
        Tue, 26 Oct 2021 04:54:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19QBsUDl027739;
        Tue, 26 Oct 2021 04:54:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19QBsUoR027738;
        Tue, 26 Oct 2021 04:54:30 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 01/13] qla2xxx: relogin during fabric disturbance
Date:   Tue, 26 Oct 2021 04:54:00 -0700
Message-ID: <20211026115412.27691-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211026115412.27691-1-njavali@marvell.com>
References: <20211026115412.27691-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: iULCVkydtr5tyj6RGsUAmac-PCfg2VDL
X-Proofpoint-ORIG-GUID: iULCVkydtr5tyj6RGsUAmac-PCfg2VDL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For RSCN of type "Area, Domain, or Fabric", which indicate
a portion or entire fabric was disturbed. Current driver
does not set the scan_need flag to indicate a session was
affected by the disturbance. This in turn, can lead to
IO timeout and delay of relogin. Hence initiate relogin
in the event of fabric disturbance.

Fixes: 1560bafdff9e ("scsi: qla2xxx: Use complete switch scan for RSCN events")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 54 +++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a9a4243cb15a..339aa3b2737a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1786,16 +1786,52 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	fc_port_t *fcport;
 	unsigned long flags;
 
-	fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
-	if (fcport) {
-		if (fcport->flags & FCF_FCP2_DEVICE) {
-			ql_dbg(ql_dbg_disc, vha, 0x2115,
-			       "Delaying session delete for FCP2 portid=%06x %8phC ",
-			       fcport->d_id.b24, fcport->port_name);
-			return;
+	switch (ea->id.b.rsvd_1) {
+	case RSCN_PORT_ADDR:
+		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
+		if (fcport) {
+			if (fcport->flags & FCF_FCP2_DEVICE) {
+				ql_dbg(ql_dbg_disc, vha, 0x2115,
+				       "Delaying session delete for FCP2 portid=%06x %8phC ",
+					fcport->d_id.b24, fcport->port_name);
+				return;
+			}
+			fcport->scan_needed = 1;
+			fcport->rscn_gen++;
+		}
+		break;
+	case RSCN_AREA_ADDR:
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->flags & FCF_FCP2_DEVICE)
+				continue;
+
+			if ((ea->id.b24 & 0xffff00) == (fcport->d_id.b24 & 0xffff00)) {
+				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
 		}
-		fcport->scan_needed = 1;
-		fcport->rscn_gen++;
+		break;
+	case RSCN_DOM_ADDR:
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->flags & FCF_FCP2_DEVICE)
+				continue;
+
+			if ((ea->id.b24 & 0xff0000) == (fcport->d_id.b24 & 0xff0000)) {
+				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
+		}
+		break;
+	case RSCN_FAB_ADDR:
+	default:
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->flags & FCF_FCP2_DEVICE)
+				continue;
+
+			fcport->scan_needed = 1;
+			fcport->rscn_gen++;
+		}
+		break;
 	}
 
 	spin_lock_irqsave(&vha->work_lock, flags);
-- 
2.19.0.rc0

