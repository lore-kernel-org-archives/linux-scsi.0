From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 04/15] target: Move cmd->prot_op check into target_check_write_prot
Date: Mon, 30 Mar 2015 03:28:13 +0000
Message-ID: <1427686104-14231-5-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35688 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbbC3D30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2015 23:29:26 -0400
Received: by obcjt1 with SMTP id jt1so110298403obc.2
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2015 20:29:26 -0700 (PDT)
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

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
index aef989e..6a24151 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1738,6 +1738,25 @@ void __target_execute_cmd(struct se_cmd *cmd)
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
@@ -1817,15 +1836,9 @@ void target_execute_cmd(struct se_cmd *cmd)
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

