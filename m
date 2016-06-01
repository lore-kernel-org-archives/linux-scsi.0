From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/14] target: Add target_complete_ios wrapper
Date: Wed,  1 Jun 2016 21:48:37 +0000
Message-ID: <1464817727-9125-5-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a basic target_complete_ios() wrapper to
dereference struct se_cmd from struct target_iostate, and
invoke existing target_complete_cmd() code.

It also includes PSCSI + TCMU backend driver conversions.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c     | 4 ++--
 drivers/target/target_core_transport.c | 9 ++++++++-
 drivers/target/target_core_user.c      | 4 ++--
 include/target/target_core_backend.h   | 1 +
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 105894a..b5728bc 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1109,13 +1109,13 @@ static void pscsi_req_done(struct request *req, int uptodate)
 
 	switch (host_byte(pt->pscsi_result)) {
 	case DID_OK:
-		target_complete_cmd(cmd, cmd->scsi_status);
+		target_complete_ios(&cmd->t_iostate, cmd->scsi_status);
 		break;
 	default:
 		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", cmd, pt->pscsi_cdb[0],
 			pt->pscsi_result);
-		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
+		target_complete_ios(&cmd->t_iostate, SAM_STAT_CHECK_CONDITION);
 		break;
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 18661da..2207624 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -714,7 +714,6 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	cmd->scsi_status = scsi_status;
 
-
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	cmd->transport_state &= ~CMD_T_BUSY;
 
@@ -752,6 +751,14 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
+void target_complete_ios(struct target_iostate *ios, u16 scsi_status)
+{
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+
+	target_complete_cmd(cmd, scsi_status);
+}
+EXPORT_SYMBOL(target_complete_ios);
+
 void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
 {
 	if (scsi_status == SAM_STAT_GOOD && length < cmd->t_iostate.data_length) {
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index d6758a1..505b312 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -601,7 +601,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 			se_cmd->t_iostate.data_direction);
 	}
 
-	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
+	target_complete_ios(&cmd->se_cmd->t_iostate, entry->rsp.scsi_status);
 	cmd->se_cmd = NULL;
 
 	kmem_cache_free(tcmu_cmd_cache, cmd);
@@ -680,7 +680,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		return 0;
 
 	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
-	target_complete_cmd(cmd->se_cmd, SAM_STAT_CHECK_CONDITION);
+	target_complete_ios(&cmd->se_cmd->t_iostate, SAM_STAT_CHECK_CONDITION);
 	cmd->se_cmd = NULL;
 
 	kmem_cache_free(tcmu_cmd_cache, cmd);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index d8ab510..2f6deb0 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -58,6 +58,7 @@ void	target_backend_unregister(const struct target_backend_ops *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
 void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
+void	target_complete_ios(struct target_iostate *, u16);
 
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
 sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
-- 
1.9.1
