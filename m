From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/13] st: make all the fragment buffers the same size
Date: Thu, 11 Dec 2008 23:07:40 +0900
Message-ID: <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43883 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbYLKOK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:56 -0500
In-Reply-To: <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This patch simiplifies the fragment buffer management a bit, all the
buffers in the fragment list become the same size. This is necessary
to use the block layer API (sg driver was modified in the same way)
since the block layer API takes the same size page frames instead of
scatter gatter.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 7f3f317..a63b504 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3747,20 +3747,20 @@ static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, int need_dm
 	priority = GFP_KERNEL | __GFP_NOWARN;
 	if (need_dma)
 		priority |= GFP_DMA;
-	for (b_size = PAGE_SIZE, order=0; order <= 6 &&
-	     b_size < new_size - STbuffer->buffer_size;
-	     order++, b_size *= 2)
-		;  /* empty */
+
+	if (STbuffer->frp_segs) {
+		b_size = STbuffer->frp[0].length;
+		order = get_order(b_size);
+	} else {
+		for (b_size = PAGE_SIZE, order=0;
+		     order <= 6 && b_size < new_size; order++, b_size *= 2)
+			;  /* empty */
+	}
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
 	     segs < max_segs && got < new_size;) {
 		STbuffer->frp[segs].page = alloc_pages(priority, order);
 		if (STbuffer->frp[segs].page == NULL) {
-			if (new_size - got <= (max_segs - segs) * b_size / 2) {
-				b_size /= 2; /* Large enough for the rest of the buffers */
-				order--;
-				continue;
-			}
 			DEB(STbuffer->buffer_size = got);
 			normalize_buffer(STbuffer);
 			return 0;
-- 
1.5.6.5

