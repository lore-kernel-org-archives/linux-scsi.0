Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A7CC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73C860F5E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbhHQFO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28234 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234162AbhHQFOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lb7C006738
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dNaKr1XEg2fGjLqpti7nQlZA5q0/lZ9Bz3Ezi1S9gpg=;
 b=ZYJHjjK/sRF8MPX+4g0neZqP2bYJzR4ik/BLrcKretAoBt4Jebp7NchNsqhXcxrbljCq
 3FUiJL92azFrXZF+n+ucytTPW6lhs6oXAQ0gMrVLOsQ+x4QcvvTxsq6daRqMc3KhHtYg
 VpY+ZeHv8x91FDvH9RAOYf01hQywNSPMBCkEHAxsN17dsPC95YrvXqJ0RMOAAwkAJ/7S
 VGpfoOZ2cMjVEb4jbVdeiomDf8W4wPAOgJynEeNp0JczTnFBXKLXTslctTtMvmF3Zf38
 f9VQmjN/s2jDqQ5Sg7/6Snzvs2WdluadxubhQk+rItuqDsdBoWMZ6pq88W7C6dD7KkKT Vg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4FA6C3F70AD;
        Mon, 16 Aug 2021 22:13:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5DpR4002536;
        Mon, 16 Aug 2021 22:13:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DpLQ002535;
        Mon, 16 Aug 2021 22:13:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/12] qla2xxx: edif: do secure plogi when auth app is present
Date:   Mon, 16 Aug 2021 22:13:09 -0700
Message-ID: <20210817051315.2477-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: GkjotsJNFzngMczMq7wsH6woeRBEtkMh
X-Proofpoint-ORIG-GUID: GkjotsJNFzngMczMq7wsH6woeRBEtkMh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For initiator mode, always do secure login when authentication app started.
Also remove redundant flags to indicate secure connection.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 2 --
 drivers/scsi/qla2xxx/qla_edif.c   | 6 +++---
 drivers/scsi/qla2xxx/qla_init.c   | 7 ++-----
 drivers/scsi/qla2xxx/qla_iocb.c   | 5 ++++-
 drivers/scsi/qla2xxx/qla_target.c | 4 +---
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 031107b6024f..ddc6932f05fa 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2620,7 +2620,6 @@ typedef struct fc_port {
 		uint32_t	enable:1;	/* device is edif enabled/req'd */
 		uint32_t	app_stop:2;
 		uint32_t	app_started:1;
-		uint32_t	secured_login:1;
 		uint32_t	aes_gmac:1;
 		uint32_t	app_sess_online:1;
 		uint32_t	tx_sa_set:1;
@@ -2631,7 +2630,6 @@ typedef struct fc_port {
 		uint32_t	rx_rekey_cnt;
 		uint64_t	tx_bytes;
 		uint64_t	rx_bytes;
-		uint8_t		non_secured_login;
 		uint8_t		auth_state;
 		uint16_t	authok:1;
 		uint16_t	rekey_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index bb5cda85b60f..dc10874a0c99 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -568,7 +568,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
 				break;
-			if (!fcport->edif.secured_login)
+			if (!(fcport->flags & FCF_FCSP_DEVICE))
 				continue;
 
 			fcport->edif.app_started = 1;
@@ -647,7 +647,7 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	qla_edb_stop(vha);          /* stop db */
 
 	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
-		if (fcport->edif.non_secured_login)
+		if (!(fcport->flags & FCF_FCSP_DEVICE))
 			continue;
 
 		if (fcport->flags & FCF_FCSP_DEVICE) {
@@ -948,7 +948,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
 			    "Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%06x secure %d.\n",
 			    fcport->node_name, fcport->port_name, pcnt,
-			    fcport->d_id.b24, fcport->edif.secured_login);
+			    fcport->d_id.b24, fcport->flags & FCF_FCSP_DEVICE);
 
 			switch (fcport->edif.auth_state) {
 			case VND_CMD_AUTH_STATE_ELS_RCVD:
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4c5acfde0788..7e6fb4ad4255 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1435,18 +1435,15 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
 		ql_dbg(ql_dbg_disc, vha, 0x104d,
 		    "Secure Login established on %8phC\n",
 		    fcport->port_name);
-		fcport->edif.secured_login = 1;
-		fcport->edif.non_secured_login = 0;
 		fcport->flags |= FCF_FCSP_DEVICE;
 	} else {
 		ql_dbg(ql_dbg_disc, vha, 0x104d,
 		    "non-Secure Login %8phC",
 		    fcport->port_name);
-		fcport->edif.secured_login = 0;
-		fcport->edif.non_secured_login = 1;
+		fcport->flags &= ~FCF_FCSP_DEVICE;
 	}
 	if (vha->hw->flags.edif_enabled) {
-		if (fcport->edif.secured_login) {
+		if (fcport->flags & FCF_FCSP_DEVICE) {
 			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_AUTH_PEND);
 			/* Start edif prli timer & ring doorbell for app */
 			fcport->edif.rx_sa_set = 0;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index eef1fa2b45c2..9d4ad1d2b00a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1552,6 +1552,9 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (sp->fcport->edif.enable  && (sp->fcport->flags & FCF_FCSP_DEVICE))
+		return qla28xx_start_scsi_edif(sp);
+
 	/* Setup device pointers. */
 	req = vha->req;
 	rsp = req->rsp;
@@ -1910,7 +1913,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
 
-	if (sp->fcport->edif.enable)
+	if (sp->fcport->edif.enable && (sp->fcport->flags & FCF_FCSP_DEVICE))
 		return qla28xx_start_scsi_edif(sp);
 
 	/* Acquire qpair specific lock */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2f4da88995ea..b3478ed9b12e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -636,10 +636,8 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 		fcport->fw_login_state = DSC_LS_PLOGI_PEND;
 		c = "PLOGI";
 		if (vha->hw->flags.edif_enabled &&
-		    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP)) {
+		    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP))
 			fcport->flags |= FCF_FCSP_DEVICE;
-			fcport->edif.secured_login = 1;
-		}
 		break;
 	case SRB_NACK_PRLI:
 		fcport->fw_login_state = DSC_LS_PRLI_PEND;
-- 
2.23.1

