From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 27/32] scsi_data_buffer
Date: Wed, 17 Oct 2007 20:21:15 +0200
Message-ID: <4716529B.7020107@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7171 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758062AbXJQSWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:22:04 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  In preparation for bidi we abstract all IO members of scsi_cmnd,
  that will need to duplicate, into a substructure.

  - Group all IO members of scsi_cmnd into a scsi_data_buffer
    structure.
  - Adjust accessors to new members.
  - scsi_{alloc,free}_sgtable receive a scsi_data_buffer instead of
    scsi_cmnd. And work on it.
  - Adjust scsi_init_io() and  scsi_release_buffers() for above
    change.
  - Fix other parts of scsi_lib/scsi.c to members migration. Use
    accessors where appropriate.

  - Old I/O members are kept for backward compatibility, since
    not all of scsi-ml/ul is converted yet. Once done they will
    be removed in a closing patch. (Other wise the patchset will
    not be bisectable)

  - fix Documentation about scsi_cmnd in scsi_host.h
  - Small API shim in scsi_tgt_lib (to be removed in
    tgt patch)

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
 Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi.c         |    2 +-
 drivers/scsi/scsi_lib.c     |   80 ++++++++++++++++---------------------------
 drivers/scsi/scsi_tgt_lib.c |   18 ++++++++++
 include/scsi/scsi_cmnd.h    |   57 ++++++++++++++++++++++--------
 include/scsi/scsi_host.h    |    4 +-
 5 files changed, 92 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1929488..73d2216 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -698,7 +698,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = cmd->request_bufflen;
+	good_bytes = scsi_bufflen(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aac8a02..ce59cfe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -438,7 +438,7 @@ EXPORT_SYMBOL_GPL(scsi_execute_async);
 static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = 0;
-	cmd->resid = 0;
+	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
@@ -737,16 +737,15 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+int scsi_alloc_sgtable(struct scsi_data_buffer * sdb, unsigned short sg_count,
+                       gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl, *prev, *ret;
 	unsigned int index;
 	int this, left;
 
-	BUG_ON(!cmd->use_sg);
-
-	left = cmd->use_sg;
+	left = sg_count;
 	ret = prev = NULL;
 	do {
 		this = left;
@@ -793,8 +792,9 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	 * ->use_sg may get modified after dma mapping has potentially
 	 * shrunk the number of segments, so keep a copy of it for free.
 	 */
-	cmd->__use_sg = cmd->use_sg;
-	return ret;
+	sdb->alloc_sg_count = sdb->sg_count = sg_count;
+	sdb->sglist = ret;
+	return 0;
 enomem:
 	if (ret) {
 		/*
@@ -813,26 +813,25 @@ enomem:
 
 		mempool_free(prev, sgp->pool);
 	}
-	return NULL;
+	return -1;
 }
-
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
+	if (sdb->alloc_sg_count > SCSI_MAX_SG_SEGMENTS) {
 		unsigned short this, left;
 		struct scatterlist *next;
 		unsigned int index;
 
-		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
+		left = sdb->alloc_sg_count - (SCSI_MAX_SG_SEGMENTS - 1);
 		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
 		while (left && next) {
 			sgl = next;
@@ -856,14 +855,13 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 		/*
 		 * Restore original, will be freed below
 		 */
-		sgl = cmd->request_buffer;
+		sgl = sdb->sglist;
 		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
 	} else
-		sgp = scsi_sg_pools + scsi_sgtable_index(cmd->__use_sg);
+		sgp = scsi_sg_pools + scsi_sgtable_index(sdb->sg_count);
 
 	mempool_free(sgl, sgp->pool);
 }
-
 EXPORT_SYMBOL(scsi_free_sgtable);
 
 /*
@@ -885,15 +883,10 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd);
+	if (cmd->sdb.sglist)
+		scsi_free_sgtable(&cmd->sdb);
 
-	/*
-	 * Zero these out.  They now point to freed memory, and it is
-	 * dangerous to hang onto the pointers.
-	 */
-	cmd->request_buffer = NULL;
-	cmd->request_bufflen = 0;
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 }
 
 /*
@@ -927,7 +920,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
@@ -935,8 +928,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
@@ -959,9 +950,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
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
@@ -969,7 +962,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -1101,41 +1093,31 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
 	int		   count;
+	struct scsi_data_buffer *sdb = &cmd->sdb;
 
-	/*
-	 * We used to not use scatter-gather for single segment request,
-	 * but now we do (it makes highmem I/O easier to support without
-	 * kmapping pages)
-	 */
-	cmd->use_sg = req->nr_phys_segments;
-
-	/*
-	 * If sg table allocation fails, requeue request later.
-	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	if (scsi_alloc_sgtable(sdb, req->nr_phys_segments, GFP_ATOMIC)) {
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
+	printk(KERN_ERR "counted %d, received %d\n", count, sdb->sg_count);
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
@@ -1193,9 +1175,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 		req->buffer = NULL;
 	}
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a91761c..b4b3af5 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -60,6 +60,24 @@ struct scsi_tgt_queuedata {
 	spinlock_t cmd_hash_lock;
 };
 
+/* FIXME Begin: Shim API until tgt is converted to use sdb */
+static struct scatterlist *tgt_scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t flags)
+{
+	if (scsi_alloc_sgtable(&cmd->sdb, cmd->use_sg, flags))
+		return NULL;
+	return cmd->sdb.sglist;
+}
+
+static void tgt_scsi_free_sgtable(struct scsi_cmnd *cmd)
+{
+	scsi_free_sgtable(&cmd->sdb);
+}
+#define scsi_alloc_sgtable tgt_scsi_alloc_sgtable
+#define scsi_free_sgtable tgt_scsi_free_sgtable
+
+/* FIXME End: Shim API until tgt is converted to use sdb */
+
+
 /*
  * Function:	scsi_host_get_command()
  *
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3f47e52..047ffe6 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -12,6 +12,13 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_data_buffer {
+	unsigned length;
+	int resid;
+	unsigned short sg_count;
+	unsigned short alloc_sg_count;
+	struct scatterlist* sglist;
+};
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -62,15 +69,10 @@ struct scsi_cmnd {
 	/* These elements define the operation we are about to perform */
 #define MAX_COMMAND_SIZE	16
 	unsigned char cmnd[MAX_COMMAND_SIZE];
-	unsigned request_bufflen;	/* Actual request size */
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
-	void *request_buffer;		/* Actual requested buffer */
 
 	/* These elements define the operation we ultimately want to perform */
-	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short __use_sg;
-
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -80,10 +82,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	int resid;		/* Number of bytes requested to be
-				   transferred less actual number
-				   transferred (0 if not supported) */
-
 	struct request *request;	/* The command we are
 				   	   working on */
 
@@ -114,6 +112,22 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
+
+	union {
+		struct scsi_data_buffer sdb;
+		/*
+		 * FIXME: Here for compatibility with unconverted drivers.
+		 *        Must be kept in sync with exact type and order
+		 *        of struct scsi_data_buffer members.
+		 */
+		struct {
+			unsigned __deprecated request_bufflen;
+			int __deprecated resid;
+			unsigned short __deprecated use_sg;
+			unsigned short __deprecated place_holder_sg_alloc;
+			void __deprecated *request_buffer;
+		};
+	};
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
@@ -128,24 +142,35 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern int scsi_alloc_sgtable(struct scsi_data_buffer *, unsigned short, gfp_t);
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
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..cb2bcab 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -136,9 +136,9 @@ struct scsi_host_template {
 	 * the done callback is invoked.
 	 *
 	 * This is called to inform the LLD to transfer
-	 * cmd->request_bufflen bytes. The cmd->use_sg speciefies the
+	 * scsi_bufflen(cmd) bytes. scsi_sg_count(cmd) speciefies the
 	 * number of scatterlist entried in the command and
-	 * cmd->request_buffer contains the scatterlist.
+	 * scsi_sglist(cmd) returns the scatterlist.
 	 *
 	 * return values: see queuecommand
 	 *
-- 
1.5.3.1


