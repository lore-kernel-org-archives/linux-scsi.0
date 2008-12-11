From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 12/13] st: remove unused orig_frp_segs
Date: Thu, 11 Dec 2008 23:07:49 +0900
Message-ID: <1229004470-25718-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49132 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbYLKOLB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:11:01 -0500
In-Reply-To: <1229004470-25718-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

orig_frp_segs in struct st_buffer is always zero. We don't need it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |    7 +++----
 drivers/scsi/st.h |    1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ac1cd62..ddfacc8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3748,7 +3748,7 @@ static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
 	}
-	tb->frp_segs = tb->orig_frp_segs = 0;
+	tb->frp_segs = 0;
 	tb->use_sg = max_sg;
 	tb->dma = need_dma;
 	tb->buffer_size = 0;
@@ -3837,11 +3837,11 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 {
 	int i, order = STbuffer->map_data.page_order;
 
-	for (i = STbuffer->orig_frp_segs; i < STbuffer->frp_segs; i++) {
+	for (i = 0; i < STbuffer->frp_segs; i++) {
 		__free_pages(STbuffer->reserved_pages[i], order);
 		STbuffer->buffer_size -= (PAGE_SIZE << order);
 	}
-	STbuffer->frp_segs = STbuffer->orig_frp_segs;
+	STbuffer->frp_segs = 0;
 	STbuffer->frp_sg_current = 0;
 	STbuffer->sg_segs = 0;
 	STbuffer->map_data.page_order = 0;
@@ -4302,7 +4302,6 @@ static void scsi_tape_release(struct kref *kref)
 	tpnt->device = NULL;
 
 	if (tpnt->buffer) {
-		tpnt->buffer->orig_frp_segs = 0;
 		normalize_buffer(tpnt->buffer);
 		kfree(tpnt->buffer->reserved_pages);
 		kfree(tpnt->buffer);
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index d297607..e682f80 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -51,7 +51,6 @@ struct st_buffer {
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
-	unsigned short orig_frp_segs;	/* number of segments allocated at first try */
 	unsigned short frp_segs;	/* number of buffer segments */
 	unsigned int frp_sg_current;	/* driver buffer length currently in s/g list */
 };
-- 
1.5.6.5

