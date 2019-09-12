Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9635C4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92DC92081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="afXIhm6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfILSJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:09:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55760 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726956AbfILSJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI5CH1006870;
        Thu, 12 Sep 2019 11:09:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=fgRxxqI7Kh9iE7ImPw5FG06F9s8KU+HZX2naJNdM03c=;
 b=afXIhm6ohwneO/dJrpb9JLn1bCLb+ygqh5Sc5c+Z3QJsfGIKzgwSYPMcnFNyxtgLZPsr
 GhZPHfK332H6P1IHIricmMHxnqxm1fSVr5zuk42XXqgbYsctgdk8Tg2KI/ChH2U2uAWf
 zs+avbh++CKY1/CwozOQBZa3Pi4NBl0jKpl96eMtnV5et1AvGMTGLbescmutCQUNXNnq
 IO14StKO2ZG2w0Ld1WeCYm5atMlkm/wWvRHpV4qIa+PPaVwABi3VZmiyNBFFpSgrqcwi
 /z305r8JOvqdE+KlopveBKrTkAMiQkJk7xoObRoA6C1d0SH2Eq8e18GjwFQy4NCfg/SF qQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uytdh0673-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:09:39 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:09:38 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:09:38 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 446F73F703F;
        Thu, 12 Sep 2019 11:09:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CI9cKw006495;
        Thu, 12 Sep 2019 11:09:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CI9cXe006494;
        Thu, 12 Sep 2019 11:09:38 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 06/14] qla2xxx: Fix N2N link up fail
Date:   Thu, 12 Sep 2019 11:09:10 -0700
Message-ID: <20190912180918.6436-7-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

During link up/bounce, qla driver would do command flush as
part of cleanup.  In this case, the flush can intefere with FW state.
This patch allows FW to be in control of link up.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 drivers/scsi/qla2xxx/qla_os.c  | 6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6d6e10812b42..1cc6913f76c4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3897,6 +3897,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->dm_login_expire = jiffies + 2*HZ;
 				fcport->scan_state = QLA_FCPORT_FOUND;
 				fcport->n2n_flag = 1;
+				fcport->keep_nport_handle = 1;
 				if (vha->flags.nvme_enabled)
 					fcport->fc4f_nvme = 1;
 
@@ -4042,6 +4043,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			fcport->login_retry = vha->hw->login_retry_count;
 			fcport->plogi_nack_done_deadline = jiffies + HZ;
 			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->keep_nport_handle = 1;
 			fcport->n2n_flag = 1;
 			fcport->d_id.b.domain =
 				rptid_entry->u.f2.remote_nport_id[2];
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8411dd5acd43..ee47de9fbc05 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5135,11 +5135,9 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			if (dfcp)
 				qlt_schedule_sess_for_deletion(tfcp);
 
-
-			if (N2N_TOPO(vha->hw))
-				fcport->flags &= ~FCF_FABRIC_DEVICE;
-
 			if (N2N_TOPO(vha->hw)) {
+				fcport->flags &= ~FCF_FABRIC_DEVICE;
+				fcport->keep_nport_handle = 1;
 				if (vha->flags.nvme_enabled) {
 					fcport->fc4f_nvme = 1;
 					fcport->n2n_flag = 1;
-- 
2.12.0

