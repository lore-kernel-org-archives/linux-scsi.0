From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 068/103] target: remove the unused SCF_SE_DISABLE_ONLINE_CHECK flag
Date: Thu, 21 Jul 2011 00:11:51 -0700
Message-ID: <1311232346-6674-69-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:38999 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752228Ab1GUHHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:07 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

From: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   12 +++++-------
 include/target/target_core_base.h      |    1 -
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e3544c8..bd97c6a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2431,14 +2431,12 @@ static int transport_execute_tasks(struct se_cmd *cmd)
 {
 	int add_tasks;
 
-	if (!(cmd->se_cmd_flags & SCF_SE_DISABLE_ONLINE_CHECK)) {
-		if (se_dev_check_online(cmd->se_orig_obj_ptr) != 0) {
-			cmd->transport_error_status =
-				PYX_TRANSPORT_LU_COMM_FAILURE;
-			transport_generic_request_failure(cmd, NULL, 0, 1);
-			return 0;
-		}
+	if (se_dev_check_online(cmd->se_orig_obj_ptr) != 0) {
+		cmd->transport_error_status = PYX_TRANSPORT_LU_COMM_FAILURE;
+		transport_generic_request_failure(cmd, NULL, 0, 1);
+		return 0;
 	}
+
 	/*
 	 * Call transport_cmd_check_stop() to see if a fabric exception
 	 * has occurred that prevents execution.
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 71c96ce..bfcf4c2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -116,7 +116,6 @@ enum se_cmd_flags_table {
 	SCF_SE_CMD_FAILED		= 0x00000400,
 	SCF_SE_LUN_CMD			= 0x00000800,
 	SCF_SE_ALLOW_EOO		= 0x00001000,
-	SCF_SE_DISABLE_ONLINE_CHECK	= 0x00002000,
 	SCF_SENT_CHECK_CONDITION	= 0x00004000,
 	SCF_OVERFLOW_BIT		= 0x00008000,
 	SCF_UNDERFLOW_BIT		= 0x00010000,
-- 
1.7.6

