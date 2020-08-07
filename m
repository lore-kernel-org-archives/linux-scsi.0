Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665C0C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF5E21744
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="OW0H65Io"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgHGLnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:43:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHGLnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:43:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077AoDXH009460
        for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2020 04:07:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=8GkOwEejP+caaAPh5n9wDVGPztdnEXLd61IMOULuKm8=;
 b=OW0H65Io8WSzbqXvsQ44jAw3CSohkEMZX+ct5KBLjpm8hts5OP9+RluJrogYouRvAbfX
 ciqewB1JBaXkhSLxXkpZSbpugc2kBiVSiOWogGbp6a4ZbjTdiw+g18Yz2bz14WIy3J9G
 RPMbAjf6GAxbyCn5EPU/1aQdYmccIOc92lSIJZveMXEr5amaqfM/DbDDJxdWqpH4SP0X
 1+dK+3grEb7pr0V5PFMCyqiBZ9DaS0kYiJuiIUIj5886/XPfVcmRYkYzvEPBcfuGXBMf
 0lG1qO24IzYnyWkemblfCMWdfrbBdrU90Uc9prsUIpChtDxdXcfZ7sFawL1M+LyLCu2N 9g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32s3c98g8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:07:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:07:45 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:07:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 04:07:45 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C21AD3F703F;
        Fri,  7 Aug 2020 04:07:44 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 077B7ieq020012;
        Fri, 7 Aug 2020 04:07:44 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 077B7id1020003;
        Fri, 7 Aug 2020 04:07:44 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/7] qedf: Check for port type and role before processing an event.
Date:   Fri, 7 Aug 2020 04:06:50 -0700
Message-ID: <20200807110656.19965-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200807110656.19965-1-jhasan@marvell.com>
References: <20200807110656.19965-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_06:2020-08-06,2020-08-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 The rport lock get initialized during offload. If the no FCP or
 non target rport got logout then this rport will be uninitiazed.
 Kasan was complaining because of it.
=========
[   14.384434] the code is fine but needs lockdep annotation.
[   14.384482] turning off the locking correctness validator.
========

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 47fc14f..86b9479 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1536,6 +1536,17 @@ static void qedf_rport_event_handler(struct fc_lport *lport,
 		if (port_id == FC_FID_DIR_SERV)
 			break;
 
+		if (rdata->spp_type != FC_TYPE_FCP) {
+			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
+			    "No action since spp type isn't FCP\n");
+			break;
+		}
+		if (!(rdata->ids.roles & FC_RPORT_ROLE_FCP_TARGET)) {
+			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
+			    "Not FCP target so no action\n");
+			break;
+		}
+
 		if (!rport) {
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
 			    "port_id=%x - rport notcreated Yet!!\n", port_id);
-- 
1.8.3.1

