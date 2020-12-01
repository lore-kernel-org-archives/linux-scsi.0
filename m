Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A92C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED118206E3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Jv6FzVqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgLAI3Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:29:25 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33448 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgLAI3Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:29:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18L16g027368
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:28:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1JNBdxo7GpwrJ6Za6f09tknSz33BAUPT/UT7ZR6Lsos=;
 b=Jv6FzVqhbveAL6W5mpN7x6zoMcPJcWoz+u7NJj+3mQhx/lVlzIib3KQKcheuGnB2puTJ
 KIVjC7LaueQYOxj/0FcbVTZj77c0cckEuz0RlV/FfD+IXDedIR6tK91saWhw1F0HbOR1
 RP9EHllcFRLcyvC1MqRmSYl1NJjw7fJZRM+fYDXyLY0mRTto7qHl0yM0pzUqy9JjWx8x
 80VrNjXEUlYPke6Pvl2UlslG+ZPCFu0Ru5WQ0Wri6BJmtYtTyzPjvwdjpQVAOu3QrDBC
 vluMfDxgx76UkEO89PhmZm1vqzxISkbXzIodRnLlxqt1qNu9dp/MwMd7DFONM6/B+umn VA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 353mssfkku-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:28:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:28:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:28:43 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5C7D53F703F;
        Tue,  1 Dec 2020 00:28:43 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18Shdl024217;
        Tue, 1 Dec 2020 00:28:43 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18Sh2t024208;
        Tue, 1 Dec 2020 00:28:43 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/15] qla2xxx: Change post del message from debug level to log level
Date:   Tue, 1 Dec 2020 00:27:17 -0800
Message-ID: <20201201082730.24158-3-njavali@marvell.com>
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

Change the message debug level.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.19.0.rc0

