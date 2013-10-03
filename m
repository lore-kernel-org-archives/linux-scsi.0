From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/3] iscsi-target: Only perform wait_for_tasks when performing shutdown
Date: Thu,  3 Oct 2013 21:01:10 +0000
Message-ID: <1380834072-25309-2-git-send-email-nab@daterainc.com>
References: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41787 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3JCVS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2013 17:18:29 -0400
Received: by mail-oa0-f49.google.com with SMTP id i4so2907660oah.8
        for <linux-scsi@vger.kernel.org>; Thu, 03 Oct 2013 14:18:29 -0700 (PDT)
In-Reply-To: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes transport_generic_free_cmd() to only wait_for_tasks
when shutdown=true is passed to iscsit_free_cmd().

With the advent of >= v3.10 iscsi-target code using se_cmd->cmd_kref,
the extra wait_for_tasks with shutdown=false is unnecessary, and may
end up causing an extra context switch when releasing WRITEs.

Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index f2de28e..b0cac0c 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -736,7 +736,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 		 * Fallthrough
 		 */
 	case ISCSI_OP_SCSI_TMFUNC:
-		rc = transport_generic_free_cmd(&cmd->se_cmd, 1);
+		rc = transport_generic_free_cmd(&cmd->se_cmd, shutdown);
 		if (!rc && shutdown && se_cmd && se_cmd->se_sess) {
 			__iscsit_free_cmd(cmd, true, shutdown);
 			target_put_sess_cmd(se_cmd->se_sess, se_cmd);
@@ -752,7 +752,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 			se_cmd = &cmd->se_cmd;
 			__iscsit_free_cmd(cmd, true, shutdown);
 
-			rc = transport_generic_free_cmd(&cmd->se_cmd, 1);
+			rc = transport_generic_free_cmd(&cmd->se_cmd, shutdown);
 			if (!rc && shutdown && se_cmd->se_sess) {
 				__iscsit_free_cmd(cmd, true, shutdown);
 				target_put_sess_cmd(se_cmd->se_sess, se_cmd);
-- 
1.7.10.4

