From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/6] target: Fix quiese during transport_write_pending_qf endless loop
Date: Wed,  8 Nov 2017 04:31:49 +0000
Message-ID: <1510115512-15617-4-git-send-email-nab@linux-iscsi.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Potnuri Bharat Teja <bharat@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a potential end-less loop during QUEUE_FULL,
where cmd->se_tfo->write_pending() callback fails repeatedly
but __transport_wait_for_tasks() has already been invoked to
quiese the outstanding se_cmd descriptor.

To address this bug, this patch adds a CMD_T_STOP|CMD_T_ABORTED
check within transport_write_pending_qf() and invokes the
existing se_cmd->t_transport_stop_comp to signal quiese
completion back to __transport_wait_for_tasks().

Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d02218c..0e89db8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2560,7 +2560,20 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 
 static void transport_write_pending_qf(struct se_cmd *cmd)
 {
+	unsigned long flags;
 	int ret;
+	bool stop;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	stop = (cmd->transport_state & (CMD_T_STOP | CMD_T_ABORTED));
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
+	if (stop) {
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
+			__func__, __LINE__, cmd->tag);
+		complete_all(&cmd->t_transport_stop_comp);
+		return;
+	}
 
 	ret = cmd->se_tfo->write_pending(cmd);
 	if (ret) {
-- 
1.9.1
