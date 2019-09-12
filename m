Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED72DC4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2258206A5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Yu9MPqKt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733001AbfILPVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:21:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27206 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732699AbfILPVU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:21:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFFGj1029075;
        Thu, 12 Sep 2019 08:20:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=EtgFqclSbiTpkC/Q09gr7XDBSwk9ysdcfjOdzXLI9Gg=;
 b=Yu9MPqKtJ/dEz/9TQ297euy+elZMo3TUKJjhcrzpAbAdhuhC0AcKE2J73MbMeDn9Fm1f
 mfIyU2zhrdqj/B0z7g+mHuBbRgbAoi86NnUDoSjjNGXcV2lH9rYOwKO108+nWAOhyDvx
 GiAz8uSF2XLyAvln+0GX5JmNhM2FOowRcycur8gFKQ0/dhcZrZIuT9aUcEVL7xS7D3ui
 xApiE7OXTIDhwEmeCP+z6bgbDck4p9bqFZdsbarQXHaIJhac24QpP6BgE0Nlc5Brgx/c
 vRIT3rWLK4q+Fqt9CZvRKtmoyoEO6/SWFt7Rm1/UBWbcDQNGMDgfkGlNyKY9IvUDgblG kA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkfyp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:20:18 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:20:16 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:20:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D653C3F7040;
        Thu, 12 Sep 2019 08:20:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFKG1e002646;
        Thu, 12 Sep 2019 08:20:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFKGsD002645;
        Thu, 12 Sep 2019 08:20:16 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 09/14] qla2xxx: Add error handling for PLOGI ELS passthrough
Date:   Thu, 12 Sep 2019 08:19:44 -0700
Message-ID: <20190912151949.2348-10-hmadhani@marvell.com>
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

Add error handling logic to ELS Passthrough relating to NVME
devices. Current code does not parse error code to take proper
recovery action, instead it re-login with the same login parameters
that encountered the error. Ex: nport handle collision.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 95 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5c279449ca1c..840c3bf2a364 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2765,6 +2765,10 @@ qla2x00_els_dcmd2_sp_done(void *ptr, int res)
 	struct scsi_qla_host *vha = sp->vha;
 	struct event_arg ea;
 	struct qla_work_evt *e;
+	struct fc_port *conflict_fcport;
+	port_id_t cid;	/* conflict Nport id */
+	u32 *fw_status = sp->u.iocb_cmd.u.els_plogi.fw_status;
+	u16 lid;
 
 	ql_dbg(ql_dbg_disc, vha, 0x3072,
 	    "%s ELS done rc %d hdl=%x, portid=%06x %8phC\n",
@@ -2776,14 +2780,99 @@ qla2x00_els_dcmd2_sp_done(void *ptr, int res)
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
 	else {
-		if (res) {
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		} else {
+		switch (fw_status[0]) {
+		case CS_DATA_UNDERRUN:
+		case CS_COMPLETE:
 			memset(&ea, 0, sizeof(ea));
 			ea.fcport = fcport;
 			ea.rc = res;
 			ea.event = FCME_ELS_PLOGI_DONE;
 			qla2x00_fcport_event_handler(vha, &ea);
+			break;
+		case CS_IOCB_ERROR:
+			switch (fw_status[1]) {
+			case LSC_SCODE_PORTID_USED:
+				lid = fw_status[2] & 0xffff;
+				qlt_find_sess_invalidate_other(vha,
+				    wwn_to_u64(fcport->port_name),
+				    fcport->d_id, lid, &conflict_fcport);
+				if (conflict_fcport) {
+					/*
+					 * Another fcport shares the same
+					 * loop_id & nport id; conflict
+					 * fcport needs to finish cleanup
+					 * before this fcport can proceed
+					 * to login.
+					 */
+					conflict_fcport->conflict = fcport;
+					fcport->login_pause = 1;
+					ql_dbg(ql_dbg_disc, vha, 0x20ed,
+					    "%s %d %8phC pid %06x inuse with lid %#x post gidpn\n",
+					    __func__, __LINE__,
+					    fcport->port_name,
+					    fcport->d_id.b24, lid);
+				} else {
+					ql_dbg(ql_dbg_disc, vha, 0x20ed,
+					    "%s %d %8phC pid %06x inuse with lid %#x sched del\n",
+					    __func__, __LINE__,
+					    fcport->port_name,
+					    fcport->d_id.b24, lid);
+					qla2x00_clear_loop_id(fcport);
+					set_bit(lid, vha->hw->loop_id_map);
+					fcport->loop_id = lid;
+					fcport->keep_nport_handle = 0;
+					qlt_schedule_sess_for_deletion(fcport);
+				}
+				break;
+
+			case LSC_SCODE_NPORT_USED:
+				cid.b.domain = (fw_status[2] >> 16) & 0xff;
+				cid.b.area   = (fw_status[2] >>  8) & 0xff;
+				cid.b.al_pa  = fw_status[2] & 0xff;
+				cid.b.rsvd_1 = 0;
+
+				ql_dbg(ql_dbg_disc, vha, 0x20ec,
+				    "%s %d %8phC lid %#x in use with pid %06x post gnl\n",
+				    __func__, __LINE__, fcport->port_name,
+				    fcport->loop_id, cid.b24);
+				set_bit(fcport->loop_id,
+				    vha->hw->loop_id_map);
+				fcport->loop_id = FC_NO_LOOP_ID;
+				qla24xx_post_gnl_work(vha, fcport);
+				break;
+
+			case LSC_SCODE_NOXCB:
+				vha->hw->exch_starvation++;
+				if (vha->hw->exch_starvation > 5) {
+					ql_log(ql_log_warn, vha, 0xd046,
+					    "Exchange starvation. Resetting RISC\n");
+					vha->hw->exch_starvation = 0;
+					set_bit(ISP_ABORT_NEEDED,
+					    &vha->dpc_flags);
+					qla2xxx_wake_dpc(vha);
+				}
+				/* fall through */
+			default:
+				ql_dbg(ql_dbg_disc, vha, 0x20eb,
+				    "%s %8phC cmd error fw_status 0x%x 0x%x 0x%x\n",
+				    __func__, sp->fcport->port_name,
+				    fw_status[0], fw_status[1], fw_status[2]);
+
+				fcport->flags &= ~FCF_ASYNC_SENT;
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+				break;
+			}
+			break;
+
+		default:
+			ql_dbg(ql_dbg_disc, vha, 0x20eb,
+			    "%s %8phC cmd error 2 fw_status 0x%x 0x%x 0x%x\n",
+			    __func__, sp->fcport->port_name,
+			    fw_status[0], fw_status[1], fw_status[2]);
+
+			sp->fcport->flags &= ~FCF_ASYNC_SENT;
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			break;
 		}
 
 		e = qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
-- 
2.12.0

