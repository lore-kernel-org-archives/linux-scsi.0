From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC 1/2] scsi core: alloc_cmnd
Date: Fri, 19 Oct 2007 12:33:31 -0600
Message-ID: <20071019183331.GC30807@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33602 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbXJSSdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 14:33:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This fairly naive patch introduces alloc_cmnd and destroy_cmnd.  I'm not
exactly happy about passing down the gfp_mask -- I'd prefer to be able
to allocate scsi_cmnds before we grab the queue_lock (and hence get
rid of the possibility we might need to GFP_ATOMIC), but I don't see
anywhere to do that.  Maybe there's a simple change we can make to the
block layer to allow it.

Merely-an-RFC-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1929488..30698da 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -160,8 +160,11 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			gfp_mask | shost->cmd_pool->gfp_mask);
+	if (shost->hostt->alloc_cmnd)
+		cmd = shost->hostt->alloc_cmnd(shost, gfp_mask);
+	else
+		cmd = kmem_cache_alloc(shost->cmd_pool->slab,
+					gfp_mask | shost->cmd_pool->gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -230,8 +233,12 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	}
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-	if (likely(cmd != NULL))
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+	if (likely(cmd != NULL)) {
+		if (shost->hostt->destroy_cmnd)
+			shost->hostt->destroy_cmnd(cmd);
+		else
+			kmem_cache_free(shost->cmd_pool->slab, cmd);
+	}
 
 	put_device(dev);
 }
@@ -280,31 +287,37 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
 
-	/*
-	 * Select a command slab for this host and create it if not
-	 * yet existant.
-	 */
-	mutex_lock(&host_cmd_pool_mutex);
-	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
-	if (!pool->users) {
-		pool->slab = kmem_cache_create(pool->name,
-				sizeof(struct scsi_cmnd), 0,
-				pool->slab_flags, NULL);
-		if (!pool->slab)
-			goto fail;
-	}
+	if (shost->hostt->alloc_cmnd) {
+		cmd = shost->hostt->alloc_cmnd(shost, GFP_KERNEL);
+		if (!cmd)
+			return -ENOMEM;
+	} else {
+		/*
+		 * Select a command slab for this host and create it if not
+		 * yet existant.
+		 */
+		mutex_lock(&host_cmd_pool_mutex);
+		pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
+		if (!pool->users) {
+			pool->slab = kmem_cache_create(pool->name,
+					sizeof(struct scsi_cmnd), 0,
+					pool->slab_flags, NULL);
+			if (!pool->slab)
+				goto fail;
+		}
 
-	pool->users++;
-	shost->cmd_pool = pool;
-	mutex_unlock(&host_cmd_pool_mutex);
+		pool->users++;
+		shost->cmd_pool = pool;
+		mutex_unlock(&host_cmd_pool_mutex);
+		/*
+		 * Get one backup command for this host.
+		 */
+		cmd = kmem_cache_alloc(shost->cmd_pool->slab,
+				GFP_KERNEL | shost->cmd_pool->gfp_mask);
+		if (!cmd)
+			goto fail2;
+	}
 
-	/*
-	 * Get one backup command for this host.
-	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			GFP_KERNEL | shost->cmd_pool->gfp_mask);
-	if (!cmd)
-		goto fail2;
 	list_add(&cmd->list, &shost->free_list);		
 	return 0;
 
@@ -315,15 +328,13 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
  fail:
 	mutex_unlock(&host_cmd_pool_mutex);
 	return -ENOMEM;
-
 }
 
-/*
- * Function:	scsi_destroy_command_freelist()
- *
- * Purpose:	Release the command freelist for a scsi host.
+/**
+ * scsi_destroy_command_freelist - Release the command freelist for a scsi host
+ * @shost: Destroy the freelist for this host
  *
- * Arguments:	shost	- host that's freelist is going to be destroyed
+ * The @shost is being destroyed, so make sure we've freed this resource.
  */
 void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 {
@@ -332,9 +343,15 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 
 		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
 		list_del_init(&cmd->list);
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+		if (shost->hostt->destroy_cmnd)
+			shost->hostt->destroy_cmnd(cmd);
+		else
+			kmem_cache_free(shost->cmd_pool->slab, cmd);
 	}
 
+	if (shost->hostt->destroy_cmnd)
+		return;
+
 	mutex_lock(&host_cmd_pool_mutex);
 	if (!--shost->cmd_pool->users)
 		kmem_cache_destroy(shost->cmd_pool->slab);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7d210cd..19e2241 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -284,6 +284,15 @@ struct scsi_host_template {
 	void (* scan_start)(struct Scsi_Host *);
 
 	/*
+	 * Fill in this pair of functions to allow the driver to allocate
+	 * extra per-command memory.
+	 *
+	 * Status: OPTIONAL (for now ...)
+	 */
+	struct scsi_cmnd *(*alloc_cmnd)(struct Scsi_Host *, gfp_t);
+	void (*destroy_cmnd)(struct scsi_cmnd *);
+
+	/*
 	 * fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  returns either
 	 * the current queue depth setting (may be different from what
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
