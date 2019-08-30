Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC440C3A59B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F8123431
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cPpziDmg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfH3WYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:24:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19668 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728157AbfH3WYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 18:24:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMJoiQ001460;
        Fri, 30 Aug 2019 15:24:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hykvNowIUAw69cZ7F106ER9TV79DpZ4RoduIAMy6dXY=;
 b=cPpziDmgSMTa8dDgoN0rhEOV9g0G1t1Bh6f0juThuYWar1+adhTKh48eAqJOoVhaBPH5
 cRqC/+mjEI1tfbWJ+glgMtXNUJV2j3PWIVvauKCbfYHU6NdKgcW8QxvEsusHbjkrovy3
 KbsnO+3tDP+8CIs454nEakKZ6KWbx8tdBc+ZD4VgRpFMJGnyt1ciclmUtK08ByN1dqWR
 nIYKzTLK18hJHufCbEwgDDqCiPqRz1v6sLRMdapum1jh9fDlI0scdfwGPW5TAqKb1E8d
 W7Kb7ZsF9FpRkLxOL5sAOVHyF4Du3gWcBFs8BDQ3vPIjqpPIRupy0TycqddLwe3A/oEL 5A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rm2dat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:24:17 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 15:24:15 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 15:24:15 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 60F2D3F703F;
        Fri, 30 Aug 2019 15:24:15 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7UMOFU1023739;
        Fri, 30 Aug 2019 15:24:15 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7UMOF7U023738;
        Fri, 30 Aug 2019 15:24:15 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 4/6] qla2xxx: Fix stuck login session
Date:   Fri, 30 Aug 2019 15:24:00 -0700
Message-ID: <20190830222402.23688-5-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830222402.23688-1-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Login session was stucked on cable pull. When FW is in the middle
PRLI PENDING + driver is in Initiator mode, driver fail to
check back with FW to see if the PRLI has completed. This patch
would re-check with FW again to make sure PRLI would complete before
pushing forward with relogin.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8161f08f3a4d..2bbadcf60295 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -808,6 +808,15 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			fcport->fw_login_state = current_login_state;
 			fcport->d_id = id;
 			switch (current_login_state) {
+			case DSC_LS_PRLI_PEND:
+				/*
+				 * In the middle of PRLI. Let it finish.
+				 * Allow relogin code to recheck state again
+				 * with GNL. Push disc_state back to DELETED
+				 * so GNL can go out again
+				 */
+				fcport->disc_state = DSC_DELETED;
+				break;
 			case DSC_LS_PRLI_COMP:
 				if ((e->prli_svc_param_word_3[0] & BIT_4) == 0)
 					fcport->port_type = FCT_INITIATOR;
@@ -1474,7 +1483,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u64 wwn;
 	u16 sec;
 
-	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20d8,
+	ql_dbg(ql_dbg_disc, vha, 0x20d8,
 	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
@@ -1485,6 +1494,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return 0;
 
 	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
+	    qla_dual_mode_enabled(vha) &&
 	    ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
 	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
 		return 0;
@@ -1674,17 +1684,6 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	    fcport->last_login_gen, fcport->login_gen,
 	    fcport->flags);
 
-	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
-		return;
-
-	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
-		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-			return;
-		}
-	}
-
 	if (fcport->last_rscn_gen != fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20e9, "%s %d %8phC post gnl\n",
 		    __func__, __LINE__, fcport->port_name);
-- 
2.12.0

