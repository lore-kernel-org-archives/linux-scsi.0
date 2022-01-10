Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC57C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbiAJFDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:03:02 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58932 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229752AbiAJFC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:02:57 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209MWKDw024446
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:02:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=uk9OkRVd2orSyXgozHL1NeqMRZdXD1OMTU7l4E9Z9sE=;
 b=Fwar1Bap8xI11BU3j6U9jienSbPC46VgQwmXml/QucSuWiKHC3q7bqUqFR26woKtUma0
 n8uRKYq63ivO4vOnrM/BtkVpQc3EBNgEEGe2TRvKgXwdYAryPivB7VJn28tsRC5tHlYV
 M8wgskpBQiIfkDjxxkQba/p6RCF/daKbGCSxfz537oHQgSC+fPE/RsMWDVGFJkN/eUks
 LU1o1iSMmJOUduz6QRcrNZB6u55VkQGkiC0/Ku5YVtMl68D3ONz/J5ulxFpCmFHEqTA8
 h6T72uVqqiUsoVudyXOvykB1oz/pJE3cx2L0kntp+/RPEMvR6EXxs2P3vXU1QyfgyZNm tA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dg7nks0qj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:02:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 9 Jan
 2022 21:02:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 336CE3F70AB;
        Sun,  9 Jan 2022 21:02:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52tZ4004033;
        Sun, 9 Jan 2022 21:02:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52trU004032;
        Sun, 9 Jan 2022 21:02:55 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 10/17] qla2xxx: Fix device reconnect in loop topology
Date:   Sun, 9 Jan 2022 21:02:11 -0800
Message-ID: <20220110050218.3958-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LWcRsvPpoxR65egHEqSVuIH5U4Dnh_9i
X-Proofpoint-ORIG-GUID: LWcRsvPpoxR65egHEqSVuIH5U4Dnh_9i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

A device logout in loop topology initiates a device connection teardown
which looses the FW device handle. In loop topo, the device handle is not
regrabbed leading to device login failures and eventually to loss of the
device. Fix this by taking the main login path that does it.

Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 15 +++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ac25d2bfa90b..24322eb01571 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -974,6 +974,9 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			}
 			break;
+		case ISP_CFG_NL:
+			qla24xx_fcport_handle_login(vha, fcport);
+			break;
 		default:
 			break;
 		}
@@ -1563,6 +1566,11 @@ static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u8 login = 0;
 	int rc;
 
+	ql_dbg(ql_dbg_disc, vha, 0x307b,
+	    "%s %8phC DS %d LS %d lid %d retries=%d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, fcport->loop_id, fcport->login_retry);
+
 	if (qla_tgt_mode_enabled(vha))
 		return;
 
@@ -5604,6 +5612,13 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			memcpy(fcport->node_name, new_fcport->node_name,
 			    WWN_SIZE);
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			if (fcport->login_retry == 0) {
+				fcport->login_retry = vha->hw->login_retry_count;
+				ql_dbg(ql_dbg_disc, vha, 0x2135,
+				    "Port login retry %8phN, lid 0x%04x retry cnt=%d.\n",
+				    fcport->port_name, fcport->loop_id,
+				    fcport->login_retry);
+			}
 			found++;
 			break;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7d5159306112..88bff825aa5e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5540,6 +5540,11 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 					memset(&ea, 0, sizeof(ea));
 					ea.fcport = fcport;
 					qla24xx_handle_relogin_event(vha, &ea);
+				} else if (vha->hw->current_topology ==
+					 ISP_CFG_NL &&
+					IS_QLA2XXX_MIDTYPE(vha->hw)) {
+					(void)qla24xx_fcport_handle_login(vha,
+									fcport);
 				} else if (vha->hw->current_topology ==
 				    ISP_CFG_NL) {
 					fcport->login_retry--;
-- 
2.23.1

