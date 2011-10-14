From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 09/37] target: remove transport_generic_handle_cdb
Date: Fri, 14 Oct 2011 00:41:41 +0000
Message-ID: <1318552929-13341-10-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   23 +++--------------------
 include/target/target_core_transport.h |    1 -
 2 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index af1e0a5..f0f21bb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1728,24 +1728,6 @@ int transport_generic_allocate_tasks(
 }
 EXPORT_SYMBOL(transport_generic_allocate_tasks);
 
-/*
- * Used by fabric module frontends not defining a TFO->new_cmd_map()
- * to queue up a newly setup se_cmd w/ TRANSPORT_NEW_CMD statis
- */
-int transport_generic_handle_cdb(
-	struct se_cmd *cmd)
-{
-	if (!cmd->se_lun) {
-		dump_stack();
-		pr_err("cmd->se_lun is NULL\n");
-		return -EINVAL;
-	}
-
-	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
-	return 0;
-}
-EXPORT_SYMBOL(transport_generic_handle_cdb);
-
 static void transport_generic_request_failure(struct se_cmd *,
 			struct se_device *, int, int);
 /*
@@ -5205,6 +5187,9 @@ get_cmd:
 			continue;
 
 		switch (cmd->t_state) {
+		case TRANSPORT_NEW_CMD:
+			BUG();
+			break;
 		case TRANSPORT_NEW_CMD_MAP:
 			if (!cmd->se_tfo->new_cmd_map) {
 				pr_err("cmd->se_tfo->new_cmd_map is"
@@ -5219,8 +5204,6 @@ get_cmd:
 						    DMA_TO_DEVICE));
 				break;
 			}
-			/* Fall through */
-		case TRANSPORT_NEW_CMD:
 			ret = transport_generic_new_cmd(cmd);
 			if (ret == -EAGAIN)
 				break;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 46aae4f..0482a28 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -171,7 +171,6 @@ void *transport_kmap_first_data_page(struct se_cmd *cmd);
 void transport_kunmap_first_data_page(struct se_cmd *cmd);
 extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
-extern int transport_generic_handle_cdb(struct se_cmd *);
 extern int transport_handle_cdb_direct(struct se_cmd *);
 extern int transport_generic_handle_cdb_map(struct se_cmd *);
 extern int transport_generic_handle_data(struct se_cmd *);
-- 
1.5.6.5
