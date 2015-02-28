From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 4/9] target: Move cmd->prot_op check into target_check_write_prot
Date: Sat, 28 Feb 2015 10:36:01 +0000
Message-ID: <1425119766-11878-5-git-send-email-nab@daterainc.com>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38980 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbB1LKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 06:10:03 -0500
Received: by mail-ob0-f178.google.com with SMTP id uz6so23194418obc.9
        for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2015 03:10:02 -0800 (PST)
In-Reply-To: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the existing target_execute_cmd() check for
cmd->prot_op into it's own function, so it's easier to add
future support for WRITE STRIP.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 38d9d1b..a4d64d5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1714,6 +1714,25 @@ void __target_execute_cmd(struct se_cmd *cmd)
 	}
 }
 
+static int target_check_write_prot(struct se_cmd *cmd)
+{
+	/*
+	 * Perform WRITE_INSERT of PI using software emulation when backend
+	 * device has PI enabled, if the transport has not already generated
+	 * PI using hardware WRITE_INSERT offload.
+	 */
+	switch (cmd->prot_op) {
+	case TARGET_PROT_DOUT_INSERT:
+		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
+			sbc_dif_generate(cmd);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static bool target_handle_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
@@ -1793,15 +1812,9 @@ void target_execute_cmd(struct se_cmd *cmd)
 	cmd->t_state = TRANSPORT_PROCESSING;
 	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
-	/*
-	 * Perform WRITE_INSERT of PI using software emulation when backend
-	 * device has PI enabled, if the transport has not already generated
-	 * PI using hardware WRITE_INSERT offload.
-	 */
-	if (cmd->prot_op == TARGET_PROT_DOUT_INSERT) {
-		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
-			sbc_dif_generate(cmd);
-	}
+
+	if (target_check_write_prot(cmd))
+		return;
 
 	if (target_handle_task_attr(cmd)) {
 		spin_lock_irq(&cmd->t_state_lock);
-- 
1.9.1

