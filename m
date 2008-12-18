From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 11/16] st: remove struct scatterlist
Date: Thu, 18 Dec 2008 14:49:46 +0900
Message-ID: <1229579391-28753-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46381 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYLRGIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:50 -0500
In-Reply-To: <1229579391-28753-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This removes the usage of struct scatterlist completely.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |    8 ++------
 drivers/scsi/st.h |    1 -
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1cfd217..f934016 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3744,7 +3744,7 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 static struct st_buffer *
  new_tape_buffer(int from_initialization, int need_dma, int max_sg)
 {
-	int i, got = 0;
+	int got = 0;
 	gfp_t priority;
 	struct st_buffer *tb;
 
@@ -3753,10 +3753,7 @@ static struct st_buffer *
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
@@ -3766,7 +3763,6 @@ static struct st_buffer *
 
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

