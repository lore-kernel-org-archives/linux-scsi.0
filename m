From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 04/11] qla2xxx: Clear options-flags while issuing stop-firmware mbx command.
Date: Thu, 9 Feb 2012 11:14:06 -0800
Message-ID: <1328814853-21764-5-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:31226
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758380Ab2BITaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:30 -0500
Received: from mail16-ch1 (localhost [127.0.0.1])	by mail16-ch1-R.bigfish.com
 (Postfix) with ESMTP id C42512004DF	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:29 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Not clearing the options flags in mbx1 could lead the firmware
into interpreting old data in mbx1 through mbx8.  This could
lead to inadvertent DMA read/write operations to stale memory.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 34344d3..8635722 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2581,7 +2581,8 @@ qla2x00_stop_firmware(scsi_qla_host_t *vha)
 	ql_dbg(ql_dbg_mbx, vha, 0x10a1, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_STOP_FIRMWARE;
-	mcp->out_mb = MBX_0;
+	mcp->mb[1] = 0;
+	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
 	mcp->tov = 5;
 	mcp->flags = 0;
-- 
1.6.0.2


