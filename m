From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/37] target: remove transport_free_se_cmd
Date: Fri, 14 Oct 2011 00:41:43 +0000
Message-ID: <1318552929-13341-12-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33402 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1JNAn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:43:59 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

It is only called by transport_release_cmd, so inline it there.  Also add
a kerneldoc comment for transport_release_cmd while we are at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   25 +++++++++++--------------
 include/target/target_core_transport.h |    1 -
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0c1d004..49df097 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1640,19 +1640,6 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	return 0;
 }
 
-void transport_free_se_cmd(
-	struct se_cmd *se_cmd)
-{
-	if (se_cmd->se_tmr_req)
-		core_tmr_release_req(se_cmd->se_tmr_req);
-	/*
-	 * Check and free any extended CDB buffer that was allocated
-	 */
-	if (se_cmd->t_task_cdb != se_cmd->__t_task_cdb)
-		kfree(se_cmd->t_task_cdb);
-}
-EXPORT_SYMBOL(transport_free_se_cmd);
-
 static void transport_generic_wait_for_tasks(struct se_cmd *, int, int);
 
 /*	transport_generic_allocate_tasks():
@@ -4371,11 +4358,21 @@ queue_full:
 	return ret;
 }
 
+/**
+ * transport_release_cmd - free a command
+ * @cmd:       command to free
+ *
+ * This routine unconditionally frees a command, and reference counting
+ * or list removal must be done in the caller.
+ */
 void transport_release_cmd(struct se_cmd *cmd)
 {
 	BUG_ON(!cmd->se_tfo);
 
-	transport_free_se_cmd(cmd);
+	if (cmd->se_tmr_req)
+		core_tmr_release_req(cmd->se_tmr_req);
+	if (cmd->t_task_cdb != cmd->__t_task_cdb)
+		kfree(cmd->t_task_cdb);
 	cmd->se_tfo->release_cmd(cmd);
 }
 EXPORT_SYMBOL(transport_release_cmd);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 0482a28..99a671e 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -169,7 +169,6 @@ extern void transport_init_se_cmd(struct se_cmd *,
 					unsigned char *);
 void *transport_kmap_first_data_page(struct se_cmd *cmd);
 void transport_kunmap_first_data_page(struct se_cmd *cmd);
-extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_handle_cdb_direct(struct se_cmd *);
 extern int transport_generic_handle_cdb_map(struct se_cmd *);
-- 
1.5.6.5

