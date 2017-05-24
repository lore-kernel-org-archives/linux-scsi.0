From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/31] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Tue, 23 May 2017 17:33:59 -0700
Message-ID: <20170524003420.5381-11-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Scott Bauer <scott.bauer@intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
Cc: Scott Bauer <scott.bauer@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c  | 43 +++++++++++++++++++++++++------------------
 include/scsi/scsi_cmnd.h |  1 +
 2 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 30a7900d331c..59400033aba8 100644
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
 
@@ -2003,10 +2003,13 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
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
@@ -2016,10 +2019,10 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
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
@@ -2092,11 +2095,15 @@ EXPORT_SYMBOL_GPL(__scsi_init_queue);
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
@@ -2110,19 +2117,19 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
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
