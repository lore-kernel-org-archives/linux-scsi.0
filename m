From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Thu, 19 Nov 2009 16:46:18 +0900
Message-ID: <20091119164558H.fujita.tomonori@lab.ntt.co.jp>
References: <4B028253.1040407@jmbreuer.net>
	<alpine.LNX.2.00.0911172231040.20752@kai.makisara.local>
	<alpine.LNX.2.00.0911182338070.13484@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40994 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZKSHqa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 02:46:30 -0500
In-Reply-To: <alpine.LNX.2.00.0911182338070.13484@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-kernel@jmbreuer.net, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Wed, 18 Nov 2009 23:55:10 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Tue, 17 Nov 2009, Kai Makisara wrote:
> 
> > On Tue, 17 Nov 2009, linux-kernel@jmbreuer.net wrote:
> > 
> > > FUJITA Tomonori wrote:
> > > >>> Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
> > > >>> spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
> > > >>> is hit shortly thereafter.
> > > >>>
> ...
> > I don't have enough energy tonight to experiment (sleep deprived ;-) but I 
> > have looked at the output and may have found something. The buffer size 
> > 516096 B = 504 kB = 126 * 4096 looks suspicious, especially with 512 kB 
> > fixed blocks. In this case the buffer should be at least one block. This 
> > is given to enlarge_buffer() as argument.
> > 
> > Looking at enlarge_buffer(), it seems to me that if the allocation loop 
> > near the end fails with segs < max_segs before got > new_size, we have a 
> > bug: the allocation actually fails but it is returned as success. However, 
> > I don't have any explanation why this would happen.
> > 
> > I will continue tomorrow (after work).
> > 
> OK, I have continued but not found the bug. I have also read the other 
> messages from today. The problem seems to be related to direct i/o.
> 
> The logs from the problem case gives some information about what is 
> happening. This is from the log with variable block size:
> 
> st0: Number of r/w requests 86, dio used in 1, pages 128.                                                    
> st0: Block limits 1 - 16777215 bytes.                                                                        
> st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
> st0: Density 26, tape length: 0, drv buffer: 1
> st0: Block size: 0, buffer size: 516096 (1 blocks).
> 
> The first line is from closing the file. It shows that, in this case, 
> direct i/o was used in one write and the other ones have, for some reason, 
> used the internal buffer. The aic7xxx driver supports 128 scatter/gather 
> segments and so it is capable of using direct i/o up to 512 kB. It has 
> gone to using buffer for some other reason (alignment?).
> 
> The following lines are from the next open. The buffer is (should be) 
> deallocated at close() (normalize_buffer() called) but, in this case, 
> something is wrong.

As you suggested earlier, looks like normalize_buffer() doesn't free
all the buffers. I think that I found one bug that causes to this.

When enlarge_buffer() allocates 524288 from 0, st uses six-order page
allocation. So mdata->page_order is 6 and frp_seg is 2.

After that, if st uses dio, sgl_map_user_pages() sets
mdata->page_order to 0 for st_do_scsi(). After that, when we call
normalize_buffer(), it frees only free frp_seg * PAGE_SIZE (2 * 4096)
though we should free frp_seg * PAGE_SIZE << 6 (2 * 4096 << 6). So we
see buffer_size is set to 516096 (524288 - 8192).

Here's a fix for this.

Thanks,

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 12d58a7..9c44828 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -552,13 +552,15 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	SRpnt->waiting = waiting;
 
 	if (STp->buffer->do_dio) {
+		mdata->page_order = 0;
 		mdata->nr_entries = STp->buffer->sg_segs;
 		mdata->pages = STp->buffer->mapped_pages;
 	} else {
+		mdata->page_order = STp->buffer->reserved_page_order;
 		mdata->nr_entries =
 			DIV_ROUND_UP(bytes, PAGE_SIZE << mdata->page_order);
-		STp->buffer->map_data.pages = STp->buffer->reserved_pages;
-		STp->buffer->map_data.offset = 0;
+		mdata->pages = STp->buffer->reserved_pages;
+		mdata->offset = 0;
 	}
 
 	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
@@ -3699,6 +3701,9 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 	int segs, nbr, max_segs, b_size, order, got;
 	gfp_t priority;
 
+	DEB(printk("%s: %d %u %d\n", __func__, new_size, STbuffer->buffer_size,
+		   STbuffer->reserved_page_order);)
+
 	if (new_size <= STbuffer->buffer_size)
 		return 1;
 
@@ -3718,7 +3723,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		priority |= __GFP_ZERO;
 
 	if (STbuffer->frp_segs) {
-		order = STbuffer->map_data.page_order;
+		order = STbuffer->reserved_page_order;
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order = 0;
@@ -3751,7 +3756,9 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
-	STbuffer->map_data.page_order = order;
+	STbuffer->reserved_page_order = order;
+
+	DEB(printk("%s: %d %u %d\n", __func__, new_size, STbuffer->buffer_size,	order);)
 
 	return 1;
 }
@@ -3764,7 +3771,7 @@ static void clear_buffer(struct st_buffer * st_bp)
 
 	for (i=0; i < st_bp->frp_segs; i++)
 		memset(page_address(st_bp->reserved_pages[i]), 0,
-		       PAGE_SIZE << st_bp->map_data.page_order);
+		       PAGE_SIZE << st_bp->reserved_page_order);
 	st_bp->cleared = 1;
 }
 
@@ -3772,7 +3779,7 @@ static void clear_buffer(struct st_buffer * st_bp)
 /* Release the extra buffer */
 static void normalize_buffer(struct st_buffer * STbuffer)
 {
-	int i, order = STbuffer->map_data.page_order;
+	int i, order = STbuffer->reserved_page_order;
 
 	for (i = 0; i < STbuffer->frp_segs; i++) {
 		__free_pages(STbuffer->reserved_pages[i], order);
@@ -3780,8 +3787,11 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 	}
 	STbuffer->frp_segs = 0;
 	STbuffer->sg_segs = 0;
-	STbuffer->map_data.page_order = 0;
+	STbuffer->reserved_page_order = 0;
 	STbuffer->map_data.offset = 0;
+
+	if (STbuffer->buffer_size)
+		printk(KERN_ERR "%s: %u\n", __func__, STbuffer->buffer_size);
 }
 
 
@@ -3790,7 +3800,7 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count)
 {
 	int i, cnt, res, offset;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	for (i = 0, offset = st_bp->buffer_bytes;
 	     i < st_bp->frp_segs && offset >= length; i++)
@@ -3822,7 +3832,7 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 {
 	int i, cnt, res, offset;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	for (i = 0, offset = st_bp->read_pointer;
 	     i < st_bp->frp_segs && offset >= length; i++)
@@ -3855,7 +3865,7 @@ static void move_buffer_data(struct st_buffer * st_bp, int offset)
 {
 	int src_seg, dst_seg, src_offset = 0, dst_offset;
 	int count, total;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	if (offset == 0)
 		return;
@@ -4577,7 +4587,6 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
         }
 
 	mdata->offset = uaddr & ~PAGE_MASK;
-	mdata->page_order = 0;
 	STbp->mapped_pages = pages;
 
 	return nr_pages;
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 544dc6b..f91a67c 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -46,6 +46,7 @@ struct st_buffer {
 	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
 	struct page **reserved_pages;
+	int reserved_page_order;
 	struct page **mapped_pages;
 	struct rq_map_data map_data;
 	unsigned char *b_data;
