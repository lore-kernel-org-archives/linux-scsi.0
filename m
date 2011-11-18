From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 07/14] qla2xxx: Return the correct value for a mailbox command if 82xx is in reset recovery.
Date: Fri, 18 Nov 2011 09:02:15 -0800
Message-ID: <1321635742-16426-8-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:5941 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758230Ab1KRRPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:40 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

We need to return QLA_FUNCTION_TIMEOUT immediately otherwise we mess up the
mailbox command state machine.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3b3cec9..f965a57 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -79,8 +79,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		mcp->mb[0] = MBS_LINK_DOWN_ERROR;
 		ql_log(ql_log_warn, base_vha, 0x1004,
 		    "FW hung = %d.\n", ha->flags.isp82xx_fw_hung);
-		rval = QLA_FUNCTION_FAILED;
-		goto premature_exit;
+		return QLA_FUNCTION_TIMEOUT;
 	}
 
 	/*
-- 
1.6.0.2


