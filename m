From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 2/2] use dynamically allocated sense buffer
Date: Thu, 3 Jan 2008 23:00:57 +0900
Message-ID: <20080103230400O.tomof@acm.org>
References: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org>
	<20080103135907G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45984 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYACOBI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 09:01:08 -0500
In-Reply-To: <20080103135907G.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, benh@kernel.crashing.org, tomof@acm.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 3 Jan 2008 13:56:37 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> This removes static array sense_buffer in scsi_cmnd and uses
> dynamically allocated sense_buffer (with GFP_DMA).
> 
> scsi_add_host allocates as many buffers as
> scsi_host->can_queue. __scsi_get_command attaches sense_buffer to a
> scsi_cmnd and __scsi_put_command detaches the sense_buffer from it.
> 
> There is a small possibility that a host need more sense buffers than
> can_queue. The failure of the buffer allocation works just like the
> failure of scsi_cmnd allocation. So everything should work as before.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/hosts.c     |   10 ++++++-
>  drivers/scsi/scsi.c      |   67 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/scsi_priv.h |    2 +
>  include/scsi/scsi_cmnd.h |    2 +-
>  include/scsi/scsi_host.h |    3 ++
>  5 files changed, 81 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 9a10b43..35c5f0e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -205,10 +205,14 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
>  	if (!shost->shost_gendev.parent)
>  		shost->shost_gendev.parent = dev ? dev : &platform_bus;
>  
> -	error = device_add(&shost->shost_gendev);
> +	error = scsi_setup_command_sense_buffer(shost);
>  	if (error)
>  		goto out;
>  
> +	error = device_add(&shost->shost_gendev);
> +	if (error)
> +		goto destroy_pool;
> +
>  	scsi_host_set_state(shost, SHOST_RUNNING);
>  	get_device(shost->shost_gendev.parent);
>  
> @@ -248,6 +252,8 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
>  	class_device_del(&shost->shost_classdev);
>   out_del_gendev:
>  	device_del(&shost->shost_gendev);
> + destroy_pool:
> +	scsi_destroy_command_sense_buffer(shost);
>   out:
>  	return error;
>  }
> @@ -267,6 +273,8 @@ static void scsi_host_dev_release(struct device *dev)
>  		scsi_free_queue(shost->uspace_req_q);
>  	}
>  
> +	scsi_destroy_command_sense_buffer(shost);
> +
>  	scsi_destroy_command_freelist(shost);
>  	if (shost->bqt)
>  		blk_free_tags(shost->bqt);
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ebc0193..91306a5 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -161,6 +161,9 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
>  
>  static DEFINE_MUTEX(host_cmd_pool_mutex);
>  
> +static struct kmem_cache *sense_buffer_slab;
> +static int sense_buffer_slab_users;
> +
>  /**
>   * __scsi_get_command - Allocate a struct scsi_cmnd
>   * @shost: host to transmit command
> @@ -172,6 +175,11 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
>  struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  {
>  	struct scsi_cmnd *cmd;
> +	unsigned char *buf;
> +
> +	buf = mempool_alloc(shost->sense_buffer_pool, __GFP_DMA|gfp_mask);
> +	if (!buf)
> +		return NULL;
>  
>  	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
>  			gfp_mask | shost->cmd_pool->gfp_mask);
> @@ -188,6 +196,14 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>  	}
>  
> +	if (cmd) {
> +		memset(cmd, 0, sizeof(*cmd));
> +		cmd->sense_buffer = buf;
> +		/* probably unnecessary */
> +		memset(buf, 0, SCSI_SENSE_BUFFERSIZE);
> +	} else
> +		mempool_free(buf, shost->sense_buffer_pool);
> +
>  	return cmd;
>  }
>  EXPORT_SYMBOL_GPL(__scsi_get_command);
> @@ -212,7 +228,6 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
>  	if (likely(cmd != NULL)) {
>  		unsigned long flags;
>  
> -		memset(cmd, 0, sizeof(*cmd));
>  		cmd->device = dev;
>  		init_timer(&cmd->eh_timeout);
>  		INIT_LIST_HEAD(&cmd->list);
> @@ -238,6 +253,8 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
>  {
>  	unsigned long flags;
>  
> +	mempool_free(cmd->sense_buffer, shost->sense_buffer_pool);
> +
>  	/* changing locks here, don't need to restore the irq state */
>  	spin_lock_irqsave(&shost->free_list_lock, flags);
>  	if (unlikely(list_empty(&shost->free_list))) {
> @@ -352,6 +369,54 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
>  	mutex_unlock(&host_cmd_pool_mutex);
>  }
>  
> +int scsi_setup_command_sense_buffer(struct Scsi_Host *shost)
> +{
> +	int ret;
> +
> +	mutex_lock(&host_cmd_pool_mutex);
> +	if (!sense_buffer_slab) {

Sorry, here should be:

+	if (!sense_buffer_slab_users) {


This is an updated patch.


diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 9a10b43..35c5f0e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -205,10 +205,14 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
 
-	error = device_add(&shost->shost_gendev);
+	error = scsi_setup_command_sense_buffer(shost);
 	if (error)
 		goto out;
 
+	error = device_add(&shost->shost_gendev);
+	if (error)
+		goto destroy_pool;
+
 	scsi_host_set_state(shost, SHOST_RUNNING);
 	get_device(shost->shost_gendev.parent);
 
@@ -248,6 +252,8 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	class_device_del(&shost->shost_classdev);
  out_del_gendev:
 	device_del(&shost->shost_gendev);
+ destroy_pool:
+	scsi_destroy_command_sense_buffer(shost);
  out:
 	return error;
 }
@@ -267,6 +273,8 @@ static void scsi_host_dev_release(struct device *dev)
 		scsi_free_queue(shost->uspace_req_q);
 	}
 
+	scsi_destroy_command_sense_buffer(shost);
+
 	scsi_destroy_command_freelist(shost);
 	if (shost->bqt)
 		blk_free_tags(shost->bqt);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ebc0193..2cd91e7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -161,6 +161,9 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
+static struct kmem_cache *sense_buffer_slab;
+static int sense_buffer_slab_users;
+
 /**
  * __scsi_get_command - Allocate a struct scsi_cmnd
  * @shost: host to transmit command
@@ -172,6 +175,11 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
+	unsigned char *buf;
+
+	buf = mempool_alloc(shost->sense_buffer_pool, __GFP_DMA|gfp_mask);
+	if (!buf)
+		return NULL;
 
 	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
 			gfp_mask | shost->cmd_pool->gfp_mask);
@@ -188,6 +196,14 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 	}
 
+	if (cmd) {
+		memset(cmd, 0, sizeof(*cmd));
+		cmd->sense_buffer = buf;
+		/* probably unnecessary */
+		memset(buf, 0, SCSI_SENSE_BUFFERSIZE);
+	} else
+		mempool_free(buf, shost->sense_buffer_pool);
+
 	return cmd;
 }
 EXPORT_SYMBOL_GPL(__scsi_get_command);
@@ -212,7 +228,6 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
 
-		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
@@ -238,6 +253,8 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 {
 	unsigned long flags;
 
+	mempool_free(cmd->sense_buffer, shost->sense_buffer_pool);
+
 	/* changing locks here, don't need to restore the irq state */
 	spin_lock_irqsave(&shost->free_list_lock, flags);
 	if (unlikely(list_empty(&shost->free_list))) {
@@ -352,6 +369,54 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
+int scsi_setup_command_sense_buffer(struct Scsi_Host *shost)
+{
+	int ret;
+
+	mutex_lock(&host_cmd_pool_mutex);
+	if (!sense_buffer_slab_users) {
+		sense_buffer_slab = kmem_cache_create("scsi_sense_buffer",
+						      SCSI_SENSE_BUFFERSIZE,
+						      0, SLAB_CACHE_DMA, NULL);
+		if (!sense_buffer_slab) {
+			mutex_unlock(&host_cmd_pool_mutex);
+			return -ENOMEM;
+		}
+	}
+	sense_buffer_slab_users++;
+	mutex_unlock(&host_cmd_pool_mutex);
+
+	shost->sense_buffer_pool =
+		mempool_create_slab_pool(0, sense_buffer_slab);
+	if (!shost->sense_buffer_pool)
+		goto fail;
+
+	ret = mempool_resize(shost->sense_buffer_pool, shost->can_queue,
+			     __GFP_DMA|GFP_KERNEL);
+	if (ret) {
+		mempool_destroy(shost->sense_buffer_pool);
+		goto fail;
+	}
+
+	return 0;
+fail:
+	mutex_lock(&host_cmd_pool_mutex);
+	if (!--sense_buffer_slab_users)
+			kmem_cache_destroy(sense_buffer_slab);
+	mutex_unlock(&host_cmd_pool_mutex);
+	return -ENOMEM;
+}
+
+void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost)
+{
+	mempool_destroy(shost->sense_buffer_pool);
+
+	mutex_lock(&host_cmd_pool_mutex);
+	if (!--sense_buffer_slab_users)
+		kmem_cache_destroy(sense_buffer_slab);
+	mutex_unlock(&host_cmd_pool_mutex);
+}
+
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd)
 {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index eff0059..88b20f0 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -27,6 +27,8 @@ extern void scsi_exit_hosts(void);
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
+extern int scsi_setup_command_sense_buffer(struct Scsi_Host *shost);
+extern void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost);
 extern void __scsi_done(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a7be605..753da55 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -88,7 +88,7 @@ struct scsi_cmnd {
 				   	   working on */
 
 #define SCSI_SENSE_BUFFERSIZE 	96
-	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
 				 * command (auto-sense) */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..3f4bae3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/mempool.h>
 
 struct request_queue;
 struct block_device;
@@ -520,6 +521,8 @@ struct Scsi_Host {
 	struct list_head	free_list; /* backup store of cmd structs */
 	struct list_head	starved_list;
 
+	mempool_t *sense_buffer_pool;
+
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
