From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/9] add scsi_data_buffer structure
Date: Fri, 7 Sep 2007 06:50:14 +0900
Message-ID: <20070906183450Y.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60494 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbXIFVvj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:51:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

This adds a new data structure, scsi_data_buffer, including scsi data
transfer. One scsi_data_buffer structure is embedded in struct
scsi_cmnd for uni-directional transfer.

This is a preparation for bidirectional support.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c  |   85 ++++++++++++++++++++++-----------------------
 include/scsi/scsi_cmnd.h |   38 ++++++++++++++------
 2 files changed, 69 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1e0f691..3adce94 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -742,16 +742,22 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, gfp_t gfp_mask,
+		       int sg_count)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl, *prev, *ret;
 	unsigned int index;
 	int this, left;
 
-	BUG_ON(!cmd->use_sg);
+	/*
+	 * don't allow subsequent mempool allocs to sleep, it would
+	 * violate the mempool principle.
+	 */
+	gfp_mask &= ~__GFP_WAIT;
+	gfp_mask |= __GFP_HIGH;
 
-	left = cmd->use_sg;
+	left = sg_count;
 	ret = prev = NULL;
 	do {
 		this = left;
@@ -785,21 +791,17 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		if (prev)
 			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
 
-		/*
-		 * don't allow subsequent mempool allocs to sleep, it would
-		 * violate the mempool principle.
-		 */
-		gfp_mask &= ~__GFP_WAIT;
-		gfp_mask |= __GFP_HIGH;
 		prev = sgl;
 	} while (left);
 
 	/*
-	 * ->use_sg may get modified after dma mapping has potentially
+	 * ->sg_count may get modified after dma mapping has potentially
 	 * shrunk the number of segments, so keep a copy of it for free.
 	 */
-	cmd->__use_sg = cmd->use_sg;
-	return ret;
+	sdb->sg_count = sg_count;
+	sdb->__sg_count = sg_count;
+	sdb->sglist = ret;
+	return 0;
 enomem:
 	if (ret) {
 		/*
@@ -818,26 +820,26 @@ enomem:
 
 		mempool_free(prev, sgp->pool);
 	}
-	return NULL;
+	return -ENOMEM;
 }
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+void scsi_free_sgtable(struct scsi_data_buffer *sdb)
 {
-	struct scatterlist *sgl = cmd->request_buffer;
+	struct scatterlist *sgl = sdb->sglist;
 	struct scsi_host_sg_pool *sgp;
 
 	/*
 	 * if this is the biggest size sglist, check if we have
 	 * chained parts we need to free
 	 */
-	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
+	if (sdb->__sg_count > SCSI_MAX_SG_SEGMENTS) {
 		unsigned short this, left;
 		struct scatterlist *next;
 		unsigned int index;
 
-		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
+		left = sdb->__sg_count - (SCSI_MAX_SG_SEGMENTS - 1);
 		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
 		while (left && next) {
 			sgl = next;
@@ -861,10 +863,10 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 		/*
 		 * Restore original, will be freed below
 		 */
-		sgl = cmd->request_buffer;
+		sgl = sdb->sglist;
 		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
 	} else
-		sgp = scsi_sg_pools + scsi_sgtable_index(cmd->__use_sg);
+		sgp = scsi_sg_pools + scsi_sgtable_index(sdb->__sg_count);
 
 	mempool_free(sgl, sgp->pool);
 }
@@ -890,15 +892,14 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd);
+	if (cmd->sdb.sglist)
+		scsi_free_sgtable(&cmd->sdb);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
 	 * dangerous to hang onto the pointers.
 	 */
-	cmd->request_buffer = NULL;
-	cmd->request_bufflen = 0;
+	cmd->sdb.sglist = NULL;
 }
 
 /*
@@ -932,7 +933,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
@@ -940,8 +941,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
@@ -964,9 +963,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
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
@@ -974,7 +975,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
+	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", scsi_sg_count(cmd)));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -1105,43 +1106,44 @@ EXPORT_SYMBOL(scsi_io_completion);
  */
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
-	struct request     *req = cmd->request;
-	int		   count;
+	struct request *req = cmd->request;
+	struct scsi_data_buffer *sdb = &cmd->sdb;
+	int count;
+	int ret;
 
 	/*
 	 * We used to not use scatter-gather for single segment request,
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
-	cmd->use_sg = req->nr_phys_segments;
+	ret = scsi_alloc_sgtable(sdb, GFP_ATOMIC, req->nr_phys_segments);
 
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	if (unlikely(ret)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
 	if (blk_pc_request(req))
-		cmd->request_bufflen = req->data_len;
+		sdb->length = req->data_len;
 	else
-		cmd->request_bufflen = req->nr_sectors << 9;
+		sdb->length = req->nr_sectors << 9;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
+	count = blk_rq_map_sg(req->q, req, sdb->sglist);
+	if (likely(count <= sdb->sg_count)) {
+		sdb->sg_count = count;
 		return BLKPREP_OK;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
+	printk(KERN_ERR "counted %d, received %d\n", count, scsi_sg_count(cmd));
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
@@ -1181,7 +1183,7 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1210,9 +1212,6 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
 		req->buffer = NULL;
 	}
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bb6358a..3eac964 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -12,6 +12,13 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_data_buffer {
+	unsigned length;
+	int resid;
+	short sg_count;
+	short __sg_count;
+	struct scatterlist *sglist;
+};
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -83,10 +90,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	int resid;		/* Number of bytes requested to be
-				   transferred less actual number
-				   transferred (0 if not supported) */
-
 	struct request *request;	/* The command we are
 				   	   working on */
 
@@ -118,6 +121,8 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
+
+	struct scsi_data_buffer sdb;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
@@ -133,24 +138,35 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern int scsi_alloc_sgtable(struct scsi_data_buffer *, gfp_t, int);
+extern void scsi_free_sgtable(struct scsi_data_buffer *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
-#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
+{
+	return cmd->sdb.sg_count;
+}
+
+static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
+{
+	return cmd->sdb.sglist;
+}
+
+static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
+{
+	return cmd->sdb.length;
+}
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
-	cmd->resid = resid;
+	cmd->sdb.resid = resid;
 }
 
 static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 {
-	return cmd->resid;
+	return cmd->sdb.resid;
 }
 
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
-- 
1.5.2.4

