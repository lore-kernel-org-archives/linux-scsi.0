From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] tcm_loop: Convert to pre-allocated struct se_cmd descriptors
Date: Fri, 10 Sep 2010 02:26:45 -0700
Message-ID: <1284110805-337-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joe Eykholt <jeykholt@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the TCM_Loop fabric module to use pre-allocated struct se_cmd
descriptors and sense data buffer located at struct tcm_loop_cmd->tl_se_cmd and
struct tcm_loop_cmd->tl_sense_buf respectively.

This includes updating tcm_loop_allocate_core_cmd() to use transport_init_se_cmd()
for the main tcm_loop_queuecommand() entry point, as well as the same conversion
in tcm_loop_device_reset() for TMR LUN_RESET.

This also includes the conversion of a number of functions to use container_of()
instead of struct se_cmd->se_fabric_cmd_ptr to locate the struct tcm_loop_cmd *.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_core.h        |    6 ++-
 drivers/target/tcm_loop/tcm_loop_fabric.c      |   12 ++++----
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   37 +++++++++++-------------
 3 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index 69906b7..821d73c 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -29,9 +29,11 @@ struct tcm_loop_cmd {
 	u32 sc_cmd_state;
 	/* Pointer to the CDB+Data descriptor from Linux/SCSI subsystem */
 	struct scsi_cmnd *sc;
-	/* Pointer to the TCM allocated struct se_cmd */
-	struct se_cmd *tl_se_cmd;
 	struct list_head *tl_cmd_list;
+	/* The TCM I/O descriptor that is accessed via container_of() */
+	struct se_cmd tl_se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
 };
 
 struct tcm_loop_tmr {
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index abd643d..b12a760 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -305,8 +305,8 @@ u32 tcm_loop_get_task_tag(struct se_cmd *se_cmd)
 
 int tcm_loop_get_cmd_state(struct se_cmd *se_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-			(struct tcm_loop_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+			struct tcm_loop_cmd, tl_se_cmd);
 
 	return tl_cmd->sc_cmd_state;
 }
@@ -376,8 +376,8 @@ int tcm_loop_write_pending_status(struct se_cmd *se_cmd)
 
 int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-			(struct tcm_loop_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
 	TL_CDB_DEBUG( "tcm_loop_queue_data_in() called for scsi_cmnd: %p"
@@ -398,8 +398,8 @@ int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 
 int tcm_loop_queue_status(struct se_cmd *se_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-			(struct tcm_loop_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
 	TL_CDB_DEBUG("tcm_loop_queue_status() called for scsi_cmnd: %p"
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 46d24b4..fee70fe 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -100,17 +100,14 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 		}
 	} else
 		sam_task_attr = TASK_ATTR_SIMPLE;
+
+	se_cmd = &tl_cmd->tl_se_cmd;
 	/*
-	 * Allocate the struct se_cmd descriptor from target_core_mod infrastructure
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
-	tl_cmd->tl_se_cmd = transport_alloc_se_cmd(se_tpg->se_tpg_tfo,
-			se_sess, (void *)tl_cmd, scsi_bufflen(sc),
-			data_direction, sam_task_attr);
-	if (!(tl_cmd->tl_se_cmd)) {
-		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
-		return NULL;
-	}
-	se_cmd = tl_cmd->tl_se_cmd;
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			scsi_bufflen(sc), data_direction, sam_task_attr,
+			&tl_cmd->tl_sense_buf[0]);
 	/*
 	 * Locate the struct se_lun pointer and attach it to struct se_cmd
 	 */
@@ -136,7 +133,8 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
  */
 int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd = se_cmd->se_fabric_cmd_ptr;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 	void *mem_ptr;
 	int ret;
@@ -206,12 +204,12 @@ void tcm_loop_check_stop_free(struct se_cmd *se_cmd)
 }
 
 /*
- * Called from struct target_core_fabric_ops->releastruct se_cmdo_pool()
+ * Called from struct target_core_fabric_ops->release_cmd_to_pool()
  */
 void tcm_loop_deallocate_core_cmd(struct se_cmd *se_cmd)
 {
-	struct tcm_loop_cmd *tl_cmd =
-			(struct tcm_loop_cmd *)se_cmd->se_fabric_cmd_ptr;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
 
 	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 }
@@ -417,15 +415,14 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 		goto release;
 	}
 	init_waitqueue_head(&tl_tmr->tl_tmr_wait);
+
+	se_cmd = &tl_cmd->tl_se_cmd;
 	/*
-	 * Allocate the struct se_cmd for a LUN_RESET TMR
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
-	tl_cmd->tl_se_cmd = transport_alloc_se_cmd(se_tpg->se_tpg_tfo,
-			se_sess, (void *)tl_cmd, 0, SE_DIRECTION_NONE,
-			TASK_ATTR_SIMPLE);
-	if (!(tl_cmd->tl_se_cmd))
-		goto release;
-	se_cmd = tl_cmd->tl_se_cmd;
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
+				SE_DIRECTION_NONE, TASK_ATTR_SIMPLE,
+				&tl_cmd->tl_sense_buf[0]);
 	/*
 	 * Allocate the LUN_RESET TMR
 	 */
-- 
1.5.6.5
