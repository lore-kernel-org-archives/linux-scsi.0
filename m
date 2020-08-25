Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F76C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA522076C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SCNi4Hf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgHYGrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 02:47:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18648 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729076AbgHYGrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 02:47:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P6Tssr009624
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:47:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=N08kTSTpe6UPbMBwLn2rVY/IaBQ77YYttqAyukfrC/4=;
 b=SCNi4Hf8/6tNE/6W9EvZhSyruqTAkIz+IQMbTKekP7Yc+bOOGREvAwPf8aaBBJf2HEmG
 L2vlbq6aQQLDfgmnuOkE2R3caISTtkhiN7055ZSFI35ovflEcLcEseQgvjfp0vayUtyK
 ZFZ913gNsj4S2C43QMWwld1utFZZJPQda1ixXmXDvhhpkD3TU2iv6RxQRoxV8b1VgOJC
 dpUMvslhbt6p9KdhfkVhS+gmVIK+URaMGaUHVFMMnsmsjn5Xd/fMjocg6aJuponkMvMa
 0b2LllOiX2OTs7oW8Ep6Z2kHj4c850z+yZC4iqPX9gAA8XrUtwSHKEXCM+P1C6uSNTRz qQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vmtc64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:47:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 23:47:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 Aug 2020 23:47:07 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5B38D3F7045;
        Mon, 24 Aug 2020 23:47:07 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07P6l7UH016450;
        Mon, 24 Aug 2020 23:47:07 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07P6l76Q016449;
        Mon, 24 Aug 2020 23:47:07 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 7/8] qedf: Retry qed->probe during recovery.
Date:   Mon, 24 Aug 2020 23:43:53 -0700
Message-ID: <20200825064354.16361-8-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200825064354.16361-1-jhasan@marvell.com>
References: <20200825064354.16361-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

During recovery due to fcoe fn ramrod failure, we
wait for 2 sec and then call qed->probe, if probe
fails then re-try max 10 times.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3a45ca7..091cf86 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3245,11 +3245,16 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	void *task_start, *task_end;
 	struct qed_slowpath_params slowpath_params;
 	struct qed_probe_params qed_params;
+	u16 retry_cnt = 10;
 
 	/*
 	 * When doing error recovery we didn't reap the lport so don't try
 	 * to reallocate it.
 	 */
+retry_probe:
+	if (mode == QEDF_MODE_RECOVERY)
+		msleep(2000);
+
 	if (mode != QEDF_MODE_RECOVERY) {
 		lport = libfc_host_alloc(&qedf_host_template,
 		    sizeof(struct qedf_ctx));
@@ -3336,6 +3341,12 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	qed_params.is_vf = is_vf;
 	qedf->cdev = qed_ops->common->probe(pdev, &qed_params);
 	if (!qedf->cdev) {
+		if ((mode == QEDF_MODE_RECOVERY) && retry_cnt) {
+			QEDF_ERR(&qedf->dbg_ctx,
+				"Retry %d initialize hardware\n", retry_cnt);
+			retry_cnt--;
+			goto retry_probe;
+		}
 		QEDF_ERR(&qedf->dbg_ctx, "common probe failed.\n");
 		rc = -ENODEV;
 		goto err1;
-- 
1.8.3.1

