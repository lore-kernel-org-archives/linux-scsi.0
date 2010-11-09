From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add transport_generic_handle_cdb_map() wrapper
Date: Mon,  8 Nov 2010 16:58:27 -0800
Message-ID: <1289264307-5095-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:44661 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752778Ab0KIA6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 19:58:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi hch,

Here is a patch that goes along with the:

	[PATCH 1/9] target: remove never changing indirections in se_cmd

which adds a new transport_generic_handle_cdb_map() wrapper around the
transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD_MAP) call used by
tcm_loop_fabric_scsi.c:tcm_loop_queuecommand() to hand off of the
TFO->new_cmd_map() caller.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c         |   26 +++++++++++++++++++++--
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    2 +-
 include/target/target_core_transport.h         |    1 +
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6a6936e..fda11e9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2943,14 +2943,15 @@ int transport_generic_allocate_tasks(
 }
 EXPORT_SYMBOL(transport_generic_allocate_tasks);
 
-/*	transport_generic_handle_cdb():
- *
- *
+/* 
+ * Used by fabric module frontends not defining a TFO->new_cmd_map()
+ * to queue up a newly setup se_cmd w/ TRANSPORT_NEW_CMD statis
  */
 int transport_generic_handle_cdb(
 	struct se_cmd *cmd)
 {
 	if (!SE_LUN(cmd)) {
+		dump_stack();
 		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
 		return -1;
 	}
@@ -2960,6 +2961,25 @@ int transport_generic_handle_cdb(
 }
 EXPORT_SYMBOL(transport_generic_handle_cdb);
 
+/*
+ * Used by fabric module frontends defining a TFO->new_cmd_map() caller
+ * to  queue up a newly setup se_cmd w/ TRANSPORT_NEW_CMD_MAP in order to
+ * complete setup in TCM process context w/ TFO->new_cmd_map().
+ */
+int transport_generic_handle_cdb_map(
+	struct se_cmd *cmd)
+{
+	if (!SE_LUN(cmd)) {
+		dump_stack();
+		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
+		return -1;
+	}
+
+	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD_MAP);
+	return 0;	
+}
+EXPORT_SYMBOL(transport_generic_handle_cdb_map);
+
 /*	transport_generic_handle_data():
  *
  *
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 3c204a8..80f2940 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -350,7 +350,7 @@ static int tcm_loop_queuecommand(
 	/*
 	 * Queue up the newly allocated to be processed in TCM thread context.
 	*/
-	transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
+	transport_generic_handle_cdb_map(se_cmd);
 	/*
 	 * Reaquire the the struct scsi_host->host_lock before returning
 	 */
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 0701618..88d208e 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -203,6 +203,7 @@ extern void transport_init_se_cmd(struct se_cmd *,
 extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_generic_handle_cdb(struct se_cmd *);
+extern int transport_generic_handle_cdb_map(struct se_cmd *);
 extern int transport_generic_handle_data(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
 extern int transport_stop_tasks_for_cmd(struct se_cmd *);
-- 
1.5.6.5

