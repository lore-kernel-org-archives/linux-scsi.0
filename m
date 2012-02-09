From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 10/11] qla2xxx: Proper detection of firmware abort error code for ISP82xx.
Date: Thu, 9 Feb 2012 11:14:12 -0800
Message-ID: <1328814853-21764-11-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:26547
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758378Ab2BITaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:30 -0500
Received: from mail13-ch1 (localhost [127.0.0.1])	by mail13-ch1-R.bigfish.com
 (Postfix) with ESMTP id CD7D34A0594	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:29 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index bb06c20..270ba31 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3379,7 +3379,7 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 					    QLA82XX_CRB_PEG_NET_3 + 0x3c),
 				    qla82xx_rd_32(ha,
 					    QLA82XX_CRB_PEG_NET_4 + 0x3c));
-				if (LSW(MSB(halt_status)) == 0x67)
+				if (((halt_status & 0x1fffff00) >> 8) == 0x67)
 					ql_log(ql_log_warn, vha, 0xb052,
 					    "Firmware aborted with "
 					    "error code 0x00006700. Device is "
-- 
1.6.0.2


