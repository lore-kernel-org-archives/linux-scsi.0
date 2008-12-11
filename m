From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 09/13] st: kill struct st_buff_fragment
Date: Thu, 11 Dec 2008 23:07:46 +0900
Message-ID: <1229004470-25718-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43891 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbYLKOK5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:57 -0500
In-Reply-To: <1229004470-25718-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This removes struct st_buff_fragment and use reserved_pages array to
store fragment buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   78 +++++++++++++++++++++++++++++-----------------------
 drivers/scsi/st.h |    7 -----
 2 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 40c1305..1547acf 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3752,8 +3752,9 @@ static struct st_buffer *
 	else
 		priority = GFP_KERNEL;
 
-	i = sizeof(struct st_buffer) + (max_sg - 1) * sizeof(struct scatterlist) +
-		max_sg * sizeof(struct st_buf_fragment);
+	i = sizeof(struct st_buffer) +
+		(max_sg - 1) * sizeof(struct scatterlist);
+
 	tb = kzalloc(i, priority);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
@@ -3761,7 +3762,6 @@ static struct st_buffer *
 	}
 	tb->frp_segs = tb->orig_frp_segs = 0;
 	tb->use_sg = max_sg;
-	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
 	tb->dma = need_dma;
 	tb->buffer_size = got;
@@ -3798,9 +3798,12 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 	if (need_dma)
 		priority |= GFP_DMA;
 
+	if (STbuffer->cleared)
+		priority |= __GFP_ZERO;
+
 	if (STbuffer->frp_segs) {
-		b_size = STbuffer->frp[0].length;
-		order = get_order(b_size);
+		order = STbuffer->map_data.page_order;
+		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order=0;
 		     order <= 6 && b_size < new_size; order++, b_size *= 2)
@@ -3809,22 +3812,22 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
 	     segs < max_segs && got < new_size;) {
-		STbuffer->frp[segs].page = alloc_pages(priority, order);
-		if (STbuffer->frp[segs].page == NULL) {
+		struct page *page;
+
+		page = alloc_pages(priority, order);
+		if (!page) {
 			DEB(STbuffer->buffer_size = got);
 			normalize_buffer(STbuffer);
 			return 0;
 		}
-		STbuffer->frp[segs].length = b_size;
+
 		STbuffer->frp_segs += 1;
 		got += b_size;
 		STbuffer->buffer_size = got;
-		if (STbuffer->cleared)
-			memset(page_address(STbuffer->frp[segs].page), 0, b_size);
-		STbuffer->reserved_pages[segs] = STbuffer->frp[segs].page;
+		STbuffer->reserved_pages[segs] = page;
 		segs++;
 	}
-	STbuffer->b_data = page_address(STbuffer->frp[0].page);
+	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
 	STbuffer->map_data.page_order = order;
 
 	return 1;
@@ -3837,7 +3840,8 @@ static void clear_buffer(struct st_buffer * st_bp)
 	int i;
 
 	for (i=0; i < st_bp->frp_segs; i++)
-		memset(page_address(st_bp->frp[i].page), 0, st_bp->frp[i].length);
+		memset(page_address(st_bp->reserved_pages[i]), 0,
+		       PAGE_SIZE << st_bp->map_data.page_order);
 	st_bp->cleared = 1;
 }
 
@@ -3845,12 +3849,11 @@ static void clear_buffer(struct st_buffer * st_bp)
 /* Release the extra buffer */
 static void normalize_buffer(struct st_buffer * STbuffer)
 {
-	int i, order;
+	int i, order = STbuffer->map_data.page_order;
 
 	for (i = STbuffer->orig_frp_segs; i < STbuffer->frp_segs; i++) {
-		order = get_order(STbuffer->frp[i].length);
-		__free_pages(STbuffer->frp[i].page, order);
-		STbuffer->buffer_size -= STbuffer->frp[i].length;
+		__free_pages(STbuffer->reserved_pages[i], order);
+		STbuffer->buffer_size -= (PAGE_SIZE << order);
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
@@ -3865,18 +3868,19 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count)
 {
 	int i, cnt, res, offset;
+	int length = PAGE_SIZE << st_bp->map_data.page_order;
 
 	for (i = 0, offset = st_bp->buffer_bytes;
-	     i < st_bp->frp_segs && offset >= st_bp->frp[i].length; i++)
-		offset -= st_bp->frp[i].length;
+	     i < st_bp->frp_segs && offset >= length; i++)
+		offset -= length;
 	if (i == st_bp->frp_segs) {	/* Should never happen */
 		printk(KERN_WARNING "st: append_to_buffer offset overflow.\n");
 		return (-EIO);
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
-		cnt = st_bp->frp[i].length - offset < do_count ?
-		    st_bp->frp[i].length - offset : do_count;
-		res = copy_from_user(page_address(st_bp->frp[i].page) + offset, ubp, cnt);
+		struct page *page = st_bp->reserved_pages[i];
+		cnt = length - offset < do_count ? length - offset : do_count;
+		res = copy_from_user(page_address(page) + offset, ubp, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -3896,18 +3900,19 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 {
 	int i, cnt, res, offset;
+	int length = PAGE_SIZE << st_bp->map_data.page_order;
 
 	for (i = 0, offset = st_bp->read_pointer;
-	     i < st_bp->frp_segs && offset >= st_bp->frp[i].length; i++)
-		offset -= st_bp->frp[i].length;
+	     i < st_bp->frp_segs && offset >= length; i++)
+		offset -= length;
 	if (i == st_bp->frp_segs) {	/* Should never happen */
 		printk(KERN_WARNING "st: from_buffer offset overflow.\n");
 		return (-EIO);
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
-		cnt = st_bp->frp[i].length - offset < do_count ?
-		    st_bp->frp[i].length - offset : do_count;
-		res = copy_to_user(ubp, page_address(st_bp->frp[i].page) + offset, cnt);
+		struct page *page = st_bp->reserved_pages[i];
+		cnt = length - offset < do_count ? length - offset : do_count;
+		res = copy_to_user(ubp, page_address(page) + offset, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -3928,6 +3933,7 @@ static void move_buffer_data(struct st_buffer * st_bp, int offset)
 {
 	int src_seg, dst_seg, src_offset = 0, dst_offset;
 	int count, total;
+	int length = PAGE_SIZE << st_bp->map_data.page_order;
 
 	if (offset == 0)
 		return;
@@ -3935,24 +3941,26 @@ static void move_buffer_data(struct st_buffer * st_bp, int offset)
 	total=st_bp->buffer_bytes - offset;
 	for (src_seg=0; src_seg < st_bp->frp_segs; src_seg++) {
 		src_offset = offset;
-		if (src_offset < st_bp->frp[src_seg].length)
+		if (src_offset < length)
 			break;
-		offset -= st_bp->frp[src_seg].length;
+		offset -= length;
 	}
 
 	st_bp->buffer_bytes = st_bp->read_pointer = total;
 	for (dst_seg=dst_offset=0; total > 0; ) {
-		count = min(st_bp->frp[dst_seg].length - dst_offset,
-			    st_bp->frp[src_seg].length - src_offset);
-		memmove(page_address(st_bp->frp[dst_seg].page) + dst_offset,
-			page_address(st_bp->frp[src_seg].page) + src_offset, count);
+		struct page *dpage = st_bp->reserved_pages[dst_seg];
+		struct page *spage = st_bp->reserved_pages[src_seg];
+
+		count = min(length - dst_offset, length - src_offset);
+		memmove(page_address(dpage) + dst_offset,
+			page_address(spage) + src_offset, count);
 		src_offset += count;
-		if (src_offset >= st_bp->frp[src_seg].length) {
+		if (src_offset >= length) {
 			src_seg++;
 			src_offset = 0;
 		}
 		dst_offset += count;
-		if (dst_offset >= st_bp->frp[dst_seg].length) {
+		if (dst_offset >= length) {
 			dst_seg++;
 			dst_offset = 0;
 		}
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index d80926f..cc46f18 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -54,16 +54,9 @@ struct st_buffer {
 	unsigned short orig_frp_segs;	/* number of segments allocated at first try */
 	unsigned short frp_segs;	/* number of buffer segments */
 	unsigned int frp_sg_current;	/* driver buffer length currently in s/g list */
-	struct st_buf_fragment *frp;	/* the allocated buffer fragment list */
 	struct scatterlist sg[1];	/* MUST BE last item */
 };
 
-/* The tape buffer fragment descriptor */
-struct st_buf_fragment {
-	struct page *page;
-	unsigned int length;
-};
-
 /* The tape mode definition */
 struct st_modedef {
 	unsigned char defined;
-- 
1.5.6.5

