Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B38C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 11:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B9BE6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 11:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhJZL5F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 07:57:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234077AbhJZL45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 07:56:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QAMn6Y014732
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 04:54:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tEkOOfL35HscptAZC1fGanVOzm6eFkxkO0LeE6W97Wk=;
 b=PnHiuUZYxIr1cW9dVexZ+jSnf+Xa8WeJ57km/NX9KbPsotAtp3T+kv0Re1xZ/lkTn5wN
 AjVB2P4NpnkWuH4zUx2QrVHl038d2OxE+BvOA1IIdOCy1G6+XNny429dDsU/vbY9N8TR
 194f8ptPt+RIZX0uXn7MxphOz+pIZilIlU5ImXAQKdzYv3mJwpJpoSE5l/gfn9IPrpiA
 4L2rqaN786uljNVfNeSgJoE3mX/q0aYjI3ZE2TPntuYOWaI882f8mWargS0xp45s2Kmd
 F3FEpUmIT/Z7YINxDhn8sMXaK+ZwqvTGwQZI0A+dEZf4lrzbdmu9+Fgwla3+/asSbAKJ 5g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8gc0f-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 04:54:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 04:54:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 04:54:31 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3A3293F7093;
        Tue, 26 Oct 2021 04:54:31 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19QBsVbW027755;
        Tue, 26 Oct 2021 04:54:31 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19QBsVNo027754;
        Tue, 26 Oct 2021 04:54:31 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 05/13] qla2xxx: edif: fix app start delay
Date:   Tue, 26 Oct 2021 04:54:04 -0700
Message-ID: <20211026115412.27691-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211026115412.27691-1-njavali@marvell.com>
References: <20211026115412.27691-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 071etxTUmCaG9caIeaw0VHRf4GBPyCJI
X-Proofpoint-ORIG-GUID: 071etxTUmCaG9caIeaw0VHRf4GBPyCJI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Current driver does unnecessary pause for each session to
get to certain state before allowing the app start call to
return. In larger environment, this introduce long delay.
Previously, the delay is meant to synchronize app and driver.
In today's driver, the 2 side uses various events to synchronize
the state.

The same is applied to authentication failure call.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 64 ++-------------------------------
 1 file changed, 3 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 615596becb7a..cf62f26ce27d 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -290,63 +290,6 @@ qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
 	return false;
 }
 
-static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
-		int waitonly)
-{
-	int cnt, max_cnt = 200;
-	bool traced = false;
-
-	fcport->keep_nport_handle = 1;
-
-	if (!waitonly) {
-		qla2x00_set_fcport_disc_state(fcport, state);
-		qlt_schedule_sess_for_deletion(fcport);
-	} else {
-		qla2x00_set_fcport_disc_state(fcport, state);
-	}
-
-	ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		"%s: waiting for session, max_cnt=%u\n",
-		__func__, max_cnt);
-
-	cnt = 0;
-
-	if (waitonly) {
-		/* Marker wait min 10 msecs. */
-		msleep(50);
-		cnt += 50;
-	}
-	while (1) {
-		if (!traced) {
-			ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-			    "%s: session sleep.\n",
-			    __func__);
-			traced = true;
-		}
-		msleep(20);
-		cnt++;
-		if (waitonly && (fcport->disc_state == state ||
-			fcport->disc_state == DSC_LOGIN_COMPLETE))
-			break;
-		if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
-			break;
-		if (cnt > max_cnt)
-			break;
-	}
-
-	if (!waitonly) {
-		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		    "%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
-		    __func__, fcport->port_name, fcport->loop_id,
-		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
-	} else {
-		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		    "%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
-		    __func__, fcport->port_name, fcport->loop_id,
-		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
-	}
-}
-
 static void
 qla_edif_free_sa_ctl(fc_port_t *fcport, struct edif_sa_ctl *sa_ctl,
 	int index)
@@ -583,8 +526,8 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			ql_dbg(ql_dbg_edif, vha, 0x911e,
 			       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
 			       __func__, fcport->port_name);
-			fcport->edif.app_sess_online = 1;
-			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+			fcport->edif.app_sess_online = 0;
+			qlt_schedule_sess_for_deletion(fcport);
 			qla_edif_sa_ctl_init(vha, fcport);
 		}
 	}
@@ -800,7 +743,6 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_edif, vha, 0x911e,
 		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
 		    __func__, fcport->port_name);
-		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
 		qla24xx_post_prli_work(vha, fcport);
 	}
 
@@ -873,7 +815,7 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		if (qla_ini_mode_enabled(fcport->vha)) {
 			fcport->send_els_logo = 1;
-			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+			qlt_schedule_sess_for_deletion(fcport);
 		}
 	}
 
-- 
2.19.0.rc0

