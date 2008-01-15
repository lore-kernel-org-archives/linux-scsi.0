From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2] use dynamically allocated sense buffer
Date: Tue, 15 Jan 2008 18:23:42 +0900
Message-ID: <20080115182342Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:43323 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYAOJXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 04:23:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

This is the second version of

http://marc.info/?l=linux-scsi&m=119933628210006&w=2

I gave up once, but I found that the performance loss is negligible
(within 1%) by using kmem_cache_alloc instead of mempool.

I use scsi_debug with fake_rw=1 and disktest (DIO reads with 8
threads) again:

scsi-misc (slub)         | 486.9 MB/s  IOPS 124652.9/s
dynamic sense buf (slub) | 483.2 MB/s  IOPS 123704.1/s

scsi-misc (slab)         | 467.0 MB/s  IOPS 119544.3/s
dynamic sense buf (slab) | 468.7 MB/s  IOPS 119986.0/s

The results are the averages of three runs with a server using two
dual-core 1.60 GHz Xeon processors with DDR2 memory.


I doubt think that someone will complain about the performance
regression due to this patch. In addition, unlike scsi_debug, the real
LLDs allocate the own data structure per scsi_cmnd so the performance
differences would be smaller (and with the real hard disk overheads).

Here's the full results:

http://www.kernel.org/pub/linux/kernel/people/tomo/sense/results.txt


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

A scsi_host reserves one sense buffer for the backup command
(shost->backup_sense_buffer).


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c     |   10 ++++++-
 drivers/scsi/scsi.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_priv.h |    2 +
 include/scsi/scsi_cmnd.h |    2 +-
 include/scsi/scsi_host.h |    3 ++
 5 files changed, 80 insertions(+), 4 deletions(-)

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
index 54ff611..d153da3 100644
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
@@ -186,6 +189,22 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 			list_del_init(&cmd->list);
 		}
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
+
+		if (cmd) {
+			memset(cmd, 0, sizeof(*cmd));
+			cmd->sense_buffer = shost->backup_sense_buffer;
+		}
+	} else {
+		unsigned char *buf;
+
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
@@ -351,6 +371,49 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
+int scsi_setup_command_sense_buffer(struct Scsi_Host *shost)
+{
+	unsigned char *sense_buffer;
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
+	sense_buffer = kmem_cache_alloc(sense_buffer_slab,
+					GFP_KERNEL | __GFP_DMA);
+	if (!sense_buffer)
+		goto fail;
+
+	shost->backup_sense_buffer = sense_buffer;
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
+	kmem_cache_free(sense_buffer_slab, shost->backup_sense_buffer);
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
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..65d2bcf 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -520,6 +520,9 @@ struct Scsi_Host {
 	struct list_head	free_list; /* backup store of cmd structs */
 	struct list_head	starved_list;
 
+	/* sense buffer for the backup command */
+	unsigned char *backup_sense_buffer;
+
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
-- 
1.5.3.4

