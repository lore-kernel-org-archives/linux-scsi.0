From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 08/13] st: remove buf_to_sg
Date: Thu, 11 Dec 2008 23:07:45 +0900
Message-ID: <1229004470-25718-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229004470-25718-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49120 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbYLKOK5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:57 -0500
In-Reply-To: <1229004470-25718-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This removes unused buf_to_sg() that the non-dio path used.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 80b1c25..40c1305 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -189,7 +189,6 @@ static void normalize_buffer(struct st_buffer *);
 static int append_to_buffer(const char __user *, struct st_buffer *, int);
 static int from_buffer(struct st_buffer *, char __user *, int);
 static void move_buffer_data(struct st_buffer *, int);
-static void buf_to_sg(struct st_buffer *, unsigned int);
 
 static int sgl_map_user_pages(struct st_buffer *, const unsigned int,
 			      unsigned long, size_t, int);
@@ -554,8 +553,6 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 		mdata->nr_entries = STp->buffer->sg_segs;
 		mdata->pages = STp->buffer->mapped_pages;
 	} else {
-		buf_to_sg(STp->buffer, bytes);
-
 		mdata->nr_entries =
 			DIV_ROUND_UP(bytes, PAGE_SIZE << mdata->page_order);
 		STp->buffer->map_data.pages = STp->buffer->reserved_pages;
@@ -3963,32 +3960,6 @@ static void move_buffer_data(struct st_buffer * st_bp, int offset)
 	}
 }
 
-
-/* Fill the s/g list up to the length required for this transfer */
-static void buf_to_sg(struct st_buffer *STbp, unsigned int length)
-{
-	int i;
-	unsigned int count;
-	struct scatterlist *sg;
-	struct st_buf_fragment *frp;
-
-	if (length == STbp->frp_sg_current)
-		return;   /* work already done */
-
-	sg = &(STbp->sg[0]);
-	frp = STbp->frp;
-	for (i=count=0; count < length; i++) {
-		if (length - count > frp[i].length)
-			sg_set_page(&sg[i], frp[i].page, frp[i].length, 0);
-		else
-			sg_set_page(&sg[i], frp[i].page, length - count, 0);
-		count += sg[i].length;
-	}
-	STbp->sg_segs = i;
-	STbp->frp_sg_current = length;
-}
-
-
 /* Validate the options from command line or module parameters */
 static void validate_options(void)
 {
-- 
1.5.6.5

