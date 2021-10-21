Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AF4C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C476109F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhJUHer (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 03:34:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44746 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230385AbhJUHeo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 03:34:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KMsQa3002523
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=znENNcSxDYSLAr3yaxGdgZUVZjbAwBOvM/5wJIrLY9U=;
 b=U73CUpPP/D0XKmrwAS/9CZb25KbDRJIsyaGenKmIjuifV9CzQL8WUj5HeD9MLMLrtmXI
 tIFlR5sut7oDBzYpajXhy1oq4rAzbCaHZTuNqIDvMfu24kriiB0/96dHDPv0KTMp4/bC
 4toxFbuBJXygtRRwWr9tkhRbU61OlSP+1yq7Ffy6sw2aje10pmthqbN7LvCIqGdlkhVM
 brzfZcJxpCEllcTXH94+mU4V0ql8ShYE4T0yDF56ZGplaGs9xDVINtkxzQCbRngkNO9I
 2mDuuk/IqwGYmLuTkIBVynLqqKmGasL0QU2+mLlTBxCrsrX8BVsEYLVYGk3ZSoyMZiJa qA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3btjwdmrxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 00:32:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 21 Oct 2021 00:32:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 80A653F7088;
        Thu, 21 Oct 2021 00:32:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19L7WQ9K027621;
        Thu, 21 Oct 2021 00:32:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19L7WQis027620;
        Thu, 21 Oct 2021 00:32:26 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 01/13] qla2xxx: relogin during fabric disturbance
Date:   Thu, 21 Oct 2021 00:31:56 -0700
Message-ID: <20211021073208.27582-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211021073208.27582-1-njavali@marvell.com>
References: <20211021073208.27582-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: d167TCoZCyhzI-o8Ljp4jKQD7efb1FxM
X-Proofpoint-ORIG-GUID: d167TCoZCyhzI-o8Ljp4jKQD7efb1FxM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_02,2021-10-20_02,2020-04-07_01
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

