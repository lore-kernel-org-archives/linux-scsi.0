From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/4] scsi_free_command API change - Don't support GFP_DMA
Date: Thu, 01 May 2008 16:56:06 +0300
Message-ID: <4819CBF6.2070105@panasas.com>
References: <4819C9DB.60104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14465 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbYEAN4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 09:56:22 -0400
In-Reply-To: <4819C9DB.60104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>


Support of GFP_DMA for scsi_cmnd is going away. Don't let new
users get used to it. (None of the potential users need it)
Change that now before it has any users.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi.c      |   23 +++++++++--------------
 include/scsi/scsi_cmnd.h |    4 ++--
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 749c9c7..a120c04 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -386,13 +386,13 @@ static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
 
 /**
  * scsi_allocate_command - get a fully allocated SCSI command
- * @gfp_mask:	allocation mask
+ * @gfp_mask:	allocation mask (must not be __GFP_DMA)
  *
  * This function is for use outside of the normal host based pools.
- * It allocates the relevant command and takes an additional reference
- * on the pool it used.  This function *must* be paired with
- * scsi_free_command which also has the identical mask, otherwise the
- * free pool counts will eventually go wrong and you'll trigger a bug.
+ * It allocates a command and takes an additional reference on the
+ * pool. This function *must* be paired with scsi_free_command
+ * otherwise the free pool counts will eventually go wrong and will
+ * not be de-allocated.
  *
  * This function should *only* be used by drivers that need a static
  * command allocation at start of day for internal functions.
@@ -410,16 +410,11 @@ EXPORT_SYMBOL(scsi_allocate_command);
 
 /**
  * scsi_free_command - free a command allocated by scsi_allocate_command
- * @gfp_mask:	mask used in the original allocation
  * @cmd:	command to free
- *
- * Note: using the original allocation mask is vital because that's
- * what determines which command pool we use to free the command.  Any
- * mismatch will cause the system to BUG eventually.
  */
-void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd)
+void scsi_free_command(struct scsi_cmnd *cmd)
 {
-	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(gfp_mask);
+	struct scsi_host_cmd_pool *pool = scsi_get_host_cmd_pool(0);
 
 	/*
 	 * this could trigger if the mask to scsi_allocate_command
@@ -435,8 +430,8 @@ void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd)
 	 * reference we took above, and once to release the reference
 	 * originally taken by scsi_allocate_command
 	 */
-	scsi_put_host_cmd_pool(gfp_mask);
-	scsi_put_host_cmd_pool(gfp_mask);
+	scsi_put_host_cmd_pool(0);
+	scsi_put_host_cmd_pool(0);
 }
 EXPORT_SYMBOL(scsi_free_command);
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8d20e60..2ebd52e 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -130,8 +130,8 @@ extern void scsi_release_buffers(struct scsi_cmnd *cmd);
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
-void scsi_free_command(gfp_t gfp_mask, struct scsi_cmnd *cmd);
+extern struct scsi_cmnd *scsi_allocate_command(gfp_t gfp_mask);
+extern void scsi_free_command(struct scsi_cmnd *cmd);
 
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
-- 
1.5.3.3


