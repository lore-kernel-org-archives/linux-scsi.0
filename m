Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B99C2BB85
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46BE320771
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="yCZln6z7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503435AbgDPJEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 05:04:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502682AbgDPIos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 04:44:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8dtGr020179;
        Thu, 16 Apr 2020 01:43:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WzxkJ4o8LoGFpShMUF55K4KiIgtnqKK8d70wY8a0oyM=;
 b=yCZln6z714S5ydkCqnxoEG9D9OsIgdw0izIwbCLecq7vxLKHya5U6y8mX0RKShPEA3tP
 3Z0tfe5wau1M9L5xzmMAmPJvjfOsiHaH4X0RaCIhRmpwtvEeJicRM82oC4G9muZulEhV
 MOFdMXymTrhCNpmMNiMlUGXXRYCx5RzMnOSpuyCiY6i8J8oT6THsdvaAOUm6PpHdpQom
 HkcxLCCe3NElnohp4VJDMstzaXWlrijIdw6WsWZJpKST7M4yXJay9qSDugGoRRjmuxk3
 xlUAGVGdl+/qccm9yqZRecjxol8qY3zPlxHxYvT971vj1fQ9+f8wiYN7qZG9vdzRYNw5 LQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30dn84p7q7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BEBA83F7041;
        Thu, 16 Apr 2020 01:43:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hK7J018894;
        Thu, 16 Apr 2020 01:43:20 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hKCj018893;
        Thu, 16 Apr 2020 01:43:20 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 2/9] qedf: Increase the upper limit of retry delay.
Date:   Thu, 16 Apr 2020 01:43:07 -0700
Message-ID: <20200416084314.18851-3-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200416084314.18851-1-skashyap@marvell.com>
References: <20200416084314.18851-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_03:2020-04-14,2020-04-16 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

Max time to hold the IO in case of SAM_STAT_TASK_SET_FULL
or SAM_STAT_BUSY.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 042ebf6..aaa2ac9 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -470,7 +470,7 @@ static inline void qedf_stop_all_io(struct qedf_ctx *qedf)
 extern uint qedf_io_tracing;
 extern uint qedf_stop_io_on_error;
 extern uint qedf_link_down_tmo;
-#define QEDF_RETRY_DELAY_MAX		20 /* 2 seconds */
+#define QEDF_RETRY_DELAY_MAX		600 /* 60 seconds */
 extern bool qedf_retry_delay;
 extern uint qedf_debug;
 
-- 
1.8.3.1

