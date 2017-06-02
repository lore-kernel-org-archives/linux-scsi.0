From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 01/12] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Fri, 2 Jun 2017 14:21:52 -0700
Message-ID: <20170602212203.30401-2-bart.vanassche@sandisk.com>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4908 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFBVWT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:22:19 -0400
In-Reply-To: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Scott Bauer <scott.bauer@intel.com>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org

Dereferencing shost from scsi_exit_rq() is not safe because the
SCSI host may already have been freed when scsi_exit_rq() is
called. Increasing the shost reference count in scsi_init_rq()
and dropping that reference in scsi_exit_rq() is nontrivial since
scsi_host_dev_release() may sleep and since scsi_exit_rq() may
be called from interrupt context. Since scsi_exit_rq() only needs
a single bit from shost, copy that bit into struct scsi_cmnd.

Reported-by: Scott Bauer <scott.bauer@intel.com>
Fixes: e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Scott Bauer <scott.bauer@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c  | 47 +++++++++++++++++++++++++++++------------------
 include/scsi/scsi_cmnd.h |  1 +
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 814a4bd8405d..cc9f792cd12b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -44,23 +44,23 @@ static struct kmem_cache *scsi_sense_isadma_cache;
 static DEFINE_MUTEX(scsi_sense_cache_mutex);
 
 static inline struct kmem_cache *
-scsi_select_sense_cache(struct Scsi_Host *shost)
+scsi_select_sense_cache(bool unchecked_isa_dma)
 {
-	return shost->unchecked_isa_dma ?
-		scsi_sense_isadma_cache : scsi_sense_cache;
+	return unchecked_isa_dma ? scsi_sense_isadma_cache : scsi_sense_cache;
 }
 
-static void scsi_free_sense_buffer(struct Scsi_Host *shost,
-		unsigned char *sense_buffer)
+static void scsi_free_sense_buffer(bool unchecked_isa_dma,
+				   unsigned char *sense_buffer)
 {
-	kmem_cache_free(scsi_select_sense_cache(shost), sense_buffer);
+	kmem_cache_free(scsi_select_sense_cache(unchecked_isa_dma),
+			sense_buffer);
 }
 
-static unsigned char *scsi_alloc_sense_buffer(struct Scsi_Host *shost,
+static unsigned char *scsi_alloc_sense_buffer(bool unchecked_isa_dma,
 	gfp_t gfp_mask, int numa_node)
 {
-	return kmem_cache_alloc_node(scsi_select_sense_cache(shost), gfp_mask,
-			numa_node);
+	return kmem_cache_alloc_node(scsi_select_sense_cache(unchecked_isa_dma),
+				     gfp_mask, numa_node);
 }
 
 int scsi_init_sense_cache(struct Scsi_Host *shost)
@@ -68,7 +68,7 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 	struct kmem_cache *cache;
 	int ret = 0;
 
-	cache = scsi_select_sense_cache(shost);
+	cache = scsi_select_sense_cache(shost->unchecked_isa_dma);
 	if (cache)
 		return 0;
 
@@ -1137,6 +1137,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
 	void *buf = cmd->sense_buffer;
 	void *prot = cmd->prot_sdb;
+	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
 	unsigned long flags;
 
 	/* zero out the cmd, except for the embedded scsi_request */
@@ -1146,6 +1147,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
+	cmd->flags = unchecked_isa_dma;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 
@@ -1846,6 +1848,7 @@ static int scsi_mq_prep_fn(struct request *req)
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
 	unsigned char *sense_buf = cmd->sense_buffer;
+	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
 	struct scatterlist *sg;
 
 	/* zero out the cmd, except for the embedded scsi_request */
@@ -1857,6 +1860,7 @@ static int scsi_mq_prep_fn(struct request *req)
 	cmd->request = req;
 	cmd->device = sdev;
 	cmd->sense_buffer = sense_buf;
+	cmd->flags = unchecked_isa_dma;
 
 	cmd->tag = req->tag;
 
@@ -2003,10 +2007,13 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 		unsigned int hctx_idx, unsigned int numa_node)
 {
 	struct Scsi_Host *shost = set->driver_data;
+	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	cmd->sense_buffer =
-		scsi_alloc_sense_buffer(shost, GFP_KERNEL, numa_node);
+	if (unchecked_isa_dma)
+		cmd->flags |= SCMD_UNCHECKED_ISA_DMA;
+	cmd->sense_buffer = scsi_alloc_sense_buffer(unchecked_isa_dma,
+						    GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
 	cmd->req.sense = cmd->sense_buffer;
@@ -2016,10 +2023,10 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 static void scsi_exit_request(struct blk_mq_tag_set *set, struct request *rq,
 		unsigned int hctx_idx)
 {
-	struct Scsi_Host *shost = set->driver_data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+	scsi_free_sense_buffer(cmd->flags & SCMD_UNCHECKED_ISA_DMA,
+			       cmd->sense_buffer);
 }
 
 static int scsi_map_queues(struct blk_mq_tag_set *set)
@@ -2092,11 +2099,15 @@ EXPORT_SYMBOL_GPL(__scsi_init_queue);
 static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 {
 	struct Scsi_Host *shost = q->rq_alloc_data;
+	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	memset(cmd, 0, sizeof(*cmd));
 
-	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
+	if (unchecked_isa_dma)
+		cmd->flags |= SCMD_UNCHECKED_ISA_DMA;
+	cmd->sense_buffer = scsi_alloc_sense_buffer(unchecked_isa_dma, gfp,
+						    NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
 		goto fail;
 	cmd->req.sense = cmd->sense_buffer;
@@ -2110,19 +2121,19 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 	return 0;
 
 fail_free_sense:
-	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+	scsi_free_sense_buffer(unchecked_isa_dma, cmd->sense_buffer);
 fail:
 	return -ENOMEM;
 }
 
 static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 {
-	struct Scsi_Host *shost = q->rq_alloc_data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	if (cmd->prot_sdb)
 		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
-	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+	scsi_free_sense_buffer(cmd->flags & SCMD_UNCHECKED_ISA_DMA,
+			       cmd->sense_buffer);
 }
 
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index b379f93a2c48..16351de31243 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -56,6 +56,7 @@ struct scsi_pointer {
 
 /* for scmd->flags */
 #define SCMD_TAGGED		(1 << 0)
+#define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
 
 struct scsi_cmnd {
 	struct scsi_request req;
-- 
2.12.2
