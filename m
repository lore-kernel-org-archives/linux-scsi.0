Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA53C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF2E22CB3
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="NIMfykZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHEEqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:46:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbgHEEqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:46:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754ZYGN023943
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:46:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nqm9W1BA52mv2euK6YR/84346Lp8A2RIYnlieG/bHQU=;
 b=NIMfykZT69X7fid6LtWi5Hvx3Hv9alNBI9APWBOa/7PyfnRizEPPRYoje9tghdt3UeqN
 UneTOKL2aJuQ9XiHBSGtm7SNrTgb2mJ2XbZojWcXq7jD1V/7Gop8mCzW2QwS5qr4nyuK
 i71DWA6dHPKB9LL3AQLb+ZtrHgCPZGMRbdDnxS+75Kn6PfxjeOf1ilXWAeIOXuw2DLu2
 I5ttJSErj7Qo51jEbo2sdcn8Aeq1yBkz/o9xZQ3RlrWXeb1MmxL6R3JIkgD1clmKfCjb
 oztW2iVobmx5MjDTbjJeUkzXI+XBx42ftPLxnECQkGW/cxAoGQs8ZkxQGxxRyEUGrWOJ DQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:46:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:46:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:46:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:46:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9F3F03F703F;
        Tue,  4 Aug 2020 21:46:03 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754k3ca030612;
        Tue, 4 Aug 2020 21:46:03 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754k3I4030611;
        Tue, 4 Aug 2020 21:46:03 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/10] qla2xxx: fix login timeout
Date:   Tue, 4 Aug 2020 21:43:56 -0700
Message-ID: <20200805044402.30543-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200805044402.30543-1-njavali@marvell.com>
References: <20200805044402.30543-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Multipath errors were seen during failback due to login timeout.
The remote device sent LOGO, the local host teared down the session
and did relogin. The RSCN arrived indicates remote device is going
through failover after which the relogin is in a 20s timeout phase.
At this point the driver is stuck in the relogin process.
Add a fix to delete the session as part of abort/flush the login.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c     | 19 ++++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8c30d9dbb48c..2d7a47a2873b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3536,10 +3536,23 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		}
 
 		if (fcport->scan_state != QLA_FCPORT_FOUND) {
+			bool do_delete = false;
+
+			if (fcport->scan_needed &&
+			    fcport->disc_state == DSC_LOGIN_PEND) {
+				/* his cable just got disconnected after we
+				 * send him a login. Do delete to prevent
+				 * timeout
+				 */
+				fcport->logout_on_delete = 1;
+				do_delete = true;
+			}
+
 			fcport->scan_needed = 0;
-			if ((qla_dual_mode_enabled(vha) ||
-				qla_ini_mode_enabled(vha)) &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
+			if (((qla_dual_mode_enabled(vha) ||
+			      qla_ini_mode_enabled(vha)) &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) ||
+				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
 					if (fcport->flags & FCF_FCP2_DEVICE)
 						fcport->logout_on_delete = 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fbb80a043b4f..90289162dbd4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1270,7 +1270,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 
 	qla24xx_chk_fcp_state(sess);
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
+	ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
-- 
2.19.0.rc0

