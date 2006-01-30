From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] st: cleanup new_tape_buffer
Date: Mon, 30 Jan 2006 19:19:41 +0100
Message-ID: <20060130181941.GA6185@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20203 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751278AbWA3STo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 13:19:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - remove superflous forward prototype
 - remove whitespace before function name
 - update header comment
 - remove from_initialization parametes.  It was always 1, but should
   always be 0 because all callers can sleep
 - use kzalloc
 - remove variable 'got', it was always 0


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/st.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/st.c	2006-01-30 19:14:29.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/st.c	2006-01-30 19:15:13.000000000 +0100
@@ -180,7 +180,6 @@
 
 static int modes_defined;
 
-static struct st_buffer *new_tape_buffer(int, int, int);
 static int enlarge_buffer(struct st_buffer *, int, int);
 static void normalize_buffer(struct st_buffer *);
 static int append_to_buffer(const char __user *, struct st_buffer *, int);
@@ -3574,35 +3573,27 @@
 
 

 
-/* Try to allocate a new tape buffer. Calling function must not hold
-   dev_arr_lock. */
+/* Allocate a new tape buffer. */
 static struct st_buffer *
- new_tape_buffer(int from_initialization, int need_dma, int max_sg)
+new_tape_buffer(int need_dma, int max_sg)
 {
-	int i, got = 0;
-	gfp_t priority;
+	int i;
 	struct st_buffer *tb;
 
-	if (from_initialization)
-		priority = GFP_ATOMIC;
-	else
-		priority = GFP_KERNEL;
-
 	i = sizeof(struct st_buffer) + (max_sg - 1) * sizeof(struct scatterlist) +
 		max_sg * sizeof(struct st_buf_fragment);
-	tb = kmalloc(i, priority);
+	tb = kzalloc(i, GFP_KERNEL);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
 	}
-	memset(tb, 0, i);
 	tb->frp_segs = tb->orig_frp_segs = 0;
 	tb->use_sg = max_sg;
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
 	tb->in_use = 1;
 	tb->dma = need_dma;
-	tb->buffer_size = got;
+	tb->buffer_size = 0;
 
 	return tb;
 }
@@ -3896,7 +3887,7 @@
 		SDp->request_queue->max_phys_segments);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
-	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(SDp->host->unchecked_isa_dma, i);
 	if (buffer == NULL) {
 		printk(KERN_ERR
 		       "st: Can't allocate new tape buffer. Device not attached.\n");
