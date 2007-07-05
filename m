From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Thu, 05 Jul 2007 16:43:42 +0300
Message-ID: <468CF58E.1020901@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27074 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757612AbXGENoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:44:06 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


  As proposed by James Bottomley all I/O members of struc scsi_cmnd
  and the resid member, which need to be duplicated for bidirectional
  transfers. Can be allocated together with the sg-list they are
  pointing to. This way when bidi comes the all structure can be duplicated
  with minimal change to code, and with no extra baggage when bidi is not
  used. The resulting code is the use of a new mechanism called scsi_sgtable.
  (Old code will be removed in next patch for easier reviewing)

  scsi_cmnd.h
  - define a new scsi_sgtable structure that will hold IO descriptors + the
    actual scattergather array.
  - Hold a pointer to the scsi_sgtable in scsi_cmnd.
  - Deprecate old, now unnecessary, IO members of scsi_cmnd. These members are
    kept for compatibility with unconverted drivers, still lurking around in
    the code tree. Last patch in the series removes them completely.
  - Modify data accessors to now use new members of scsi_sgtable.

  scsi_lib.c
  - Allocate scsi_sgtable of different sizes in sg-pools instead of the
    old sg arrays. The code Automatically calculates at compile time the
    maximum size sg-table that will fit in a memory-page and will allocate
    pools of (BASE_2-1) size, up to that maximum size.
  - scsi_lib is converted to use the new scsi_sgtable, in stead of the old
    members and sg-arrays.
  - The old scsi_{alloc,free}_sgtable() is no longer exported. This will break scsi_sgt
    which will need to be converted to new implementation.
  - Special code is inserted to initialize the old compatibility members from
    the new structures. This code will be removed.
  - Some extra prints for the duration of the stability period. Once
    debugging phase is finished these prints should be removed.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c  |  168 +++++++++++++++++++++++++++++-----------------
 include/scsi/scsi_cmnd.h |   40 ++++++-----
 2 files changed, 128 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 70454b4..a5505ec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -29,40 +29,32 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-
-#define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
 struct scsi_host_sg_pool {
 	size_t		size;
-	char		*name; 
 	struct kmem_cache	*slab;
 	mempool_t	*pool;
 };
 
-#if (SCSI_MAX_PHYS_SEGMENTS < 32)
-#error SCSI_MAX_PHYS_SEGMENTS is too small
-#endif
+/*
+ * Should fit within a single page.
+ */
+enum { SCSI_MAX_SG_SEGMENTS =
+	((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
+	sizeof(struct scatterlist)) };
+
+enum { SG_MEMPOOL_NR =
+	(SCSI_MAX_SG_SEGMENTS >= 7) +
+	(SCSI_MAX_SG_SEGMENTS >= 15) +
+	(SCSI_MAX_SG_SEGMENTS >= 31) +
+	(SCSI_MAX_SG_SEGMENTS >= 63) +
+	(SCSI_MAX_SG_SEGMENTS >= 127) +
+	(SCSI_MAX_SG_SEGMENTS >= 255) +
+	(SCSI_MAX_SG_SEGMENTS >= 511)
+};
 
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
+static struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR];
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -701,6 +693,46 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
+static unsigned scsi_sgtable_index(unsigned nents)
+{
+	int i, size;
+
+	for (i = 0, size = 8; i < SG_MEMPOOL_NR-1; i++, size <<= 1)
+		if (size > nents)
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
+static void _scsi_free_sgtable(struct scsi_sgtable *sgt)
+{
+	mempool_free(sgt, scsi_sg_pools[sgt->sg_pool].pool);
+}
+
+static struct scsi_sgtable *_scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
+	struct scsi_sgtable *sgt;
+	unsigned int index;
+
+	index = scsi_sgtable_index(sg_count);
+	sgp = scsi_sg_pools + index;
+
+	sgt = mempool_alloc(sgp->pool, gfp_mask);
+	if (unlikely(!sgt))
+		return NULL;
+
+	memset(sgt, 0, SG_TABLE_SIZEOF(sgp->size));
+	sgt->sg_pool = index;
+	sgt->sg_count = sg_count;
+	return sgt;
+}
+
 struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
@@ -775,15 +807,15 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	if (cmd->sgtable)
+		_scsi_free_sgtable(cmd->sgtable);
 
-	/*
-	 * Zero these out.  They now point to freed memory, and it is
-	 * dangerous to hang onto the pointers.
-	 */
+	cmd->sgtable = NULL;
+
+	/*FIXME: make code backward compatible with old system */
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
+	cmd->use_sg = 0;
 }
 
 /*
@@ -817,13 +849,14 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
+	int resid = scsi_get_resid(cmd);
 
 	scsi_release_buffers(cmd);
 
@@ -849,7 +882,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
-		req->data_len = cmd->resid;
+		req->data_len = resid;
 	}
 
 	/*
@@ -859,7 +892,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -991,44 +1023,43 @@ EXPORT_SYMBOL(scsi_io_completion);
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
-	struct scatterlist *sgpnt;
 	int		   count;
-
-	/*
-	 * We used to not use scatter-gather for single segment request,
-	 * but now we do (it makes highmem I/O easier to support without
-	 * kmapping pages)
-	 */
-	cmd->use_sg = req->nr_phys_segments;
+	struct scsi_sgtable *sgt;
 
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt)) {
+	sgt = _scsi_alloc_sgtable(req->nr_phys_segments, GFP_ATOMIC);
+	if (unlikely(!sgt)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
-	cmd->request_buffer = (char *) sgpnt;
 	if (blk_pc_request(req))
-		cmd->request_bufflen = req->data_len;
+		sgt->length = req->data_len;
 	else
-		cmd->request_bufflen = req->nr_sectors << 9;
+		sgt->length = req->nr_sectors << 9;
 
+	cmd->sgtable = sgt;
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
+	count = blk_rq_map_sg(req->q, req, sgt->sglist);
+	if (likely(count <= sgt->sg_count)) {
+		sgt->sg_count = count;
+		
+		/*FIXME: make code backward compatible with old system */
+		cmd->request_buffer = sgt->sglist;
+		cmd->request_bufflen = sgt->length;
+		cmd->use_sg = sgt->sg_count;
+
 		return BLKPREP_OK;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
+	printk(KERN_ERR "counted %d, received %d\n", count, scsi_sg_count(cmd));
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
@@ -1084,7 +1115,7 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1113,9 +1144,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		cmd->sgtable = NULL;
 		req->buffer = NULL;
 	}
 
@@ -1576,7 +1605,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 		return NULL;
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
@@ -1655,9 +1684,15 @@ void scsi_unblock_requests(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_unblock_requests);
 
+const char* sg_names[] = {
+	"sgtable-7", "sgtable-15", "sgtable-31", "sgtable-63",
+	"sgtable-127", "sgtable-255", "sgtable-511"
+};
+
 int __init scsi_init_queue(void)
 {
 	int i;
+	unsigned size;
 
 	scsi_io_context_cache = kmem_cache_create("scsi_io_context",
 					sizeof(struct scsi_io_context),
@@ -1667,25 +1702,32 @@ int __init scsi_init_queue(void)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+	for (i = 0, size = 8; i < SG_MEMPOOL_NR; i++, size <<= 1) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
-
-		sgp->slab = kmem_cache_create(sgp->name, size, 0,
-				SLAB_HWCACHE_ALIGN, NULL, NULL);
+		sgp->size = size-1;
+		sgp->slab = kmem_cache_create(sg_names[i],
+				SG_TABLE_SIZEOF(sgp->size), 0, 0, NULL, NULL);
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
+		"so_sgtable=%Zd so_scaterlist=%Zd\n",
+		SCSI_MAX_SG_SEGMENTS, SG_MEMPOOL_NR, PAGE_SIZE,
+		sizeof(struct scsi_sgtable), sizeof(struct scatterlist)
+	);
+
 	return 0;
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index aaf8282..d408d93 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -11,6 +11,16 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_sgtable {
+	unsigned length;
+	int resid;
+	short sg_count;
+	short sg_pool;
+	struct scatterlist sglist[0];
+};
+
+#define SG_TABLE_SIZEOF(sg_count) ((sg_count)*sizeof(struct scatterlist) \
+                                   + sizeof(struct scsi_sgtable))
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -64,15 +74,11 @@ struct scsi_cmnd {
 	/* These elements define the operation we are about to perform */
 #define MAX_COMMAND_SIZE	16
 	unsigned char cmnd[MAX_COMMAND_SIZE];
-	unsigned request_bufflen;	/* Actual request size */
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
-	void *request_buffer;		/* Actual requested buffer */
+	struct scsi_sgtable *sgtable;
 
 	/* These elements define the operation we ultimately want to perform */
-	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
-
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -82,10 +88,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	int resid;		/* Number of bytes requested to be
-				   transferred less actual number
-				   transferred (0 if not supported) */
-
 	struct request *request;	/* The command we are
 				   	   working on */
 
@@ -117,6 +119,12 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
+
+	unsigned short sglist_len;
+	unsigned short __deprecated use_sg;
+	unsigned __deprecated request_bufflen;
+	void __deprecated *request_buffer;
+	int __deprecated resid;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
@@ -132,35 +140,33 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scatterlist *, int);
-
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
-	return cmd->use_sg;
+	return cmd->sgtable ? cmd->sgtable->sg_count : 0;
 }
 
 static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
 {
-	return (struct scatterlist *)cmd->request_buffer;
+	return cmd->sgtable ? cmd->sgtable->sglist : 0;
 }
 
 static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
 {
-	return cmd->request_bufflen;
+	return cmd->sgtable ? cmd->sgtable->length : 0;
 }
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
-	cmd->resid = resid;
+	if (cmd->sgtable)
+		cmd->sgtable->resid = resid;
 }
 
 static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 {
-	return cmd->resid;
+	return cmd->sgtable ? cmd->sgtable->resid : 0;
 }
 
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
-- 
1.5.2.2.249.g45fd


