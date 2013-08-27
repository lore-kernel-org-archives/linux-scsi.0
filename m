From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 23/29] qla2xxx: Select link initialization option bits from current operating mode.
Date: Tue, 27 Aug 2013 01:37:49 -0400
Message-ID: <1377581875-8574-24-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:5323 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab3H0GGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:53 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R65GY3019637
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690x3-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1261884..c825d1d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1667,7 +1667,11 @@ qla24xx_link_initialize(scsi_qla_host_t *vha)
 		return QLA_FUNCTION_FAILED;
 
 	mcp->mb[0] = MBC_LINK_INITIALIZATION;
-	mcp->mb[1] = BIT_6|BIT_4;
+	mcp->mb[1] = BIT_4;
+	if (vha->hw->operating_mode == LOOP)
+		mcp->mb[1] |= BIT_6;
+	else
+		mcp->mb[1] |= BIT_5;
 	mcp->mb[2] = 0;
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
-- 
1.7.7

