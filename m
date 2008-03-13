From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] consolidate command allocation in a single place
Date: Thu, 13 Mar 2008 11:53:11 -0500
Message-ID: <1205427192.2893.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38939 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbYCMQxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 12:53:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

Since the way we allocate commands with a separate sense buffer is
getting complicated, we should isolate setup and teardown to a single
routine so that if it gets even more complex, there's only one place
in the code that needs to be altered.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi.c |   76 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e5c6f6a..d70e608 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -166,6 +166,51 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
 /**
+ * scsi_get_command_from_pool - internal function to get a fully allocated command
+ * @pool:	slab pool to allocate the command from
+ * @gfp_mask:	mask for the allocation
+ *
+ * Returns a fully allocated command (with the allied sense buffer) or
+ * NULL on failure
+ */
+static struct scsi_cmnd *
+scsi_get_command_from_pool(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
+{
+	struct scsi_cmnd *cmd;
+
+	cmd = kmem_cache_alloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	if (!cmd)
+		return NULL;
+
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
+					     gfp_mask | pool->gfp_mask);
+	if (!cmd->sense_buffer) {
+		kmem_cache_free(pool->cmd_slab, cmd);
+		return NULL;
+	}
+
+	return cmd;
+}
+
+/**
+ * scsi_put_command_to_pool - internal function to release a command
+ * @pool:	slab pool to allocate the command from
+ * @cmd:	command to release
+ *
+ * the command must previously have been allocated by
+ * scsi_get_command_from_pool.
+ */
+static void
+scsi_put_command_to_pool(struct scsi_host_cmd_pool *pool,
+			 struct scsi_cmnd *cmd)
+{
+	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
+	kmem_cache_free(pool->cmd_slab, cmd);
+}
+
+/**
  * __scsi_get_command - Allocate a struct scsi_cmnd
  * @shost: host to transmit command
  * @gfp_mask: allocation mask
@@ -178,8 +223,7 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 	struct scsi_cmnd *cmd;
 	unsigned char *buf;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       gfp_mask | shost->cmd_pool->gfp_mask);
+	cmd = scsi_get_command_from_pool(shost->cmd_pool, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -197,16 +241,6 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			memset(cmd, 0, sizeof(*cmd));
 			cmd->sense_buffer = buf;
 		}
-	} else {
-		buf = kmem_cache_alloc(shost->cmd_pool->sense_slab,
-				       gfp_mask | shost->cmd_pool->gfp_mask);
-		if (likely(buf)) {
-			memset(cmd, 0, sizeof(*cmd));
-			cmd->sense_buffer = buf;
-		} else {
-			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
-			cmd = NULL;
-		}
 	}
 
 	return cmd;
@@ -266,11 +300,8 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	}
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-	if (likely(cmd != NULL)) {
-		kmem_cache_free(shost->cmd_pool->sense_slab,
-				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
-	}
+	if (likely(cmd != NULL))
+		scsi_put_command_to_pool(shost->cmd_pool, cmd);
 
 	put_device(dev);
 }
@@ -346,23 +377,14 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	cmd = scsi_get_command_from_pool(shost->cmd_pool, GFP_KERNEL);
 	if (!cmd)
 		goto fail2;
 
-	cmd->sense_buffer = kmem_cache_alloc(shost->cmd_pool->sense_slab,
-					     GFP_KERNEL |
-					     shost->cmd_pool->gfp_mask);
-	if (!cmd->sense_buffer)
-		goto fail2;
-
 	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
  fail2:
-	if (cmd)
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	mutex_lock(&host_cmd_pool_mutex);
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
-- 
1.5.4.1



