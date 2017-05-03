From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Wed, 3 May 2017 11:09:11 -0700
Message-ID: <20170503180911.24326-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Scott Bauer <scott.bauer@intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
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
 drivers/scsi/scsi_lib.c  | 39 +++++++++++++++++++++------------------
 include/scsi/scsi_cmnd.h |  1 +
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 15c9fe766071..3a5a49e3274a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -43,23 +43,23 @@ static struct kmem_cache *scsi_sense_isadma_cache;
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
@@ -67,7 +67,7 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 	struct kmem_cache *cache;
 	int ret = 0;
 
-	cache = scsi_select_sense_cache(shost);
+	cache = scsi_select_sense_cache(shost->unchecked_isa_dma);
 	if (cache)
 		return 0;
 
@@ -2004,10 +2004,12 @@ static int scsi_init_request(void *data, struct request *rq,
 		unsigned int numa_node)
 {
 	struct Scsi_Host *shost = data;
+	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	cmd->sense_buffer =
-		scsi_alloc_sense_buffer(shost, GFP_KERNEL, numa_node);
+	cmd->unchecked_isa_dma = unchecked_isa_dma;
+	cmd->sense_buffer = scsi_alloc_sense_buffer(unchecked_isa_dma,
+						    GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
 	cmd->req.sense = cmd->sense_buffer;
@@ -2017,10 +2019,9 @@ static int scsi_init_request(void *data, struct request *rq,
 static void scsi_exit_request(void *data, struct request *rq,
 		unsigned int hctx_idx, unsigned int request_idx)
 {
-	struct Scsi_Host *shost = data;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
-	scsi_free_sense_buffer(shost, cmd->sense_buffer);
+	scsi_free_sense_buffer(cmd->unchecked_isa_dma, cmd->sense_buffer);
 }
 
 static int scsi_map_queues(struct blk_mq_tag_set *set)
@@ -2093,11 +2094,14 @@ EXPORT_SYMBOL_GPL(__scsi_init_queue);
 static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 {
 	struct Scsi_Host *shost = q->rq_alloc_data;
+	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
 	memset(cmd, 0, sizeof(*cmd));
 
-	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
+	cmd->unchecked_isa_dma = unchecked_isa_dma;
+	cmd->sense_buffer = scsi_alloc_sense_buffer(unchecked_isa_dma, gfp,
+						    NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
 		goto fail;
 	cmd->req.sense = cmd->sense_buffer;
@@ -2111,19 +2115,18 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
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
+	scsi_free_sense_buffer(cmd->unchecked_isa_dma, cmd->sense_buffer);
 }
 
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index b379f93a2c48..9f1b5432c4c1 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -139,6 +139,7 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 	int flags;		/* Command flags */
 
+	bool unchecked_isa_dma;
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
-- 
2.12.2
