From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] consolidate command allocation in a single place
Date: Mon, 17 Mar 2008 13:25:39 -0500
Message-ID: <1205778339.6767.160.camel@localhost.localdomain>
References: <1205427192.2893.22.camel@localhost.localdomain>
	 <20080313170924.GK613@parisc-linux.org>
	 <1205428542.2893.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46828 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYCQSZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 14:25:44 -0400
In-Reply-To: <1205428542.2893.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

On Thu, 2008-03-13 at 12:15 -0500, James Bottomley wrote:
> On Thu, 2008-03-13 at 11:09 -0600, Matthew Wilcox wrote:
> > On Thu, Mar 13, 2008 at 11:53:11AM -0500, James Bottomley wrote:
> > > Since the way we allocate commands with a separate sense buffer is
> > > getting complicated, we should isolate setup and teardown to a single
> > > routine so that if it gets even more complex, there's only one place
> > > in the code that needs to be altered.
> > 
> > > +static struct scsi_cmnd *
> > > +scsi_get_command_from_pool(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> > > +static void
> > > +scsi_put_command_to_pool(struct scsi_host_cmd_pool *pool,
> > > +			 struct scsi_cmnd *cmd)
> > 
> > The names are a bit clunky ... 'put command to pool'?  How about
> > alloc/free instead of get/put?  or:
> > 
> > scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> > scsi_pool_free_command(struct scsi_host_cmd_pool *pool, struct scsi_cmnd *cmd)
> > 
> > or even:
> > 
> > scsi_command_pool_alloc(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> > scsi_command_pool_free(struct scsi_host_cmd_pool *pool, struct scsi_cmnd *cmd)
> > 
> > (i also wouldn't object to use 'cmnd' or 'cmd' in place of 'command').
> 
> Yes, but it's following the naming convention in the file.  OK, I don't
> like it as well, that's why the new functions in the following patch
> have alloc/free.

Actually, I reconsidered this.  Since I don't use the get/put
terminology in the second patch, it really doesn't make sense to stick
with it in the first one.  The naming convention still seems to be
scsi_<action>_command, so I picked

scsi_pool_alloc_command
scsi_pool_free_command

I also swept up one last place where the kmem_cache_allocs were being
used in the destroy freelist.

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 13 Mar 2008 11:16:33 -0500
Subject: consolidate command allocation in a single place

Since the way we allocate commands with a separate sense buffer is
getting complicated, we should isolate setup and teardown to a single
routine so that if it gets even more complex, there's only one place
in the code that needs to be altered.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi.c |   80 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e5c6f6a..2cf9a62 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -166,6 +166,51 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
 /**
+ * scsi_pool_alloc_command - internal function to get a fully allocated command
+ * @pool:	slab pool to allocate the command from
+ * @gfp_mask:	mask for the allocation
+ *
+ * Returns a fully allocated command (with the allied sense buffer) or
+ * NULL on failure
+ */
+static struct scsi_cmnd *
+scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
+{
+	struct scsi_cmnd *cmd;
+
+	cmd = kmem_cache_alloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	if (!cmd)
+		return NULL;
+
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
+					     gfp_mask | pool->gfp_mask);
+	if (!cmd->sense_buffer) {
+		kmem_cache_free(pool->cmd_slab, cmd);
+		return NULL;
+	}
+
+	return cmd;
+}
+
+/**
+ * scsi_pool_free_command - internal function to release a command
+ * @pool:	slab pool to allocate the command from
+ * @cmd:	command to release
+ *
+ * the command must previously have been allocated by
+ * scsi_pool_alloc_command.
+ */
+static void
+scsi_pool_free_command(struct scsi_host_cmd_pool *pool,
+			 struct scsi_cmnd *cmd)
+{
+	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
+	kmem_cache_free(pool->cmd_slab, cmd);
+}
+
+/**
  * __scsi_get_command - Allocate a struct scsi_cmnd
  * @shost: host to transmit command
  * @gfp_mask: allocation mask
@@ -178,8 +223,7 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 	struct scsi_cmnd *cmd;
 	unsigned char *buf;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       gfp_mask | shost->cmd_pool->gfp_mask);
+	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -197,16 +241,6 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			memset(cmd, 0, sizeof(*cmd));
 			cmd->sense_buffer = buf;
 		}
-	} else {
-		buf = kmem_cache_alloc(shost->cmd_pool->sense_slab,
-				       gfp_mask | shost->cmd_pool->gfp_mask);
-		if (likely(buf)) {
-			memset(cmd, 0, sizeof(*cmd));
-			cmd->sense_buffer = buf;
-		} else {
-			kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
-			cmd = NULL;
-		}
 	}
 
 	return cmd;
@@ -266,11 +300,8 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	}
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-	if (likely(cmd != NULL)) {
-		kmem_cache_free(shost->cmd_pool->sense_slab,
-				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
-	}
+	if (likely(cmd != NULL))
+		scsi_pool_free_command(shost->cmd_pool, cmd);
 
 	put_device(dev);
 }
@@ -346,23 +377,14 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	cmd = scsi_pool_alloc_command(shost->cmd_pool, GFP_KERNEL);
 	if (!cmd)
 		goto fail2;
 
-	cmd->sense_buffer = kmem_cache_alloc(shost->cmd_pool->sense_slab,
-					     GFP_KERNEL |
-					     shost->cmd_pool->gfp_mask);
-	if (!cmd->sense_buffer)
-		goto fail2;
-
 	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
  fail2:
-	if (cmd)
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	mutex_lock(&host_cmd_pool_mutex);
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
@@ -384,9 +406,7 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 
 		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
 		list_del_init(&cmd->list);
-		kmem_cache_free(shost->cmd_pool->sense_slab,
-				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+		scsi_pool_free_command(shost->cmd_pool, cmd);
 	}
 
 	mutex_lock(&host_cmd_pool_mutex);
-- 
1.5.4.3



