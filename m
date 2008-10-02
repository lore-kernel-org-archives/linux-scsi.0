From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [11/21] SCSI-ISA-DMA: Remove GFP_DMA uses in st/osst
Date: Thu,  2 Oct 2008 09:58:49 +0200 (CEST)
Message-ID: <20081002075849.4D7643E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYJBH6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:51 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Parts of it were already dead code: the ->dma member was only set, but not read.

Then also remove the code to allocate buffers with GFP_DMA, because this
goes all through the block layer which bounces anyways.

Also remove code to disable direct sg for unchecked_isa_dma

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/osst.c |   24 ++++++++++--------------
 drivers/scsi/osst.h |    2 --
 drivers/scsi/st.c   |   35 ++++++++++++++++-------------------
 drivers/scsi/st.h   |    2 --
 4 files changed, 26 insertions(+), 37 deletions(-)

Index: linux/drivers/scsi/osst.c
===================================================================
--- linux.orig/drivers/scsi/osst.c
+++ linux/drivers/scsi/osst.c
@@ -158,8 +158,8 @@ static DEFINE_RWLOCK(os_scsi_tapes_lock)
 
 static int modes_defined = 0;
 
-static struct osst_buffer *new_tape_buffer(int, int, int);
-static int enlarge_buffer(struct osst_buffer *, int);
+static struct osst_buffer *new_tape_buffer(int, int);
+static int enlarge_buffer(struct osst_buffer *);
 static void normalize_buffer(struct osst_buffer *);
 static int append_to_buffer(const char __user *, struct osst_buffer *, int);
 static int from_buffer(struct osst_buffer *, char __user *, int);
@@ -4431,7 +4431,7 @@ static int __os_scsi_tape_open(struct in
 		STp->header_ok = 0;
 
 	/* Allocate data segments for this device's tape buffer */
-	if (!enlarge_buffer(STp->buffer, STp->restr_dma)) {
+	if (!enlarge_buffer(STp->buffer)) {
 		printk(KERN_ERR "%s:E: Unable to allocate memory segments for tape buffer.\n", name);
 		retval = (-EOVERFLOW);
 		goto err_out;
@@ -5210,7 +5210,7 @@ static long osst_compat_ioctl(struct fil
 /* Memory handling routines */
 
 /* Try to allocate a new tape buffer skeleton. Caller must not hold os_scsi_tapes_lock */
-static struct osst_buffer * new_tape_buffer( int from_initialization, int need_dma, int max_sg )
+static struct osst_buffer * new_tape_buffer( int from_initialization, int max_sg )
 {
 	int i;
 	gfp_t priority;
@@ -5231,19 +5231,18 @@ static struct osst_buffer * new_tape_buf
 	tb->sg_segs = tb->orig_sg_segs = 0;
 	tb->use_sg = max_sg;
 	tb->in_use = 1;
-	tb->dma = need_dma;
 	tb->buffer_size = 0;
 #if DEBUG
 	if (debugging) 
 		printk(OSST_DEB_MSG
-			"osst :D: Allocated tape buffer skeleton (%d bytes, %d segments, dma: %d).\n",
-			   i, max_sg, need_dma);
+			"osst :D: Allocated tape buffer skeleton (%d bytes, %d segments).\n",
+			   i, max_sg);
 #endif
 	return tb;
 }
 
 /* Try to allocate a temporary (while a user has the device open) enlarged tape buffer */
-static int enlarge_buffer(struct osst_buffer *STbuffer, int need_dma)
+static int enlarge_buffer(struct osst_buffer *STbuffer)
 {
 	int segs, nbr, max_segs, b_size, order, got;
 	gfp_t priority;
@@ -5261,8 +5260,6 @@ static int enlarge_buffer(struct osst_bu
 		return 0;
 
 	priority = GFP_KERNEL /* | __GFP_NOWARN */;
-	if (need_dma)
-		priority |= GFP_DMA;
 
 	/* Try to allocate the first segment up to OS_DATA_SIZE and the others
 	   big enough to reach the goal (code assumes no segments in place) */
@@ -5307,8 +5304,8 @@ static int enlarge_buffer(struct osst_bu
 #if DEBUG
 	if (debugging) {
 		printk(OSST_DEB_MSG
-			   "osst :D: Expanded tape buffer (%d bytes, %d->%d segments, dma: %d, at: %p).\n",
-			   got, STbuffer->orig_sg_segs, STbuffer->sg_segs, need_dma, STbuffer->b_data);
+			   "osst :D: Expanded tape buffer (%d bytes, %d->%d segments, at: %p).\n",
+			   got, STbuffer->orig_sg_segs, STbuffer->sg_segs, STbuffer->b_data);
 		printk(OSST_DEB_MSG
 			   "osst :D: segment sizes: first %d at %p, last %d bytes at %p.\n",
 			   STbuffer->sg[0].length, page_address(STbuffer->sg[0].page),
@@ -5805,7 +5802,7 @@ static int osst_probe(struct device *dev
 	i = SDp->host->sg_tablesize;
 	if (osst_max_sg_segs < i)
 		i = osst_max_sg_segs;
-	buffer = new_tape_buffer(1, SDp->host->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(1, i);
 	if (buffer == NULL) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Unable to allocate a tape buffer, device not attached.\n");
@@ -5823,7 +5820,6 @@ static int osst_probe(struct device *dev
 	tpnt->capacity = 0xfffff;
 	tpnt->dirty = 0;
 	tpnt->drv_buffer = 1;  /* Try buffering if no mode sense */
-	tpnt->restr_dma = (SDp->host)->unchecked_isa_dma;
 	tpnt->density = 0;
 	tpnt->do_auto_lock = OSST_AUTO_LOCK;
 	tpnt->can_bsr = OSST_IN_FILE_POS;
Index: linux/drivers/scsi/osst.h
===================================================================
--- linux.orig/drivers/scsi/osst.h
+++ linux/drivers/scsi/osst.h
@@ -510,7 +510,6 @@ typedef struct os_header_s {
 /* The OnStream tape buffer descriptor. */
 struct osst_buffer {
   unsigned char in_use;
-  unsigned char dma;	/* DMA-able buffer */
   int buffer_size;
   int buffer_blocks;
   int buffer_bytes;
@@ -544,7 +543,6 @@ struct osst_tape {
   unsigned char can_partitions;
   unsigned char two_fm;
   unsigned char fast_mteom;
-  unsigned char restr_dma;
   unsigned char scsi2_logical;
   unsigned char default_drvbuffer;  /* 0xff = don't touch, value 3 bits */
   unsigned char pos_unknown;        /* after reset position unknown */
Index: linux/drivers/scsi/st.c
===================================================================
--- linux.orig/drivers/scsi/st.c
+++ linux/drivers/scsi/st.c
@@ -182,8 +182,8 @@ static struct scsi_tape **scsi_tapes = N
 
 static int modes_defined;
 
-static struct st_buffer *new_tape_buffer(int, int, int);
-static int enlarge_buffer(struct st_buffer *, int, int);
+static struct st_buffer *new_tape_buffer(int, int);
+static int enlarge_buffer(struct scsi_tape *t, struct st_buffer *, int);
 static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
 static int append_to_buffer(const char __user *, struct st_buffer *, int);
@@ -1155,7 +1155,7 @@ static int st_open(struct inode *inode, 
 	}
 
 	/* See that we have at least a one page buffer available */
-	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
+	if (!enlarge_buffer(STp, STp->buffer, PAGE_SIZE)) {
 		printk(KERN_WARNING "%s: Can't allocate one page tape buffer.\n",
 		       name);
 		retval = (-EOVERFLOW);
@@ -1447,7 +1447,7 @@ static int setup_buffering(struct scsi_t
 		}
 
 		if (bufsize > STbp->buffer_size &&
-		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
+		    !enlarge_buffer(STp, STbp, bufsize)) {
 			printk(KERN_WARNING "%s: Can't allocate %d byte tape buffer.\n",
 			       tape_name(STp), bufsize);
 			retval = (-EOVERFLOW);
@@ -3605,7 +3605,7 @@ static long st_compat_ioctl(struct file 
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
 static struct st_buffer *
- new_tape_buffer(int from_initialization, int need_dma, int max_sg)
+ new_tape_buffer(int from_initialization, int max_sg)
 {
 	int i, got = 0;
 	gfp_t priority;
@@ -3627,7 +3627,6 @@ static struct st_buffer *
 	tb->use_sg = max_sg;
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
-	tb->dma = need_dma;
 	tb->buffer_size = got;
 	sg_init_table(tb->sg, max_sg);
 
@@ -3636,9 +3635,11 @@ static struct st_buffer *
 
 
 /* Try to allocate enough space in the tape buffer */
-static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dma)
+static int enlarge_buffer(struct scsi_tape *t, struct st_buffer * STbuffer,
+			  int new_size)
 {
-	int segs, nbr, max_segs, b_size, order, got;
+	struct request_queue *q = t->device->request_queue;
+	int segs, nbr, max_segs, b_size, got;
 	gfp_t priority;
 
 	if (new_size <= STbuffer->buffer_size)
@@ -3653,20 +3654,18 @@ static int enlarge_buffer(struct st_buff
 		return 0;
 
 	priority = GFP_KERNEL | __GFP_NOWARN;
-	if (need_dma)
-		priority |= GFP_DMA;
-	for (b_size = PAGE_SIZE, order=0; order <= 6 &&
+	for (b_size = PAGE_SIZE; b_size <= (PAGE_SIZE << 6) &&
 	     b_size < new_size - STbuffer->buffer_size;
-	     order++, b_size *= 2)
+	     b_size *= 2)
 		;  /* empty */
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
 	     segs < max_segs && got < new_size;) {
-		STbuffer->frp[segs].page = alloc_pages(priority, order);
+		STbuffer->frp[segs].page = alloc_pages_mask(priority,
+					b_size, blk_q_mask(q));
 		if (STbuffer->frp[segs].page == NULL) {
 			if (new_size - got <= (max_segs - segs) * b_size / 2) {
 				b_size /= 2; /* Large enough for the rest of the buffers */
-				order--;
 				continue;
 			}
 			DEB(STbuffer->buffer_size = got);
@@ -3701,11 +3700,10 @@ static void clear_buffer(struct st_buffe
 /* Release the extra buffer */
 static void normalize_buffer(struct st_buffer * STbuffer)
 {
-	int i, order;
+	int i;
 
 	for (i = STbuffer->orig_frp_segs; i < STbuffer->frp_segs; i++) {
-		order = get_order(STbuffer->frp[i].length);
-		__free_pages(STbuffer->frp[i].page, order);
+		__free_pages_mask(STbuffer->frp[i].page, STbuffer->frp[i].length);
 		STbuffer->buffer_size -= STbuffer->frp[i].length;
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
@@ -3934,7 +3932,7 @@ static int st_probe(struct device *dev)
 		SDp->request_queue->max_phys_segments);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
-	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(1, i);
 	if (buffer == NULL) {
 		printk(KERN_ERR
 		       "st: Can't allocate new tape buffer. Device not attached.\n");
@@ -4013,7 +4011,6 @@ static int st_probe(struct device *dev)
 	tpnt->dirty = 0;
 	tpnt->in_use = 0;
 	tpnt->drv_buffer = 1;	/* Try buffering if no mode sense */
-	tpnt->restr_dma = (SDp->host)->unchecked_isa_dma;
 	tpnt->use_pf = (SDp->scsi_level >= SCSI_2);
 	tpnt->density = 0;
 	tpnt->do_auto_lock = ST_AUTO_LOCK;
Index: linux/drivers/scsi/st.h
===================================================================
--- linux.orig/drivers/scsi/st.h
+++ linux/drivers/scsi/st.h
@@ -33,7 +33,6 @@ struct st_request {
 
 /* The tape buffer descriptor. */
 struct st_buffer {
-	unsigned char dma;	/* DMA-able buffer */
 	unsigned char do_dio;   /* direct i/o set up? */
 	unsigned char cleared;  /* internal buffer cleared after open? */
 	int buffer_size;
@@ -113,7 +112,6 @@ struct scsi_tape {
 	unsigned char two_fm;
 	unsigned char fast_mteom;
 	unsigned char immediate;
-	unsigned char restr_dma;
 	unsigned char scsi2_logical;
 	unsigned char default_drvbuffer;	/* 0xff = don't touch, value 3 bits */
 	unsigned char cln_mode;			/* 0 = none, otherwise sense byte nbr */
