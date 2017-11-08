From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/6] target: Fix QUEUE_FULL + SCSI task attribute handling
Date: Wed,  8 Nov 2017 04:31:47 +0000
Message-ID: <1510115512-15617-2-git-send-email-nab@linux-iscsi.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug during QUEUE_FULL where transport_complete_qf()
calls transport_complete_task_attr() after it's already been invoked
by target_complete_ok_work() or transport_generic_request_failure()
during initial completion, preceeding QUEUE_FULL.

This will result in se_device->simple_cmds, se_device->dev_cur_ordered_id
and/or se_device->dev_ordered_sync being updated multiple times for
a single se_cmd.

To address this bug, clear SCF_TASK_ATTR_SET after the first call
to transport_complete_task_attr(), and avoid updating SCSI task
attribute related counters for any subsequent calls.

Also, when a se_cmd is deferred due to ordered tags and executed
via target_restart_delayed_cmds(), set CMD_T_SENT before execution
matching what target_execute_cmd() does.

Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 473d652..c33d1e9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2011,6 +2011,8 @@ static void target_restart_delayed_cmds(struct se_device *dev)
 		list_del(&cmd->se_delayed_node);
 		spin_unlock(&dev->delayed_cmd_lock);
 
+		cmd->transport_state |= CMD_T_SENT;
+
 		__target_execute_cmd(cmd, true);
 
 		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
@@ -2046,6 +2048,8 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED\n",
 			 dev->dev_cur_ordered_id);
 	}
+	cmd->se_cmd_flags &= ~SCF_TASK_ATTR_SET;
+
 restart:
 	target_restart_delayed_cmds(dev);
 }
-- 
1.9.1
