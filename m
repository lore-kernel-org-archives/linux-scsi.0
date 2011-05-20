From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/6] target: Convert TASK_ATTR to scsi_tcq.h definitions
Date: Thu, 19 May 2011 20:19:14 -0700
Message-ID: <1305861554-29960-7-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13.access.bullet.mail.mud.yahoo.com ([66.94.237.214]:38787
	"HELO nm13.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932636Ab1ETDTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 23:19:46 -0400
In-Reply-To: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts target core and follwing scsi-misc upstream fabric
modules to use include/scsi/scsi_tcq.h includes for SIMPLE, HEAD_OF_QUEUE
and ORDERED SCSI tasks instead of scsi/libsas.h with TASK_ATTR*

*) tcm_loop: Convert tcm_loop_allocate_core_cmd() + tcm_loop_device_reset() to
   scsi_tcq.h
*) tcm_fc: Convert ft_send_cmd() from FCP_PTA_* to scsi_tcq.h

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |   12 ++++++------
 drivers/target/target_core_pscsi.c     |    4 ++--
 drivers/target/target_core_transport.c |   22 +++++++++++-----------
 drivers/target/tcm_fc/tfc_cmd.c        |   20 +++++++++++++++++++-
 include/scsi/scsi_tcq.h                |    1 +
 5 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 09681ba..dee2a2c 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -31,7 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/libsas.h> /* For TASK_ATTR_* */
+#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
@@ -95,17 +95,17 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	if (sc->device->tagged_supported) {
 		switch (sc->tag) {
 		case HEAD_OF_QUEUE_TAG:
-			sam_task_attr = TASK_ATTR_HOQ;
+			sam_task_attr = MSG_HEAD_TAG;
 			break;
 		case ORDERED_QUEUE_TAG:
-			sam_task_attr = TASK_ATTR_ORDERED;
+			sam_task_attr = MSG_ORDERED_TAG;
 			break;
 		default:
-			sam_task_attr = TASK_ATTR_SIMPLE;
+			sam_task_attr = MSG_SIMPLE_TAG;
 			break;
 		}
 	} else
-		sam_task_attr = TASK_ATTR_SIMPLE;
+		sam_task_attr = MSG_SIMPLE_TAG;
 
 	/*
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
@@ -379,7 +379,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
-				DMA_NONE, TASK_ATTR_SIMPLE,
+				DMA_NONE, MSG_SIMPLE_TAG,
 				&tl_cmd->tl_sense_buf[0]);
 	/*
 	 * Allocate the LUN_RESET TMR
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7ff6a35..331d423 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -41,7 +41,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
-#include <scsi/libsas.h> /* For TASK_ATTR_* */
+#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -911,7 +911,7 @@ static int pscsi_do_task(struct se_task *task)
 	 * descriptor
 	 */
 	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL, pt->pscsi_req,
-			(task->task_se_cmd->sam_task_attr == TASK_ATTR_HOQ),
+			(task->task_se_cmd->sam_task_attr == MSG_HEAD_TAG),
 			pscsi_req_done);
 
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index beaf8fa..5b1ce81 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -42,7 +42,7 @@
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/libsas.h> /* For TASK_ATTR_* */
+#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -1074,7 +1074,7 @@ static inline int transport_add_task_check_sam_attr(
 	 * head of the struct se_device->execute_task_list, and task_prev
 	 * after that for each subsequent task
 	 */
-	if (task->task_se_cmd->sam_task_attr == TASK_ATTR_HOQ) {
+	if (task->task_se_cmd->sam_task_attr == MSG_HEAD_TAG) {
 		list_add(&task->t_execute_list,
 				(task_prev != NULL) ?
 				&task_prev->t_execute_list :
@@ -1873,7 +1873,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	if (SE_DEV(cmd)->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
 		return 0;
 
-	if (cmd->sam_task_attr == TASK_ATTR_ACA) {
+	if (cmd->sam_task_attr == MSG_ACA_TAG) {
 		DEBUG_STA("SAM Task Attribute ACA"
 			" emulation is not supported\n");
 		return -1;
@@ -2517,7 +2517,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 	 * Check for the existence of HEAD_OF_QUEUE, and if true return 1
 	 * to allow the passed struct se_cmd list of tasks to the front of the list.
 	 */
-	 if (cmd->sam_task_attr == TASK_ATTR_HOQ) {
+	 if (cmd->sam_task_attr == MSG_HEAD_TAG) {
 		atomic_inc(&SE_DEV(cmd)->dev_hoq_count);
 		smp_mb__after_atomic_inc();
 		DEBUG_STA("Added HEAD_OF_QUEUE for CDB:"
@@ -2525,7 +2525,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 			T_TASK(cmd)->t_task_cdb[0],
 			cmd->se_ordered_id);
 		return 1;
-	} else if (cmd->sam_task_attr == TASK_ATTR_ORDERED) {
+	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
 		spin_lock(&SE_DEV(cmd)->ordered_cmd_lock);
 		list_add_tail(&cmd->se_ordered_list,
 				&SE_DEV(cmd)->ordered_cmd_list);
@@ -3424,7 +3424,7 @@ static int transport_generic_cmd_sequencer(
 		 * See spc4r17 section 5.3
 		 */
 		if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
-			cmd->sam_task_attr = TASK_ATTR_HOQ;
+			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_BUFFER:
@@ -3632,7 +3632,7 @@ static int transport_generic_cmd_sequencer(
 		 * See spc4r17 section 5.3
 		 */
 		if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
-			cmd->sam_task_attr = TASK_ATTR_HOQ;
+			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
 	default:
@@ -3790,21 +3790,21 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	struct se_cmd *cmd_p, *cmd_tmp;
 	int new_active_tasks = 0;
 
-	if (cmd->sam_task_attr == TASK_ATTR_SIMPLE) {
+	if (cmd->sam_task_attr == MSG_SIMPLE_TAG) {
 		atomic_dec(&dev->simple_cmds);
 		smp_mb__after_atomic_dec();
 		dev->dev_cur_ordered_id++;
 		DEBUG_STA("Incremented dev->dev_cur_ordered_id: %u for"
 			" SIMPLE: %u\n", dev->dev_cur_ordered_id,
 			cmd->se_ordered_id);
-	} else if (cmd->sam_task_attr == TASK_ATTR_HOQ) {
+	} else if (cmd->sam_task_attr == MSG_HEAD_TAG) {
 		atomic_dec(&dev->dev_hoq_count);
 		smp_mb__after_atomic_dec();
 		dev->dev_cur_ordered_id++;
 		DEBUG_STA("Incremented dev_cur_ordered_id: %u for"
 			" HEAD_OF_QUEUE: %u\n", dev->dev_cur_ordered_id,
 			cmd->se_ordered_id);
-	} else if (cmd->sam_task_attr == TASK_ATTR_ORDERED) {
+	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
 		spin_lock(&dev->ordered_cmd_lock);
 		list_del(&cmd->se_ordered_list);
 		atomic_dec(&dev->dev_ordered_sync);
@@ -3837,7 +3837,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		new_active_tasks++;
 
 		spin_lock(&dev->delayed_cmd_lock);
-		if (cmd_p->sam_task_attr == TASK_ATTR_ORDERED)
+		if (cmd_p->sam_task_attr == MSG_ORDERED_TAG)
 			break;
 	}
 	spin_unlock(&dev->delayed_cmd_lock);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 49e5177..c056a11 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
@@ -592,8 +593,25 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 		case FCP_CFL_WRDATA | FCP_CFL_RDDATA:
 			goto err;	/* TBD not supported by tcm_fc yet */
 		}
+		/*
+		 * Locate the SAM Task Attr from fc_pri_ta
+		 */
+		switch (fcp->fc_pri_ta & FCP_PTA_MASK) {
+		case FCP_PTA_HEADQ:
+			task_attr = MSG_HEAD_TAG;
+			break;
+		case FCP_PTA_ORDERED:
+			task_attr = MSG_ORDERED_TAG;
+			break;
+		case FCP_PTA_ACA:
+			task_attr = MSG_ACA_TAG;
+			break;
+		case FCP_PTA_SIMPLE: /* Fallthrough */
+		default:
+			task_attr = MSG_SIMPLE_TAG;
+		}
+
 
-		/* FCP_PTA_ maps 1:1 to TASK_ATTR_ */
 		task_attr = fcp->fc_pri_ta & FCP_PTA_MASK;
 		data_len = ntohl(fcp->fc_dl);
 		cmd->cdb = fcp->fc_cdb;
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index d6e7994..81dd12e 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -9,6 +9,7 @@
 #define MSG_SIMPLE_TAG	0x20
 #define MSG_HEAD_TAG	0x21
 #define MSG_ORDERED_TAG	0x22
+#define MSG_ACA_TAG	0x24	/* unsupported */
 
 #define SCSI_NO_TAG	(-1)    /* identify no tag in use */
 
-- 
1.7.5.1

