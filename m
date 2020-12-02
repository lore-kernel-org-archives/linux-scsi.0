Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C587C64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC8E221FB
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgLBNZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:25:07 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18770 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726567AbgLBNZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:25:07 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DFUh1016245
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:24:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=z5kKJDcDk6FGJ9TyT0pR2gwrbBIGrIoJ6HhxDa1yFno=;
 b=FGXA8a8R1G+mZ8/eQEEnLEf4faoRweHXfu9+i3D32PF/Pxf8gFls4FyDt7rOPTXTqPDp
 bjLc/MNUTYgB2wkmbScwT91ws4blOsvNKm18wOA/ix7phxh5OlTbomGoHtkXGr4LB/Hr
 I5Iu9Sl0Lwvror7DrKe+lqXR89tCj3Is9gtB43+2Wnyh40gsGHTL39xGSww1JuNRg8Iu
 E2mMObT3upRIXCV1uQDbd3CTyfpL/D2IDqmfr1AQZ4ZON02HfYdh93qq69ZEUkVICqM/
 Nj4XzRr79YWHRkxpj5T2WuyYGU7b/ml2J5LTWn+yrra1qFCNkOV39wo34x7Y+WXRmeZH cw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8ftb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:24:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:24:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:24:25 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 35DEE3F703F;
        Wed,  2 Dec 2020 05:24:25 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DOPCq020026;
        Wed, 2 Dec 2020 05:24:25 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DOPtx020016;
        Wed, 2 Dec 2020 05:24:25 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 02/15] qla2xxx: Change post del message from debug level to log level
Date:   Wed, 2 Dec 2020 05:22:59 -0800
Message-ID: <20201202132312.19966-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Change the message debug level.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c     | 8 ++++----
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e28c4b7ec55f..391ac75e3de3 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3558,10 +3558,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 					if (fcport->flags & FCF_FCP2_DEVICE)
 						fcport->logout_on_delete = 0;
 
-					ql_dbg(ql_dbg_disc, vha, 0x20f0,
-					    "%s %d %8phC post del sess\n",
-					    __func__, __LINE__,
-					    fcport->port_name);
+					ql_log(ql_log_warn, vha, 0x20f0,
+					       "%s %d %8phC post del sess\n",
+					       __func__, __LINE__,
+					       fcport->port_name);
 
 					qlt_schedule_sess_for_deletion(fcport);
 					continue;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6603caddc054..0d09480b66cd 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1273,7 +1273,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 
 	qla24xx_chk_fcp_state(sess);
 
-	ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
+	ql_dbg(ql_log_warn, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
-- 
2.19.0.rc0

