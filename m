From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Sun, 20 Jan 2008 10:36:56 -0600
Message-ID: <1200847016.3105.9.camel@localhost.localdomain>
References: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45723 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796AbYATQhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jan 2008 11:37:06 -0500
In-Reply-To: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.org


On Wed, 2008-01-16 at 13:32 +0900, FUJITA Tomonori wrote:
> This is the third version of:
> 
> http://marc.info/?l=linux-scsi&m=120038907123706&w=2
[...]
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 54ff611..0a4a5b8 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -186,6 +190,21 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  			list_del_init(&cmd->list);
>  		}
>  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
> +
> +		if (cmd) {
> +			buf = cmd->sense_buffer;
> +			memset(cmd, 0, sizeof(*cmd));
> +			cmd->sense_buffer = buf;
> +		}
> +	} else {
> +		buf = kmem_cache_alloc(sense_buffer_slab, __GFP_DMA|gfp_mask);

This is going to cause the enterprise some angst because ZONE_DMA can be
very small, and the enterprise requrements for commands in flight very
large.  I also think its unnecessary if we know the host isn't requiring
ISA DMA.  How about the below to fix this, it's based on the existing
infrastructure for solving the very same problem.

James

---

>From e7ffbd81684779f5eb41d66d5f499b82af40e12b Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 20 Jan 2008 09:28:24 -0600
Subject: [SCSI] don't use __GFP_DMA for sense buffers if not required

Only hosts which actually have ISA DMA requirements need sense buffers
coming out of ZONE_DMA, so only use the __GFP_DMA flag for that case
to avoid allocating this scarce resource if it's not necessary.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/hosts.c     |    9 +----
 drivers/scsi/scsi.c      |  106 +++++++++++++++++++--------------------------
 drivers/scsi/scsi_priv.h |    2 -
 3 files changed, 46 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f5d3fbb..9a10b43 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -268,7 +268,6 @@ static void scsi_host_dev_release(struct device *dev)
 	}
 
 	scsi_destroy_command_freelist(shost);
-	scsi_destroy_command_sense_buffer(shost);
 	if (shost->bqt)
 		blk_free_tags(shost->bqt);
 
@@ -373,13 +372,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	rval = scsi_setup_command_sense_buffer(shost);
-	if (rval)
-		goto fail_kfree;
-
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
-		goto fail_destroy_sense;
+		goto fail_kfree;
 
 	device_initialize(&shost->shost_gendev);
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
@@ -404,8 +399,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_destroy_freelist:
 	scsi_destroy_command_freelist(shost);
- fail_destroy_sense:
-	scsi_destroy_command_sense_buffer(shost);
  fail_kfree:
 	kfree(shost);
 	return NULL;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0a4a5b8..045e69d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -141,29 +141,30 @@ const char * scsi_device_type(unsigned type)
 EXPORT_SYMBOL(scsi_device_type);
 
 struct scsi_host_cmd_pool {
-	struct kmem_cache	*slab;
-	unsigned int	users;
-	char		*name;
-	unsigned int	slab_flags;
-	gfp_t		gfp_mask;
+	struct kmem_cache	*cmd_slab;
+	struct kmem_cache	*sense_slab;
+	unsigned int		users;
+	char			*cmd_name;
+	char			*sense_name;
+	unsigned int		slab_flags;
+	gfp_t			gfp_mask;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.name		= "scsi_cmd_cache",
+	.cmd_name	= "scsi_cmd_cache",
+	.sense_name	= "scsi_sense_cache",
 	.slab_flags	= SLAB_HWCACHE_ALIGN,
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.name		= "scsi_cmd_cache(DMA)",
+	.cmd_name	= "scsi_cmd_cache(DMA)",
+	.sense_name	= "scsi_sense_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 	.gfp_mask	= __GFP_DMA,
 };
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
-static struct kmem_cache *sense_buffer_slab;
-static int sense_buffer_slab_users;
-
 /**
  * __scsi_get_command - Allocate a struct scsi_cmnd
  * @shost: host to transmit command
@@ -177,8 +178,8 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 	struct scsi_cmnd *cmd;
 	unsigned char *buf;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			gfp_mask | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
+			       gfp_mask | shost->cmd_pool->gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -197,12 +198,13 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			cmd->sense_buffer = buf;
 		}
 	} else {
-		buf = kmem_cache_alloc(sense_buffer_slab, __GFP_DMA|gfp_mask);
+		buf = kmem_cache_alloc(shost->cmd_pool->sense_slab,
+				       gfp_mask | shost->cmd_pool->gfp_mask);
 		if (likely(buf)) {
 			memset(cmd, 0, sizeof(*cmd));
 			cmd->sense_buffer = buf;
 		} else {
-			kmem_cache_free(shost->cmd_pool->slab, cmd);
+			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 			cmd = NULL;
 		}
 	}
@@ -265,8 +267,9 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 	if (likely(cmd != NULL)) {
-		kmem_cache_free(sense_buffer_slab, cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+		kmem_cache_free(shost->cmd_pool->sense_slab,
+				cmd->sense_buffer);
+		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	}
 
 	put_device(dev);
@@ -310,7 +313,6 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 {
 	struct scsi_host_cmd_pool *pool;
 	struct scsi_cmnd *cmd;
-	unsigned char *sense_buffer;
 
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
@@ -322,10 +324,13 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
 	if (!pool->users) {
-		pool->slab = kmem_cache_create(pool->name,
-				sizeof(struct scsi_cmnd), 0,
-				pool->slab_flags, NULL);
-		if (!pool->slab)
+		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
+						   sizeof(struct scsi_cmnd), 0,
+						   pool->slab_flags, NULL);
+		pool->sense_slab = kmem_cache_create(pool->sense_name,
+						     SCSI_SENSE_BUFFERSIZE, 0,
+						     pool->slab_flags, NULL);
+		if (!pool->cmd_slab || !pool->sense_slab)
 			goto fail;
 	}
 
@@ -336,26 +341,28 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
-			GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
+			       GFP_KERNEL | shost->cmd_pool->gfp_mask);
 	if (!cmd)
 		goto fail2;
 
-	sense_buffer = kmem_cache_alloc(sense_buffer_slab,
-					GFP_KERNEL | __GFP_DMA);
-	if (!sense_buffer)
-		goto destroy_backup;
+	cmd->sense_buffer = kmem_cache_alloc(shost->cmd_pool->sense_slab,
+					     GFP_KERNEL |
+					     shost->cmd_pool->gfp_mask);
+	if (!cmd->sense_buffer)
+		goto fail2;
 
-	cmd->sense_buffer = sense_buffer;
 	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
-destroy_backup:
-	kmem_cache_free(shost->cmd_pool->slab, cmd);
  fail2:
+	if (cmd)
+		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	mutex_lock(&host_cmd_pool_mutex);
-	if (!--pool->users)
-		kmem_cache_destroy(pool->slab);
+	if (!--pool->users) {
+		kmem_cache_destroy(pool->cmd_slab);
+		kmem_cache_destroy(pool->sense_slab);
+	}
  fail:
 	mutex_unlock(&host_cmd_pool_mutex);
 	return -ENOMEM;
@@ -372,39 +379,16 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 
 		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
 		list_del_init(&cmd->list);
-		kmem_cache_free(sense_buffer_slab, cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->slab, cmd);
+		kmem_cache_free(shost->cmd_pool->sense_slab,
+				cmd->sense_buffer);
+		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	}
 
 	mutex_lock(&host_cmd_pool_mutex);
-	if (!--shost->cmd_pool->users)
-		kmem_cache_destroy(shost->cmd_pool->slab);
-	mutex_unlock(&host_cmd_pool_mutex);
-}
-
-int scsi_setup_command_sense_buffer(struct Scsi_Host *shost)
-{
-	mutex_lock(&host_cmd_pool_mutex);
-	if (!sense_buffer_slab_users) {
-		sense_buffer_slab = kmem_cache_create("scsi_sense_buffer",
-						      SCSI_SENSE_BUFFERSIZE,
-						      0, SLAB_CACHE_DMA, NULL);
-		if (!sense_buffer_slab) {
-			mutex_unlock(&host_cmd_pool_mutex);
-			return -ENOMEM;
-		}
+	if (!--shost->cmd_pool->users) {
+		kmem_cache_destroy(shost->cmd_pool->cmd_slab);
+		kmem_cache_destroy(shost->cmd_pool->sense_slab);
 	}
-	sense_buffer_slab_users++;
-	mutex_unlock(&host_cmd_pool_mutex);
-
-	return 0;
-}
-
-void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost)
-{
-	mutex_lock(&host_cmd_pool_mutex);
-	if (!--sense_buffer_slab_users)
-		kmem_cache_destroy(sense_buffer_slab);
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 55c6f71..3f34e93 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -27,8 +27,6 @@ extern void scsi_exit_hosts(void);
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-extern int scsi_setup_command_sense_buffer(struct Scsi_Host *shost);
-extern void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost);
 extern void __scsi_done(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
-- 
1.5.3.7



