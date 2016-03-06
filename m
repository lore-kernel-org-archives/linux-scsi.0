From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Drop incorrect ABORT_TASK put for completed commands
Date: Sun,  6 Mar 2016 04:19:24 +0000
Message-ID: <1457237964-3536-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a recent ABORT_TASK regression associated
with commit febe562c, where a left-over target_put_sess_cmd()
would still be called when __target_check_io_state() detected
a command has already been completed, and explicit ABORT must
be avoided.

Note commit febe562c dropped the local kref_get_unless_zero()
check in core_tmr_abort_task(), but did not drop this extra
corresponding target_put_sess_cmd() in the failure path.

So go ahead and drop this now bogus target_put_sess_cmd(),
and avoid this potential use-after-free.

Reported-by: Dan Lane <dracodan@gmail.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 82a663b..4f229e7 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -177,7 +177,6 @@ void core_tmr_abort_task(
 
 		if (!__target_check_io_state(se_cmd, se_sess, 0)) {
 			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-			target_put_sess_cmd(se_cmd);
 			goto out;
 		}
 		list_del_init(&se_cmd->se_cmd_list);
-- 
1.9.1
