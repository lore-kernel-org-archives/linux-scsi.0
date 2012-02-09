From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 21/29] qla2xxx: Perform firmware dump procedure on mailbox command timeout.
Date: Thu, 9 Feb 2012 11:15:53 -0800
Message-ID: <1328814961-21866-22-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:41066
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758407Ab2BITcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:12 -0500
Received: from mail124-ch1 (localhost [127.0.0.1])	by
 mail124-ch1-R.bigfish.com (Postfix) with ESMTP id B859C20209	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:11 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 957a4b8..adc2b14 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -277,6 +277,12 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		    "mb[0] = 0x%x.\n", mb0);
 		ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1019);
 
+		/*
+		 * Attempt to capture a firmware dump for further analysis
+		 * of the current firmware state
+		 */
+		ha->isp_ops->fw_dump(vha, 0);
+
 		rval = QLA_FUNCTION_TIMEOUT;
 	}
 
-- 
1.6.0.2


