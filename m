Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B60C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94D5206E3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GEsTMIme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgLAIai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:30:38 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22974 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726415AbgLAIai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:30:38 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18Kwl5026330
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:29:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=q8XrmEn98aZj6HqTHvp1q/nB1Hkoa5e3ZszbIhbRymQ=;
 b=GEsTMImeukBocuBM76yJ6Uvwx9/DDWa6WmJ0J0o4i1gQonbMYd1bdhB1QUGGAFckTV3k
 LK9sY27XK8TUhJSiZVgeMib4w8j0On0ipqFoOBASB2HjJ4gcmMJCW7IQQDMvioFh132z
 55vU5dbFp1yhB49SiCs4AB/VJfRTn8/90Ms2h5u1c10M67ep3y+/WIkcvF1jVyAIlA77
 3Aw6bDp/otaHsC/IuWCGLsfywPeLJUyepfuHVrCJy/xPWFjZlgJvUfjzBOO/qu7zNZg0
 35Z830Ed7CSM8wU/8FVDhg02G6RemB0CCR1hrYdlts8E9K+nc5z8nfmC1/TCUY+YBPr8 QQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 353mssfkp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:29:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:29:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:29:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:29:56 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BD3353F703F;
        Tue,  1 Dec 2020 00:29:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18TteY024237;
        Tue, 1 Dec 2020 00:29:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18Ttca024228;
        Tue, 1 Dec 2020 00:29:55 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 05/15] qla2xxx: Don't check for fw_started while posting nvme command
Date:   Tue, 1 Dec 2020 00:27:20 -0800
Message-ID: <20201201082730.24158-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201201082730.24158-1-njavali@marvell.com>
References: <20201201082730.24158-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

NVMe commands can come only after successful addition of rport and nvme
connect, and rport is only registered after FW started bit is set. Remove the
redundant check.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index b7a1dc24db38..d4159d5a4ffd 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -554,19 +554,15 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 
 	fcport = qla_rport->fcport;
 
-	if (!qpair || !fcport)
-		return -ENODEV;
-
-	if (!qpair->fw_started || fcport->deleted)
+	if (unlikely(!qpair || !fcport || fcport->deleted))
 		return -EBUSY;
 
-	vha = fcport->vha;
-
 	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
 		return -ENODEV;
 
-	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-	    (qpair && !qpair->fw_started) || fcport->deleted)
+	vha = fcport->vha;
+
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		return -EBUSY;
 
 	/*
-- 
2.19.0.rc0

