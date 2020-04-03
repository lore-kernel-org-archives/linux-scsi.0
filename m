Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A7CC2BA18
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 12:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0079820721
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 12:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MSZDoL8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403896AbgDCMKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:10:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6052 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728175AbgDCMKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 08:10:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033C0Fo1011752;
        Fri, 3 Apr 2020 05:10:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=zM4RrSO2DvizfKXmC6pIIS8Jn6nIkU2uKlXMEB2FSnE=;
 b=MSZDoL8SlncRT5FlwKrp/jDWpDnwBxl6JiT79XyL0R9DhWuGNr4zsnQ7XXDxzN1l/D8v
 mmlqik2eLfF4Zmv+nnTxFp75ifL77tmgFvBANhwUCtoogke4Ww0eCc4RGv4G7RtQTym7
 bCKOjKhBSdGu8eWGtAbDuCBdV1V3v7jMv+qbXonID+YHe5kPZXjnudpb2pBmIt3KCHwy
 aeCZQQSAAWb71sFEMJa4H6EXMGT2EbPYY4s2fbmnjCX7fhZGKeoncGQicwyfIltwiNWR
 Ck9D02oFsla+uEE0ffLMZ+kM9Ce+eOsJ6RiDohG8LX7R6TsDdAPzfjJOnXkJXHx/rTTe Bg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 304855xgsm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Apr 2020 05:10:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 05:10:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 05:10:10 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8D74A3F7043;
        Fri,  3 Apr 2020 05:10:10 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 033CAAhN002562;
        Fri, 3 Apr 2020 05:10:10 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 033CAAZh002561;
        Fri, 3 Apr 2020 05:10:10 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 4/7] qedf: Implement callback for bw_update.
Date:   Fri, 3 Apr 2020 05:09:54 -0700
Message-ID: <20200403120957.2431-5-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200403120957.2431-1-skashyap@marvell.com>
References: <20200403120957.2431-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_07:2020-04-02,2020-04-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is extension of bw common callback provided by qed.
This is called whenever there is a change in the BW.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ee468102..ba66216 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -509,6 +509,32 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
 }
 
+static void qedf_bw_update(void *dev)
+{
+	struct qedf_ctx *qedf = (struct qedf_ctx *)dev;
+	struct qed_link_output link;
+
+	/* Get the latest status of the link */
+	qed_ops->common->get_link(qedf->cdev, &link);
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Ignore link update, driver getting unload.\n");
+		return;
+	}
+
+	if (link.link_up) {
+		if (atomic_read(&qedf->link_state) == QEDF_LINK_UP)
+			qedf_update_link_speed(qedf, &link);
+		else
+			QEDF_ERR(&qedf->dbg_ctx,
+				 "Ignore bw update, link is down.\n");
+
+	} else {
+		QEDF_ERR(&qedf->dbg_ctx, "link_up is not set.\n");
+	}
+}
+
 static void qedf_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedf_ctx *qedf = (struct qedf_ctx *)dev;
@@ -635,6 +661,7 @@ static u32 qedf_get_login_failures(void *cookie)
 static struct qed_fcoe_cb_ops qedf_cb_ops = {
 	{
 		.link_update = qedf_link_update,
+		.bw_update = qedf_bw_update,
 		.dcbx_aen = qedf_dcbx_handler,
 		.get_generic_tlv_data = qedf_get_generic_tlv_data,
 		.get_protocol_tlv_data = qedf_get_protocol_tlv_data,
-- 
1.8.3.1

