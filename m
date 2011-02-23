From: madhu.iyengar@qlogic.com
Subject: [PATCH 06/13] qla2xxx: Don't wait for active mailbox command completion when firmware is hung.
Date: Wed, 23 Feb 2011 15:27:11 -0800
Message-ID: <1298503638-22396-7-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52622 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755079Ab1BWXaa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:30 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a7f7346..b4a82b5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -71,6 +71,13 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
+	if (ha->flags.isp82xx_fw_hung) {
+		/* Setting Link-Down error */
+		mcp->mb[0] = MBS_LINK_DOWN_ERROR;
+		rval = QLA_FUNCTION_FAILED;
+		goto premature_exit;
+	}
+
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
 	 * seconds. This is to serialize actual issuing of mailbox cmds during
@@ -83,13 +90,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
-	if (ha->flags.isp82xx_fw_hung) {
-		/* Setting Link-Down error */
-		mcp->mb[0] = MBS_LINK_DOWN_ERROR;
-		rval = QLA_FUNCTION_FAILED;
-		goto premature_exit;
-	}
-
 	ha->flags.mbox_busy = 1;
 	/* Save mailbox command for debug */
 	ha->mcp = mcp;
-- 
1.6.0.2

