Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5CBC43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 07:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080F02082D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 07:08:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="luQZi+Dm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCZHId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 03:08:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31586 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgCZHIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Mar 2020 03:08:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q710LH017933;
        Thu, 26 Mar 2020 00:08:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qHPq8rdK92ELKTaBex6dyt4dM2hWopqM5W+p4Cu48QM=;
 b=luQZi+DmoL9Z64ZviRdCrtRXlxlREtcy52M21Ha/wE20fbz9bKxd4PDtcreG5MbP3JR9
 e2ZnQgXafryIo66CMDSHIK2/QC0/w+JIq6TXF8WYNRvCmmWAXRCng0aFctWIZ/yHZakR
 NfXu8wEuLHEXNpUtOIIkYYOa48CVcLeMwUVKDL9Y1zMFZn2dBap21pfbccwG0M5ekw5A
 ZrjIaSxQU5GRUg1fmrGRVye1mCZz6v2QSFTyLcJFciW6HzOIULP8sf+q5OSZgSkDcAXE
 uw8qPepmVNggwCEB6r0THtKZxxuOzJubhL9bdWc42kutkZSUXDRuyuy6DVkznO72hXlV nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpctndq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 00:08:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:30 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:29 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 00:08:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0A2493F703F;
        Thu, 26 Mar 2020 00:08:29 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02Q78SAj025556;
        Thu, 26 Mar 2020 00:08:28 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02Q78S8X025555;
        Thu, 26 Mar 2020 00:08:28 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 7/8] qedf: Get dev info after updating the params.
Date:   Thu, 26 Mar 2020 00:08:05 -0700
Message-ID: <20200326070806.25493-8-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200326070806.25493-1-skashyap@marvell.com>
References: <20200326070806.25493-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Get the dev info after updating the params.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index bbad015..49e6d12 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3330,6 +3330,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 	qed_ops->common->update_pf_params(qedf->cdev, &qedf->pf_params);
 
+	/* Learn information crucial for qedf to progress */
+	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
+	if (rc) {
+		QEDF_ERR(&qedf->dbg_ctx, "Failed to dev info.\n");
+		goto err2;
+	}
+
 	/* Record BDQ producer doorbell addresses */
 	qedf->bdq_primary_prod = qedf->dev_info.primary_dbq_rq_addr;
 	qedf->bdq_secondary_prod = qedf->dev_info.secondary_bdq_rq_addr;
-- 
1.8.3.1

