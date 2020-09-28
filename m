Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63408C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27A32208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="lGZSZafX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgI1FxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:53:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgI1FxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 01:53:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S5opEA023026
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6JdxdUp54UyKC/lg7pNIdR8iYOsggbNh3UGDy/DmgjI=;
 b=lGZSZafXuqJfk6AnL4f2XsbQ6e4cdoko7MjmOp9fDbQ/PRouroBfManvoDP42A1UMObt
 icPj6KBh2twZpDjMATDRw0D+NDkZ8hsW4OsTRsuYFxX5kqvUJ750QB2QQCb0kSSaizeH
 WOmgsy8yIgiKW+jIuEUXqrypgeA0ZadAF+m7AVq2EsA0VhGe0RkmEqM/iOQkrEU8QW+j
 YupoL/cZ3jGEHlFf8XazbqfpTvRseWWs1m+CoDqIVyWgF9bXzHJWBVuCR8pzUlcAXvJZ
 Ch2r+jzaA6pcuZ2AlD5Kizcgx5BRCOPSSk/LEDtY5VOnBgFRKyzqcvniDU9eoBIi7Nw7 tQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55nyxcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:53:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:53:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 27 Sep 2020 22:53:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B04213F703F;
        Sun, 27 Sep 2020 22:53:12 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08S5rC3M004033;
        Sun, 27 Sep 2020 22:53:12 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08S5rCxG004032;
        Sun, 27 Sep 2020 22:53:12 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 6/7] qla2xxx: Fix point-to-point (N2N) device discovery issue
Date:   Sun, 27 Sep 2020 22:50:22 -0700
Message-ID: <20200928055023.3950-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200928055023.3950-1-njavali@marvell.com>
References: <20200928055023.3950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Driver was using a shorter timeout waiting for PLOGI from the
peer in point-to-point configurations. Some devices takes
some time (~4 seconds) to initiate the PLOGI. This peer
initiating PLOGI is when the peer has a higher P-WWN.

Increase the wait time based on N2N R_A_TOV.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 ++
 drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
 drivers/scsi/qla2xxx/qla_os.c  | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 98814a9a8ea6..b0b4228050e9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5147,6 +5147,8 @@ struct sff_8247_a0 {
 	 ha->current_topology == ISP_CFG_N || \
 	 !ha->current_topology)
 
+#define QLA_N2N_WAIT_TIME	5 /* 2 * ra_tov(n2n) + 1 */
+
 #define NVME_TYPE(fcport) \
 	(fcport->fc4_type & FS_FC4TYPE_NVME) \
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d861d025bce1..d90880d5cf46 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3994,7 +3994,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 
 			if (fcport) {
 				fcport->plogi_nack_done_deadline = jiffies + HZ;
-				fcport->dm_login_expire = jiffies + 2*HZ;
+				fcport->dm_login_expire = jiffies +
+					QLA_N2N_WAIT_TIME * HZ;
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6c4dc8eff8b8..b7a0feecac76 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5097,6 +5097,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 			fcport->fc4_type = e->u.new_sess.fc4_type;
 			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N) {
+				fcport->dm_login_expire = jiffies +
+					QLA_N2N_WAIT_TIME * HZ;
 				fcport->fc4_type = FS_FC4TYPE_FCP;
 				fcport->n2n_flag = 1;
 				if (vha->flags.nvme_enabled)
-- 
2.19.0.rc0

