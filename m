From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi: scsi_data_buffer
Date: Thu, 13 Dec 2007 13:47:40 +0200
Message-ID: <47611BDC.2030305@panasas.com>
References: <47611977.5080702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12838 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbXLMLsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 06:48:02 -0500
In-Reply-To: <47611977.5080702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>


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

  - fix Documentation about scsi_cmnd in scsi_host.h

  - scsi_error.c
    * Changed needed members of struct scsi_eh_save.
    * Careful considerations in scsi_eh_prep/restore_cmnd.

  - sd.c and sr.c
    * sd and sr would adjust IO size to align on device's block
      size so code needs to change once we move to scsi_data_buff
      implementation.
    * Convert code to use scsi_for_each_sg
    * Use data accessors where appropriate.

  - tgt: convert libsrp to use scsi_data_buffer
  - isd200: This driver still bangs on scsi_cmnd IO members,
    so need changing

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsrp.c        |    4 +-
 drivers/scsi/scsi.c          |    2 +-
 drivers/scsi/scsi_error.c    |   28 +++++----------
 drivers/scsi/scsi_lib.c      |   77 ++++++++++++++++--------------------------
 drivers/scsi/sd.c            |    4 +-
 drivers/scsi/sr.c            |   25 +++++++------
 drivers/usb/storage/isd200.c |    8 ++--
 include/scsi/scsi_cmnd.h     |   39 +++++++++++++--------
 include/scsi/scsi_eh.h       |    8 ++---
 include/scsi/scsi_host.h     |    4 +-
 10 files changed, 91 insertions(+), 108 deletions(-)

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 5cff020..8a8562a 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -426,8 +426,8 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 
 	sc->SCp.ptr = info;
 	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
-	sc->request_bufflen = len;
-	sc->request_buffer = (void *) (unsigned long) addr;
+	sc->sdb.length = len;
+	sc->sdb.sglist = (void *) (unsigned long) addr;
 	sc->tag = tag;
 	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
 				     cmd->tag);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ebc0193..a0fd785 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -712,7 +712,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = cmd->request_bufflen;
+	good_bytes = scsi_bufflen(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 169bc59..241ab48 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -617,29 +617,25 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->cmd_len = scmd->cmd_len;
 	memcpy(ses->cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	ses->data_direction = scmd->sc_data_direction;
-	ses->bufflen = scmd->request_bufflen;
-	ses->buffer = scmd->request_buffer;
-	ses->use_sg = scmd->use_sg;
-	ses->resid = scmd->resid;
+	ses->sdb = scmd->sdb;
 	ses->result = scmd->result;
 
+	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
+
 	if (sense_bytes) {
-		scmd->request_bufflen = min_t(unsigned,
+		scmd->sdb.length = min_t(unsigned,
 		                       sizeof(scmd->sense_buffer), sense_bytes);
 		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
-		                                       scmd->request_bufflen);
-		scmd->request_buffer = &ses->sense_sgl;
+							      scmd->sdb.length);
+		scmd->sdb.sglist = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->use_sg = 1;
+		scmd->sdb.sg_count = 1;
 		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 		scmd->cmnd[0] = REQUEST_SENSE;
-		scmd->cmnd[4] = scmd->request_bufflen;
+		scmd->cmnd[4] = scmd->sdb.length;
 		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	} else {
-		scmd->request_buffer = NULL;
-		scmd->request_bufflen = 0;
 		scmd->sc_data_direction = DMA_NONE;
-		scmd->use_sg = 0;
 		if (cmnd) {
 			memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 			memcpy(scmd->cmnd, cmnd, cmnd_size);
@@ -676,10 +672,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->cmd_len = ses->cmd_len;
 	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = ses->data_direction;
-	scmd->request_bufflen = ses->bufflen;
-	scmd->request_buffer = ses->buffer;
-	scmd->use_sg = ses->use_sg;
-	scmd->resid = ses->resid;
+	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
@@ -1700,8 +1693,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
-	scmd->request_buffer		= NULL;
-	scmd->request_bufflen		= 0;
+	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1a4671..7ac36fe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -440,7 +440,7 @@ EXPORT_SYMBOL_GPL(scsi_execute_async);
 static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = 0;
-	cmd->resid = 0;
+	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
@@ -739,17 +739,15 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	return index;
 }
 
-static struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd,
-								gfp_t gfp_mask)
+static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb,
+					unsigned short sg_count, gfp_t gfp_mask)
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
@@ -803,8 +801,9 @@ static struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd,
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
@@ -823,24 +822,24 @@ enomem:
 
 		mempool_free(prev, sgp->pool);
 	}
-	return NULL;
+	return -ENOMEM;
 }
 
-static void scsi_free_sgtable(struct scsi_cmnd *cmd)
+static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
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
@@ -864,10 +863,10 @@ static void scsi_free_sgtable(struct scsi_cmnd *cmd)
 		/*
 		 * Restore original, will be freed below
 		 */
-		sgl = cmd->request_buffer;
+		sgl = sdb->sglist;
 		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
 	} else
-		sgp = scsi_sg_pools + scsi_sgtable_index(cmd->__use_sg);
+		sgp = scsi_sg_pools + scsi_sgtable_index(sdb->alloc_sg_count);
 
 	mempool_free(sgl, sgp->pool);
 }
@@ -891,15 +890,10 @@ static void scsi_free_sgtable(struct scsi_cmnd *cmd)
  */
 void scsi_release_buffers(struct scsi_cmnd *cmd)
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
 EXPORT_SYMBOL(scsi_release_buffers);
 
@@ -934,7 +928,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
@@ -942,8 +936,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
@@ -966,9 +958,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
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
@@ -976,7 +970,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -1107,36 +1100,26 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
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
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
-	if (unlikely(!cmd->request_buffer)) {
+	if (scsi_alloc_sgtable(sdb, req->nr_phys_segments, gfp_mask)) {
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
-	BUG_ON(count > cmd->use_sg);
-	cmd->use_sg = count;
+	count = blk_rq_map_sg(req->q, req, sdb->sglist);
+	BUG_ON(count > sdb->sg_count);
+	sdb->sg_count = count;
 	return BLKPREP_OK;
 }
 EXPORT_SYMBOL(scsi_init_io);
@@ -1192,9 +1175,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 		req->buffer = NULL;
 	}
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e6d85b0..1fcec1e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -507,7 +507,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[4] = (unsigned char) this_count;
 		SCpnt->cmnd[5] = 0;
 	}
-	SCpnt->request_bufflen = this_count * sdp->sector_size;
+	SCpnt->sdb.length = this_count * sdp->sector_size;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -914,7 +914,7 @@ static struct block_device_operations sd_fops = {
 static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
- 	unsigned int xfer_size = SCpnt->request_bufflen;
+	unsigned int xfer_size = scsi_bufflen(SCpnt);
  	unsigned int good_bytes = result ? 0 : xfer_size;
  	u64 start_lba = SCpnt->request->sector;
  	u64 bad_lba;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7128d15..93d9dc8 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -233,7 +233,7 @@ out:
 static int sr_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->request_bufflen;
+	int this_count = scsi_bufflen(SCpnt);
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
@@ -378,17 +378,18 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	}
 
 	{
-		struct scatterlist *sg = SCpnt->request_buffer;
-		int i, size = 0;
-		for (i = 0; i < SCpnt->use_sg; i++)
-			size += sg[i].length;
+		struct scatterlist *sg;
+		int i, size = 0, sg_count = scsi_sg_count(SCpnt);
 
-		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
+		scsi_for_each_sg(SCpnt, sg, sg_count, i)
+			size += sg->length;
+
+		if (size != scsi_bufflen(SCpnt)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				"mismatch count %d, bytes %d\n",
-				size, SCpnt->request_bufflen);
-			if (SCpnt->request_bufflen > size)
-				SCpnt->request_bufflen = size;
+				size, scsi_bufflen(SCpnt));
+			if (scsi_bufflen(SCpnt) > size)
+				SCpnt->sdb.length = size;
 		}
 	}
 
@@ -396,12 +397,12 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
 	if (((unsigned int)rq->sector % (s_size >> 9)) ||
-	    (SCpnt->request_bufflen % s_size)) {
+	    (scsi_bufflen(SCpnt) % s_size)) {
 		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
 		goto out;
 	}
 
-	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
+	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
 
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
@@ -415,7 +416,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 
 	if (this_count > 0xffff) {
 		this_count = 0xffff;
-		SCpnt->request_bufflen = this_count * s_size;
+		SCpnt->sdb.length = this_count * s_size;
 	}
 
 	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 178e8c2..2d9a32b 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -415,14 +415,14 @@ static void isd200_set_srb(struct isd200_info *info,
 		sg_init_one(&info->sg, buff, bufflen);
 
 	srb->sc_data_direction = dir;
-	srb->request_buffer = buff ? &info->sg : NULL;
-	srb->request_bufflen = bufflen;
-	srb->use_sg = buff ? 1 : 0;
+	srb->sdb.sglist = buff ? &info->sg : NULL;
+	srb->sdb.length = bufflen;
+	srb->sdb.sg_count = buff ? 1 : 0;
 }
 
 static void isd200_srb_set_bufflen(struct scsi_cmnd *srb, unsigned bufflen)
 {
-	srb->request_bufflen = bufflen;
+	srb->sdb.length = bufflen;
 }
 
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a7be605..887a12a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -12,6 +12,13 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_data_buffer {
+	struct scatterlist *sglist;
+	unsigned length;
+	int resid;
+	unsigned short sg_count;
+	unsigned short alloc_sg_count; /* private to scsi_lib */
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
 
@@ -114,6 +112,8 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
+
+	struct scsi_data_buffer sdb;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
@@ -134,18 +134,29 @@ extern void scsi_release_buffers(struct scsi_cmnd *cmd);
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
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index d21b891..1e08be1 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -68,16 +68,14 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 extern int scsi_reset_provider(struct scsi_device *, int);
 
 struct scsi_eh_save {
+	/* saved state */
 	int result;
 	enum dma_data_direction data_direction;
 	unsigned char cmd_len;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
+	struct scsi_data_buffer sdb;
 
-	void *buffer;
-	unsigned bufflen;
-	unsigned short use_sg;
-	int resid;
-
+	/* new command support */
 	struct scatterlist sense_sgl;
 };
 
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
1.5.3.3


