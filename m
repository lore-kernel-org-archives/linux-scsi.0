From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/16] scsi: remove gfp_flags member in scsi_host_cmd_pool
Date: Mon, 23 Jan 2017 16:29:14 +0100
Message-ID: <1485185361-29786-10-git-send-email-hch@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

When using the slab allocator we already decide at cache creation time if
an allocation comes from a GFP_DMA pool using the SLAB_CACHE_DMA flag,
and there is no point passing the kmalloc-family only GFP_DMA flag to
kmem_cache_alloc.  Drop all the infrastructure for doing so.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 75455d4..0f93892 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -105,7 +105,6 @@ struct scsi_host_cmd_pool {
 	char			*cmd_name;
 	char			*sense_name;
 	unsigned int		slab_flags;
-	gfp_t			gfp_mask;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
@@ -118,7 +117,6 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
 	.cmd_name	= "scsi_cmd_cache(DMA)",
 	.sense_name	= "scsi_sense_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
-	.gfp_mask	= __GFP_DMA,
 };
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
@@ -156,12 +154,11 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 	struct scsi_host_cmd_pool *pool = shost->cmd_pool;
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask);
 	if (!cmd)
 		goto fail;
 
-	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
-					     gfp_mask | pool->gfp_mask);
+	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab, gfp_mask);
 	if (!cmd->sense_buffer)
 		goto fail_free_cmd;
 
@@ -327,10 +324,8 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 	}
 
 	pool->slab_flags = SLAB_HWCACHE_ALIGN;
-	if (shost->unchecked_isa_dma) {
+	if (shost->unchecked_isa_dma)
 		pool->slab_flags |= SLAB_CACHE_DMA;
-		pool->gfp_mask = __GFP_DMA;
-	}
 
 	if (hostt->cmd_size)
 		hostt->cmd_pool = pool;
@@ -424,7 +419,6 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
  */
 int scsi_setup_command_freelist(struct Scsi_Host *shost)
 {
-	const gfp_t gfp_mask = shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL;
 	struct scsi_cmnd *cmd;
 
 	spin_lock_init(&shost->free_list_lock);
@@ -437,7 +431,7 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = scsi_host_alloc_command(shost, gfp_mask);
+	cmd = scsi_host_alloc_command(shost, GFP_KERNEL);
 	if (!cmd) {
 		scsi_put_host_cmd_pool(shost);
 		shost->cmd_pool = NULL;
-- 
2.1.4

