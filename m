From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [3/21] SCSI-ISA-DMA: Pass gfp to scsi_allocate_command
Date: Thu,  2 Oct 2008 09:58:41 +0200 (CEST)
Message-ID: <20081002075841.234593E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57081 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYJBH6n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:43 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Instead of deciding low level based on unchecked_isa_dma pass in the GFP.
This makes it easier to remove unchecked_isa_dma later and also simplifies some code.

Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi.c      |   45 +++++++++++++++++++++++++++++----------------
 include/scsi/scsi_cmnd.h |    5 +++--
 2 files changed, 32 insertions(+), 18 deletions(-)

Index: linux/include/scsi/scsi_cmnd.h
===================================================================
--- linux.orig/include/scsi/scsi_cmnd.h
+++ linux/include/scsi/scsi_cmnd.h
@@ -151,8 +151,9 @@ extern void scsi_release_buffers(struct 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
-void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
+struct scsi_cmnd *scsi_allocate_command(struct Scsi_Host *shost,
+					gfp_t gfp_mask);
+void scsi_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -353,7 +353,8 @@ void scsi_put_command(struct scsi_cmnd *
 }
 EXPORT_SYMBOL(scsi_put_command);
 
-static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
+static struct scsi_host_cmd_pool *
+scsi_get_host_cmd_pool(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_host_cmd_pool *retval = NULL, *pool;
 	/*
@@ -361,8 +362,9 @@ static struct scsi_host_cmd_pool *scsi_g
 	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
-		&scsi_cmd_pool;
+	pool = &scsi_cmd_pool;
+	if (shost && shost->unchecked_isa_dma)
+		pool = &scsi_cmd_dma_pool;
 	if (!pool->users) {
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
 						   sizeof(struct scsi_cmnd), 0,
@@ -386,12 +388,12 @@ static struct scsi_host_cmd_pool *scsi_g
 	return retval;
 }
 
-static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
+static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
 {
 	struct scsi_host_cmd_pool *pool;
 
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
+	pool = (shost && shost->unchecked_isa_dma) ? &scsi_cmd_dma_pool :
 		&scsi_cmd_pool;
 	/*
 	 * This may happen if a driver has a mismatched get and put
@@ -409,6 +411,10 @@ static void scsi_put_host_cmd_pool(gfp_t
 
 /**
  * scsi_allocate_command - get a fully allocated SCSI command
+ * @shost:	SCSI host. Can be NULL, then we assume you have no
+ *		special DMA address requirements for command/sense buffer.
+ *		If you have special DMA requirements you must record
+ *		them in the shost before calling this.
  * @gfp_mask:	allocation mask
  *
  * This function is for use outside of the normal host based pools.
@@ -420,9 +426,16 @@ static void scsi_put_host_cmd_pool(gfp_t
  * This function should *only* be used by drivers that need a static
  * command allocation at start of day for internal functions.
  */
-struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask)
+struct scsi_cmnd *scsi_allocate_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
-	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
+	struct scsi_host_cmd_pool *pool;
+
+	/*
+	 * ISA-DMAness should be only decided by flags in shost. Only use the gfp for
+	 * sleeping vs non sleeping if at all.
+	 */
+	BUG_ON(gfp_mask & __GFP_DMA);
+	pool = scsi_get_host_cmd_pool(shost, gfp_mask);
 
 	if (!pool)
 		return NULL;
@@ -433,16 +446,16 @@ EXPORT_SYMBOL(scsi_allocate_command);
 
 /**
  * scsi_free_command - free a command allocated by scsi_allocate_command
- * @gfp_mask:	mask used in the original allocation
+ * @shost:	shost used in the original allocation or NULL
  * @cmd:	command to free
  *
- * Note: using the original allocation mask is vital because that's
+ * Note: using the original shost is vital because that's
  * what determines which command pool we use to free the command.  Any
  * mismatch will cause the system to BUG eventually.
  */
-void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd)
+void scsi_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
-	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
+	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(shost, 0);
 
 	/*
 	 * this could trigger if the mask to scsi_allocate_command
@@ -458,8 +471,8 @@ void scsi_free_command(gfp_t gfp_mask, s
 	 * reference we took above, and once to release the reference
 	 * originally taken by scsi_allocate_command
 	 */
-	scsi_put_host_cmd_pool(gfp_mask);
-	scsi_put_host_cmd_pool(gfp_mask);
+	scsi_put_host_cmd_pool(shost);
+	scsi_put_host_cmd_pool(shost);
 }
 EXPORT_SYMBOL(scsi_free_command);
 
@@ -481,7 +494,7 @@ int scsi_setup_command_freelist(struct S
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
 
-	shost->cmd_pool = scsi_get_host_cmd_pool(gfp_mask);
+	shost->cmd_pool = scsi_get_host_cmd_pool(shost, 0);
 
 	if (!shost->cmd_pool)
 		return -ENOMEM;
@@ -491,7 +504,7 @@ int scsi_setup_command_freelist(struct S
 	 */
 	cmd = scsi_host_alloc_command(shost, gfp_mask);
 	if (!cmd) {
-		scsi_put_host_cmd_pool(gfp_mask);
+		scsi_put_host_cmd_pool(shost);
 		shost->cmd_pool = NULL;
 		return -ENOMEM;
 	}
@@ -520,7 +533,7 @@ void scsi_destroy_command_freelist(struc
 		scsi_pool_free_command(shost->cmd_pool, cmd);
 	}
 	shost->cmd_pool = NULL;
-	scsi_put_host_cmd_pool(shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL);
+	scsi_put_host_cmd_pool(shost);
 }
 
 #ifdef CONFIG_SCSI_LOGGING
