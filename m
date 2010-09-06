From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/6] tcm: Add support for TRANSPORT_NEW_CMD_MAP
Date: Mon,  6 Sep 2010 14:37:00 -0700
Message-ID: <1283809020-13640-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.ne1.yahoo.com ([98.138.84.215]:31875 "HELO
	smtp104.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755603Ab0IFVhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:37:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for a TRANSPORT_NEW_CMD_MAP state that allows
initial TCM fabric module specific setup for individual struct se_cmd I/O
descriptors to be done in interrupt context.  The caller itself at struct
target_core_fabric_ops->new_cmd_map() is called from TCM backstore thread
processing context to allow the fabric module complete the reset of the
I/O descriptor setup such as transport_generic_allocate_tasks() and
transport_generic_map_mem_to_cmd().

This is used by HW target mode modules who do their allocations of
struct se_cmd in interrupt context, and use TFO->new_cmd_map() to finish
the remaining setup.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c  |   19 +++++++++++++++++--
 include/target/target_core_base.h       |    3 ++-
 include/target/target_core_fabric_ops.h |    6 ++++++
 include/target/target_core_transport.h  |    2 +-
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9348728..5be102c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1029,7 +1029,7 @@ void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
 int transport_add_cmd_to_queue(
 	struct se_cmd *cmd,
 	struct se_queue_obj *qobj,
-	u8 t_state)
+	int t_state)
 {
 	struct se_queue_req *qr;
 	unsigned long flags;
@@ -1062,7 +1062,7 @@ int transport_add_cmd_to_queue(
 	return 0;
 }
 
-static int transport_add_cmd_to_dev_queue(struct se_cmd *cmd, u8 t_state)
+static int transport_add_cmd_to_dev_queue(struct se_cmd *cmd, int t_state)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -2719,6 +2719,7 @@ void transport_device_setup_cmd(struct se_cmd *cmd)
 	cmd->transport_add_cmd_to_queue = &transport_add_cmd_to_dev_queue;
 	cmd->se_dev = SE_LUN(cmd)->lun_se_dev;
 }
+EXPORT_SYMBOL(transport_device_setup_cmd);
 
 struct se_cmd *__transport_alloc_se_cmd(
 	struct target_core_fabric_ops *tfo,
@@ -8236,6 +8237,20 @@ get_cmd:
 		kfree(qr);
 
 		switch (t_state) {
+		case TRANSPORT_NEW_CMD_MAP:
+			if (!(CMD_TFO(cmd)->new_cmd_map)) {
+				printk(KERN_ERR "CMD_TFO(cmd)->new_cmd_map is"
+					" NULL for TRANSPORT_NEW_CMD_MAP\n");
+				BUG();
+			}
+			ret = CMD_TFO(cmd)->new_cmd_map(cmd);
+			if (ret < 0) {
+				cmd->transport_error_status = ret;
+				transport_generic_request_failure(cmd, NULL,
+						0, (cmd->data_direction !=
+						    SE_DIRECTION_WRITE));
+			}
+			/* Fall through */
 		case TRANSPORT_NEW_CMD:
 			ret = transport_generic_new_cmd(cmd);
 			if (ret < 0) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 4d693ec..0833612 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -122,6 +122,7 @@ enum {
 	TRANSPORT_KILL		= 13,
 	TRANSPORT_REMOVE	= 14,
 	TRANSPORT_FREE		= 15,
+	TRANSPORT_NEW_CMD_MAP	= 16,
 };	
 
 /* Used for struct se_cmd->se_cmd_flags */
@@ -597,7 +598,7 @@ struct se_cmd {
 	struct se_tmr_req	*se_tmr_req;
 	struct se_transport_task *t_task;
 	struct target_core_fabric_ops *se_tfo;
-	int (*transport_add_cmd_to_queue)(struct se_cmd *, u8);
+	int (*transport_add_cmd_to_queue)(struct se_cmd *, int);
 	int (*transport_allocate_resources)(struct se_cmd *, u32, u32);
 	int (*transport_cdb_transform)(struct se_cmd *,
 					struct se_transform_info *);
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 3bc7fd6..e620eda 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -27,6 +27,12 @@ struct target_core_fabric_ops {
 					struct se_node_acl *);
 	u32 (*tpg_get_inst_index)(struct se_portal_group *);
 	/*
+	 * Optional function pointer for TCM to perform command map
+	 * from TCM processing thread context, for those struct se_cmd
+	 * initally allocated in interrupt context.
+	 */
+	int (*new_cmd_map)(struct se_cmd *);
+	/*
 	 * Optional function pointer for TCM fabric modules that use
 	 * Linux/NET sockets to allocate struct iovec array to struct se_cmd
 	 */
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 91785b5..711ec71 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -144,7 +144,7 @@ extern void transport_task_dev_remove_state(struct se_task *,
 extern void transport_cmd_finish_abort(struct se_cmd *, int);
 extern void transport_cmd_finish_abort_tmr(struct se_cmd *);
 extern int transport_add_cmd_to_queue(struct se_cmd *,
-					struct se_queue_obj *, u8);
+					struct se_queue_obj *, int);
 extern struct se_queue_req *__transport_get_qr_from_queue(
 					struct se_queue_obj *);
 extern void transport_remove_cmd_from_queue(struct se_cmd *,
-- 
1.5.6.5

