From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH A2/5 ver2] SCSI: scsi_sgtable implementation
Date: Wed, 25 Jul 2007 12:06:28 +0300
Message-ID: <46A71294.8000002@panasas.com>
References: <46A5BCB6.9050102@panasas.com> <46A5BDEB.3040506@panasas.com> <46A704F6.2040500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31749 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbXGYJGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 05:06:44 -0400
In-Reply-To: <46A704F6.2040500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  As proposed by James Bottomley all I/O members of struc scsi_cmnd
  and the resid member, which need to be duplicated for bidirectional
  transfers. Can be allocated together with the sg-list they are
  pointing to. This way when bidi comes the all structure can be duplicated
  with minimal change to code, and with no extra baggage when bidi is not
  used. The resulting code is the use of a new mechanism called scsi_sgtable.

  scsi_cmnd.h
  - define a new scsi_sgtable structure that will hold IO descriptors + the
    actual scattergather array.
  - Hold a pointer to the scsi_sgtable in scsi_cmnd.
  - Deprecate old, now unnecessary, IO members of scsi_cmnd. These members are
    kept for compatibility with unconverted drivers, still lurking around in
    the code tree. Last patch in the series removes them completely.
  - Modify data accessors to now use new members of scsi_sgtable.

  scsi_lib.c
  - scsi_lib is converted to use the new scsi_sgtable, in stead of the old
    members and sg-arrays.
  - scsi_{alloc,free}_sgtable() API has changed. This will break scsi_stgt
    which will need to be converted to new implementation.
  - Special code is inserted to initialize the old compatibility members from
    the new structures. This code will be removed.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c  |  116 +++++++++++++++++++++++-----------------------
 include/scsi/scsi_cmnd.h |   40 ++++++++++------
 2 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 694bffa..899b7df 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,16 +35,17 @@
 /*
  * Should fit within a single page.
  */
-enum { SCSI_MAX_SG_SEGMENTS = (PAGE_SIZE / sizeof(struct scatterlist)) };
+enum { SCSI_MAX_SG_SEGMENTS = ((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
+                               sizeof(struct scatterlist)) };
 
 enum { SG_MEMPOOL_NR =
-	(SCSI_MAX_SG_SEGMENTS >= 8) +
-	(SCSI_MAX_SG_SEGMENTS >= 16) +
-	(SCSI_MAX_SG_SEGMENTS >= 32) +
-	(SCSI_MAX_SG_SEGMENTS >= 64) +
-	(SCSI_MAX_SG_SEGMENTS >= 128) +
-	(SCSI_MAX_SG_SEGMENTS >= 256) +
-	(SCSI_MAX_SG_SEGMENTS >= 512)
+	(SCSI_MAX_SG_SEGMENTS > 8) +
+	(SCSI_MAX_SG_SEGMENTS > 16) +
+	(SCSI_MAX_SG_SEGMENTS > 32) +
+	(SCSI_MAX_SG_SEGMENTS > 64) +
+	(SCSI_MAX_SG_SEGMENTS > 128) +
+	(SCSI_MAX_SG_SEGMENTS > 256) +
+	(SCSI_MAX_SG_SEGMENTS > 512)
 };
 
 struct scsi_host_sg_pool {
@@ -54,7 +55,10 @@ struct scsi_host_sg_pool {
 };
 static struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR];
 
-
+static inline unsigned scsi_pool_size(int pool)
+{
+	return scsi_sg_pools[pool].size;
+}
 
 static void scsi_run_queue(struct request_queue *q);
 
@@ -699,7 +703,7 @@ static unsigned scsi_sgtable_index(unsigned nents)
 	int i, size;
 
 	for (i = 0, size = 8; i < SG_MEMPOOL_NR-1; i++, size <<= 1)
-		if (size >= nents)
+		if (size > nents)
 			return i;
 
 	if (SCSI_MAX_SG_SEGMENTS >= nents)
@@ -710,26 +714,26 @@ static unsigned scsi_sgtable_index(unsigned nents)
 	return -1;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+struct scsi_sgtable *scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask)
 {
-	unsigned int pool = scsi_sgtable_index(cmd->use_sg);
-	struct scatterlist *sgl;
+	unsigned int pool = scsi_sgtable_index(sg_count);
+	struct scsi_sgtable *sgt;
 
-	sgl = mempool_alloc(scsi_sg_pools[pool].pool, gfp_mask);
-	if (unlikely(!sgl))
+	sgt = mempool_alloc(scsi_sg_pools[pool].pool, gfp_mask);
+	if (unlikely(!sgt))
 		return NULL;
 
-	cmd->sg_pool = pool;
-	return sgl;
+	memset(sgt, 0, SG_TABLE_SIZEOF(scsi_pool_size(pool)));
+	sgt->sg_count = sg_count;
+	sgt->sg_pool = pool;
+	return sgt;
 }
-
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+void scsi_free_sgtable(struct scsi_sgtable *sgt)
 {
-	mempool_free(cmd->request_buffer, scsi_sg_pools[cmd->sg_pool].pool);
+	mempool_free(sgt, scsi_sg_pools[sgt->sg_pool].pool);
 }
-
 EXPORT_SYMBOL(scsi_free_sgtable);
 
 /*
@@ -751,13 +755,12 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd);
+	if (cmd->sgtable)
+		scsi_free_sgtable(cmd->sgtable);
 
-	/*
-	 * Zero these out.  They now point to freed memory, and it is
-	 * dangerous to hang onto the pointers.
-	 */
+	cmd->sgtable = NULL;
+
+	/*FIXME: make code backward compatible with old system */
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
 	cmd->use_sg = 0;
@@ -794,7 +797,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
@@ -802,8 +805,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
@@ -826,9 +827,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
-		req->data_len = cmd->resid;
+		req->data_len = scsi_get_resid(cmd);
 	}
 
+	scsi_release_buffers(cmd);
+
 	/*
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
@@ -836,7 +839,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -969,41 +971,42 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
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
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	sgt = scsi_alloc_sgtable(req->nr_phys_segments, GFP_ATOMIC);
+	if (unlikely(!sgt)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
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
 
@@ -1059,7 +1062,7 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1088,9 +1091,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		cmd->sgtable = NULL;
 		req->buffer = NULL;
 	}
 
@@ -1631,8 +1632,8 @@ void scsi_unblock_requests(struct Scsi_Host *shost)
 EXPORT_SYMBOL(scsi_unblock_requests);
 
 const char* sg_names[] = {
-	"sgpool-8", "sgpool-16", "sgpool-32", "sgpool-64",
-	"sgpool-128", "sgpool-256", "sgpool-512"
+	"sgtable-7", "sgtable-15", "sgtable-31", "sgtable-63",
+	"sgtable-127", "sgtable-255", "sgtable-511"
 };
 
 int __init scsi_init_queue(void)
@@ -1650,11 +1651,10 @@ int __init scsi_init_queue(void)
 
 	for (i = 0, size = 8; i < SG_MEMPOOL_NR; i++, size <<= 1) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		sgp->size = (i != SG_MEMPOOL_NR-1) ? size :
+		sgp->size = (i != SG_MEMPOOL_NR-1) ? size - 1:
 		                                           SCSI_MAX_SG_SEGMENTS;
 		sgp->slab = kmem_cache_create(sg_names[i],
-				sgp->size*sizeof(struct scatterlist),
-				0, 0, NULL);
+				SG_TABLE_SIZEOF(sgp->size), 0, 0, NULL);
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sg_names[i]);
@@ -1671,9 +1671,9 @@ int __init scsi_init_queue(void)
 	/* FIXME: Here for the debugging phase only */
 	printk(KERN_ERR
 		"SCSI: max_sg_count=%d SG_MEMPOOL_NR=%d page=%ld "
-		"so_scaterlist=%Zd\n",
+		"so_scaterlist=%Zd so_sgtable=%Zd\n",
 		SCSI_MAX_SG_SEGMENTS, SG_MEMPOOL_NR, PAGE_SIZE,
-		sizeof(struct scatterlist)
+		sizeof(struct scatterlist), sizeof(struct scsi_sgtable)
 	);
 
 	return 0;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 279a4df..574ea9d 100644
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
-	unsigned short sg_pool;	/* pool index of allocated sg array */
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
 
@@ -117,6 +119,11 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
+
+	unsigned short __deprecated use_sg;
+	unsigned __deprecated request_bufflen;
+	void __deprecated *request_buffer;
+	int __deprecated resid;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
@@ -132,35 +139,36 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern struct scsi_sgtable *scsi_alloc_sgtable(int sg_count, gfp_t gfp_mask);
+extern void scsi_free_sgtable(struct scsi_sgtable *sgt);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
-	return cmd->->use_sg;
+	return cmd->sgtable ? cmd->sgtable->sg_count : 0;
 }
 
 static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
 {
-	return ((struct scatterlist *)cmd->request_buffer)
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


