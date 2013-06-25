From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 05/16] qla2xxx: Do not take a second firmware dump when intentionally generating one.
Date: Tue, 25 Jun 2013 11:27:20 -0400
Message-ID: <1372174051-4211-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:58159
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab3FYPx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:56 -0400
Received: from mail157-co9 (localhost [127.0.0.1])	by
 mail157-co9-R.bigfish.com (Postfix) with ESMTP id 947D13C0153	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:55 +0000 (UTC)
Received: from CO9EHSMHS026.bigfish.com (unknown [10.236.132.235])	by
 mail157-co9.bigfish.com (Postfix) with ESMTP id 6B6E9120069	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:50 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

When we are intentionally generating a firmware dump by executing the
MBC_GEN_SYSTEM_ERROR command, the command actually times out. The normal
course of action when a mailbox command times out is to take a firmware dump.
However, in this special case we do not want to do this since the
MBA_SYSTEM_ERR AEN already generates a firmware dump.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 144effd..7257c3c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -281,9 +281,11 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 		/*
 		 * Attempt to capture a firmware dump for further analysis
-		 * of the current firmware state
+		 * of the current firmware state.  We do not need to do this
+		 * if we are intentionally generating a dump.
 		 */
-		ha->isp_ops->fw_dump(vha, 0);
+		if (mcp->mb[0] != MBC_GEN_SYSTEM_ERROR)
+			ha->isp_ops->fw_dump(vha, 0);
 
 		rval = QLA_FUNCTION_TIMEOUT;
 	}
-- 
1.7.7


