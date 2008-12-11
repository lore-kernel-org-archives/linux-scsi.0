From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 11/13] st: simplify new_tape_buffer
Date: Thu, 11 Dec 2008 23:07:48 +0900
Message-ID: <1229004470-25718-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43899 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbYLKOK7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 09:10:59 -0500
In-Reply-To: <1229004470-25718-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

- remove the from_initialization argument, which is always 1. We
always need to use GFP_ATOMIC.

- 'got' valuable is initialized to zero and doesn't change. We don't
need it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 4cd06cc..ac1cd62 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -182,7 +182,6 @@ static struct scsi_tape **scsi_tapes = NULL;
 
 static int modes_defined;
 
-static struct st_buffer *new_tape_buffer(int, int, int);
 static int enlarge_buffer(struct st_buffer *, int, int);
 static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
@@ -3740,30 +3739,21 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
-static struct st_buffer *
- new_tape_buffer(int from_initialization, int need_dma, int max_sg)
+static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
 {
-	int got = 0;
-	gfp_t priority;
 	struct st_buffer *tb;
 
-	if (from_initialization)
-		priority = GFP_ATOMIC;
-	else
-		priority = GFP_KERNEL;
-
-	tb = kzalloc(sizeof(struct st_buffer), priority);
+	tb = kzalloc(sizeof(struct st_buffer), GFP_ATOMIC);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
 	}
 	tb->frp_segs = tb->orig_frp_segs = 0;
 	tb->use_sg = max_sg;
-
 	tb->dma = need_dma;
-	tb->buffer_size = got;
+	tb->buffer_size = 0;
 
-	tb->reserved_pages = kzalloc(max_sg * sizeof(struct page *), priority);
+	tb->reserved_pages = kzalloc(max_sg * sizeof(struct page *), GFP_ATOMIC);
 	if (!tb->reserved_pages) {
 		kfree(tb);
 		return NULL;
@@ -4058,7 +4048,7 @@ static int st_probe(struct device *dev)
 		SDp->request_queue->max_phys_segments);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
-	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
+	buffer = new_tape_buffer((SDp->host)->unchecked_isa_dma, i);
 	if (buffer == NULL) {
 		printk(KERN_ERR
 		       "st: Can't allocate new tape buffer. Device not attached.\n");
-- 
1.5.6.5

