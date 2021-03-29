Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1542DC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF854619B9
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbhC2I7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:59:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5554 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236533AbhC2I5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:57:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8sRx7008738;
        Mon, 29 Mar 2021 01:57:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Fu0O9UZTODAKlKx4bVSly1iiMoCxoVp0fX+41nri63A=;
 b=du/E0NP6JUSg2+ThhlNHETcolDIb0y+eKR2xnIABeFlxHDf2Y3tJmFEeADEle4t8sweV
 OmK2L25h3RInZwLdYrn/z9PJMb62DFNaDDjNfyf7WVTjYqhdHnCm5+P/qbIZc1Y6cG0K
 wyJBHqJCuv3uHjY5Y1k3UUJ1SkUmbIOSDerKpGB8F7uIxFg5AHYqMCdWYPVQHdU68315
 628oHmcVY0XtVRQbb+Hn9yqs2q6fIpCyJ/XPxSO+VFlMwesEY/qtavAGJmmhTZ+wYqLN
 gSVEt/BVqzrbRX6lUM+WHuYEtDagpkJNd1Rd/KR6b/RbIk5dkBcsVPM0RqgpOO2N03oG xg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37k63b8vts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:57:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:57:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:57:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7DA453F703F;
        Mon, 29 Mar 2021 01:57:19 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8vJtR004487;
        Mon, 29 Mar 2021 01:57:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8vJF8004486;
        Mon, 29 Mar 2021 01:57:19 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 11/12] qla2xxx: Do logout even if fabric scan retries got exhausted
Date:   Mon, 29 Mar 2021 01:52:28 -0700
Message-ID: <20210329085229.4367-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qICDRuDaKNIV4qQWuWJ5lrCNk_sZc8-g
X-Proofpoint-GUID: qICDRuDaKNIV4qQWuWJ5lrCNk_sZc8-g
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Perform logout of all remote ports so that all IOs with
driver are requeued with mid-layer for retry.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 517d358b0031..2a93d9c3c024 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3443,6 +3443,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			list_for_each_entry(fcport, &vha->vp_fcports, list) {
 				if ((fcport->flags & FCF_FABRIC_DEVICE) != 0) {
 					fcport->scan_state = QLA_FCPORT_SCAN;
+					if (fcport->loop_id == FC_NO_LOOP_ID)
+						fcport->logout_on_delete = 0;
+					else
+						fcport->logout_on_delete = 1;
 				}
 			}
 			goto login_logout;
-- 
2.19.0.rc0

