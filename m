From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v3] use dynamically allocated sense buffer
Date: Wed, 16 Jan 2008 13:32:17 +0900
Message-ID: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:50806 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYAPEdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 23:33:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

This is the third version of:

http://marc.info/?l=linux-scsi&m=120038907123706&w=2

The changes from the second version are:

- Fixed the memory leak bug that Boaz pointed out.

shots->backup_sense_buffer has gone. One sense buffer is allocated per
host and it's always attached to the scsi_cmnd linked with freelist
(backup command).

- Calling scsi_setup_command_sense_buffer in scsi_host_alloc instead
of scsi_add_host.

The first version tries to allocates as many buffers as
shost->can_queue so scsi_setup_command_sense_buffer is called in
scsi_add_host. But, it's not the case any more, so this calls
scsi_setup_command_sense_buffer in scsi_host_alloc like
scsi_setup_command_freelist.


I did the same tests against this patch (though I knew there were not
the performnace differences):

dynamic sense buf (slub) | 483.5 MB/s  IOPS 123772.7/s

For convenience, here are the previous results:

scsi-misc (slub)         | 486.9 MB/s  IOPS 124652.9/s
dynamic sense buf (slub) | 483.2 MB/s  IOPS 123704.1/s


I put the results and the kernel configuration:

http://www.kernel.org/pub/linux/kernel/people/tomo/sense/


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] use dynamically allocated sense buffer

This removes static array sense_buffer in scsi_cmnd and uses
dynamically allocated sense_buffer (with GFP_DMA).

The reason for doing this is that some architectures need cacheline
aligned buffer for DMA:

http://lkml.org/lkml/2007/11/19/2

The problems are that scsi_eh_prep_cmnd puts scsi_cmnd::sense_buffer
to sglist and some LLDs directly DMA to scsi_cmnd::sense_buffer. It's
necessary to DMA to scsi_cmnd::sense_buffer safely. This patch solves
these issues.

__scsi_get_command allocates sense_buffer via kmem_cache_alloc and
attaches it to a scsi_cmnd so everything just work as before.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c     |    9 ++++++-
 drivers/scsi/scsi.c      |   61 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_priv.h |    2 +
 include/scsi/scsi_cmnd.h |    2 +-
 4 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 9a10b43..f5d3fbb 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -268,6 +268,7 @@ static void scsi_host_dev_release(struct device *dev)
 	}
 
 	scsi_destroy_command_freelist(shost);
+	scsi_destroy_command_sense_buffer(shost);
 	if (shost->bqt)
 		blk_free_tags(shost->bqt);
 
@@ -372,10 +373,14 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	rval = scsi_setup_command_freelist(shost);
+	rval = scsi_setup_command_sense_buffer(shost);
 	if (rval)
 		goto fail_kfree;
 
+	rval = scsi_setup_command_freelist(shost);
+	if (rval)
+		goto fail_destroy_sense;
+
 	device_initialize(&shost->shost_gendev);
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
 		shost->host_no);
@@ -399,6 +404,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_destroy_freelist:
 	scsi_destroy_command_freelist(shost);
+ fail_destroy_sense:
+	scsi_destroy_command_sense_buffer(shost);
  fail_kfree:
 	kfree(shost);
 	return NULL;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 54ff611..0a4a5b8 100644
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
@@ -172,6 +175,7 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
+	unsigned char *buf;
 
 	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
 			gfp_mask | shost->cmd_pool->gfp_mask);
@@ -186,6 +190,21 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			list_del_init(&cmd->list);
 		}
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
+
+		if (cmd) {
+			buf = cmd->sense_buffer;
+			memset(cmd, 0, sizeof(*cmd));
+			cmd->sense_buffer = buf;
+		}
+	} else {
+		buf = kmem_cache_alloc(sense_buffer_slab, __GFP_DMA|gfp_mask);
+		if (likely(buf)) {
+			memset(cmd, 0, sizeof(*cmd));
+			cmd->sense_buffer = buf;
+		} else {
+			kmem_cache_free(shost->cmd_pool->slab, cmd);
+			cmd = NULL;
+		}
 	}
 
 	return cmd;
@@ -212,7 +231,6 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
 
-		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
@@ -246,8 +264,10 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 	}
 	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-	if (likely(cmd != NULL))
+	if (likely(cmd != NULL)) {
+		kmem_cache_free(sense_buffer_slab, cmd->sense_buffer);
 		kmem_cache_free(shost->cmd_pool->slab, cmd);
+	}
 
 	put_device(dev);
 }
@@ -290,6 +310,7 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 {
 	struct scsi_host_cmd_pool *pool;
 	struct scsi_cmnd *cmd;
+	unsigned char *sense_buffer;
 
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
@@ -319,9 +340,18 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 			GFP_KERNEL | shost->cmd_pool->gfp_mask);
 	if (!cmd)
 		goto fail2;
+
+	sense_buffer = kmem_cache_alloc(sense_buffer_slab,
+					GFP_KERNEL | __GFP_DMA);
+	if (!sense_buffer)
+		goto destroy_backup;
+
+	cmd->sense_buffer = sense_buffer;
 	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
+destroy_backup:
+	kmem_cache_free(shost->cmd_pool->slab, cmd);
  fail2:
 	mutex_lock(&host_cmd_pool_mutex);
 	if (!--pool->users)
@@ -342,6 +372,7 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 
 		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
 		list_del_init(&cmd->list);
+		kmem_cache_free(sense_buffer_slab, cmd->sense_buffer);
 		kmem_cache_free(shost->cmd_pool->slab, cmd);
 	}
 
@@ -351,6 +382,32 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
+int scsi_setup_command_sense_buffer(struct Scsi_Host *shost)
+{
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
+	return 0;
+}
+
+void scsi_destroy_command_sense_buffer(struct Scsi_Host *shost)
+{
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
index 3f34e93..55c6f71 100644
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
index 3f47e52..abd7479 100644
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
-- 
1.5.3.4

