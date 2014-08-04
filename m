From: jgross@suse.com
Subject: [PATCH V3] Save command pool address of Scsi_Host
Date: Mon,  4 Aug 2014 06:26:09 +0200
Message-ID: <1407126369-16543-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaHDE0O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2014 00:26:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>

From: Juergen Gross <jgross@suse.com>

If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.

This will result in an access error when the host is removed.

Avoid the problem by saving the address of a new allocated command pool where
it is expected and delete it again when the pool is destroyed.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/scsi.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..11ea502 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -351,11 +351,12 @@ scsi_find_host_cmd_pool(struct Scsi_Host *shost)
 }
 
 static void
-scsi_free_host_cmd_pool(struct scsi_host_cmd_pool *pool)
+scsi_free_host_cmd_pool(struct scsi_host_cmd_pool **pool)
 {
-	kfree(pool->sense_name);
-	kfree(pool->cmd_name);
-	kfree(pool);
+	kfree(pool[0]->sense_name);
+	kfree(pool[0]->cmd_name);
+	kfree(pool[0]);
+	pool[0] = NULL;
 }
 
 static struct scsi_host_cmd_pool *
@@ -371,7 +372,7 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
 	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->name);
 	if (!pool->cmd_name || !pool->sense_name) {
-		scsi_free_host_cmd_pool(pool);
+		scsi_free_host_cmd_pool(&pool);
 		return NULL;
 	}
 
@@ -380,6 +381,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 		pool->slab_flags |= SLAB_CACHE_DMA;
 		pool->gfp_mask = __GFP_DMA;
 	}
+
+	if (hostt->cmd_size)
+		hostt->cmd_pool = pool;
+
 	return pool;
 }
 
@@ -425,7 +430,7 @@ out_free_slab:
 	kmem_cache_destroy(pool->cmd_slab);
 out_free_pool:
 	if (hostt->cmd_size)
-		scsi_free_host_cmd_pool(pool);
+		scsi_free_host_cmd_pool(&hostt->cmd_pool);
 	goto out;
 }
 
@@ -448,7 +453,7 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
 		kmem_cache_destroy(pool->cmd_slab);
 		kmem_cache_destroy(pool->sense_slab);
 		if (hostt->cmd_size)
-			scsi_free_host_cmd_pool(pool);
+			scsi_free_host_cmd_pool(&hostt->cmd_pool);
 	}
 	mutex_unlock(&host_cmd_pool_mutex);
 }
-- 
1.8.4.5

