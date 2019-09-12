Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9942C4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C6AE2081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OpFjEsOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbfILPUL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:20:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47150 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732566AbfILPUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:20:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFFGiw029075;
        Thu, 12 Sep 2019 08:20:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=mFE0StApMvgSHnNRFR/LWHL1FnmKT48vS1y3XxMD/RY=;
 b=OpFjEsOBTSHvfNM19NQkzMu/WTe3l1h9WmLEhBs99sk3y7HCzEc2Tp7XHqKtIXwwWaTw
 Lz3o5ZsWV9ADwTDytEtUYSGGRAAAAQnYO7+kAL//xDJDvusi7i+K3BUooG3FCt957Dp1
 f51O78YmXpeuiJsJKj2zSTSyxu7oIU50XYO+Oeem2ZDCCibDj02oyZGanMZyk6USR68l
 NYQL9pRWUf7SXqJztaAVV6D4L7MT6DFYUcsZkOM5ELE2i/3Fs+8t31Nw0yvVJNKZ0p13
 oAPFYInRTXDlFX4LvBvNcw3GzC1RtEk40LzCPgrhBXWJHjtX7JBC7CnNR7J4+8hAp1TK Fw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkfyn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:20:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:20:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:20:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 80E9C3F703F;
        Thu, 12 Sep 2019 08:20:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFK6Oq002581;
        Thu, 12 Sep 2019 08:20:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFK6nP002580;
        Thu, 12 Sep 2019 08:20:06 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 05/14] qla2xxx: Fix N2N link reset
Date:   Thu, 12 Sep 2019 08:19:40 -0700
Message-ID: <20190912151949.2348-6-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912151949.2348-1-hmadhani@marvell.com>
References: <20190912151949.2348-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_08:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Fix stalled link recovery for N2N with FC-NVMe connection

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   3 +-
 drivers/scsi/qla2xxx/qla_init.c | 107 +++++++++++++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_mbx.c  |  23 +++++++--
 drivers/scsi/qla2xxx/qla_os.c   |   4 ++
 4 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c15a37d15561..597f44ae7057 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2339,6 +2339,7 @@ typedef struct fc_port {
 	unsigned int query:1;
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
+	unsigned int n2n_flag:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2389,7 +2390,6 @@ typedef struct fc_port {
 	uint8_t fc4_type;
 	uint8_t	fc4f_nvme;
 	uint8_t scan_state;
-	uint8_t n2n_flag;
 
 	unsigned long last_queue_full;
 	unsigned long last_ramp_up;
@@ -2980,6 +2980,7 @@ enum scan_flags_t {
 enum fc4type_t {
 	FS_FC4TYPE_FCP	= BIT_0,
 	FS_FC4TYPE_NVME	= BIT_1,
+	FS_FCP_IS_N2N = BIT_7,
 };
 
 struct fab_scan_rp {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a98f857b3d72..5b715dac7145 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -757,12 +757,15 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			break;
 		default:
 			if ((id.b24 != fcport->d_id.b24 &&
-			    fcport->d_id.b24) ||
+			    fcport->d_id.b24 &&
+			    fcport->loop_id != FC_NO_LOOP_ID) ||
 			    (fcport->loop_id != FC_NO_LOOP_ID &&
 				fcport->loop_id != loop_id)) {
 				ql_dbg(ql_dbg_disc, vha, 0x20e3,
 				    "%s %d %8phC post del sess\n",
 				    __func__, __LINE__, fcport->port_name);
+				if (fcport->n2n_flag)
+					fcport->d_id.b24 = 0;
 				qlt_schedule_sess_for_deletion(fcport);
 				return;
 			}
@@ -770,6 +773,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		}
 
 		fcport->loop_id = loop_id;
+		if (fcport->n2n_flag)
+			fcport->d_id.b24 = id.b24;
 
 		wwn = wwn_to_u64(fcport->port_name);
 		qlt_find_sess_invalidate_other(vha, wwn,
@@ -986,7 +991,7 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 		wwn = wwn_to_u64(e->port_name);
 
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20e8,
-		    "%s %8phC %02x:%02x:%02x state %d/%d lid %x \n",
+		    "%s %8phC %02x:%02x:%02x CLS %x/%x lid %x \n",
 		    __func__, (void *)&wwn, e->port_id[2], e->port_id[1],
 		    e->port_id[0], e->current_login_state, e->last_login_state,
 		    (loop_id & 0x7fff));
@@ -1519,7 +1524,8 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
 		return 0;
 
-	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP &&
+	    !N2N_TOPO(vha->hw)) {
 		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			return 0;
@@ -1590,8 +1596,9 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				qla24xx_post_gpdb_work(vha, fcport, 0);
 			}  else {
 				ql_dbg(ql_dbg_disc, vha, 0x2118,
-				    "%s %d %8phC post NVMe PRLI\n",
-				    __func__, __LINE__, fcport->port_name);
+				    "%s %d %8phC post %s PRLI\n",
+				    __func__, __LINE__, fcport->port_name,
+				    fcport->fc4f_nvme ? "NVME" : "FC");
 				qla24xx_post_prli_work(vha, fcport);
 			}
 			break;
@@ -1934,17 +1941,38 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
-		if (ea->fcport->n2n_flag) {
+		if (ea->fcport->fc4f_nvme) {
 			ql_dbg(ql_dbg_disc, vha, 0x2118,
 				"%s %d %8phC post fc4 prli\n",
 				__func__, __LINE__, ea->fcport->port_name);
 			ea->fcport->fc4f_nvme = 0;
-			ea->fcport->n2n_flag = 0;
 			qla24xx_post_prli_work(vha, ea->fcport);
+			return;
+		}
+
+		/* at this point both PRLI NVME & PRLI FCP failed */
+		if (N2N_TOPO(vha->hw)) {
+			if (ea->fcport->n2n_link_reset_cnt < 3) {
+				ea->fcport->n2n_link_reset_cnt++;
+				/*
+				 * remote port is not sending Plogi. Reset
+				 * link to kick start his state machine
+				 */
+				set_bit(N2N_LINK_RESET, &vha->dpc_flags);
+			} else {
+				ql_log(ql_log_warn, vha, 0x2119,
+				    "%s %d %8phC Unable to reconnect\n",
+				    __func__, __LINE__, ea->fcport->port_name);
+			}
+		} else {
+			/*
+			 * switch connect. login failed. Take connection
+			 * down and allow relogin to retrigger
+			 */
+			ea->fcport->flags &= ~FCF_ASYNC_SENT;
+			ea->fcport->keep_nport_handle = 0;
+			qlt_schedule_sess_for_deletion(ea->fcport);
 		}
-		ql_dbg(ql_dbg_disc, vha, 0x2119,
-		    "%s %d %8phC unhandle event of %x\n",
-		    __func__, __LINE__, ea->fcport->port_name, ea->data[0]);
 		break;
 	}
 }
@@ -5092,28 +5120,47 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	unsigned long flags;
 
 	/* Inititae N2N login. */
-	if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
-		/* borrowing */
-		u32 *bp, i, sz;
-
-		memset(ha->init_cb, 0, ha->init_cb_size);
-		sz = min_t(int, sizeof(struct els_plogi_payload),
-		    ha->init_cb_size);
-		rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
-		    (void *)ha->init_cb, sz);
-		if (rval == QLA_SUCCESS) {
-			bp = (uint32_t *)ha->init_cb;
-			for (i = 0; i < sz/4 ; i++, bp++)
-				*bp = cpu_to_be32(*bp);
+	if (N2N_TOPO(ha)) {
+		if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
+			/* borrowing */
+			u32 *bp, i, sz;
+
+			memset(ha->init_cb, 0, ha->init_cb_size);
+			sz = min_t(int, sizeof(struct els_plogi_payload),
+			    ha->init_cb_size);
+			rval = qla24xx_get_port_login_templ(vha,
+			    ha->init_cb_dma, (void *)ha->init_cb, sz);
+			if (rval == QLA_SUCCESS) {
+				bp = (uint32_t *)ha->init_cb;
+				for (i = 0; i < sz/4 ; i++, bp++)
+					*bp = cpu_to_be32(*bp);
 
-			memcpy(&ha->plogi_els_payld.data, (void *)ha->init_cb,
-			    sizeof(ha->plogi_els_payld.data));
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		} else {
-			ql_dbg(ql_dbg_init, vha, 0x00d1,
-			    "PLOGI ELS param read fail.\n");
+				memcpy(&ha->plogi_els_payld.data,
+				    (void *)ha->init_cb,
+				    sizeof(ha->plogi_els_payld.data));
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			} else {
+				ql_dbg(ql_dbg_init, vha, 0x00d1,
+				    "PLOGI ELS param read fail.\n");
+				goto skip_login;
+			}
+		}
+
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->n2n_flag) {
+				qla24xx_fcport_handle_login(vha, fcport);
+				return QLA_SUCCESS;
+			}
+		}
+skip_login:
+		spin_lock_irqsave(&vha->work_lock, flags);
+		vha->scan.scan_retry++;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+
+		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
-		return QLA_SUCCESS;
 	}
 
 	found_devs = 0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d728819b7ffa..3c297ad4247f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2245,7 +2245,7 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x105a,
+	ql_dbg(ql_dbg_disc, vha, 0x105a,
 	    "Entered %s.\n", __func__);
 
 	if (IS_CNA_CAPABLE(vha->hw)) {
@@ -3879,14 +3879,23 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		case TOPO_N2N:
 			ha->current_topology = ISP_CFG_N;
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+			list_for_each_entry(fcport, &vha->vp_fcports, list) {
+				fcport->scan_state = QLA_FCPORT_SCAN;
+				fcport->n2n_flag = 0;
+			}
+
 			fcport = qla2x00_find_fcport_by_wwpn(vha,
 			    rptid_entry->u.f1.port_name, 1);
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 			if (fcport) {
 				fcport->plogi_nack_done_deadline = jiffies + HZ;
-				fcport->dm_login_expire = jiffies + 3*HZ;
+				fcport->dm_login_expire = jiffies + 2*HZ;
 				fcport->scan_state = QLA_FCPORT_FOUND;
+				fcport->n2n_flag = 1;
+				if (vha->flags.nvme_enabled)
+					fcport->fc4f_nvme = 1;
+
 				switch (fcport->disc_state) {
 				case DSC_DELETED:
 					set_bit(RELOGIN_NEEDED,
@@ -3920,7 +3929,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				    rptid_entry->u.f1.port_name,
 				    rptid_entry->u.f1.node_name,
 				    NULL,
-				    FC4_TYPE_UNKNOWN);
+				    FS_FCP_IS_N2N);
 			}
 
 			/* if our portname is higher then initiate N2N login */
@@ -4019,6 +4028,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			fcport->scan_state = QLA_FCPORT_SCAN;
+			fcport->n2n_flag = 0;
 		}
 
 		fcport = qla2x00_find_fcport_by_wwpn(vha,
@@ -4028,6 +4038,13 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			fcport->login_retry = vha->hw->login_retry_count;
 			fcport->plogi_nack_done_deadline = jiffies + HZ;
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->n2n_flag = 1;
+			fcport->d_id.b.domain =
+				rptid_entry->u.f2.remote_nport_id[2];
+			fcport->d_id.b.area =
+				rptid_entry->u.f2.remote_nport_id[1];
+			fcport->d_id.b.al_pa =
+				rptid_entry->u.f2.remote_nport_id[0];
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5aeb027c1dbd..a9ad3bd8f8cf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5060,6 +5060,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
+
+			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N)
+				fcport->n2n_flag = 1;
+
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
 				   "%s %8phC mem alloc fail.\n",
-- 
2.12.0

