Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92854C83019
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FE9A2063A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgLBN14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:27:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2270 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727368AbgLBN14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:27:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DPOtg002490
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:27:15 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8g18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:27:15 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:27:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:27:14 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 25D4D3F7043;
        Wed,  2 Dec 2020 05:27:14 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DRDl3020070;
        Wed, 2 Dec 2020 05:27:13 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DRDMq020069;
        Wed, 2 Dec 2020 05:27:13 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 09/15] qla2xxx: fix N2N and NVME connect retry failure
Date:   Wed, 2 Dec 2020 05:23:06 -0800
Message-ID: <20201202132312.19966-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

FC-NVMe target discovery failed when initiator wwpn < target wwpn in an
N2N (Direct Attach) config, where the driver was stuck on FCP PRLI
mode and failed to retry with NVME PRLI.

Fixes: 84ed362ac40c ("scsi: qla2xxx: Dual FCP-NVMe target port support”)
Fixes: 983f127603fa ("scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure”)
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 71 ++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c  |  3 --
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5626e9b6949f..12e3b05baf41 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1268,9 +1268,10 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 		lio->u.logio.flags |= SRB_LOGIN_NVME_PRLI;
 
 	ql_dbg(ql_dbg_disc, vha, 0x211b,
-	    "Async-prli - %8phC hdl=%x, loopid=%x portid=%06x retries=%d %s.\n",
+	    "Async-prli - %8phC hdl=%x, loopid=%x portid=%06x retries=%d fc4type %x priority %x %s.\n",
 	    fcport->port_name, sp->handle, fcport->loop_id, fcport->d_id.b24,
-	    fcport->login_retry, NVME_TARGET(vha->hw, fcport) ? "nvme" : "fc");
+	    fcport->login_retry, fcport->fc4_type, vha->hw->fc4_type_priority,
+	    NVME_TARGET(vha->hw, fcport) ? "nvme" : "fcp");
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -1932,26 +1933,58 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		/*
-		 * Retry PRLI with other FC-4 type if failure occurred on dual
-		 * FCP/NVMe port
-		 */
-		if (NVME_FCP_TARGET(ea->fcport)) {
-			ql_dbg(ql_dbg_disc, vha, 0x2118,
-				"%s %d %8phC post %s prli\n",
-				__func__, __LINE__, ea->fcport->port_name,
-				(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
-				"NVMe" : "FCP");
-			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+		ql_dbg(ql_dbg_disc, vha, 0x2118,
+		       "%s %d %8phC priority %s, fc4type %x\n",
+		       __func__, __LINE__, ea->fcport->port_name,
+		       vha->hw->fc4_type_priority == FC4_PRIORITY_FCP ?
+		       "FCP" : "NVMe", ea->fcport->fc4_type);
+
+		if (N2N_TOPO(vha->hw)) {
+			if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME) {
 				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-			else
+				ea->fcport->fc4_type |= FS_FC4TYPE_FCP;
+			} else {
 				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
-		}
+				ea->fcport->fc4_type |= FS_FC4TYPE_NVME;
+			}
 
-		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		ea->fcport->keep_nport_handle = 0;
-		ea->fcport->logout_on_delete = 1;
-		qlt_schedule_sess_for_deletion(ea->fcport);
+			if (ea->fcport->n2n_link_reset_cnt < 3) {
+				ea->fcport->n2n_link_reset_cnt++;
+				vha->relogin_jif = jiffies + 2 * HZ;
+				/*
+				 * PRLI failed. Reset link to kick start
+				 * state machine
+				 */
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+			} else {
+				ql_log(ql_log_warn, vha, 0x2119,
+				       "%s %d %8phC Unable to reconnect\n",
+				       __func__, __LINE__,
+				       ea->fcport->port_name);
+			}
+		} else {
+			/*
+			 * switch connect. login failed. Take connection down
+			 * and allow relogin to retrigger
+			 */
+			if (NVME_FCP_TARGET(ea->fcport)) {
+				ql_dbg(ql_dbg_disc, vha, 0x2118,
+				       "%s %d %8phC post %s prli\n",
+				       __func__, __LINE__,
+				       ea->fcport->port_name,
+				       (ea->fcport->fc4_type & FS_FC4TYPE_NVME)
+				       ? "NVMe" : "FCP");
+				if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
+					ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
+				else
+					ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
+			}
+
+			ea->fcport->flags &= ~FCF_ASYNC_SENT;
+			ea->fcport->keep_nport_handle = 0;
+			ea->fcport->logout_on_delete = 1;
+			qlt_schedule_sess_for_deletion(ea->fcport);
+		}
 		break;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1b4261c3c476..d7d4ab65009c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3998,9 +3998,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
-				fcport->fc4_type = FS_FC4TYPE_FCP;
-				if (vha->flags.nvme_enabled)
-					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
 				if (wwn_to_u64(vha->port_name) >
 				    wwn_to_u64(fcport->port_name)) {
-- 
2.19.0.rc0

