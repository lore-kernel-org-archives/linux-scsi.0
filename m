From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH AB1/5 ver2] SCSI: SG pools allocation cleanup.
Date: Wed, 25 Jul 2007 12:05:09 +0300
Message-ID: <46A71245.9070903@panasas.com>
References: <46A5BCB6.9050102@panasas.com> <46A5BDEB.3040506@panasas.com> <46A704F6.2040500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32339 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756602AbXGYJF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 05:05:26 -0400
In-Reply-To: <46A704F6.2040500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  - The code Automatically calculates at compile time the
    maximum size sg-array that will fit in a memory-page and will allocate
    pools of BASE_2 size, up to that maximum size.
  - split scsi_alloc() into an helper scsi_sgtable_index() that will return
    the index of the pool for a given sg_count.
  - Remove now unused SCSI_MAX_PHYS_SEGMENTS
  - rename sglist_len to sg_pool which is what it always was.
  - Some extra prints at scsi_init_queue(). These prints will be removed
    once everything stabilizes.

  Now that the Arrays are automatically calculated to fit in a page, what
  about ARCH's that have a very big page size? I have, just for demonstration,
  calculated upto 512 entries. But I suspect that other kernel-subsystems are
  bounded to 256 or 128, is that true? should I allow more/less than 512 here?

some common numbers:
Arch                      | SCSI_MAX_SG_SEGMENTS =  | sizeof(struct scatterlist)
--------------------------|-------------------------|---------------------------
x86_64                    | 128                     |32
i386 CONFIG_HIGHMEM64G=y  | 205                     |20
i386 other                | 256                     |16

  Could some one give example numbers of an ARCH with big page size?

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c  |  143 +++++++++++++++++++++-------------------------
 include/scsi/scsi.h      |    7 --
 include/scsi/scsi_cmnd.h |   19 +++++-
 3 files changed, 80 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5edadfe..694bffa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -30,40 +30,31 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-
-#define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
+/*
+ * Should fit within a single page.
+ */
+enum { SCSI_MAX_SG_SEGMENTS = (PAGE_SIZE / sizeof(struct scatterlist)) };
+
+enum { SG_MEMPOOL_NR =
+	(SCSI_MAX_SG_SEGMENTS >= 8) +
+	(SCSI_MAX_SG_SEGMENTS >= 16) +
+	(SCSI_MAX_SG_SEGMENTS >= 32) +
+	(SCSI_MAX_SG_SEGMENTS >= 64) +
+	(SCSI_MAX_SG_SEGMENTS >= 128) +
+	(SCSI_MAX_SG_SEGMENTS >= 256) +
+	(SCSI_MAX_SG_SEGMENTS >= 512)
+};
+
 struct scsi_host_sg_pool {
-	size_t		size;
-	char		*name; 
+	unsigned		size;
 	struct kmem_cache	*slab;
 	mempool_t	*pool;
 };
+static struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR];
+
 
-#if (SCSI_MAX_PHYS_SEGMENTS < 32)
-#error SCSI_MAX_PHYS_SEGMENTS is too small
-#endif
-
-#define SP(x) { x, "sgpool-" #x } 
-static struct scsi_host_sg_pool scsi_sg_pools[] = {
-	SP(8),
-	SP(16),
-	SP(32),
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
-	SP(64),
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	SP(128),
-#if (SCSI_MAX_PHYS_SEGMENTS > 128)
-	SP(256),
-#if (SCSI_MAX_PHYS_SEGMENTS > 256)
-#error SCSI_MAX_PHYS_SEGMENTS is too large
-#endif
-#endif
-#endif
-#endif
-}; 	
-#undef SP
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -703,44 +694,32 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
+static unsigned scsi_sgtable_index(unsigned nents)
+{
+	int i, size;
+
+	for (i = 0, size = 8; i < SG_MEMPOOL_NR-1; i++, size <<= 1)
+		if (size >= nents)
+			return i;
+
+	if (SCSI_MAX_SG_SEGMENTS >= nents)
+		return SG_MEMPOOL_NR-1;
+
+	printk(KERN_ERR "scsi: bad segment count=%d\n", nents);
+	BUG();
+	return -1;
+}
+
 struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
-	struct scsi_host_sg_pool *sgp;
+	unsigned int pool = scsi_sgtable_index(cmd->use_sg);
 	struct scatterlist *sgl;
 
-	BUG_ON(!cmd->use_sg);
-
-	switch (cmd->use_sg) {
-	case 1 ... 8:
-		cmd->sglist_len = 0;
-		break;
-	case 9 ... 16:
-		cmd->sglist_len = 1;
-		break;
-	case 17 ... 32:
-		cmd->sglist_len = 2;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
-	case 33 ... 64:
-		cmd->sglist_len = 3;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	case 65 ... 128:
-		cmd->sglist_len = 4;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS  > 128)
-	case 129 ... 256:
-		cmd->sglist_len = 5;
-		break;
-#endif
-#endif
-#endif
-	default:
+	sgl = mempool_alloc(scsi_sg_pools[pool].pool, gfp_mask);
+	if (unlikely(!sgl))
 		return NULL;
-	}
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
+	cmd->sg_pool = pool;
 	return sgl;
 }
 
@@ -748,13 +727,7 @@ EXPORT_SYMBOL(scsi_alloc_sgtable);
 
 void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
-	struct scatterlist *sgl = cmd->request_buffer;
-	struct scsi_host_sg_pool *sgp;
-
-	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
-
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	mempool_free(sgl, sgp->pool);
+	mempool_free(cmd->request_buffer, scsi_sg_pools[cmd->sg_pool].pool);
 }
 
 EXPORT_SYMBOL(scsi_free_sgtable);
@@ -787,6 +760,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 	 */
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
+	cmd->use_sg = 0;
 }
 
 /*
@@ -994,7 +968,6 @@ EXPORT_SYMBOL(scsi_io_completion);
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
-	struct scatterlist *sgpnt;
 	int		   count;
 
 	/*
@@ -1007,14 +980,13 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt)) {
+	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
+	if (unlikely(!cmd->request_buffer)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
-	cmd->request_buffer = (char *) sgpnt;
 	if (blk_pc_request(req))
 		cmd->request_bufflen = req->data_len;
 	else
@@ -1579,7 +1551,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 		return NULL;
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
@@ -1658,9 +1630,15 @@ void scsi_unblock_requests(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_unblock_requests);
 
+const char* sg_names[] = {
+	"sgpool-8", "sgpool-16", "sgpool-32", "sgpool-64",
+	"sgpool-128", "sgpool-256", "sgpool-512"
+};
+
 int __init scsi_init_queue(void)
 {
 	int i;
+	unsigned size;
 
 	scsi_io_context_cache = kmem_cache_create("scsi_io_context",
 					sizeof(struct scsi_io_context),
@@ -1670,25 +1648,34 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+	for (i = 0, size = 8; i < SG_MEMPOOL_NR; i++, size <<= 1) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
-
-		sgp->slab = kmem_cache_create(sgp->name, size, 0,
-				SLAB_HWCACHE_ALIGN, NULL);
+		sgp->size = (i != SG_MEMPOOL_NR-1) ? size :
+		                                           SCSI_MAX_SG_SEGMENTS;
+		sgp->slab = kmem_cache_create(sg_names[i],
+				sgp->size*sizeof(struct scatterlist),
+				0, 0, NULL);
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
-					sgp->name);
+					sg_names[i]);
 		}
 
 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
 						     sgp->slab);
 		if (!sgp->pool) {
 			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
-					sgp->name);
+					sg_names[i]);
 		}
 	}
 
+	/* FIXME: Here for the debugging phase only */
+	printk(KERN_ERR
+		"SCSI: max_sg_count=%d SG_MEMPOOL_NR=%d page=%ld "
+		"so_scaterlist=%Zd\n",
+		SCSI_MAX_SG_SEGMENTS, SG_MEMPOOL_NR, PAGE_SIZE,
+		sizeof(struct scatterlist)
+	);
+
 	return 0;
 }
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 9f8f80a..702fcfe 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,13 +11,6 @@
 #include <linux/types.h>
 
 /*
- *	The maximum sg list length SCSI can cope with
- *	(currently must be a power of 2 between 32 and 256)
- */
-#define SCSI_MAX_PHYS_SEGMENTS	MAX_PHYS_SEGMENTS
-
-
-/*
  *	SCSI command lengths
  */
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 760d4a5..279a4df 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -71,7 +71,7 @@ struct scsi_cmnd {
 
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
+	unsigned short sg_pool;	/* pool index of allocated sg array */
 
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
@@ -138,9 +138,20 @@ extern void scsi_free_sgtable(struct scsi_cmnd *);
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
-#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
+{
+	return cmd->->use_sg;
+}
+
+static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
+{
+	return ((struct scatterlist *)cmd->request_buffer)
+}
+
+static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
+{
+	return cmd->request_bufflen;
+}
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
-- 
1.5.2.2.249.g45fd


