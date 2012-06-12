From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/2] qla2xxx: Don't leak commands we give up on in qlt_do_work()
Date: Mon, 11 Jun 2012 18:23:16 -0700
Message-ID: <1339464196-22744-2-git-send-email-roland@kernel.org>
References: <1339464196-22744-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1339464196-22744-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

If we go to the "out_term:" exit path in qlt_do_work(), we call
qlt_send_term_exchange() with a NULL cmd, which means that it can't
possibly free the cmd for us.  Add an explicit call to free the
command memory, so we don't leak the allocation.

This will also fix warnings about "BUG qla_tgt_cmd_cachep: Objects
remaining on kmem_cache_close" from slub when unloading the qla2xxx
target module.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c263f90..e912920 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2725,10 +2725,12 @@ static void qlt_do_work(struct work_struct *work)
 out_term:
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf020, "Terminating work cmd %p", cmd);
 	/*
-	 * cmd has not sent to target yet, so pass NULL as the second argument
+	 * cmd has not sent to target yet, so pass NULL as the second
+	 * argument to qlt_send_term_exchange() and free the memory here.
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
+	kmem_cache_free(qla_tgt_cmd_cachep, cmd);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
-- 
1.7.9.5
