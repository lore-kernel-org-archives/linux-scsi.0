From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 12/16] st: simplify new_tape_buffer
Date: Thu, 18 Dec 2008 14:49:47 +0900
Message-ID: <1229579391-28753-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
 <1229579391-28753-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46383 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYLRGIw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:52 -0500
In-Reply-To: <1229579391-28753-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- remove the from_initialization argument, which is always 1. We
always need to use GFP_ATOMIC.

- 'got' valuable is initialized to zero and doesn't change. We don't
need it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f934016..22ddca8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -182,7 +182,6 @@ static struct scsi_tape **scsi_tapes = NULL;
 
 static int modes_defined;
 
-static struct st_buffer *new_tape_buffer(int, int, int);
 static int enlarge_buffer(struct st_buffer *, int, int);
 static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
@@ -3741,30 +3740,22 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 
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
+	tb->reserved_pages = kzalloc(max_sg * sizeof(struct page *),
+				     GFP_ATOMIC);
 	if (!tb->reserved_pages) {
 		kfree(tb);
 		return NULL;
@@ -4059,7 +4050,7 @@ static int st_probe(struct device *dev)
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

