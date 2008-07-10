From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 6] scsi: Support devices with protection information
Date: Wed, 09 Jul 2008 22:48:05 -0400
Message-ID: <c4e4e530bd0ab3c2c817.1215658085@sermon.lab.mkp.net>
References: <patchbomb.1215658082@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:58724 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbYGJCwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 22:52:01 -0400
In-Reply-To: <patchbomb.1215658082@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Implement support for DMA of protection information for devices that
are data integrity capable.

 - Add support for mapping an extra scatter-gather list containing
   the protection information.

 - Handle protection scsi_data_buffer in command allocation.

 - Preallocate protection scsi_data_buffer in command freelist if host
   is DIX (integrity DMA) capable.

 - Accessor function for checking whether a device has protection
   enabled.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
7 files changed, 97 insertions(+), 11 deletions(-)
drivers/scsi/scsi.c         |   47 ++++++++++++++++++++++++++++++++++++++-----
drivers/scsi/scsi_error.c   |    2 -
drivers/scsi/scsi_lib.c     |   27 ++++++++++++++++++++++--
drivers/scsi/scsi_priv.h    |    1 
drivers/scsi/scsi_tgt_lib.c |    2 -
include/scsi/scsi_cmnd.h    |   24 ++++++++++++++++++++-
include/scsi/scsi_device.h  |    5 ++++



diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -199,24 +199,60 @@ scsi_pool_free_command(struct scsi_host_
 {
 	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
 	kmem_cache_free(pool->cmd_slab, cmd);
+
+	if (cmd->prot_sdb)
+		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
+}
+
+/**
+ * scsi_host_alloc_command - internal function to allocate command
+ * @shost:	SCSI host whose pool to allocate from
+ * @gfp_mask:	mask for the allocation
+ *
+ * Returns a fully allocated command with sense buffer and protection
+ * data buffer (where applicable) or NULL on failure
+ */
+static struct scsi_cmnd *
+scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
+{
+	struct scsi_cmnd *cmd;
+
+	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
+	if (!cmd)
+		return NULL;
+
+	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
+		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);
+
+		if (!cmd->prot_sdb) {
+			scsi_pool_free_command(shost->cmd_pool, cmd);
+			return NULL;
+		}
+	}
+
+	return cmd;
 }
 
 /**
  * __scsi_get_command - Allocate a struct scsi_cmnd
  * @shost: host to transmit command
  * @gfp_mask: allocation mask
+ * @protection: allocate protection sdb
  *
  * Description: allocate a struct scsi_cmd from host's slab, recycling from the
  *              host's free_list if necessary.
  */
-struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
+struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask, int protection)
 {
 	struct scsi_cmnd *cmd;
 	unsigned char *buf;
 
 	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
 
-	if (unlikely(!cmd)) {
+	if (protection)
+		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);
+
+	if (unlikely(!cmd) || unlikely(protection && cmd->prot_sdb == NULL)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&shost->free_list_lock, flags);
@@ -242,10 +278,11 @@ EXPORT_SYMBOL_GPL(__scsi_get_command);
  * scsi_get_command - Allocate and setup a scsi command block
  * @dev: parent scsi device
  * @gfp_mask: allocator flags
+ * @protection: allocate protection sdb
  *
  * Returns:	The allocated scsi command structure.
  */
-struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
+struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask, int protection)
 {
 	struct scsi_cmnd *cmd;
 
@@ -253,7 +290,7 @@ struct scsi_cmnd *scsi_get_command(struc
 	if (!get_device(&dev->sdev_gendev))
 		return NULL;
 
-	cmd = __scsi_get_command(dev->host, gfp_mask);
+	cmd = __scsi_get_command(dev->host, gfp_mask, protection);
 
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
@@ -457,7 +494,7 @@ int scsi_setup_command_freelist(struct S
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
+	cmd = scsi_host_alloc_command(shost, gfp_mask);
 	if (!cmd) {
 		scsi_put_host_cmd_pool(gfp_mask);
 		shost->cmd_pool = NULL;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1769,7 +1769,7 @@ int
 int
 scsi_reset_provider(struct scsi_device *dev, int flag)
 {
-	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
+	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL, 0);
 	struct Scsi_Host *shost = dev->host;
 	struct request req;
 	unsigned long flags;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -65,7 +65,7 @@ static struct scsi_host_sg_pool scsi_sg_
 };
 #undef SP
 
-static struct kmem_cache *scsi_sdb_cache;
+struct kmem_cache *scsi_sdb_cache;
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -778,6 +778,9 @@ void scsi_release_buffers(struct scsi_cm
 		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 		cmd->request->next_rq->special = NULL;
 	}
+
+	if (scsi_prot_sg_count(cmd))
+		scsi_free_sgtable(cmd->prot_sdb);
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
@@ -1063,6 +1066,26 @@ int scsi_init_io(struct scsi_cmnd *cmd, 
 			goto err_exit;
 	}
 
+	if (blk_integrity_rq(cmd->request)) {
+		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
+		int ivecs, count;
+
+		BUG_ON(prot_sdb == NULL);
+		ivecs = blk_rq_count_integrity_sg(cmd->request);
+
+		if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
+			error = BLKPREP_DEFER;
+			goto err_exit;
+		}
+
+		count = blk_rq_map_integrity_sg(cmd->request,
+						prot_sdb->table.sgl);
+		BUG_ON(unlikely(count > ivecs));
+
+		cmd->prot_sdb = prot_sdb;
+		cmd->prot_sdb->table.nents = count;
+	}
+
 	return BLKPREP_OK ;
 
 err_exit:
@@ -1082,7 +1105,7 @@ static struct scsi_cmnd *scsi_get_cmd_fr
 	struct scsi_cmnd *cmd;
 
 	if (!req->special) {
-		cmd = scsi_get_command(sdev, GFP_ATOMIC);
+		cmd = scsi_get_command(sdev, GFP_ATOMIC, blk_integrity_rq(req));
 		if (unlikely(!cmd))
 			return NULL;
 		req->special = cmd;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -77,6 +77,7 @@ struct request_queue;
 struct request_queue;
 struct request;
 extern int scsi_prep_fn(struct request_queue *, struct request *);
+extern struct kmem_cache *scsi_sdb_cache;
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -99,7 +99,7 @@ struct scsi_cmnd *scsi_host_get_command(
 	if (!rq)
 		goto free_tcmd;
 
-	cmd = __scsi_get_command(shost, gfp_mask);
+	cmd = __scsi_get_command(shost, gfp_mask, 0);
 	if (!cmd)
 		goto release_rq;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -90,6 +90,8 @@ struct scsi_cmnd {
 
 	/* These elements define the operation we ultimately want to perform */
 	struct scsi_data_buffer sdb;
+	struct scsi_data_buffer *prot_sdb;
+
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -131,8 +133,8 @@ struct scsi_cmnd {
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
-extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
-extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
+extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t, int);
+extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t, int);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
@@ -237,4 +239,22 @@ enum scsi_prot_operations {
 	SCSI_PROT_WRITE_CONVERT,
 };
 
+static inline unsigned scsi_prot_sg_count(struct scsi_cmnd *cmd)
+{
+	return cmd->prot_sdb ? cmd->prot_sdb->table.nents : 0;
+}
+
+static inline struct scatterlist *scsi_prot_sglist(struct scsi_cmnd *cmd)
+{
+	return cmd->prot_sdb ? cmd->prot_sdb->table.sgl : NULL;
+}
+
+static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
+{
+	return cmd->prot_sdb;
+}
+
+#define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
+	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
+
 #endif /* _SCSI_SCSI_CMND_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -393,6 +393,11 @@ static inline int scsi_device_enclosure(
 	return sdev->inquiry[6] & (1<<6);
 }
 
+static inline int scsi_device_protection(struct scsi_device *sdev)
+{
+	return sdev->inquiry[5] & (1<<0);
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"


