Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7585DC4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462B820658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CrM9wS45"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBZWmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:42:18 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25226 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727802AbgBZWmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:42:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMVUdl003768;
        Wed, 26 Feb 2020 14:41:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ilhv0fgvquCBiUuJJdLZcfF9nIPhw59stBA7qnMbQdE=;
 b=CrM9wS453yZY7gXk86zCDdPALlh0nuSVsamTjPAs2U2Dwq+++FPXh22JD+60w00KQmHI
 rRM2vBT75+MNxqK3tCtEL0sOHhKkSB0cSZd+v68/ZmuZHKrvYi+V2HOyW9oVh6f4VQNq
 NMrj5lVhrvlQg3Y8V1hzSSjhVFjBzOxn6ZYj0T2cg7mC0wU0MRGQH1Q6sqiL/97NbK81
 keDjhgdN/vlC0p5vdrchlC9SuufHzTGsMIucP/SGSFff8jc/6OM8au9JSw3slmWfI+7r
 yo+GncyxmMA9ofP0hDrDnjLsX+8TaF69Jc4hCqaMIDZuqQGCvPIM7rgu/b8bRqOCNWq3 Sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ydcm15ba4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:16 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:14 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:41:14 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AFAB33F7040;
        Wed, 26 Feb 2020 14:41:14 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMfES8024629;
        Wed, 26 Feb 2020 14:41:14 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMfEmA024628;
        Wed, 26 Feb 2020 14:41:14 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 17/18] qla2xxx: Set Nport ID for N2N
Date:   Wed, 26 Feb 2020 14:40:21 -0800
Message-ID: <20200226224022.24518-18-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

When transitioning from loop to N2N, stale NPort ID
is not re-assigned. Stale ID can collide with remote device.
This patch will re-assign NPort ID on N2N is detected.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bd13b0d3cfea..a6f0bec65377 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3925,11 +3925,29 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->scan_state = QLA_FCPORT_SCAN;
 				fcport->n2n_flag = 0;
 			}
+			id.b24 = 0;
+			if (wwn_to_u64(vha->port_name) >
+			    wwn_to_u64(rptid_entry->u.f1.port_name)) {
+				vha->d_id.b24 = 0;
+				vha->d_id.b.al_pa = 1;
+				ha->flags.n2n_bigger = 1;
+
+				id.b.al_pa = 2;
+				ql_dbg(ql_dbg_async, vha, 0x5075,
+				    "Format 1: assign local id %x remote id %x\n",
+				    vha->d_id.b24, id.b24);
+			} else {
+				ql_dbg(ql_dbg_async, vha, 0x5075,
+				    "Format 1: Remote login - Waiting for WWPN %8phC.\n",
+				    rptid_entry->u.f1.port_name);
+				ha->flags.n2n_bigger = 0;
+			}
 
 			fcport = qla2x00_find_fcport_by_wwpn(vha,
 			    rptid_entry->u.f1.port_name, 1);
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+
 			if (fcport) {
 				fcport->plogi_nack_done_deadline = jiffies + HZ;
 				fcport->dm_login_expire = jiffies + 2*HZ;
@@ -3940,6 +3958,11 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				if (vha->flags.nvme_enabled)
 					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
+				if (wwn_to_u64(vha->port_name) >
+				    wwn_to_u64(fcport->port_name)) {
+					fcport->d_id = id;
+				}
+
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
 					set_bit(RELOGIN_NEEDED,
@@ -3952,25 +3975,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 					break;
 				}
 			} else {
-				id.b24 = 0;
-				if (wwn_to_u64(vha->port_name) >
-				    wwn_to_u64(rptid_entry->u.f1.port_name)) {
-					vha->d_id.b24 = 0;
-					vha->d_id.b.al_pa = 1;
-					ha->flags.n2n_bigger = 1;
-					ha->flags.n2n_ae = 0;
-
-					id.b.al_pa = 2;
-					ql_dbg(ql_dbg_async, vha, 0x5075,
-					    "Format 1: assign local id %x remote id %x\n",
-					    vha->d_id.b24, id.b24);
-				} else {
-					ql_dbg(ql_dbg_async, vha, 0x5075,
-					    "Format 1: Remote login - Waiting for WWPN %8phC.\n",
-					    rptid_entry->u.f1.port_name);
-					ha->flags.n2n_bigger = 0;
-					ha->flags.n2n_ae = 1;
-				}
 				qla24xx_post_newsess_work(vha, &id,
 				    rptid_entry->u.f1.port_name,
 				    rptid_entry->u.f1.node_name,
-- 
2.12.0

