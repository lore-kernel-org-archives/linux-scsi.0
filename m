From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] export command allocation and freeing functions
	independently of the host
Date: Thu, 13 Mar 2008 11:53:44 -0500
Message-ID: <1205427224.2893.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38952 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbYCMQxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 12:53:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

This is needed by things like USB storage that want to set up static
commands for later use at start of day.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi.c      |  149 ++++++++++++++++++++++++++++++++++-----------
 include/scsi/scsi_cmnd.h |    3 +
 2 files changed, 115 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d70e608..65dbb3e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -330,30 +330,16 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_put_command);
 
-/**
- * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
- * @shost: host to allocate the freelist for.
- *
- * Description: The command freelist protects against system-wide out of memory
- * deadlock by preallocating one SCSI command structure for each host, so the
- * system can always write to a swap file on a device associated with that host.
- *
- * Returns:	Nothing.
- */
-int scsi_setup_command_freelist(struct Scsi_Host *shost)
+static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
 {
-	struct scsi_host_cmd_pool *pool;
-	struct scsi_cmnd *cmd;
-
-	spin_lock_init(&shost->free_list_lock);
-	INIT_LIST_HEAD(&shost->free_list);
-
+	struct scsi_host_cmd_pool *retval = NULL, *pool;
 	/*
 	 * Select a command slab for this host and create it if not
 	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
+	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
+		&scsi_cmd_pool;
 	if (!pool->users) {
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
 						   sizeof(struct scsi_cmnd), 0,
@@ -371,28 +357,122 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	}
 
 	pool->users++;
-	shost->cmd_pool = pool;
+	retval = pool;
+ fail:
 	mutex_unlock(&host_cmd_pool_mutex);
+	return retval;
+}
+
+static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
+{
+	struct scsi_host_cmd_pool *pool;
 
+	mutex_lock(&host_cmd_pool_mutex);
+	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
+		&scsi_cmd_pool;
 	/*
-	 * Get one backup command for this host.
+	 * This may happen if a driver has a mismatched get and put
+	 * of the command pool; the driver should be implicated in
+	 * the stack trace
 	 */
-	cmd = scsi_get_command_from_pool(shost->cmd_pool, GFP_KERNEL);
-	if (!cmd)
-		goto fail2;
+	BUG_ON(pool->users == 0);
 
-	list_add(&cmd->list, &shost->free_list);
-	return 0;
-
- fail2:
-	mutex_lock(&host_cmd_pool_mutex);
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
 		kmem_cache_destroy(pool->sense_slab);
 	}
- fail:
 	mutex_unlock(&host_cmd_pool_mutex);
-	return -ENOMEM;
+}
+
+/**
+ * scsi_allocate_command - get a fully allocated SCSI command
+ * @gfp_mask:	allocation mask
+ *
+ * This function is for use outside of the normal host based pools.
+ * It allocates the relevant command and takes an additional reference
+ * on the pool it used.  This function *must* be paired with
+ * scsi_free_command which also has the identical mask, otherwise the
+ * free pool counts will eventually go wrong and you'll trigger a bug.
+ *
+ * This function should *only* be used by drivers that need a static
+ * command allocation at start of day for internal functions.
+ */
+struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask)
+{
+	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
+
+	if (!pool)
+		return NULL;
+
+	return scsi_get_command_from_pool(pool, gfp_mask);
+}
+EXPORT_SYMBOL(scsi_allocate_command);
+
+/**
+ * scsi_free_command - free a command allocated by scsi_allocate_command
+ * @gfp_mask:	mask used in the original allocation
+ * @cmd:	command to free
+ *
+ * Note: using the original allocation mask is vital because that's
+ * what determines which command pool we use to free the command.  Any
+ * mismatch will cause the system to BUG eventually.
+ */
+void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd)
+{
+	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
+
+	/*
+	 * this could trigger if the mask to scsi_allocate_command
+	 * doesn't match this mask.  Otherwise we're guaranteed that this
+	 * succeeds because scsi_allocate_command must have taken a reference
+	 * on the pool
+	 */
+	BUG_ON(!pool);
+
+	scsi_put_command_to_pool(pool, cmd);
+	/*
+	 * scsi_put_host_cmd_pool is called twice; once to release the
+	 * reference we took above, and once to release the reference
+	 * originally taken by scsi_allocate_command
+	 */
+	scsi_put_host_cmd_pool(gfp_mask);
+	scsi_put_host_cmd_pool(gfp_mask);
+}
+EXPORT_SYMBOL(scsi_free_command);
+
+/**
+ * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
+ * @shost: host to allocate the freelist for.
+ *
+ * Description: The command freelist protects against system-wide out of memory
+ * deadlock by preallocating one SCSI command structure for each host, so the
+ * system can always write to a swap file on a device associated with that host.
+ *
+ * Returns:	Nothing.
+ */
+int scsi_setup_command_freelist(struct Scsi_Host *shost)
+{
+	struct scsi_cmnd *cmd;
+	const gfp_t gfp_mask = shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL;
+
+	spin_lock_init(&shost->free_list_lock);
+	INIT_LIST_HEAD(&shost->free_list);
+
+	shost->cmd_pool = scsi_get_host_cmd_pool(gfp_mask);
+
+	if (!shost->cmd_pool)
+		return -ENOMEM;
+
+	/*
+	 * Get one backup command for this host.
+	 */
+	cmd = scsi_get_command_from_pool(shost->cmd_pool, gfp_mask);
+	if (!cmd) {
+		scsi_put_host_cmd_pool(gfp_mask);
+		return -ENOMEM;
+	}
+	list_add(&cmd->list, &shost->free_list);
+	return 0;
 }
 
 /**
@@ -410,13 +490,8 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 				cmd->sense_buffer);
 		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	}
-
-	mutex_lock(&host_cmd_pool_mutex);
-	if (!--shost->cmd_pool->users) {
-		kmem_cache_destroy(shost->cmd_pool->cmd_slab);
-		kmem_cache_destroy(shost->cmd_pool->sense_slab);
-	}
-	mutex_unlock(&host_cmd_pool_mutex);
+	shost->cmd_pool = NULL;
+	scsi_put_host_cmd_pool(shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL);
 }
 
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index de28aab..a13348c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -130,6 +130,9 @@ extern void scsi_release_buffers(struct scsi_cmnd *cmd);
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
+struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
+void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
+
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
 	return cmd->sdb.table.nents;
-- 
1.5.4.1



