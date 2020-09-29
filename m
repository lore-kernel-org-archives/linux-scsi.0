Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29882C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95322076A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ygkh5iVQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgI2KYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:24:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7016 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI2KYo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 06:24:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TAOOn4016033
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:24:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=J2B967FxQWegXwzhmG4lpAFO7jjNJwncTmv5XA3hynY=;
 b=Ygkh5iVQYFnvVPybyElZ/8NRRo294jkKXvRaO084+0c+3o55cxdESNsEhay2J0GEsZm4
 y3u0pG6nEq22eUQU185/uETVLsPfm/vgaYQDxm+NNzrrS2rTUVs0gsDnUd4NI8DgaOXR
 Li9ylIWgR+CGBY1Mxx6vDwosMLjnrANvsN5GY/az1/TtcX5lTbRqwPCTn/1+kuqR1hdX
 1XlQSx6znWK4IeFiV7VIUWOd0MVjhNrp/js0aUmJYqL7t+YRjpxIhvG1ZdHBlesvvHNz
 nSWUQGPp5UW8Ll8lpLt/VPpm7zHxloG/Z53ELNU5XENjnKfKW7q1By/Lex3GfbsPhSt9 vg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p5g61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:24:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:24:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:24:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 03:24:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2F8873F703F;
        Tue, 29 Sep 2020 03:24:41 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08TAOfup032362;
        Tue, 29 Sep 2020 03:24:41 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08TAOfUX032352;
        Tue, 29 Sep 2020 03:24:41 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 6/7] qla2xxx: Fix point-to-point (N2N) device discovery issue
Date:   Tue, 29 Sep 2020 03:21:51 -0700
Message-ID: <20200929102152.32278-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200929102152.32278-1-njavali@marvell.com>
References: <20200929102152.32278-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

