Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41590C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B741610FF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhJUHer (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 03:34:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229499AbhJUHeo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 03:34:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L67tfb010474
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hv/aQbH7RCXJMXLdLKyBOom63/ljn+pdnkkr4Mu8jl4=;
 b=h5ZqoTFEje8pLjch2yoc0PwyJYNgAXyrsoUPtHW9DSCx7nGfEurLer+sBi/MhBcbSd+X
 8A7QSgBzq2XXE5hNCGZCvedtqL7J2x2pA/gtTZyY+XjkZXpC+zysafuNJ9lKME8VlU3G
 1U4rEeqh8I84T4AmYQBfaQPZFDJiWunSJsu+f7P6vjc1Vgc3EapTv5wxqpXY9/uhAnSH
 /vdxVrUL4Ea1TStIaycikVz8J7uHTAp8WePZXxnqK0QBeu7HEEte5e4JgX+5Dg+gBKxe
 Y2egChPfM2QO8L13R6PkkpgH5rKnp1kBvAFGGuwJvhWsF2LUBupTY/nTvPpGUANHrEVG yg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bu2nrgbhe-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 00:32:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 21 Oct 2021 00:32:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D2EFC3F7084;
        Thu, 21 Oct 2021 00:32:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19L7WQf9027633;
        Thu, 21 Oct 2021 00:32:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19L7WQ4l027632;
        Thu, 21 Oct 2021 00:32:26 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 04/13] qla2xxx: edif: fix app start fail
Date:   Thu, 21 Oct 2021 00:31:59 -0700
Message-ID: <20211021073208.27582-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211021073208.27582-1-njavali@marvell.com>
References: <20211021073208.27582-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: MvsL1eW5-HSLX7EkyrgMrxet3vROvQca
X-Proofpoint-GUID: MvsL1eW5-HSLX7EkyrgMrxet3vROvQca
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_02,2021-10-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On app start, all sessions need to be reset to see
if secure connection can be made. Fix the
broken check which prevents that process.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 54 +++++++++++++++++----------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ad746c62f0d4..cb54d3ee11aa 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -529,7 +529,8 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	struct app_start_reply	appreply;
 	struct fc_port  *fcport, *tf;
 
-	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app start\n", __func__);
+	ql_log(ql_log_info, vha, 0x1313,
+	       "EDIF application registration with driver, FC device connections will be re-established.\n");
 
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, &appstart,
@@ -554,37 +555,38 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		qla2xxx_wake_dpc(vha);
 	} else {
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+			ql_dbg(ql_dbg_edif, vha, 0x2058,
+			       "FCSP - nn %8phN pn %8phN portid=%02x%02x%02x.\n",
+			       fcport->node_name, fcport->port_name,
+			       fcport->d_id.b.domain, fcport->d_id.b.area,
+			       fcport->d_id.b.al_pa);
 			ql_dbg(ql_dbg_edif, vha, 0xf084,
-			       "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
-			       __func__, fcport, fcport->port_name,
-			       fcport->loop_id, fcport->d_id.b24,
-			       fcport->logout_on_delete);
-
-			ql_dbg(ql_dbg_edif, vha, 0xf084,
-			       "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
-			       fcport->keep_nport_handle,
-			       fcport->send_els_logo, fcport->disc_state,
-			       fcport->edif.auth_state, fcport->edif.app_stop);
+			       "%s: se_sess %p / sess %p from port %8phC "
+			       "loop_id %#04x s_id %02x:%02x:%02x logout %d "
+			       "keep %d els_logo %d disc state %d auth state %d"
+			       "stop state %d\n",
+			       __func__, fcport->se_sess, fcport,
+			       fcport->port_name, fcport->loop_id,
+			       fcport->d_id.b.domain, fcport->d_id.b.area,
+			       fcport->d_id.b.al_pa, fcport->logout_on_delete,
+			       fcport->keep_nport_handle, fcport->send_els_logo,
+			       fcport->disc_state, fcport->edif.auth_state,
+			       fcport->edif.app_stop);
 
 			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
 				break;
-			if (!(fcport->flags & FCF_FCSP_DEVICE))
-				continue;
 
 			fcport->edif.app_started = 1;
-			if (fcport->edif.app_stop ||
-			    (fcport->disc_state != DSC_LOGIN_COMPLETE &&
-			     fcport->disc_state != DSC_LOGIN_PEND &&
-			     fcport->disc_state != DSC_DELETED)) {
-				/* no activity */
-				fcport->edif.app_stop = 0;
-
-				ql_dbg(ql_dbg_edif, vha, 0x911e,
-				       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
-				       __func__, fcport->port_name);
-				fcport->edif.app_sess_online = 1;
-				qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
-			}
+			fcport->login_retry = vha->hw->login_retry_count;
+
+			/* no activity */
+			fcport->edif.app_stop = 0;
+
+			ql_dbg(ql_dbg_edif, vha, 0x911e,
+			       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
+			       __func__, fcport->port_name);
+			fcport->edif.app_sess_online = 1;
+			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
 	}
-- 
2.19.0.rc0

