From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v2 04/10] scsi: allocate scsi_cmnd-s from the device's local numa node
Date: Fri,  2 Nov 2012 17:45:57 -0400
Message-ID: <1351892763-21325-5-git-send-email-jmoyer@redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/scsi.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..4db6973 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -173,16 +173,20 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
  * NULL on failure
  */
 static struct scsi_cmnd *
-scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
+scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask,
+			int node)
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	cmd = kmem_cache_alloc_node(pool->cmd_slab,
+				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
+				    node);
 	if (!cmd)
 		return NULL;
 
-	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
-					     gfp_mask | pool->gfp_mask);
+	cmd->sense_buffer = kmem_cache_alloc_node(pool->sense_slab,
+					gfp_mask | pool->gfp_mask | __GFP_ZERO,
+					node);
 	if (!cmd->sense_buffer) {
 		kmem_cache_free(pool->cmd_slab, cmd);
 		return NULL;
@@ -223,7 +227,8 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
+	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask,
+				      shost->numa_node);
 	if (!cmd)
 		return NULL;
 
@@ -435,7 +440,7 @@ struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask)
 	if (!pool)
 		return NULL;
 
-	return scsi_pool_alloc_command(pool, gfp_mask);
+	return scsi_pool_alloc_command(pool, gfp_mask, NUMA_NO_NODE);
 }
 EXPORT_SYMBOL(scsi_allocate_command);
 
-- 
1.7.1
