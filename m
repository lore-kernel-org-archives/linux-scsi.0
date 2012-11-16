From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 3/4] target: Clean up logic in transport_put_cmd()
Date: Fri, 16 Nov 2012 08:06:18 -0800
Message-ID: <1353081979-29474-4-git-send-email-roland@kernel.org>
References: <1353081979-29474-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:51800 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751841Ab2KPQGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2012 11:06:30 -0500
Received: by mail-pb0-f70.google.com with SMTP id ro2so119465pbb.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Nov 2012 08:06:29 -0800 (PST)
In-Reply-To: <1353081979-29474-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

No need to have a goto where a return is clearer.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dcecbfb..0f29d70 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2183,9 +2183,10 @@ static void transport_put_cmd(struct se_cmd *cmd)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (atomic_read(&cmd->t_fe_count)) {
-		if (!atomic_dec_and_test(&cmd->t_fe_count))
-			goto out_busy;
+	if (atomic_read(&cmd->t_fe_count) &&
+	    !atomic_dec_and_test(&cmd->t_fe_count)) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		return;
 	}
 
 	if (cmd->transport_state & CMD_T_DEV_ACTIVE) {
@@ -2196,9 +2197,6 @@ static void transport_put_cmd(struct se_cmd *cmd)
 
 	transport_free_pages(cmd);
 	transport_release_cmd(cmd);
-	return;
-out_busy:
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
 /*
-- 
1.7.10.4

