From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/5] target: Don't let abort handling free pending write commands too soon
Date: Wed,  2 Jan 2013 12:47:57 -0800
Message-ID: <1357159681-24477-2-git-send-email-roland@kernel.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:45354 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752696Ab3ABUsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2013 15:48:10 -0500
Received: by mail-vb0-f72.google.com with SMTP id b23so21856122vbz.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jan 2013 12:48:07 -0800 (PST)
In-Reply-To: <1357159681-24477-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

The following sequence happens for write commands (or any other
commands with a data out phase):

 - The transport calls target_submit_cmd(), which sets CMD_T_ACTIVE in
   cmd->transport_state and sets cmd->t_state to TRANSPORT_NEW_CMD.
 - Things go on transport_generic_new_cmd(), which notices that the
   command needs to transfer data, so it sets cmd->t_state to
   TRANSPORT_WRITE_PENDING and calls transport_cmd_check_stop().
 - transport_cmd_check_stop() clears CMD_T_ACTIVE in cmd->transport_state
   and returns in the normal case.
 - Then we continue on to call ->se_tfo->write_pending().
 - The data comes back from the initiator, and the transport calls
   target_execute_cmd(), which sets cmd->t_state to TRANSPORT_PROCESSING
   and calls into the backend to actually write the data.

At this point, the backend might take a long time to complete the
command, since it has to do real IO.  If an abort request comes in for
this command at this point, it will not wait for the command to finish
since CMD_T_ACTIVE is not set.  Then when the command does finally
finish, we blow up with use-after-free.

Avoid this by setting CMD_T_ACTIVE in target_execute_cmd() so that
transport_wait_for_tasks() waits for the command to finish executing.
This matches the behavior from before commit 1389533ef944 ("target:
remove transport_generic_handle_data"), when data was signaled via
transport_generic_handle_data(), which set CMD_T_ACTIVE because it
called transport_add_cmd_to_queue().

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c23c76c..1dd9d66 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1688,6 +1688,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 	}
 
 	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->transport_state |= CMD_T_ACTIVE;
 	spin_unlock_irq(&cmd->t_state_lock);
 
 	if (!target_handle_task_attr(cmd))
-- 
1.8.0

