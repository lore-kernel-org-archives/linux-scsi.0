From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] target: Simplify command completion by removing CMD_T_FAILED flag
Date: Mon,  3 Feb 2014 14:08:26 -0800
Message-ID: <1391465306-26282-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:37319 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751114AbaBCWId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 17:08:33 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so7602668pab.18
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2014 14:08:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The CMD_T_FAILED flag is set used in one place to record the result of a
trivial test, and it is only tested once, few lines later.  We might as
well make the code simpler and easier to read by directly doing the test
of "success" where we want to use it.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c | 5 +----
 include/target/target_core_base.h      | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c50fd9f11aab..24b4f65d8777 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -669,9 +669,6 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		return;
 	}
 
-	if (!success)
-		cmd->transport_state |= CMD_T_FAILED;
-
 	/*
 	 * Check for case where an explicit ABORT_TASK has been received
 	 * and transport_wait_for_tasks() will be waiting for completion..
@@ -681,7 +678,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		complete(&cmd->t_transport_stop_comp);
 		return;
-	} else if (cmd->transport_state & CMD_T_FAILED) {
+	} else if (!success) {
 		INIT_WORK(&cmd->work, target_complete_failure_work);
 	} else {
 		INIT_WORK(&cmd->work, target_complete_ok_work);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c9c791209cd1..1772fadcff62 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -525,7 +525,6 @@ struct se_cmd {
 #define CMD_T_COMPLETE		(1 << 2)
 #define CMD_T_SENT		(1 << 4)
 #define CMD_T_STOP		(1 << 5)
-#define CMD_T_FAILED		(1 << 6)
 #define CMD_T_DEV_ACTIVE	(1 << 7)
 #define CMD_T_REQUEST_STOP	(1 << 8)
 #define CMD_T_BUSY		(1 << 9)
-- 
1.9.rc1

