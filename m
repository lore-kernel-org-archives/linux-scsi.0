From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 10/13] st: remove struct scatterlist
Date: Thu, 11 Dec 2008 23:07:47 +0900
Message-ID: <1229004470-25718-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49124 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbYLKOK5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:57 -0500
In-Reply-To: <1229004470-25718-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This removes the usage of struct scatterlist completely.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |    8 ++------
 drivers/scsi/st.h |    1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1547acf..4cd06cc 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3743,7 +3743,7 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 static struct st_buffer *
  new_tape_buffer(int from_initialization, int need_dma, int max_sg)
 {
-	int i, got = 0;
+	int got = 0;
 	gfp_t priority;
 	struct st_buffer *tb;
 
@@ -3752,10 +3752,7 @@ static struct st_buffer *
 	else
 		priority = GFP_KERNEL;
 
-	i = sizeof(struct st_buffer) +
-		(max_sg - 1) * sizeof(struct scatterlist);
-
-	tb = kzalloc(i, priority);
+	tb = kzalloc(sizeof(struct st_buffer), priority);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
@@ -3765,7 +3762,6 @@ static struct st_buffer *
 
 	tb->dma = need_dma;
 	tb->buffer_size = got;
-	sg_init_table(tb->sg, max_sg);
 
 	tb->reserved_pages = kzalloc(max_sg * sizeof(struct page *), priority);
 	if (!tb->reserved_pages) {
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index cc46f18..d297607 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -54,7 +54,6 @@ struct st_buffer {
 	unsigned short orig_frp_segs;	/* number of segments allocated at first try */
 	unsigned short frp_segs;	/* number of buffer segments */
 	unsigned int frp_sg_current;	/* driver buffer length currently in s/g list */
-	struct scatterlist sg[1];	/* MUST BE last item */
 };
 
 /* The tape mode definition */
-- 
1.5.6.5

