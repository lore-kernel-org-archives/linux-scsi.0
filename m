From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] st: fix mdata->page_order handling
Date: Thu, 26 Nov 2009 09:24:13 +0900
Message-ID: <20091126092401T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55889 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265AbZKZAYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2009 19:24:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@jmbreuer.net, Kai.Makisara@kolumbus.fi

dio transfer always resets mdata->page_order to zero. It breaks
high-order pages previously allocated for non-dio transfer.

This patches adds reserved_page_order to st_buffer structure to save
page order for non-dio transfer.

http://bugzilla.kernel.org/show_bug.cgi?id=14563

When enlarge_buffer() allocates 524288 from 0, st uses six-order page
allocation. So mdata->page_order is 6 and frp_seg is 2.

After that, if st uses dio, sgl_map_user_pages() sets
mdata->page_order to 0 for st_do_scsi(). After that, when we call
normalize_buffer(), it frees only free frp_seg * PAGE_SIZE (2 * 4096)
though we should free frp_seg * PAGE_SIZE << 6 (2 * 4096 << 6). So we
see buffer_size is set to 516096 (524288 - 8192).

Reported-by: Joachim Breuer <linux-kernel@jmbreuer.net>
Tested-by: Joachim Breuer <linux-kernel@jmbreuer.net>
Tested-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stable@kernel.org
---
 drivers/scsi/st.c |   23 ++++++++++++-----------
 drivers/scsi/st.h |    1 +
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 12d58a7..5081f97 100644
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
@@ -3718,7 +3720,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		priority |= __GFP_ZERO;
 
 	if (STbuffer->frp_segs) {
-		order = STbuffer->map_data.page_order;
+		order = STbuffer->reserved_page_order;
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order = 0;
@@ -3751,7 +3753,7 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
-	STbuffer->map_data.page_order = order;
+	STbuffer->reserved_page_order = order;
 
 	return 1;
 }
@@ -3764,7 +3766,7 @@ static void clear_buffer(struct st_buffer * st_bp)
 
 	for (i=0; i < st_bp->frp_segs; i++)
 		memset(page_address(st_bp->reserved_pages[i]), 0,
-		       PAGE_SIZE << st_bp->map_data.page_order);
+		       PAGE_SIZE << st_bp->reserved_page_order);
 	st_bp->cleared = 1;
 }
 
@@ -3772,7 +3774,7 @@ static void clear_buffer(struct st_buffer * st_bp)
 /* Release the extra buffer */
 static void normalize_buffer(struct st_buffer * STbuffer)
 {
-	int i, order = STbuffer->map_data.page_order;
+	int i, order = STbuffer->reserved_page_order;
 
 	for (i = 0; i < STbuffer->frp_segs; i++) {
 		__free_pages(STbuffer->reserved_pages[i], order);
@@ -3780,7 +3782,7 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 	}
 	STbuffer->frp_segs = 0;
 	STbuffer->sg_segs = 0;
-	STbuffer->map_data.page_order = 0;
+	STbuffer->reserved_page_order = 0;
 	STbuffer->map_data.offset = 0;
 }
 
@@ -3790,7 +3792,7 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count)
 {
 	int i, cnt, res, offset;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	for (i = 0, offset = st_bp->buffer_bytes;
 	     i < st_bp->frp_segs && offset >= length; i++)
@@ -3822,7 +3824,7 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 {
 	int i, cnt, res, offset;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	for (i = 0, offset = st_bp->read_pointer;
 	     i < st_bp->frp_segs && offset >= length; i++)
@@ -3855,7 +3857,7 @@ static void move_buffer_data(struct st_buffer * st_bp, int offset)
 {
 	int src_seg, dst_seg, src_offset = 0, dst_offset;
 	int count, total;
-	int length = PAGE_SIZE << st_bp->map_data.page_order;
+	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
 	if (offset == 0)
 		return;
@@ -4577,7 +4579,6 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
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
-- 
1.5.6.5

