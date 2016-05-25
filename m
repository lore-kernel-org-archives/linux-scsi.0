From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix missing complete during ABORT_TASK + CMD_T_FABRIC_STOP
Date: Wed, 25 May 2016 19:47:40 +0000
Message-ID: <1464205660-7171-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38471 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbcEYTsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2016 15:48:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

During transport_generic_free_cmd() with a concurrent TMR
ABORT_TASK and shutdown CMD_T_FABRIC_STOP bit set, the
caller will be blocked on se_cmd->cmd_wait_stop completion
until the final kref_put() -> target_release_cmd_kref()
has been invoked to call complete().

However, when ABORT_TASK is completed with FUNCTION_COMPLETE
in core_tmr_abort_task(), the aborted se_cmd will have already
been removed from se_sess->sess_cmd_list via list_del_init().

This results in target_release_cmd_kref() hitting the
legacy list_empty() == true check, invoking ->release_cmd()
but skipping complete() to wakeup se_cmd->cmd_wait_stop
blocked earlier in transport_generic_free_cmd() code.

To address this bug, it's safe to go ahead and drop the
original list_empty() check so that fabric_stop invokes
the complete() as expected, since list_del_init() can
safely be used on a empty list.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f3e93dd..019d34f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2578,12 +2578,6 @@ static void target_release_cmd_kref(struct kref *kref)
 	bool fabric_stop;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	if (list_empty(&se_cmd->se_cmd_list)) {
-		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-		target_free_cmd_mem(se_cmd);
-		se_cmd->se_tfo->release_cmd(se_cmd);
-		return;
-	}
 
 	spin_lock(&se_cmd->t_state_lock);
 	fabric_stop = (se_cmd->transport_state & CMD_T_FABRIC_STOP);
-- 
1.9.1

