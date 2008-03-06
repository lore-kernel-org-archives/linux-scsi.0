From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [18/21] Switch to a single SCSI command pool
Date: Thu,  6 Mar 2008 21:51:40 +0100 (CET)
Message-ID: <20080306205140.430351B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:15069 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761297AbYCFUvm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:42 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Now that no low level driver relies on ISA DMAable scsi_cmnds anymore
it is safe to always use the same static slab for them.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -140,24 +140,22 @@ const char * scsi_device_type(unsigned t
 
 EXPORT_SYMBOL(scsi_device_type);
 
+static struct kmem_cache *scsi_cmd_slab;
+
 struct scsi_host_cmd_pool {
-	struct kmem_cache	*cmd_slab;
 	struct kmem_cache	*sense_slab;
 	unsigned int		users;
-	char			*cmd_name;
 	char			*sense_name;
 	unsigned int		slab_flags;
 	gfp_t			gfp_mask;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.cmd_name	= "scsi_cmd_cache",
 	.sense_name	= "scsi_sense_cache",
 	.slab_flags	= SLAB_HWCACHE_ALIGN,
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.cmd_name	= "scsi_cmd_cache(DMA)",
 	.sense_name	= "scsi_sense_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 	.gfp_mask	= __GFP_DMA,
@@ -178,10 +176,8 @@ struct scsi_cmnd *__scsi_get_command(str
 	struct scsi_cmnd *cmd;
 	unsigned char *buf;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       gfp_mask | shost->cmd_pool->gfp_mask);
-
-	if (unlikely(!cmd)) {
+	cmd = kmem_cache_alloc(scsi_cmd_slab, gfp_mask);
+	if (!cmd) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&shost->free_list_lock, flags);
@@ -204,7 +200,7 @@ struct scsi_cmnd *__scsi_get_command(str
 			memset(cmd, 0, sizeof(*cmd));
 			cmd->sense_buffer = buf;
 		} else {
-			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+			kmem_cache_free(scsi_cmd_slab, cmd);
 			cmd = NULL;
 		}
 	}
@@ -269,7 +265,7 @@ void __scsi_put_command(struct Scsi_Host
 	if (likely(cmd != NULL)) {
 		kmem_cache_free(shost->cmd_pool->sense_slab,
 				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+		kmem_cache_free(scsi_cmd_slab, cmd);
 	}
 
 	put_device(dev);
@@ -331,20 +327,24 @@ int scsi_setup_command_freelist(struct S
 	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
+
+	if (!scsi_cmd_slab) {
+		scsi_cmd_slab = kmem_cache_create("scsi_cmd_cache",
+						  sizeof(struct scsi_cmnd), 0,
+						  SLAB_HWCACHE_ALIGN, NULL);
+		if (!scsi_cmd_slab)
+			goto fail;
+	}
+
 	pool = (shost->unchecked_isa_dma || sense_buffer_isa(shost)) ?
 			&scsi_cmd_dma_pool : &scsi_cmd_pool;
 	if (!pool->users) {
-		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
-						   sizeof(struct scsi_cmnd), 0,
-						   pool->slab_flags, NULL);
-		if (!pool->cmd_slab)
-			goto fail;
-
 		pool->sense_slab = kmem_cache_create(pool->sense_name,
 						     SCSI_SENSE_BUFFERSIZE, 0,
 						     pool->slab_flags, NULL);
 		if (!pool->sense_slab) {
-			kmem_cache_destroy(pool->cmd_slab);
+			kmem_cache_destroy(scsi_cmd_slab);
+			scsi_cmd_slab = NULL;
 			goto fail;
 		}
 	}
@@ -356,8 +356,7 @@ int scsi_setup_command_freelist(struct S
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(scsi_cmd_slab, GFP_KERNEL);
 	if (!cmd)
 		goto fail2;
 
@@ -372,10 +371,11 @@ int scsi_setup_command_freelist(struct S
 
  fail2:
 	if (cmd)
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+		kmem_cache_free(scsi_cmd_slab, cmd);
 	mutex_lock(&host_cmd_pool_mutex);
 	if (!--pool->users) {
-		kmem_cache_destroy(pool->cmd_slab);
+		kmem_cache_destroy(scsi_cmd_slab);
+		scsi_cmd_slab = NULL;
 		kmem_cache_destroy(pool->sense_slab);
 	}
  fail:
@@ -396,12 +396,13 @@ void scsi_destroy_command_freelist(struc
 		list_del_init(&cmd->list);
 		kmem_cache_free(shost->cmd_pool->sense_slab,
 				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+		kmem_cache_free(scsi_cmd_slab, cmd);
 	}
 
 	mutex_lock(&host_cmd_pool_mutex);
 	if (!--shost->cmd_pool->users) {
-		kmem_cache_destroy(shost->cmd_pool->cmd_slab);
+		kmem_cache_destroy(scsi_cmd_slab);
+		scsi_cmd_slab = NULL;
 		kmem_cache_destroy(shost->cmd_pool->sense_slab);
 	}
 	mutex_unlock(&host_cmd_pool_mutex);
