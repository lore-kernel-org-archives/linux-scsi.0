From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [3/21] Pass gfp to scsi_allocate_command
Date: Sun, 16 Nov 2008 00:11:03 +0100 (CET)
Message-ID: <20081115231103.59DC93E661B@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44176 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKOXLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:03 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


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
--- linux.orig/include/scsi/scsi_cmnd.h	2008-11-15 22:37:11.000000000 +0100
+++ linux/include/scsi/scsi_cmnd.h	2008-11-15 22:37:12.000000000 +0100
@@ -148,8 +148,9 @@
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
--- linux.orig/drivers/scsi/scsi.c	2008-11-15 22:37:11.000000000 +0100
+++ linux/drivers/scsi/scsi.c	2008-11-15 23:50:59.000000000 +0100
@@ -352,7 +352,8 @@
 }
 EXPORT_SYMBOL(scsi_put_command);
 
-static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
+static struct scsi_host_cmd_pool *
+scsi_get_host_cmd_pool(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_host_cmd_pool *retval = NULL, *pool;
 	/*
@@ -360,8 +361,9 @@
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
@@ -385,12 +387,12 @@
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
@@ -408,6 +410,10 @@
 
 /**
  * scsi_allocate_command - get a fully allocated SCSI command
+ * @shost:	SCSI host. Can be NULL, then we assume you have no
+ *		special DMA address requirements for command/sense buffer.
+ *		If you have special DMA requirements you must record
+ *		them in the shost before calling this.
  * @gfp_mask:	allocation mask
  *
  * This function is for use outside of the normal host based pools.
@@ -419,9 +425,16 @@
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
@@ -432,16 +445,16 @@
 
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
@@ -457,8 +470,8 @@
 	 * reference we took above, and once to release the reference
 	 * originally taken by scsi_allocate_command
 	 */
-	scsi_put_host_cmd_pool(gfp_mask);
-	scsi_put_host_cmd_pool(gfp_mask);
+	scsi_put_host_cmd_pool(shost);
+	scsi_put_host_cmd_pool(shost);
 }
 EXPORT_SYMBOL(scsi_free_command);
 
@@ -480,7 +493,7 @@
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
 
-	shost->cmd_pool = scsi_get_host_cmd_pool(gfp_mask);
+	shost->cmd_pool = scsi_get_host_cmd_pool(shost, 0);
 
 	if (!shost->cmd_pool)
 		return -ENOMEM;
@@ -490,7 +503,7 @@
 	 */
 	cmd = scsi_host_alloc_command(shost, gfp_mask);
 	if (!cmd) {
-		scsi_put_host_cmd_pool(gfp_mask);
+		scsi_put_host_cmd_pool(shost);
 		shost->cmd_pool = NULL;
 		return -ENOMEM;
 	}
@@ -519,7 +532,7 @@
 		scsi_pool_free_command(shost->cmd_pool, cmd);
 	}
 	shost->cmd_pool = NULL;
-	scsi_put_host_cmd_pool(shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL);
+	scsi_put_host_cmd_pool(shost);
 }
 
 #ifdef CONFIG_SCSI_LOGGING
