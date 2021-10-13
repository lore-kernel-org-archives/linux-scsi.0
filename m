Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05295C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E568A610EA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 12:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhJMMq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 08:46:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14340 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233626AbhJMMq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 08:46:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D8hS2v022306
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:44:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=mZp3TpgZGqFsPln/stv03rGBfXYOICjpsWNQOrGrVlA=;
 b=fuIGAdZDbDaSC3G2bkq2xBl4FOw52PldirO9WO2I+7P8T7MANhX3cH8k5h97BWa4mmDd
 AcVmDUJxlMAjsdExWxCQlnJJQSF4fQ7mwsbYyaQMF2lraL8V4S1oxN/pNl34r0jVgJj2
 EUKroF+HefAUjrgaA/r4QC5nZww07hcAkOgq+hFyap9i2OrXCPk/KxcZrMjK+Uk0vBu5
 MKcrelUzXOa8yFtBrvdArbXQE+SKIj4fhL9trj9KYXJutK08jXcPJpieeU3udjhXgG5h
 aguxUMv0Z7Xzj6+8gxYkkyUtKLp/7cJpPvel3tv5X0FDbbIMAQmvIXEckod1rDw+ywuQ /Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bnkcck5cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 05:44:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 05:44:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 05:44:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9DD803F7043;
        Wed, 13 Oct 2021 05:44:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19DCilOY017190;
        Wed, 13 Oct 2021 05:44:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19DCigJq017189;
        Wed, 13 Oct 2021 05:44:42 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/13] qla2xxx: relogin during fabric disturbance
Date:   Wed, 13 Oct 2021 05:44:10 -0700
Message-ID: <20211013124422.17151-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211013124422.17151-1-njavali@marvell.com>
References: <20211013124422.17151-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tQQBS7OX3i0q7-VKcchZpd0galx9PTLL
X-Proofpoint-GUID: tQQBS7OX3i0q7-VKcchZpd0galx9PTLL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
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

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

