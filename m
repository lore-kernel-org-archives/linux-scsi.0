From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/15] scsi: allocate scsi_cmnd structures as part of struct request
Date: Tue, 10 Jan 2017 16:06:18 +0100
Message-ID: <1484060780-15592-14-git-send-email-hch@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53560 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758172AbdAJPHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 10:07:04 -0500
In-Reply-To: <1484060780-15592-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Rely on the new block layer functionality to allocate additional driver
specific data behind struct request instead of implementing it in SCSI
itѕelf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hosts.c      |  20 +--
 drivers/scsi/scsi.c       | 319 ----------------------------------------------
 drivers/scsi/scsi_error.c |  17 ++-
 drivers/scsi/scsi_lib.c   | 122 ++++++++++++------
 drivers/scsi/scsi_priv.h  |   8 +-
 include/scsi/scsi_host.h  |   3 -
 6 files changed, 95 insertions(+), 394 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6d29c4a..831a1c8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -230,19 +230,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		}
 	}
 
-	/*
-	 * Note that we allocate the freelist even for the MQ case for now,
-	 * as we need a command set aside for scsi_reset_provider.  Having
-	 * the full host freelist and one command available for that is a
-	 * little heavy-handed, but avoids introducing a special allocator
-	 * just for this.  Eventually the structure of scsi_reset_provider
-	 * will need a major overhaul.
-	 */
-	error = scsi_setup_command_freelist(shost);
-	if (error)
-		goto out_destroy_tags;
-
-
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
 	if (!dma_dev)
@@ -262,7 +249,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	error = device_add(&shost->shost_gendev);
 	if (error)
-		goto out_destroy_freelist;
+		goto out_disable_runtime_pm;
 
 	scsi_host_set_state(shost, SHOST_RUNNING);
 	get_device(shost->shost_gendev.parent);
@@ -312,13 +299,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	device_del(&shost->shost_dev);
  out_del_gendev:
 	device_del(&shost->shost_gendev);
- out_destroy_freelist:
+ out_disable_runtime_pm:
 	device_disable_async_suspend(&shost->shost_gendev);
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
-	scsi_destroy_command_freelist(shost);
- out_destroy_tags:
 	if (shost_use_blk_mq(shost))
 		scsi_mq_destroy_tags(shost);
  fail:
@@ -359,7 +344,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-	scsi_destroy_command_freelist(shost);
 	if (shost_use_blk_mq(shost)) {
 		if (shost->tag_set.tags)
 			scsi_mq_destroy_tags(shost);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2e24f31..3d8d215 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -98,163 +98,6 @@ EXPORT_SYMBOL(scsi_sd_probe_domain);
 ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain);
 EXPORT_SYMBOL(scsi_sd_pm_domain);
 
-struct scsi_host_cmd_pool {
-	struct kmem_cache	*cmd_slab;
-	unsigned int		users;
-	char			*cmd_name;
-};
-
-static struct scsi_host_cmd_pool scsi_cmd_pool = {
-	.cmd_name	= "scsi_cmd_cache",
-};
-
-static DEFINE_MUTEX(host_cmd_pool_mutex);
-
-/**
- * scsi_host_free_command - internal function to release a command
- * @shost:	host to free the command for
- * @cmd:	command to release
- *
- * the command must previously have been allocated by
- * scsi_host_alloc_command.
- */
-static void
-scsi_host_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	struct scsi_host_cmd_pool *pool = shost->cmd_pool;
-
-	if (cmd->prot_sdb)
-		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
-	scsi_free_sense_buffer(shost, cmd->sense_buffer);
-	kmem_cache_free(pool->cmd_slab, cmd);
-}
-
-/**
- * scsi_host_alloc_command - internal function to allocate command
- * @shost:	SCSI host whose pool to allocate from
- * @gfp_mask:	mask for the allocation
- *
- * Returns a fully allocated command with sense buffer and protection
- * data buffer (where applicable) or NULL on failure
- */
-static struct scsi_cmnd *
-scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
-{
-	struct scsi_host_cmd_pool *pool = shost->cmd_pool;
-	struct scsi_cmnd *cmd;
-
-	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask);
-	if (!cmd)
-		goto fail;
-
-	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp_mask,
-			NUMA_NO_NODE);
-	if (!cmd->sense_buffer)
-		goto fail_free_cmd;
-
-	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
-		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);
-		if (!cmd->prot_sdb)
-			goto fail_free_sense;
-	}
-
-	return cmd;
-
-fail_free_sense:
-	scsi_free_sense_buffer(shost, cmd->sense_buffer);
-fail_free_cmd:
-	kmem_cache_free(pool->cmd_slab, cmd);
-fail:
-	return NULL;
-}
-
-/**
- * __scsi_get_command - Allocate a struct scsi_cmnd
- * @shost: host to transmit command
- * @gfp_mask: allocation mask
- *
- * Description: allocate a struct scsi_cmd from host's slab, recycling from the
- *              host's free_list if necessary.
- */
-static struct scsi_cmnd *
-__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
-{
-	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
-
-	if (unlikely(!cmd)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&shost->free_list_lock, flags);
-		if (likely(!list_empty(&shost->free_list))) {
-			cmd = list_entry(shost->free_list.next,
-					 struct scsi_cmnd, list);
-			list_del_init(&cmd->list);
-		}
-		spin_unlock_irqrestore(&shost->free_list_lock, flags);
-
-		if (cmd) {
-			void *buf, *prot;
-
-			buf = cmd->sense_buffer;
-			prot = cmd->prot_sdb;
-
-			memset(cmd, 0, sizeof(*cmd));
-
-			cmd->sense_buffer = buf;
-			cmd->prot_sdb = prot;
-		}
-	}
-
-	return cmd;
-}
-
-/**
- * scsi_get_command - Allocate and setup a scsi command block
- * @dev: parent scsi device
- * @gfp_mask: allocator flags
- *
- * Returns:	The allocated scsi command structure.
- */
-struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
-{
-	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
-	unsigned long flags;
-
-	if (unlikely(cmd == NULL))
-		return NULL;
-
-	cmd->device = dev;
-	INIT_LIST_HEAD(&cmd->list);
-	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	spin_lock_irqsave(&dev->list_lock, flags);
-	list_add_tail(&cmd->list, &dev->cmd_list);
-	spin_unlock_irqrestore(&dev->list_lock, flags);
-	cmd->jiffies_at_alloc = jiffies;
-	return cmd;
-}
-
-/**
- * __scsi_put_command - Free a struct scsi_cmnd
- * @shost: dev->host
- * @cmd: Command to free
- */
-static void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	unsigned long flags;
-
-	if (unlikely(list_empty(&shost->free_list))) {
-		spin_lock_irqsave(&shost->free_list_lock, flags);
-		if (list_empty(&shost->free_list)) {
-			list_add(&cmd->list, &shost->free_list);
-			cmd = NULL;
-		}
-		spin_unlock_irqrestore(&shost->free_list_lock, flags);
-	}
-
-	if (likely(cmd != NULL))
-		scsi_host_free_command(shost, cmd);
-}
-
 /**
  * scsi_put_command - Free a scsi command block
  * @cmd: command block to free
@@ -274,168 +117,6 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
 	BUG_ON(delayed_work_pending(&cmd->abort_work));
-
-	__scsi_put_command(cmd->device->host, cmd);
-}
-
-static struct scsi_host_cmd_pool *
-scsi_find_host_cmd_pool(struct Scsi_Host *shost)
-{
-	if (shost->hostt->cmd_size)
-		return shost->hostt->cmd_pool;
-	return &scsi_cmd_pool;
-}
-
-static void
-scsi_free_host_cmd_pool(struct scsi_host_cmd_pool *pool)
-{
-	kfree(pool->cmd_name);
-	kfree(pool);
-}
-
-static struct scsi_host_cmd_pool *
-scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
-{
-	struct scsi_host_template *hostt = shost->hostt;
-	struct scsi_host_cmd_pool *pool;
-
-	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-	if (!pool)
-		return NULL;
-
-	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->proc_name);
-	if (!pool->cmd_name) {
-		scsi_free_host_cmd_pool(pool);
-		return NULL;
-	}
-
-	if (hostt->cmd_size)
-		hostt->cmd_pool = pool;
-
-	return pool;
-}
-
-static struct scsi_host_cmd_pool *
-scsi_get_host_cmd_pool(struct Scsi_Host *shost)
-{
-	struct scsi_host_template *hostt = shost->hostt;
-	struct scsi_host_cmd_pool *retval = NULL, *pool;
-	size_t cmd_size = sizeof(struct scsi_cmnd) + hostt->cmd_size;
-
-	/*
-	 * Select a command slab for this host and create it if not
-	 * yet existent.
-	 */
-	mutex_lock(&host_cmd_pool_mutex);
-	pool = scsi_find_host_cmd_pool(shost);
-	if (!pool) {
-		pool = scsi_alloc_host_cmd_pool(shost);
-		if (!pool)
-			goto out;
-	}
-
-	if (!pool->users) {
-		pool->cmd_slab = kmem_cache_create(pool->cmd_name, cmd_size, 0,
-						   SLAB_HWCACHE_ALIGN, NULL);
-		if (!pool->cmd_slab)
-			goto out_free_pool;
-	}
-
-	pool->users++;
-	retval = pool;
-out:
-	mutex_unlock(&host_cmd_pool_mutex);
-	return retval;
-
-out_free_pool:
-	if (hostt->cmd_size) {
-		scsi_free_host_cmd_pool(pool);
-		hostt->cmd_pool = NULL;
-	}
-	goto out;
-}
-
-static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
-{
-	struct scsi_host_template *hostt = shost->hostt;
-	struct scsi_host_cmd_pool *pool;
-
-	mutex_lock(&host_cmd_pool_mutex);
-	pool = scsi_find_host_cmd_pool(shost);
-
-	/*
-	 * This may happen if a driver has a mismatched get and put
-	 * of the command pool; the driver should be implicated in
-	 * the stack trace
-	 */
-	BUG_ON(pool->users == 0);
-
-	if (!--pool->users) {
-		kmem_cache_destroy(pool->cmd_slab);
-		if (hostt->cmd_size) {
-			scsi_free_host_cmd_pool(pool);
-			hostt->cmd_pool = NULL;
-		}
-	}
-	mutex_unlock(&host_cmd_pool_mutex);
-}
-
-/**
- * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
- * @shost: host to allocate the freelist for.
- *
- * Description: The command freelist protects against system-wide out of memory
- * deadlock by preallocating one SCSI command structure for each host, so the
- * system can always write to a swap file on a device associated with that host.
- *
- * Returns:	Nothing.
- */
-int scsi_setup_command_freelist(struct Scsi_Host *shost)
-{
-	struct scsi_cmnd *cmd;
-
-	spin_lock_init(&shost->free_list_lock);
-	INIT_LIST_HEAD(&shost->free_list);
-
-	shost->cmd_pool = scsi_get_host_cmd_pool(shost);
-	if (!shost->cmd_pool)
-		return -ENOMEM;
-
-	/*
-	 * Get one backup command for this host.
-	 */
-	cmd = scsi_host_alloc_command(shost, GFP_KERNEL);
-	if (!cmd) {
-		scsi_put_host_cmd_pool(shost);
-		shost->cmd_pool = NULL;
-		return -ENOMEM;
-	}
-	list_add(&cmd->list, &shost->free_list);
-	return 0;
-}
-
-/**
- * scsi_destroy_command_freelist - Release the command freelist for a scsi host.
- * @shost: host whose freelist is going to be destroyed
- */
-void scsi_destroy_command_freelist(struct Scsi_Host *shost)
-{
-	/*
-	 * If cmd_pool is NULL the free list was not initialized, so
-	 * do not attempt to release resources.
-	 */
-	if (!shost->cmd_pool)
-		return;
-
-	while (!list_empty(&shost->free_list)) {
-		struct scsi_cmnd *cmd;
-
-		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
-		list_del_init(&cmd->list);
-		scsi_host_free_command(shost, cmd);
-	}
-	shost->cmd_pool = NULL;
-	scsi_put_host_cmd_pool(shost);
 }
 
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 996e134..7c08460 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2331,7 +2331,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 {
 	struct scsi_cmnd *scmd;
 	struct Scsi_Host *shost = dev->host;
-	struct request req;
+	struct request *rq;
 	unsigned long flags;
 	int error = 0, rtn, val;
 
@@ -2346,14 +2346,16 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 		return -EIO;
 
 	error = -EIO;
-	scmd = scsi_get_command(dev, GFP_KERNEL);
-	if (!scmd)
+	rq = kzalloc(sizeof(struct request) + sizeof(struct scsi_cmnd) +
+			shost->hostt->cmd_size, GFP_KERNEL);
+	if (!rq)
 		goto out_put_autopm_host;
+	blk_rq_init(NULL, rq);
 
-	blk_rq_init(NULL, &req);
-	scmd->request = &req;
-
-	scmd->cmnd = req.cmd;
+	scmd = (struct scsi_cmnd *)(rq + 1);
+	scsi_init_command(dev, scmd);
+	scmd->request = rq;
+	scmd->cmnd = rq->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
@@ -2413,6 +2415,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	scsi_run_host_queues(shost);
 
 	scsi_put_command(scmd);
+	kfree(rq);
 
 out_put_autopm_host:
 	scsi_autopm_put_host(shost);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 898af1a..3c11892 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -37,8 +37,7 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-
-struct kmem_cache *scsi_sdb_cache;
+static struct kmem_cache *scsi_sdb_cache;
 static struct kmem_cache *scsi_sense_cache;
 static struct kmem_cache *scsi_sense_isadma_cache;
 static DEFINE_MUTEX(scsi_sense_cache_mutex);
@@ -50,14 +49,14 @@ scsi_select_sense_cache(struct Scsi_Host *shost)
 		scsi_sense_isadma_cache : scsi_sense_cache;
 }
 
-void scsi_free_sense_buffer(struct Scsi_Host *shost,
+static void scsi_free_sense_buffer(struct Scsi_Host *shost,
 		unsigned char *sense_buffer)
 {
 	kmem_cache_free(scsi_select_sense_cache(shost), sense_buffer);
 }
 
-unsigned char *scsi_alloc_sense_buffer(struct Scsi_Host *shost, gfp_t gfp_mask,
-		int numa_node)
+static unsigned char *scsi_alloc_sense_buffer(struct Scsi_Host *shost,
+	gfp_t gfp_mask, int numa_node)
 {
 	return kmem_cache_alloc_node(scsi_select_sense_cache(shost), gfp_mask,
 			numa_node);
@@ -697,14 +696,13 @@ static bool scsi_end_request(struct request *req, int error,
 
 		if (bidi_bytes)
 			scsi_release_bidi_buffers(cmd);
+		scsi_release_buffers(cmd);
+		scsi_put_command(cmd);
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_finish_request(req, error);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
-		scsi_release_buffers(cmd);
-
-		scsi_put_command(cmd);
 		scsi_run_queue(q);
 	}
 
@@ -1161,34 +1159,22 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_init_io);
 
-static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
-		struct request *req)
+void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
-	struct scsi_cmnd *cmd;
-
-	if (!req->special) {
-		/* Bail if we can't get a reference to the device */
-		if (!get_device(&sdev->sdev_gendev))
-			return NULL;
-
-		cmd = scsi_get_command(sdev, GFP_ATOMIC);
-		if (unlikely(!cmd)) {
-			put_device(&sdev->sdev_gendev);
-			return NULL;
-		}
-		req->special = cmd;
-	} else {
-		cmd = req->special;
-	}
-
-	/* pull a tag out of the request if we have one */
-	cmd->tag = req->tag;
-	cmd->request = req;
+	void *buf = cmd->sense_buffer;
+	void *prot = cmd->prot_sdb;
+	unsigned long flags;
 
-	cmd->cmnd = req->cmd;
-	cmd->prot_op = SCSI_PROT_NORMAL;
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->device = dev;
+	cmd->sense_buffer = buf;
+	cmd->prot_sdb = prot;
+	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
+	cmd->jiffies_at_alloc = jiffies;
 
-	return cmd;
+	spin_lock_irqsave(&dev->list_lock, flags);
+	list_add_tail(&cmd->list, &dev->cmd_list);
+	spin_unlock_irqrestore(&dev->list_lock, flags);
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1349,19 +1335,29 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct scsi_cmnd *cmd;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	int ret;
 
 	ret = scsi_prep_state_check(sdev, req);
 	if (ret != BLKPREP_OK)
 		goto out;
 
-	cmd = scsi_get_cmd_from_req(sdev, req);
-	if (unlikely(!cmd)) {
-		ret = BLKPREP_DEFER;
-		goto out;
+	if (!req->special) {
+		/* Bail if we can't get a reference to the device */
+		if (unlikely(!get_device(&sdev->sdev_gendev))) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		scsi_init_command(sdev, cmd);
+		req->special = cmd;
 	}
 
+	cmd->tag = req->tag;
+	cmd->request = req;
+	cmd->cmnd = req->cmd;
+	cmd->prot_op = SCSI_PROT_NORMAL;
+
 	ret = scsi_setup_cmnd(sdev, req);
 out:
 	return scsi_prep_return(q, req, ret);
@@ -2119,15 +2115,61 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
+static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
+{
+	struct Scsi_Host *shost = q->rq_alloc_data;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
+	if (!cmd->sense_buffer)
+		goto fail;
+
+	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
+		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp);
+		if (!cmd->prot_sdb)
+			goto fail_free_sense;
+	}
+
+	return 0;
+
+fail_free_sense:
+	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+fail:
+	return -ENOMEM;
+}
+
+static void scsi_exit_rq(struct request_queue *q, struct request *rq)
+{
+	struct Scsi_Host *shost = q->rq_alloc_data;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+
+	if (cmd->prot_sdb)
+		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
+	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+}
+
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
+	struct Scsi_Host *shost = sdev->host;
 	struct request_queue *q;
 
-	q = blk_init_queue(scsi_request_fn, NULL);
+	q = blk_alloc_queue_node(GFP_KERNEL, NUMA_NO_NODE);
 	if (!q)
 		return NULL;
+	q->cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
+	q->rq_alloc_data = shost;
+	q->request_fn = scsi_request_fn;
+	q->init_rq_fn = scsi_init_rq;
+	q->exit_rq_fn = scsi_exit_rq;
+
+	if (blk_init_allocated_queue(q) < 0) {
+		blk_cleanup_queue(q);
+		return NULL;
+	}
 
-	__scsi_init_queue(sdev->host, q);
+	__scsi_init_queue(shost, q);
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_unprep_rq(q, scsi_unprep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 1a712c6..99bfc98 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -30,13 +30,8 @@ extern void scsi_exit_hosts(void);
 
 /* scsi.c */
 extern bool scsi_use_blk_mq;
-void scsi_free_sense_buffer(struct Scsi_Host *shost,
-		unsigned char *sense_buffer);
-unsigned char *scsi_alloc_sense_buffer(struct Scsi_Host *shost, gfp_t gfp_mask,
-		int numa_node);
 int scsi_init_sense_cache(struct Scsi_Host *shost);
-extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
-extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
+void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
@@ -101,7 +96,6 @@ extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
 struct request_queue;
 struct request;
-extern struct kmem_cache *scsi_sdb_cache;
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f4964d7..3cd8c3b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -551,9 +551,6 @@ struct Scsi_Host {
 	struct list_head	__devices;
 	struct list_head	__targets;
 	
-	struct scsi_host_cmd_pool *cmd_pool;
-	spinlock_t		free_list_lock;
-	struct list_head	free_list; /* backup store of cmd structs */
 	struct list_head	starved_list;
 
 	spinlock_t		default_lock;
-- 
2.1.4

