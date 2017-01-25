From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/18] scsi: respect unchecked_isa_dma for blk-mq
Date: Wed, 25 Jan 2017 18:25:20 +0100
Message-ID: <1485365126-23210-13-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Currently blk-mq always allocates the sense buffer using normal GFP_KERNEL
allocation.  Refactor the cmd pool code to split the cmd and sense allocation
and share the code to allocate the sense buffers as well as the sense buffer
slab caches between the legacy and blk-mq path.

Note that this switches to lazy allocation of the sense slab caches - the
slab caches (not the actual allocations) won't be destroy until the scsi
module is unloaded instead of keeping track of hosts using them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hosts.c     |  4 ++++
 drivers/scsi/scsi.c      | 24 ++++---------------
 drivers/scsi/scsi_lib.c  | 62 +++++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_priv.h |  5 ++++
 4 files changed, 73 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 258a3f9..6d29c4a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -213,6 +213,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
+	error = scsi_init_sense_cache(shost);
+	if (error)
+		goto fail;
+
 	if (shost_use_blk_mq(shost)) {
 		error = scsi_mq_setup_tags(shost);
 		if (error)
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 0f93892..469aa0f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -100,22 +100,18 @@ EXPORT_SYMBOL(scsi_sd_pm_domain);
 
 struct scsi_host_cmd_pool {
 	struct kmem_cache	*cmd_slab;
-	struct kmem_cache	*sense_slab;
 	unsigned int		users;
 	char			*cmd_name;
-	char			*sense_name;
 	unsigned int		slab_flags;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
 	.cmd_name	= "scsi_cmd_cache",
-	.sense_name	= "scsi_sense_cache",
 	.slab_flags	= SLAB_HWCACHE_ALIGN,
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
 	.cmd_name	= "scsi_cmd_cache(DMA)",
-	.sense_name	= "scsi_sense_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 };
 
@@ -136,7 +132,7 @@ scsi_host_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 
 	if (cmd->prot_sdb)
 		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
-	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
+	scsi_free_sense_buffer(shost, cmd->sense_buffer);
 	kmem_cache_free(pool->cmd_slab, cmd);
 }
 
@@ -158,7 +154,8 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 	if (!cmd)
 		goto fail;
 
-	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab, gfp_mask);
+	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp_mask,
+			NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
 		goto fail_free_cmd;
 
@@ -171,7 +168,7 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 	return cmd;
 
 fail_free_sense:
-	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
+	scsi_free_sense_buffer(shost, cmd->sense_buffer);
 fail_free_cmd:
 	kmem_cache_free(pool->cmd_slab, cmd);
 fail:
@@ -301,7 +298,6 @@ scsi_find_host_cmd_pool(struct Scsi_Host *shost)
 static void
 scsi_free_host_cmd_pool(struct scsi_host_cmd_pool *pool)
 {
-	kfree(pool->sense_name);
 	kfree(pool->cmd_name);
 	kfree(pool);
 }
@@ -317,8 +313,7 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 		return NULL;
 
 	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->proc_name);
-	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->proc_name);
-	if (!pool->cmd_name || !pool->sense_name) {
+	if (!pool->cmd_name) {
 		scsi_free_host_cmd_pool(pool);
 		return NULL;
 	}
@@ -357,12 +352,6 @@ scsi_get_host_cmd_pool(struct Scsi_Host *shost)
 						   pool->slab_flags, NULL);
 		if (!pool->cmd_slab)
 			goto out_free_pool;
-
-		pool->sense_slab = kmem_cache_create(pool->sense_name,
-						     SCSI_SENSE_BUFFERSIZE, 0,
-						     pool->slab_flags, NULL);
-		if (!pool->sense_slab)
-			goto out_free_slab;
 	}
 
 	pool->users++;
@@ -371,8 +360,6 @@ scsi_get_host_cmd_pool(struct Scsi_Host *shost)
 	mutex_unlock(&host_cmd_pool_mutex);
 	return retval;
 
-out_free_slab:
-	kmem_cache_destroy(pool->cmd_slab);
 out_free_pool:
 	if (hostt->cmd_size) {
 		scsi_free_host_cmd_pool(pool);
@@ -398,7 +385,6 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
 
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
-		kmem_cache_destroy(pool->sense_slab);
 		if (hostt->cmd_size) {
 			scsi_free_host_cmd_pool(pool);
 			hostt->cmd_pool = NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9e1e14..3d6b364 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -39,6 +39,58 @@
 
 
 struct kmem_cache *scsi_sdb_cache;
+static struct kmem_cache *scsi_sense_cache;
+static struct kmem_cache *scsi_sense_isadma_cache;
+static DEFINE_MUTEX(scsi_sense_cache_mutex);
+
+static inline struct kmem_cache *
+scsi_select_sense_cache(struct Scsi_Host *shost)
+{
+	return shost->unchecked_isa_dma ?
+		scsi_sense_isadma_cache : scsi_sense_cache;
+}
+
+void scsi_free_sense_buffer(struct Scsi_Host *shost,
+		unsigned char *sense_buffer)
+{
+	kmem_cache_free(scsi_select_sense_cache(shost), sense_buffer);
+}
+
+unsigned char *scsi_alloc_sense_buffer(struct Scsi_Host *shost, gfp_t gfp_mask,
+		int numa_node)
+{
+	return kmem_cache_alloc_node(scsi_select_sense_cache(shost), gfp_mask,
+			numa_node);
+}
+
+int scsi_init_sense_cache(struct Scsi_Host *shost)
+{
+	struct kmem_cache *cache;
+	int ret = 0;
+
+	cache = scsi_select_sense_cache(shost);
+	if (cache)
+		return 0;
+
+	mutex_lock(&scsi_sense_cache_mutex);
+	if (shost->unchecked_isa_dma) {
+		scsi_sense_isadma_cache =
+			kmem_cache_create("scsi_sense_cache(DMA)",
+			SCSI_SENSE_BUFFERSIZE, 0,
+			SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA, NULL);
+		if (!scsi_sense_isadma_cache)
+			ret = -ENOMEM;
+	} else {
+		scsi_sense_cache =
+			kmem_cache_create("scsi_sense_cache",
+			SCSI_SENSE_BUFFERSIZE, 0, SLAB_HWCACHE_ALIGN, NULL);
+		if (!scsi_sense_cache)
+			ret = -ENOMEM;
+	}
+
+	mutex_unlock(&scsi_sense_cache_mutex);
+	return ret;
+}
 
 /*
  * When to reinvoke queueing after a resource shortage. It's 3 msecs to
@@ -1981,10 +2033,11 @@ static int scsi_init_request(void *data, struct request *rq,
 		unsigned int hctx_idx, unsigned int request_idx,
 		unsigned int numa_node)
 {
+	struct Scsi_Host *shost = data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	cmd->sense_buffer = kzalloc_node(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL,
-			numa_node);
+	cmd->sense_buffer =
+		scsi_alloc_sense_buffer(shost, GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
 	return 0;
@@ -1993,9 +2046,10 @@ static int scsi_init_request(void *data, struct request *rq,
 static void scsi_exit_request(void *data, struct request *rq,
 		unsigned int hctx_idx, unsigned int request_idx)
 {
+	struct Scsi_Host *shost = data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	kfree(cmd->sense_buffer);
+	scsi_free_sense_buffer(shost, cmd->sense_buffer);
 }
 
 static int scsi_map_queues(struct blk_mq_tag_set *set)
@@ -2208,6 +2262,8 @@ int __init scsi_init_queue(void)
 
 void scsi_exit_queue(void)
 {
+	kmem_cache_destroy(scsi_sense_cache);
+	kmem_cache_destroy(scsi_sense_isadma_cache);
 	kmem_cache_destroy(scsi_sdb_cache);
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 193636a..1a712c6 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -30,6 +30,11 @@ extern void scsi_exit_hosts(void);
 
 /* scsi.c */
 extern bool scsi_use_blk_mq;
+void scsi_free_sense_buffer(struct Scsi_Host *shost,
+		unsigned char *sense_buffer);
+unsigned char *scsi_alloc_sense_buffer(struct Scsi_Host *shost, gfp_t gfp_mask,
+		int numa_node);
+int scsi_init_sense_cache(struct Scsi_Host *shost);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 #ifdef CONFIG_SCSI_LOGGING
-- 
2.1.4

