From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] target: Add transport_handle_cdb_direct optimization
Date: Fri,  3 Jun 2011 23:01:29 -0700
Message-ID: <1307167290-24832-2-git-send-email-nab@linux-iscsi.org>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.access.bullet.mail.mud.yahoo.com ([66.94.237.202]:42228
	"HELO nm1.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751535Ab1FDGBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2011 02:01:50 -0400
In-Reply-To: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

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
index 95082b0..53a951e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1847,12 +1847,36 @@ int transport_generic_handle_cdb(
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
1.7.2.5

