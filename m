Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5013BC2D0EC
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 06:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246DE206E6
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 06:31:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="qbOzf/Zr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgC3GbA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 02:31:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37396 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729313AbgC3Ga7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 02:30:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6PQVq016787;
        Sun, 29 Mar 2020 23:30:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=3W7fmIESO+zeoLpMX7W0/8ICR/yIecO5/iPxgZfqtXs=;
 b=qbOzf/ZriTz8UdWuHzG1WMjf/cO6+OomyXjeQQWfxA7mF/eT8Ce+C42oHj3KyRiTZOpz
 ozpmaGlGE6mBwQvegV5Pa8ey9142/TnYpC8aZunxkRHtC2D3ji3rupGLw+OOazPZu2ki
 aF9YV/YxNBB6MaNYnCPbEzGNuVcmuECd8kugOuQh8iULi2SzYLqyW7UMa2x5hAFLOs8n
 Fei8+vpkN6A8aFXhqcr+GATfGIo97Povzwk4Knl1eeo6lqg6IoxzDBc19D0uUOoI1v/u
 b+6QHVspNDR89KvZJFSh+Fg24k9aBpibbjCRevCQSBIExEjtGQwHaKSzeEab1K4I047p aw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xnwdb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:30:58 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:57 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:30:57 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 475573F703F;
        Sun, 29 Mar 2020 23:30:57 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6UvdS027372;
        Sun, 29 Mar 2020 23:30:57 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6UvD2027371;
        Sun, 29 Mar 2020 23:30:57 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 7/8] qedf: Get dev info after updating the params.
Date:   Sun, 29 Mar 2020 23:30:33 -0700
Message-ID: <20200330063034.27309-8-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
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
index 52673b4..dc5ac55 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3332,6 +3332,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
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

