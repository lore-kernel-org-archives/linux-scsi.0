From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/6] target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK
Date: Wed,  8 Nov 2017 04:31:50 +0000
Message-ID: <1510115512-15617-5-git-send-email-nab@linux-iscsi.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54052 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdKHEVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 23:21:40 -0500
In-Reply-To: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Donald White <dew@datera.io>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes bug where early se_cmd exceptions that occur
before backend execution can result in use-after-free if/when
a subsequent ABORT_TASK occurs for the same tag.

Since an early se_cmd exception will have had se_cmd added to
se_session->sess_cmd_list via target_get_sess_cmd(), it will
not have CMD_T_COMPLETE set by the usual target_complete_cmd()
backend completion path.

This causes a subsequent ABORT_TASK + __target_check_io_state()
to signal ABORT_TASK should proceed.  As core_tmr_abort_task()
executes, it will bring the outstanding se_cmd->cmd_kref count
down to zero releasing se_cmd, after se_cmd has already been
queued with error status into fabric driver response path code.

To address this bug, introduce a CMD_T_PRE_EXECUTE bit that is
set at target_get_sess_cmd() time, and cleared immediately before
backend driver dispatch in target_execute_cmd() once CMD_T_ACTIVE
is set.

Then, check CMD_T_PRE_EXECUTE within __target_check_io_state() to
determine when an early exception has occured, and avoid aborting
this se_cmd since it will have already been queued into fabric
driver response path code.

Reported-by: Donald White <dew@datera.io>
Cc: Donald White <dew@datera.io>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       | 9 +++++++++
 drivers/target/target_core_transport.c | 2 ++
 include/target/target_core_base.h      | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 61909b2..9c7bc1c 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -133,6 +133,15 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
 	}
+	if (se_cmd->transport_state & CMD_T_PRE_EXECUTE) {
+		if (se_cmd->scsi_status) {
+			pr_debug("Attempted to abort io tag: %llu early failure"
+				 " status: 0x%02x\n", se_cmd->tag,
+				 se_cmd->scsi_status);
+			spin_unlock(&se_cmd->t_state_lock);
+			return false;
+		}
+	}
 	if (sess->sess_tearing_down || se_cmd->cmd_wait_set) {
 		pr_debug("Attempted to abort io tag: %llu already shutdown,"
 			" skipping\n", se_cmd->tag);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0e89db8..58caacd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1975,6 +1975,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 	}
 
 	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->transport_state &= ~CMD_T_PRE_EXECUTE;
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
@@ -2667,6 +2668,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		ret = -ESHUTDOWN;
 		goto out;
 	}
+	se_cmd->transport_state |= CMD_T_PRE_EXECUTE;
 	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
 out:
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d3139a9..ccf501b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -490,6 +490,7 @@ struct se_cmd {
 #define CMD_T_STOP		(1 << 5)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
+#define CMD_T_PRE_EXECUTE	(1 << 12)
 	spinlock_t		t_state_lock;
 	struct kref		cmd_kref;
 	struct completion	t_transport_stop_comp;
-- 
1.9.1
