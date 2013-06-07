From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/9] target: Drop unnecessary CMD_T_DEV_ACTIVE check from transport_lun_remove_cmd
Date: Fri,  7 Jun 2013 21:34:17 +0000
Message-ID: <1370640864-15568-3-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops an unnecessary acquire/release of se_cmd->t_state_lock within
transport_lun_remove_cmd() when checking CMD_T_DEV_ACTIVE for invoking
target_remove_from_state_list().

For all fast path completion cases, transport_lun_remove_cmd() is always
called ahead of transport_cmd_check_stop(), and since transport_cmd_check_stop()
is calling target_remove_from_state_list() when remove_from_lists=true,
the t_state_lock usage in transport_lun_remove_cmd() can safely be removed.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 15afa83..d062878 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -529,13 +529,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 	if (!lun)
 		return;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->transport_state & CMD_T_DEV_ACTIVE) {
-		cmd->transport_state &= ~CMD_T_DEV_ACTIVE;
-		target_remove_from_state_list(cmd);
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
 	spin_lock_irqsave(&lun->lun_cmd_lock, flags);
 	if (!list_empty(&cmd->se_lun_node))
 		list_del_init(&cmd->se_lun_node);
-- 
1.7.2.5
