Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02C0C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jan 2022 13:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiAQNyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:54:32 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236412AbiAQNyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Jan 2022 08:54:31 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20H9A3od014895;
        Mon, 17 Jan 2022 05:54:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=p5P6Ji1xDsiHUf8chQgWyDfigt70ybUMr3TtkgLBoHc=;
 b=a/fqxBPGxahr6sHFVXMzO8uEBh/h4grBKu9SAn79ZF2Qb39XuN1o2XEzf2Paf496qdoj
 +0toWKGeTNixZldzCEXgXoxNlJrXXlS+YN7th+Bvqf19Zhh5F0E3pQ2tRm7Dl1ik9Aw0
 JcU2lHXvuRg5u8rQgZGrbK7iiAqA0ymsj17Eb+he7upnkCdlZDv2po+w/I6y8n0t0LlS
 tYF85JzKSTlzrjmM2tc9TOP9432QYSxGHTy5K687KTaSe1MvNjfDbvS4r1V6tDJ12BH3
 lmCtiCU2MIGdroVhIUaeokF6WGAk+jqINQn6Qf73gOJWwOCFRdQ8a9Y/18BMwaIjyRDL Og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dn5gg8q1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 05:54:29 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 05:54:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 17 Jan 2022 05:54:27 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E40065B6921;
        Mon, 17 Jan 2022 05:54:27 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20HDsCXx006311;
        Mon, 17 Jan 2022 05:54:12 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20HDs7Dg006310;
        Mon, 17 Jan 2022 05:54:07 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <loberman@redhat.com>,
        <jpittman@redhat.com>, <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 3/3] qedf: Change context reset messages to ratelimited
Date:   Mon, 17 Jan 2022 05:53:11 -0800
Message-ID: <20220117135311.6256-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220117135311.6256-1-njavali@marvell.com>
References: <20220117135311.6256-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5Oa7YLxUC90MT-qSFLuM-twT2NV7bLTD
X-Proofpoint-GUID: 5Oa7YLxUC90MT-qSFLuM-twT2NV7bLTD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_06,2022-01-14_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

If FCoE is not configured, libfc/libfcoe keeps on retrying FLOGI and
after 3 retries driver does a context reset and tries fipvlan again.
This leads to context reset message flooding the logs. Hence
ratelimit the message to prevent flooding the logs.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3a5ce540cfc4..6ad28bc8e948 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -911,7 +911,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qed_link_output if_link;
 
 	if (lport->vport) {
-		QEDF_ERR(NULL, "Cannot issue host reset on NPIV port.\n");
+		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
 
@@ -3981,7 +3981,9 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
-	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
+	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
+			dev_name(&qedf->pdev->dev), __func__, __LINE__,
+			qedf->dbg_ctx.host_no);
 	qedf_ctx_soft_reset(qedf->lport);
 }
 
-- 
2.23.1

