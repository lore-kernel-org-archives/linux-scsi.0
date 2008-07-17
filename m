From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3 of 6] scsi: Support devices with protection information
Date: Thu, 17 Jul 2008 17:08:48 -0400
Message-ID: <yq17ibk1an3.fsf@sermon.lab.mkp.net>
References: <C4A4FCE2.2CCA%michael.hernandez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:48697 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784AbYGQVJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 17:09:07 -0400
In-Reply-To: <C4A4FCE2.2CCA%michael.hernandez@qlogic.com> (Michael Hernandez's message of "Thu\, 17 Jul 2008 13\:42\:58 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Hernandez <michael.hernandez@qlogic.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>>>>> "Mike" == Michael Hernandez <michael.hernandez@qlogic.com> writes:

Mike> Shouldn't this check (and potential kmem_cache_free call) get
Mike> done before freeing the cmd to the cmd_slab?

*sigh*  I think today is Brown Paper Bag Day for me.

But thanks - good spotting!

---8<---

scsi: Support devices with protection information

Implement support for DMA of protection information for devices that
are data integrity capable.

 - Add support for mapping an extra scatter-gather list containing
   the protection information.

 - Allocate protection scsi_data_buffer if host is DIX (integrity DMA)
   capable.

 - Accessor function for checking whether a device has protection
   enabled.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -197,8 +197,40 @@ scsi_pool_free_command(struct scsi_host_
 scsi_pool_free_command(struct scsi_host_cmd_pool *pool,
 			 struct scsi_cmnd *cmd)
 {
+	if (cmd->prot_sdb)
+		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
+
 	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
 	kmem_cache_free(pool->cmd_slab, cmd);
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
@@ -214,7 +246,7 @@ struct scsi_cmnd *__scsi_get_command(str
 	struct scsi_cmnd *cmd;
 	unsigned char *buf;
 
-	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
+	cmd = scsi_host_alloc_command(shost, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -457,7 +489,7 @@ int scsi_setup_command_freelist(struct S
 	/*
 	 * Get one backup command for this host.
 	 */
-	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
+	cmd = scsi_host_alloc_command(shost, gfp_mask);
 	if (!cmd) {
 		scsi_put_host_cmd_pool(gfp_mask);
 		shost->cmd_pool = NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -65,7 +65,7 @@ static struct scsi_host_sg_pool scsi_sg_
 };
 #undef SP
 
-static struct kmem_cache *scsi_sdb_cache;
+struct kmem_cache *scsi_sdb_cache;
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -787,6 +787,9 @@ void scsi_release_buffers(struct scsi_cm
 		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
 		cmd->request->next_rq->special = NULL;
 	}
+
+	if (scsi_prot_sg_count(cmd))
+		scsi_free_sgtable(cmd->prot_sdb);
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
@@ -1070,6 +1073,26 @@ int scsi_init_io(struct scsi_cmnd *cmd, 
 								    GFP_ATOMIC);
 		if (error)
 			goto err_exit;
+	}
+
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
 	}
 
 	return BLKPREP_OK ;
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
 
@@ -274,4 +276,22 @@ static inline sector_t scsi_get_lba(stru
 	return scmd->request->sector;
 }
 
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
@@ -416,6 +416,11 @@ static inline int scsi_device_enclosure(
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
