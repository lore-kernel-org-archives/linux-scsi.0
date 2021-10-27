Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DF4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E4461052
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241407AbhJ0KCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241512AbhJ0KCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 06:02:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I99E032380
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CDzKC6ESY3zMjjP5OVgBvA2ndNJUfEVdENfI1eAqlyg=;
 b=hmW/6TTkqExqE0RJxnnBxNvUP25WoD+3JiOrN6BA6gIp9RgLFDOiejHCHoZs/5vpQgiQ
 35qapt4vGMFGRVFTXSeNeqCD0Z1VvRqa7K4bk8amLBU5TUI9FzVOmvyG5elVBCYAl0xb
 ljmHgX2gLO4U+z4jhskZisBM5Usn+37r179Ky3dH4XzNU6mwboOEaUlKF/+/N24X8Wxs
 1lxOIkUthW3akV2ef4oPcuFlshd9putxaJmJmu5HeHx1qCtm7LbeNKDyqQCnTy1CFrpW
 GRHErxxPgqma86hr5NXHghiVTiUdjc2Epug7yTpAZXAPw5A5W3+jL5Ta4mXUj6ydfbnq cA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8tjs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:59:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 02:59:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 99DCA3F7071;
        Wed, 27 Oct 2021 02:59:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19R9xev4016417;
        Wed, 27 Oct 2021 02:59:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19R9xerE016416;
        Wed, 27 Oct 2021 02:59:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 05/13] qla2xxx: edif: fix app start delay
Date:   Wed, 27 Oct 2021 02:58:43 -0700
Message-ID: <20211027095851.16362-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211027095851.16362-1-njavali@marvell.com>
References: <20211027095851.16362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 6o_HbA5ieTaF_IaLu4lQ-ymbyibcP9LU
X-Proofpoint-ORIG-GUID: 6o_HbA5ieTaF_IaLu4lQ-ymbyibcP9LU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
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
index 15ca7930d932..e97666700b8a 100644
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
@@ -580,8 +523,8 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
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
@@ -797,7 +740,6 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_edif, vha, 0x911e,
 		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
 		    __func__, fcport->port_name);
-		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
 		qla24xx_post_prli_work(vha, fcport);
 	}
 
@@ -870,7 +812,7 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		if (qla_ini_mode_enabled(fcport->vha)) {
 			fcport->send_els_logo = 1;
-			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+			qlt_schedule_sess_for_deletion(fcport);
 		}
 	}
 
-- 
2.19.0.rc0

