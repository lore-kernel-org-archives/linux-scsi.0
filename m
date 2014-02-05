From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/17] scsi: remove scsi_allocate_command/scsi_free_command
Date: Wed, 05 Feb 2014 04:39:33 -0800
Message-ID: <20140205124019.384542106@bombadil.infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaBEMkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:25 -0500
Content-Disposition: inline; filename=0003-scsi-remove-scsi_allocate_command-scsi_free_command.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

All users are gone, so we can get rid of these.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c      |   56 ----------------------------------------------
 include/scsi/scsi_cmnd.h |    3 ---
 2 files changed, 59 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..ebcea6c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -415,62 +415,6 @@ static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
 }
 
 /**
- * scsi_allocate_command - get a fully allocated SCSI command
- * @gfp_mask:	allocation mask
- *
- * This function is for use outside of the normal host based pools.
- * It allocates the relevant command and takes an additional reference
- * on the pool it used.  This function *must* be paired with
- * scsi_free_command which also has the identical mask, otherwise the
- * free pool counts will eventually go wrong and you'll trigger a bug.
- *
- * This function should *only* be used by drivers that need a static
- * command allocation at start of day for internal functions.
- */
-struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask)
-{
-	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
-
-	if (!pool)
-		return NULL;
-
-	return scsi_pool_alloc_command(pool, gfp_mask);
-}
-EXPORT_SYMBOL(scsi_allocate_command);
-
-/**
- * scsi_free_command - free a command allocated by scsi_allocate_command
- * @gfp_mask:	mask used in the original allocation
- * @cmd:	command to free
- *
- * Note: using the original allocation mask is vital because that's
- * what determines which command pool we use to free the command.  Any
- * mismatch will cause the system to BUG eventually.
- */
-void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd)
-{
-	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
-
-	/*
-	 * this could trigger if the mask to scsi_allocate_command
-	 * doesn't match this mask.  Otherwise we're guaranteed that this
-	 * succeeds because scsi_allocate_command must have taken a reference
-	 * on the pool
-	 */
-	BUG_ON(!pool);
-
-	scsi_pool_free_command(pool, cmd);
-	/*
-	 * scsi_put_host_cmd_pool is called twice; once to release the
-	 * reference we took above, and once to release the reference
-	 * originally taken by scsi_allocate_command
-	 */
-	scsi_put_host_cmd_pool(gfp_mask);
-	scsi_put_host_cmd_pool(gfp_mask);
-}
-EXPORT_SYMBOL(scsi_free_command);
-
-/**
  * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
  * @shost: host to allocate the freelist for.
  *
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 91558a1..dff105a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -156,9 +156,6 @@ extern void scsi_release_buffers(struct scsi_cmnd *cmd);
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
-void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
-
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
 	return cmd->sdb.table.nents;
-- 
1.7.10.4


