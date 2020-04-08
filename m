Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EF4C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A5F12072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 06:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GFDNSRgz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDHGns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 02:43:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57214 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbgDHGns (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 02:43:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0386f87D025980;
        Tue, 7 Apr 2020 23:43:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=dKamY4f+QbonkgYJI4Smw78MQqd3FSDmPp3fPgTwR5A=;
 b=GFDNSRgzCsOcrjx13hXO3J65yjxRGbIp1CTQjcI63wranpdKUBASjOmsTfXI1aYpGupl
 JcVUYkodOT1h7HMaPoy5iQVYchFVzUl/h4vKwzBXpc0LIZMiCYyrGgcJqznasIYTfVFU
 nmzUG3ELU5notSrJb9fkFIs9blkMFix43qZYaYLO7wxlat5AGGUEOodUbY9SfmV7nBif
 MI2eva4t+UEHIplZD71SOY/LFvlAyKTDHRKoG60gwiNgpAzLkygdiULr8HymlzdSIRgF
 mjpl0foc/skVWVwiETVREWTsTW++VFojiKvwKeq9kY5zVlMcNadYG3+K0xdBgPrQQFrm nA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me1yjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 23:43:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 23:43:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 23:43:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Apr 2020 23:43:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AF8E53F7040;
        Tue,  7 Apr 2020 23:43:39 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0386hdRW019420;
        Tue, 7 Apr 2020 23:43:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0386hdTM019419;
        Tue, 7 Apr 2020 23:43:39 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/6] qedi: Avoid unnecessary endpoint allocation on link down
Date:   Tue, 7 Apr 2020 23:43:28 -0700
Message-ID: <20200408064332.19377-3-mrangankar@marvell.com>
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

No need to allocate and deallocate endpoint memory,
if the physical link is down.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 1f4a5fb..26b1151 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -836,6 +836,11 @@ static int qedi_task_xmit(struct iscsi_task *task)
 		return ERR_PTR(ret);
 	}
 
+	if (atomic_read(&qedi->link_state) != QEDI_LINK_UP) {
+		QEDI_WARN(&qedi->dbg_ctx, "qedi link down\n");
+		return ERR_PTR(-ENXIO);
+	}
+
 	ep = iscsi_create_endpoint(sizeof(struct qedi_endpoint));
 	if (!ep) {
 		QEDI_ERR(&qedi->dbg_ctx, "endpoint create fail\n");
@@ -870,12 +875,6 @@ static int qedi_task_xmit(struct iscsi_task *task)
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid endpoint\n");
 	}
 
-	if (atomic_read(&qedi->link_state) != QEDI_LINK_UP) {
-		QEDI_WARN(&qedi->dbg_ctx, "qedi link down\n");
-		ret = -ENXIO;
-		goto ep_conn_exit;
-	}
-
 	ret = qedi_alloc_sq(qedi, qedi_ep);
 	if (ret)
 		goto ep_conn_exit;
-- 
1.8.3.1

