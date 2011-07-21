From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 073/103] target: Add transport_handle_cdb_direct optimization
Date: Thu, 21 Jul 2011 00:11:56 -0700
Message-ID: <1311232346-6674-74-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm12.bullet.mail.bf1.yahoo.com ([98.139.212.171]:23871 "HELO
	nm12.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752363Ab1GUHH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:28 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a transport_handle_cdb_direct() optimization for mapping
and queueing tasks directly from within fabric processing context by calling
the newly exported transport_generic_new_cmd().  This currently expects to
be called from process context only, and will fail if called within interrupt
context.

This patch also leaves transport_generic_handle_cdb() unmodified for the
moment to function as expected with existing tcm_fc and ib_srpt fabrics,
and will be removed once these have been converted and tested with v4.1
code using transport_handle_cdb_direct().

Based on Andy's original patch here:

[PATCH 39/42] target: Call transport_new_cmd instead of adding to cmd queue

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   24 ++++++++++++++++++++++++
 include/target/target_core_transport.h |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d42a98e..1ae6eb7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1842,12 +1842,36 @@ int transport_generic_handle_cdb(
 		printk(KERN_ERR "cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
+
 	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
 	return 0;
 }
 EXPORT_SYMBOL(transport_generic_handle_cdb);
 
 /*
+ * Used by fabric module frontends to queue tasks directly.
+ * Many only be used from process context only
+ */
+int transport_handle_cdb_direct(
+	struct se_cmd *cmd)
+{
+	if (!cmd->se_lun) {
+		dump_stack();
+		printk(KERN_ERR "cmd->se_lun is NULL\n");
+		return -EINVAL;
+	}
+	if (in_interrupt()) {
+		dump_stack();
+		printk(KERN_ERR "transport_generic_handle_cdb cannot be called"
+				" from interrupt context\n");
+		return -EINVAL;
+	}
+
+	return transport_generic_new_cmd(cmd);
+}
+EXPORT_SYMBOL(transport_handle_cdb_direct);
+
+/*
  * Used by fabric module frontends defining a TFO->new_cmd_map() caller
  * to  queue up a newly setup se_cmd w/ TRANSPORT_NEW_CMD_MAP in order to
  * complete setup in TCM process context w/ TFO->new_cmd_map().
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 604e669..2aae764 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -166,6 +166,7 @@ extern void transport_init_se_cmd(struct se_cmd *,
 extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_generic_handle_cdb(struct se_cmd *);
+extern int transport_handle_cdb_direct(struct se_cmd *);
 extern int transport_generic_handle_cdb_map(struct se_cmd *);
 extern int transport_generic_handle_data(struct se_cmd *);
 extern void transport_new_cmd_failure(struct se_cmd *);
-- 
1.7.6

