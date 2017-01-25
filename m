From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/18] scsi: remove scsi_cmd_dma_pool
Date: Wed, 25 Jan 2017 18:25:21 +0100
Message-ID: <1485365126-23210-14-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54266 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdAYR0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 12:26:08 -0500
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

There is no need for GFP_DMA allocations of the scsi_cmnd structures
themselves, all that might be DMAed to or from is the actual payload,
or the sense buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 469aa0f..2e24f31 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -102,17 +102,10 @@ struct scsi_host_cmd_pool {
 	struct kmem_cache	*cmd_slab;
 	unsigned int		users;
 	char			*cmd_name;
-	unsigned int		slab_flags;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
 	.cmd_name	= "scsi_cmd_cache",
-	.slab_flags	= SLAB_HWCACHE_ALIGN,
-};
-
-static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.cmd_name	= "scsi_cmd_cache(DMA)",
-	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 };
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
@@ -290,8 +283,6 @@ scsi_find_host_cmd_pool(struct Scsi_Host *shost)
 {
 	if (shost->hostt->cmd_size)
 		return shost->hostt->cmd_pool;
-	if (shost->unchecked_isa_dma)
-		return &scsi_cmd_dma_pool;
 	return &scsi_cmd_pool;
 }
 
@@ -318,10 +309,6 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 		return NULL;
 	}
 
-	pool->slab_flags = SLAB_HWCACHE_ALIGN;
-	if (shost->unchecked_isa_dma)
-		pool->slab_flags |= SLAB_CACHE_DMA;
-
 	if (hostt->cmd_size)
 		hostt->cmd_pool = pool;
 
@@ -349,7 +336,7 @@ scsi_get_host_cmd_pool(struct Scsi_Host *shost)
 
 	if (!pool->users) {
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name, cmd_size, 0,
-						   pool->slab_flags, NULL);
+						   SLAB_HWCACHE_ALIGN, NULL);
 		if (!pool->cmd_slab)
 			goto out_free_pool;
 	}
-- 
2.1.4

