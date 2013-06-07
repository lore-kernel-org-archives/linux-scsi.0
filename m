From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/9] target: Avoid extra t_state_lock access in __target_execute_cmd
Date: Fri,  7 Jun 2013 21:34:19 +0000
Message-ID: <1370640864-15568-5-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48599 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3FGVry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:47:54 -0400
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch makes target_execute_cmd() set CMD_T_BUSY|CMD_T_SENT while
holding se_cmd->t_state_lock, in order to avoid the extra aquire/release
in __target_execute_cmd().

It also clears these bits in case of a target_handle_task_attr()
failure.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index daa7aa8..f9e69f5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1579,10 +1579,6 @@ static void __target_execute_cmd(struct se_cmd *cmd)
 {
 	sense_reason_t ret;
 
-	spin_lock_irq(&cmd->t_state_lock);
-	cmd->transport_state |= (CMD_T_BUSY|CMD_T_SENT);
-	spin_unlock_irq(&cmd->t_state_lock);
-
 	if (cmd->execute_cmd) {
 		ret = cmd->execute_cmd(cmd);
 		if (ret) {
@@ -1689,11 +1685,17 @@ void target_execute_cmd(struct se_cmd *cmd)
 	}
 
 	cmd->t_state = TRANSPORT_PROCESSING;
-	cmd->transport_state |= CMD_T_ACTIVE;
+	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
-	if (!target_handle_task_attr(cmd))
-		__target_execute_cmd(cmd);
+	if (target_handle_task_attr(cmd)) {
+		spin_lock_irq(&cmd->t_state_lock);
+		cmd->transport_state &= ~CMD_T_BUSY|CMD_T_SENT;
+		spin_unlock_irq(&cmd->t_state_lock);
+		return;
+	}
+
+	__target_execute_cmd(cmd);
 }
 EXPORT_SYMBOL(target_execute_cmd);
 
-- 
1.7.2.5

