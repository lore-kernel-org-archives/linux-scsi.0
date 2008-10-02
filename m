From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [19/21] SCSI-ISA-DMA: Switch to a single SCSI command pool
Date: Thu,  2 Oct 2008 09:58:57 +0200 (CEST)
Message-ID: <20081002075857.785F73E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYJBH67 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:59 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Now that no low level driver relies on ISA DMAable scsi_cmnds anymore
it is safe to always use the same static slab for them.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi.c |   58 +++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -131,24 +131,24 @@ const char * scsi_device_type(unsigned t
 
 EXPORT_SYMBOL(scsi_device_type);
 
+/* Writing of both protected by host_cmd_pool_mutex */
+static struct kmem_cache *scsi_cmd_slab;
+static int cmd_pool_users;
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
 
-static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.cmd_name	= "scsi_cmd_cache",
+static struct scsi_host_cmd_pool scsi_sense_pool = {
 	.sense_name	= "scsi_sense_cache",
 	.slab_flags	= SLAB_HWCACHE_ALIGN,
 };
 
-static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.cmd_name	= "scsi_cmd_cache(DMA)",
+static struct scsi_host_cmd_pool scsi_sense_dma_pool = {
 	.sense_name	= "scsi_sense_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 	.gfp_mask	= __GFP_DMA,
@@ -169,7 +169,7 @@ scsi_pool_alloc_command(struct scsi_host
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_alloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	cmd = kmem_cache_alloc(scsi_cmd_slab, gfp_mask);
 	if (!cmd)
 		return NULL;
 
@@ -178,7 +178,7 @@ scsi_pool_alloc_command(struct scsi_host
 	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
 					     gfp_mask | pool->gfp_mask);
 	if (!cmd->sense_buffer) {
-		kmem_cache_free(pool->cmd_slab, cmd);
+		kmem_cache_free(scsi_cmd_slab, cmd);
 		return NULL;
 	}
 
@@ -201,7 +201,7 @@ scsi_pool_free_command(struct scsi_host_
 		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
 
 	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
-	kmem_cache_free(pool->cmd_slab, cmd);
+	kmem_cache_free(scsi_cmd_slab, cmd);
 }
 
 /**
@@ -362,21 +362,26 @@ scsi_get_host_cmd_pool(struct Scsi_Host 
 	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = &scsi_cmd_pool;
-	if (shost && (shost->unchecked_isa_dma || shost->sense_buffer_isa))
-		pool = &scsi_cmd_dma_pool;
+	if (!scsi_cmd_slab) {
+		scsi_cmd_slab = kmem_cache_create("scsi_cmd_pool",
+						  sizeof(struct scsi_cmnd), 0,
+						  0, NULL);
+	}
+	if (!scsi_cmd_slab)
+		goto fail;
+	cmd_pool_users++;
+
+	pool = &scsi_sense_pool;
+	if (shost && shost->sense_buffer_isa)
+		pool = &scsi_sense_dma_pool;
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
+			cmd_pool_users--;
 			goto fail;
 		}
 	}
@@ -393,8 +398,8 @@ static void scsi_put_host_cmd_pool(struc
 	struct scsi_host_cmd_pool *pool;
 
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (shost && (shost->unchecked_isa_dma || shost->sense_buffer_isa)) ?
-		&scsi_cmd_dma_pool : &scsi_cmd_pool;
+	pool = (shost && shost->sense_buffer_isa) ?
+		&scsi_sense_dma_pool : &scsi_sense_pool;
 	/*
 	 * This may happen if a driver has a mismatched get and put
 	 * of the command pool; the driver should be implicated in
@@ -402,9 +407,11 @@ static void scsi_put_host_cmd_pool(struc
 	 */
 	BUG_ON(pool->users == 0);
 
-	if (!--pool->users) {
-		kmem_cache_destroy(pool->cmd_slab);
+	if (!--pool->users)
 		kmem_cache_destroy(pool->sense_slab);
+	if (!--cmd_pool_users) {
+		kmem_cache_destroy(scsi_cmd_slab);
+		scsi_cmd_slab = NULL;
 	}
 	mutex_unlock(&host_cmd_pool_mutex);
 }
@@ -489,9 +496,6 @@ EXPORT_SYMBOL(scsi_free_command);
 int scsi_setup_command_freelist(struct Scsi_Host *shost)
 {
 	struct scsi_cmnd *cmd;
-	gfp_t gfp_mask = GFP_KERNEL;
-	if (shost->unchecked_isa_dma || shost->sense_buffer_isa)
-		gfp_mask = GFP_DMA;
 
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
@@ -504,7 +508,7 @@ int scsi_setup_command_freelist(struct S
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = scsi_host_alloc_command(shost, gfp_mask);
+	cmd = scsi_host_alloc_command(shost, 0);
 	if (!cmd) {
 		scsi_put_host_cmd_pool(shost);
 		shost->cmd_pool = NULL;
