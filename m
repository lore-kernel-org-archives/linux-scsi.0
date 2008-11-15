From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [11/21] Remove GFP_DMA uses in st/osst
Date: Sun, 16 Nov 2008 00:11:11 +0100 (CET)
Message-ID: <20081115231111.83C6B3E6619@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44190 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYKOXLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:09 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


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
--- linux.orig/drivers/scsi/osst.c	2008-11-15 22:37:09.000000000 +0100
+++ linux/drivers/scsi/osst.c	2008-11-15 22:37:12.000000000 +0100
@@ -158,8 +158,8 @@
 
 static int modes_defined = 0;
 
-static struct osst_buffer *new_tape_buffer(int, int, int);
-static int enlarge_buffer(struct osst_buffer *, int);
+static struct osst_buffer *new_tape_buffer(int, int);
+static int enlarge_buffer(struct osst_buffer *);
 static void normalize_buffer(struct osst_buffer *);
 static int append_to_buffer(const char __user *, struct osst_buffer *, int);
 static int from_buffer(struct osst_buffer *, char __user *, int);
@@ -4431,7 +4431,7 @@
 		STp->header_ok = 0;
 
 	/* Allocate data segments for this device's tape buffer */
-	if (!enlarge_buffer(STp->buffer, STp->restr_dma)) {
+	if (!enlarge_buffer(STp->buffer)) {
 		printk(KERN_ERR "%s:E: Unable to allocate memory segments for tape buffer.\n", name);
 		retval = (-EOVERFLOW);
 		goto err_out;
@@ -5210,7 +5210,7 @@
 /* Memory handling routines */
 
 /* Try to allocate a new tape buffer skeleton. Caller must not hold os_scsi_tapes_lock */
-static struct osst_buffer * new_tape_buffer( int from_initialization, int need_dma, int max_sg )
+static struct osst_buffer * new_tape_buffer( int from_initialization, int max_sg )
 {
 	int i;
 	gfp_t priority;
@@ -5231,19 +5231,18 @@
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
@@ -5261,8 +5260,6 @@
 		return 0;
 
 	priority = GFP_KERNEL /* | __GFP_NOWARN */;
-	if (need_dma)
-		priority |= GFP_DMA;
 
 	/* Try to allocate the first segment up to OS_DATA_SIZE and the others
 	   big enough to reach the goal (code assumes no segments in place) */
@@ -5307,8 +5304,8 @@
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
@@ -5806,7 +5803,7 @@
 	i = SDp->host->sg_tablesize;
 	if (osst_max_sg_segs < i)
 		i = osst_max_sg_segs;
-	buffer = new_tape_buffer(1, SDp->host->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(1, i);
 	if (buffer == NULL) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Unable to allocate a tape buffer, device not attached.\n");
@@ -5824,7 +5821,6 @@
 	tpnt->capacity = 0xfffff;
 	tpnt->dirty = 0;
 	tpnt->drv_buffer = 1;  /* Try buffering if no mode sense */
-	tpnt->restr_dma = (SDp->host)->unchecked_isa_dma;
 	tpnt->density = 0;
 	tpnt->do_auto_lock = OSST_AUTO_LOCK;
 	tpnt->can_bsr = OSST_IN_FILE_POS;
Index: linux/drivers/scsi/osst.h
===================================================================
--- linux.orig/drivers/scsi/osst.h	2008-11-15 22:37:09.000000000 +0100
+++ linux/drivers/scsi/osst.h	2008-11-15 22:37:12.000000000 +0100
@@ -510,7 +510,6 @@
 /* The OnStream tape buffer descriptor. */
 struct osst_buffer {
   unsigned char in_use;
-  unsigned char dma;	/* DMA-able buffer */
   int buffer_size;
   int buffer_blocks;
   int buffer_bytes;
@@ -544,7 +543,6 @@
   unsigned char can_partitions;
   unsigned char two_fm;
   unsigned char fast_mteom;
-  unsigned char restr_dma;
   unsigned char scsi2_logical;
   unsigned char default_drvbuffer;  /* 0xff = don't touch, value 3 bits */
   unsigned char pos_unknown;        /* after reset position unknown */
Index: linux/drivers/scsi/st.c
===================================================================
--- linux.orig/drivers/scsi/st.c	2008-11-15 22:37:09.000000000 +0100
+++ linux/drivers/scsi/st.c	2008-11-15 23:50:57.000000000 +0100
@@ -182,8 +182,8 @@
 
 static int modes_defined;
 
-static struct st_buffer *new_tape_buffer(int, int, int);
-static int enlarge_buffer(struct st_buffer *, int, int);
+static struct st_buffer *new_tape_buffer(int, int);
+static int enlarge_buffer(struct scsi_tape *t, struct st_buffer *, int);
 static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
 static int append_to_buffer(const char __user *, struct st_buffer *, int);
@@ -1155,7 +1155,7 @@
 	}
 
 	/* See that we have at least a one page buffer available */
-	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
+	if (!enlarge_buffer(STp, STp->buffer, PAGE_SIZE)) {
 		printk(KERN_WARNING "%s: Can't allocate one page tape buffer.\n",
 		       name);
 		retval = (-EOVERFLOW);
@@ -1447,7 +1447,7 @@
 		}
 
 		if (bufsize > STbp->buffer_size &&
-		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
+		    !enlarge_buffer(STp, STbp, bufsize)) {
 			printk(KERN_WARNING "%s: Can't allocate %d byte tape buffer.\n",
 			       tape_name(STp), bufsize);
 			retval = (-EOVERFLOW);
@@ -3606,7 +3606,7 @@
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
 static struct st_buffer *
- new_tape_buffer(int from_initialization, int need_dma, int max_sg)
+ new_tape_buffer(int from_initialization, int max_sg)
 {
 	int i, got = 0;
 	gfp_t priority;
@@ -3628,7 +3628,6 @@
 	tb->use_sg = max_sg;
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
-	tb->dma = need_dma;
 	tb->buffer_size = got;
 	sg_init_table(tb->sg, max_sg);
 
@@ -3637,9 +3636,11 @@
 
 
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
@@ -3654,20 +3655,18 @@
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
@@ -3702,11 +3701,10 @@
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
@@ -3935,7 +3933,7 @@
 		SDp->request_queue->max_phys_segments);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
-	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(1, i);
 	if (buffer == NULL) {
 		printk(KERN_ERR
 		       "st: Can't allocate new tape buffer. Device not attached.\n");
@@ -4014,7 +4012,6 @@
 	tpnt->dirty = 0;
 	tpnt->in_use = 0;
 	tpnt->drv_buffer = 1;	/* Try buffering if no mode sense */
-	tpnt->restr_dma = (SDp->host)->unchecked_isa_dma;
 	tpnt->use_pf = (SDp->scsi_level >= SCSI_2);
 	tpnt->density = 0;
 	tpnt->do_auto_lock = ST_AUTO_LOCK;
Index: linux/drivers/scsi/st.h
===================================================================
--- linux.orig/drivers/scsi/st.h	2008-11-15 22:37:09.000000000 +0100
+++ linux/drivers/scsi/st.h	2008-11-15 22:37:12.000000000 +0100
@@ -33,7 +33,6 @@
 
 /* The tape buffer descriptor. */
 struct st_buffer {
-	unsigned char dma;	/* DMA-able buffer */
 	unsigned char do_dio;   /* direct i/o set up? */
 	unsigned char cleared;  /* internal buffer cleared after open? */
 	int buffer_size;
@@ -113,7 +112,6 @@
 	unsigned char two_fm;
 	unsigned char fast_mteom;
 	unsigned char immediate;
-	unsigned char restr_dma;
 	unsigned char scsi2_logical;
 	unsigned char default_drvbuffer;	/* 0xff = don't touch, value 3 bits */
 	unsigned char cln_mode;			/* 0 = none, otherwise sense byte nbr */
