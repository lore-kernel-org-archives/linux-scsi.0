From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 24/24][RFC] scsi: New sense handling
Date: Mon,  4 Feb 2008 20:02:35 +0200
Message-ID: <1202148155-5490-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33341 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYBDSHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:07:38 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  Current code allocates a dma-able sense buffer for every scsi command.
  This is in 99.9% of cases a waste because:
    - Most commands end successfully and do not need any sense space.
    - most LLDs have the sense information already in their private data
      and do not DMA this information. the sense can go directly to ULD's
      buffer.
    - Drivers that do synchronous REQUEST_SENSE through the scs_eh_prep_cmnd
      mechanism need only one dma buffer per target. (contingent allegiance condition)

  This leaves us with a very few drivers that need dma-able sense-buffer pre-allocated
  per-command. These drivers set the .pre_allocate_sense flag in thier host template
  and the mid-layer will make sure a sense buffer is allocated for them.

  So:
  - Removed the global sense mem_cache and sense allocation per command.
  - Add a per-host sense mempool_t of buffer-size specified by host template in
    .sense_buffsize. If .sense_buffsize is not set then no mempool_t is not allocated.
     (Note: This is true for the majority of drivers.)
  - If host does not have .pre_allocate_sense set then a reserved sense buffer is
    allocated per scsi-target (LUN).
  - If host has .pre_allocate_sense set then a sense buffer is allocated in
    get_command() and the code behaves like today.
  - Drivers that need a dma sense buffer call scsi_make_sense()/scsi_return_sense()
    Theses drivers where already converted. Here the implementation will allocate
    the sense buffer from above per-host pool. Subsequent calls to scsi_make_sense()
    will return the same buffer. The first call to scsi_return_sense() will do the
    scsi_eh_cpy_sense(), and return the buffer to free store. Subsequent calls
    will do nothing.
  - The scsi_eh_prep_cmnd()/scsi_eh_return_cmnd() are converted to use the
    scsi_make_sense()/scsi_return_sense(). Since these drivers set for .sense_buffsize
    but with .pre_allocate_sense not set, a pre-allocated sense buffer is guarantied
    per target even in a low memory condition situation.
  - scsi_cmnd->sense_buffer is removed as it is no longer needed. And scsi_eh_cpy_sense()
    Will copy directly to ULD's supplied buffer at request->sense. Not maxing ->sense_max_len
    and setting ->sense_len to copied count. So scsi_lib sense handling code can also be
    removed.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi.c       |  207 ++++++++++++++++++++++++++++++---------------
 drivers/scsi/scsi_error.c |   45 +++++++---
 drivers/scsi/scsi_lib.c   |   15 +---
 drivers/scsi/scsi_priv.h  |    3 +-
 drivers/scsi/scsi_scan.c  |    6 ++
 include/scsi/scsi_cmnd.h  |    5 +-
 include/scsi/scsi_eh.h    |   14 +++-
 include/scsi/scsi_host.h  |    3 +
 8 files changed, 194 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index af29ccc..3f1bb9d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -132,24 +132,20 @@ const char * scsi_device_type(unsigned type)
 EXPORT_SYMBOL(scsi_device_type);
 
 struct scsi_host_cmd_pool {
-	struct kmem_cache	*cmd_slab;
-	struct kmem_cache	*sense_slab;
-	unsigned int		users;
-	char			*cmd_name;
-	char			*sense_name;
-	unsigned int		slab_flags;
-	gfp_t			gfp_mask;
+	struct kmem_cache	*slab;
+	unsigned int	users;
+	char		*name;
+	unsigned int	slab_flags;
+	gfp_t		gfp_mask;
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.cmd_name	= "scsi_cmd_cache",
-	.sense_name	= "scsi_sense_cache",
+	.name		= "scsi_cmd_cache",
 	.slab_flags	= SLAB_HWCACHE_ALIGN,
 };
 
 static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
-	.cmd_name	= "scsi_cmd_cache(DMA)",
-	.sense_name	= "scsi_sense_cache(DMA)",
+	.name		= "scsi_cmd_cache(DMA)",
 	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
 	.gfp_mask	= __GFP_DMA,
 };
@@ -167,10 +163,9 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
-	unsigned char *buf;
 
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       gfp_mask | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
+			gfp_mask | shost->cmd_pool->gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -182,22 +177,6 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			list_del_init(&cmd->list);
 		}
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
-
-		if (cmd) {
-			buf = cmd->sense_buffer;
-			memset(cmd, 0, sizeof(*cmd));
-			cmd->sense_buffer = buf;
-		}
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
@@ -224,6 +203,7 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
 
+		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
@@ -231,6 +211,16 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 		list_add_tail(&cmd->list, &dev->cmd_list);
 		spin_unlock_irqrestore(&dev->list_lock, flags);
 		cmd->jiffies_at_alloc = jiffies;
+
+		if (cmd->device->host->hostt->pre_allocate_sense) {
+			u8 *sb;
+
+			sb = scsi_make_sense(cmd);
+			if (unlikely(!sb)) {
+				scsi_put_command(cmd);
+				cmd = NULL;
+			}
+		}
 	} else
 		put_device(&dev->sdev_gendev);
 
@@ -258,9 +248,11 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 	if (likely(cmd != NULL)) {
-		kmem_cache_free(shost->cmd_pool->sense_slab,
-				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+		if (cmd->dma_sense_check) {
+			WARN_ON(1); /* driver did not call scsi_return_sense */
+			scsi_return_sense(cmd, cmd->dma_sense_check);
+		}
+		kmem_cache_free(shost->cmd_pool->slab, cmd);
 	}
 
 	put_device(dev);
@@ -290,15 +282,106 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_put_command);
 
+static int scsi_setup_sense_pool(struct Scsi_Host *shost)
+{
+	if (!shost->sense_buffsize && shost->hostt->sense_buffsize)
+		shost->sense_buffsize = shost->hostt->sense_buffsize;
+	else if (!shost->hostt->sense_buffsize)
+		return 0; /* Host doesn't need a sense_pool */
+
+	shost->sense_slab = kmem_cache_create(shost->hostt->name,
+		shost->sense_buffsize, 0, shost->cmd_pool->slab_flags, NULL);
+	if (!shost->sense_slab) {
+		printk(KERN_ERR "SCSI: can't init sense_slab %s\n",
+				shost->hostt->name);
+		return -ENOMEM;
+	}
+
+	shost->sense_pool = mempool_create_slab_pool(1, shost->sense_slab);
+	if (!shost->sense_pool) {
+		printk(KERN_ERR "SCSI: can't init sense_pool %s\n",
+				shost->hostt->name);
+		kmem_cache_destroy(shost->sense_slab);
+		shost->sense_slab = NULL;
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void scsi_destroy_sense_pool(struct Scsi_Host *shost)
+{
+	if (shost->sense_pool)
+		mempool_destroy(shost->sense_pool);
+	shost->sense_pool = NULL;
+	if (shost->sense_slab)
+		kmem_cache_destroy(shost->sense_slab);
+	shost->sense_slab = NULL;
+}
+
+int scsi_resize_sense_pool(struct Scsi_Host *shost, int inc_dec)
+{
+	if (inc_dec > 0) {
+		u8 *sense_per_queue;
+
+		if (mempool_resize(shost->sense_pool,
+			shost->sense_pool->min_nr + 1, GFP_KERNEL))
+				goto out;
+		/* Resize might not guaranty reserved allocation.
+		 * This here will
+		 */
+		sense_per_queue = mempool_alloc(shost->sense_pool,
+					shost->cmd_pool->gfp_mask | GFP_KERNEL);
+		if (!sense_per_queue) {
+			mempool_resize(shost->sense_pool,
+				shost->sense_pool->min_nr - 1,
+				shost->cmd_pool->gfp_mask | GFP_KERNEL);
+			goto out;
+		}
+		mempool_free(sense_per_queue, shost->sense_pool);
+	} else
+		mempool_resize(shost->sense_pool,
+			shost->sense_pool->min_nr - 1,
+			shost->cmd_pool->gfp_mask | GFP_KERNEL);
+	return 0;
+
+out:
+	return -ENOMEM;
+}
+
 u8 *scsi_make_sense(struct scsi_cmnd *cmd)
 {
-	return cmd->sense_buffer;
+	if (!cmd->dma_sense_check) {
+		struct Scsi_Host *shost = cmd->device->host;
+		if (!shost->sense_pool) {
+			/* did you not set .sense_buffsize in host template */
+			WARN_ON(1);
+			shost->sense_buffsize = SCSI_SENSE_BUFFERSIZE;
+			scsi_setup_sense_pool(shost);
+			BUG_ON(!shost->sense_pool);
+		}
+
+		cmd->dma_sense_check =
+			mempool_alloc(shost->sense_pool,
+						shost->cmd_pool->gfp_mask);
+		if (cmd->dma_sense_check)
+			memset(cmd->dma_sense_check, 0, shost->sense_buffsize);
+	}
+	return cmd->dma_sense_check;
 }
 EXPORT_SYMBOL(scsi_make_sense);
 
 void scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb)
 {
-	BUG_ON(cmd->sense_buffer != sb);
+	struct Scsi_Host *shost = cmd->device->host;
+
+	if (!cmd->dma_sense_check) /* reentrant */
+		return;
+
+	BUG_ON(cmd->dma_sense_check != sb);
+
+	scsi_eh_cpy_sense(cmd, sb, shost->sense_buffsize);
+	cmd->dma_sense_check = NULL;
+	mempool_free(sb, shost->sense_pool);
 }
 EXPORT_SYMBOL(scsi_return_sense);
 
@@ -327,50 +410,36 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
 	if (!pool->users) {
-		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
-						   sizeof(struct scsi_cmnd), 0,
-						   pool->slab_flags, NULL);
-		if (!pool->cmd_slab)
+		pool->slab = kmem_cache_create(pool->name,
+				sizeof(struct scsi_cmnd), 0,
+				pool->slab_flags, NULL);
+		if (!pool->slab)
 			goto fail;
-
-		pool->sense_slab = kmem_cache_create(pool->sense_name,
-						     SCSI_SENSE_BUFFERSIZE, 0,
-						     pool->slab_flags, NULL);
-		if (!pool->sense_slab) {
-			kmem_cache_destroy(pool->cmd_slab);
-			goto fail;
-		}
 	}
 
 	pool->users++;
 	shost->cmd_pool = pool;
 	mutex_unlock(&host_cmd_pool_mutex);
 
+	if (scsi_setup_sense_pool(shost))
+		goto fail2;
+
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = kmem_cache_alloc(shost->cmd_pool->cmd_slab,
-			       GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
+			GFP_KERNEL | shost->cmd_pool->gfp_mask);
 	if (!cmd)
-		goto fail2;
-
-	cmd->sense_buffer = kmem_cache_alloc(shost->cmd_pool->sense_slab,
-					     GFP_KERNEL |
-					     shost->cmd_pool->gfp_mask);
-	if (!cmd->sense_buffer)
-		goto fail2;
-
+		goto fail3;
 	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
+ fail3:
+	scsi_destroy_sense_pool(shost);
  fail2:
-	if (cmd)
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
 	mutex_lock(&host_cmd_pool_mutex);
-	if (!--pool->users) {
-		kmem_cache_destroy(pool->cmd_slab);
-		kmem_cache_destroy(pool->sense_slab);
-	}
+	if (!--pool->users)
+		kmem_cache_destroy(pool->slab);
  fail:
 	mutex_unlock(&host_cmd_pool_mutex);
 	return -ENOMEM;
@@ -387,16 +456,14 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 
 		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
 		list_del_init(&cmd->list);
-		kmem_cache_free(shost->cmd_pool->sense_slab,
-				cmd->sense_buffer);
-		kmem_cache_free(shost->cmd_pool->cmd_slab, cmd);
+		kmem_cache_free(shost->cmd_pool->slab, cmd);
 	}
 
+	scsi_destroy_sense_pool(shost);
+
 	mutex_lock(&host_cmd_pool_mutex);
-	if (!--shost->cmd_pool->users) {
-		kmem_cache_destroy(shost->cmd_pool->cmd_slab);
-		kmem_cache_destroy(shost->cmd_pool->sense_slab);
-	}
+	if (!--shost->cmd_pool->users)
+		kmem_cache_destroy(shost->cmd_pool->slab);
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index dc8cd2b..ed7a49d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -299,6 +299,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_sense_hdr sshdr;
+	const u8 *sense;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
@@ -306,13 +307,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
+	sense = scsi_sense(scmd);
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
 	 */
 	if (sshdr.response_code == 0x70) {
 		/* fixed format */
-		if (scmd->sense_buffer[2] & 0xe0)
+		if (sense[2] & 0xe0)
 			return SUCCESS;
 	} else {
 		/*
@@ -321,8 +323,8 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 * descriptor. Ignore ILI from SBC-2 READ LONG and WRITE LONG.
 		 */
 		if ((sshdr.additional_length > 3) &&
-		    (scmd->sense_buffer[8] == 0x4) &&
-		    (scmd->sense_buffer[11] & 0xe0))
+		    (sense[8] == 0x4) &&
+		    (sense[11] & 0xe0))
 			return SUCCESS;
 	}
 
@@ -590,8 +592,18 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 
 void scsi_eh_cpy_sense(struct scsi_cmnd *cmd, void *sense, unsigned sense_bytes)
 {
-	unsigned len = min_t(unsigned, sense_bytes, SCSI_SENSE_BUFFERSIZE);
-	memcpy(cmd->sense_buffer, sense, len);
+	u8 *sb = sense;
+	unsigned len = min_t(unsigned, sense_bytes,
+						cmd->request->sense_max_len);
+	if (len > 7)
+		len = min_t(unsigned, len, 8 + sb[7]);
+
+	memcpy(cmd->request->sense, sense, len);
+
+	if (len < cmd->request->sense_max_len)
+		memset(cmd->request->sense + len, 0,
+			cmd->request->sense_max_len - len);
+	cmd->request->sense_len = len;
 }
 EXPORT_SYMBOL(scsi_eh_cpy_sense);
 
@@ -627,6 +639,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->sdb = scmd->sdb;
 	ses->next_rq = scmd->request->next_rq;
 	ses->result = scmd->result;
+	ses->sense_buff = NULL;
 
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
@@ -634,9 +647,17 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	scmd->request->next_rq = NULL;
 
 	if (sense_bytes) {
-		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
+		ses->sense_buff = scsi_make_sense(scmd);
+		/*
+		 * properly templated LLD will not fail here.
+		 * Did you set your .sense_buffsize in host template?
+		 * either that or you're reentering scsi_eh_prep_cmnd()
+		 * which is not allowed.
+		 */
+		BUG_ON(!ses->sense_buff);
+		scmd->sdb.length = min_t(unsigned, sdev->host->sense_buffsize,
 					 sense_bytes);
-		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
+		sg_init_one(&ses->sense_sgl, ses->sense_buff,
 			    scmd->sdb.length);
 		scmd->sdb.table.sgl = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
@@ -659,11 +680,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
 
-	/*
-	 * Zero the sense buffer.  The scsi spec mandates that any
-	 * untransferred sense data should be interpreted as being zero.
-	 */
-	memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	scsi_eh_reset_sense(scmd);
 }
 EXPORT_SYMBOL(scsi_eh_prep_cmnd);
 
@@ -676,6 +693,8 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  */
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
+	if (ses->sense_buff)
+		scsi_return_sense(scmd, ses->sense_buff);
 	/*
 	 * Restore original data
 	 */
@@ -1823,7 +1842,7 @@ EXPORT_SYMBOL(scsi_normalize_sense);
 int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 				 struct scsi_sense_hdr *sshdr)
 {
-	return scsi_normalize_sense(cmd->sense_buffer,
+	return scsi_normalize_sense(scsi_sense(cmd),
 			SCSI_SENSE_BUFFERSIZE, sshdr);
 }
 EXPORT_SYMBOL(scsi_command_normalize_sense);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3720b4e..e9f5a88 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -452,7 +452,7 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = 0;
 	scsi_set_resid(cmd, 0);
-	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	scsi_eh_reset_sense(cmd);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 }
@@ -861,20 +861,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
 		req->errors = result;
-		if (result) {
+		if (result)
 			clear_errors = 0;
-			if (sense_valid && req->sense) {
-				/*
-				 * SG_IO wants current and deferred errors
-				 */
-				int len = 8 + cmd->sense_buffer[7];
 
-				if (len > SCSI_SENSE_BUFFERSIZE)
-					len = SCSI_SENSE_BUFFERSIZE;
-				memcpy(req->sense, cmd->sense_buffer,  len);
-				req->sense_len = len;
-			}
-		}
 		if (scsi_bidi_cmnd(cmd)) {
 			/* will also release_buffers */
 			scsi_end_bidi_request(cmd);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f34e93..b64681e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -17,7 +17,7 @@ struct scsi_nl_hdr;
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
 
 #define SCSI_SENSE_VALID(scmd) \
-	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
+	((scsi_sense(scmd)[0] & 0x70) == 0x70)
 
 /* hosts.c */
 extern int scsi_init_hosts(void);
@@ -37,6 +37,7 @@ static inline void scsi_log_send(struct scsi_cmnd *cmd)
 static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 	{ };
 #endif
+extern int scsi_resize_sense_pool(struct Scsi_Host *shost, int inc_dec);
 
 /* scsi_scan.c */
 int scsi_complete_async_scans(void);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1dc165a..3c151f2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -311,6 +311,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		}
 	}
 
+	if (!shost->hostt->pre_allocate_sense &&
+					scsi_resize_sense_pool(shost, 1))
+		goto out_device_destroy;
+
 	return sdev;
 
 out_device_destroy:
@@ -922,6 +926,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 static inline void scsi_destroy_sdev(struct scsi_device *sdev)
 {
 	scsi_device_set_state(sdev, SDEV_DEL);
+	if (!sdev->host->hostt->pre_allocate_sense)
+		scsi_resize_sense_pool(sdev->host, -1);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 000a544..a3e535a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -88,10 +88,7 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
-	unsigned char *sense_buffer;
-				/* obtained by REQUEST SENSE when
-				 * CHECK CONDITION is received on original
-				 * command (auto-sense) */
+	u8 *dma_sense_check;
 
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 97a6180..c547900 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -4,7 +4,6 @@
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi.h>
 struct scsi_device;
 struct Scsi_Host;
 
@@ -79,6 +78,7 @@ struct scsi_eh_save {
 	/* new command support */
 	unsigned char eh_cmnd[BLK_MAX_CDB];
 	struct scatterlist sense_sgl;
+	u8 *sense_buff;
 };
 
 extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
@@ -97,12 +97,20 @@ extern void scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb);
 /*FIXME: don't use, it's temporary */
 static inline void scsi_eh_reset_sense(struct scsi_cmnd *cmd)
 {
-	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	memset(cmd->request->sense, 0, cmd->request->sense_max_len);
 }
 
 static inline const u8 *scsi_sense(struct scsi_cmnd *cmd)
 {
-	return cmd->sense_buffer;
+	if (cmd->dma_sense_check) {
+		/* Betwwen the call to scsi_make_sense()
+		 * and scsi_return_sense()
+		 */
+		WARN_ON(1);
+		return cmd->dma_sense_check;
+	}
+
+	return cmd->request->sense;
 }
 
 #endif /* _SCSI_SCSI_EH_H */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f232768..747e372 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/mempool.h>
 
 struct request_queue;
 struct block_device;
@@ -623,6 +624,8 @@ struct Scsi_Host {
 
 	/* actual allocated sense_buffsize for this host */
 	unsigned sense_buffsize;
+	struct kmem_cache *sense_slab;
+	mempool_t *sense_pool;
 
 	/*
 	 * Optional work queue to be utilized by the transport
-- 
1.5.3.3

