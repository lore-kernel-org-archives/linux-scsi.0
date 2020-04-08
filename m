Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE0CC2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 936612072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="nMLf4PmE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDHGoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 02:44:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27470 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbgDHGoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 02:44:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0386f87G025980;
        Tue, 7 Apr 2020 23:44:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=oOgwQYFH4kqaGAdkSIBMYKGs+7G/KTQXPe2ITpmkVcI=;
 b=nMLf4PmEHpGpp6JpA3TSZLxwVwsf4nKduwyVvqstA8vV9bb7ZdVVyyyQWpGHYgWFHzTP
 SO2QsEll9kAejQZygg1JO+U3VhQ8Lo+HrLX/PaU0GGE94mCvR+8kVoblf+Yi2zXXbDcU
 is52C3EUgVbGkNp+LTF/ouh3I62gD2OeYJ7Q7vVyI8SjeZZoSLgYvCheJ4K8fWooEo1Z
 gzxFVdBvilD3fTTzs4Lqi7Axzis8BKhdzPGExN1ENroLsfzAmoAD7qOelVLGk7LUUq6y
 /1rACPVGoQ4dxAK15wTUAkfI5VdIM63ODiymB1VDo5pE9UaRqFumbMfzGiL8AedgK2Y7 Jw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me1yk1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 23:44:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 23:43:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Apr 2020 23:43:49 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 47C123F703F;
        Tue,  7 Apr 2020 23:43:49 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0386hn6R019432;
        Tue, 7 Apr 2020 23:43:49 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0386hnnh019431;
        Tue, 7 Apr 2020 23:43:49 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 5/6] qedi: Add modules param to enable qed iSCSI debug.
Date:   Tue, 7 Apr 2020 23:43:31 -0700
Message-ID: <20200408064332.19377-6-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200408064332.19377-1-mrangankar@marvell.com>
References: <20200408064332.19377-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add module parameter support to enable debug message
specific to iSCSI functions.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f1d998c..b9a5c84 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -28,6 +28,10 @@
 #include "qedi_gbl.h"
 #include "qedi_iscsi.h"
 
+static uint qedi_qed_debug;
+module_param(qedi_qed_debug, uint, 0644);
+MODULE_PARM_DESC(qedi_qed_debug, " QED debug level 0 (default)");
+
 static uint qedi_fw_debug;
 module_param(qedi_fw_debug, uint, 0644);
 MODULE_PARM_DESC(qedi_fw_debug, " Firmware debug level 0(default) to 3");
@@ -2422,7 +2426,6 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi;
 	struct qed_ll2_params params;
-	u32 dp_module = 0;
 	u8 dp_level = 0;
 	bool is_vf = false;
 	char host_buf[16];
@@ -2445,7 +2448,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 
 	memset(&qed_params, 0, sizeof(qed_params));
 	qed_params.protocol = QED_PROTOCOL_ISCSI;
-	qed_params.dp_module = dp_module;
+	qed_params.dp_module = qedi_qed_debug;
 	qed_params.dp_level = dp_level;
 	qed_params.is_vf = is_vf;
 	qedi->cdev = qedi_ops->common->probe(pdev, &qed_params);
-- 
1.8.3.1

