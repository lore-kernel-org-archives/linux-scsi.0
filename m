From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] target: Fix transport_cmd_finish_abort queue removal bug
Date: Fri, 30 Sep 2011 04:55:10 +0000
Message-ID: <1317358511-10664-4-git-send-email-nab@linux-iscsi.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36592 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab1I3Ezf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2011 00:55:35 -0400
In-Reply-To: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in LUN_RESET operation with transport_cmd_finish_abort()
where transport_remove_cmd_from_queue() was incorrectly being called, causing
descriptors with t_state == TRANSPORT_FREE_CMD_INTR to be incorrectly removed
from qobj->qobj_list during process context release.  This change ensures the
descriptor is only removed via transport_remove_cmd_from_queue() when doing a
direct release via transport_generic_remove().

Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
---
 drivers/target/target_core_transport.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86470b7..33fcb6f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -597,13 +597,14 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 	transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
-	if (remove)
+	if (remove) {
+		transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
 		transport_generic_remove(cmd, 0);
+	}
 }
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
-- 
1.7.2.5

