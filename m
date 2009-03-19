From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC C 4/5] exofs: No bio for you
Date: Thu, 19 Mar 2009 16:37:14 +0200
Message-ID: <49C2589A.2080103@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6485 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753575AbZCSOi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:38:29 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


bio based API to osd_initiator is depreciated. Move to
a page array API when writing/reading pages.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/common.h |    4 --
 fs/exofs/inode.c  |  108 +++++++++++++++++++++++++++--------------------------
 2 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/fs/exofs/common.h b/fs/exofs/common.h
index f02cb4c..8a56338 100644
--- a/fs/exofs/common.h
+++ b/fs/exofs/common.h
@@ -44,10 +44,6 @@
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
 
-/* FIXME: Temporarly until exofs tree syncs with scsi-misc's osd_initiator */
-#define osd_req_write osd_req_write_old
-#define osd_req_read  osd_req_read_old
-
 /****************************************************************************
  * Object ID related defines
  * NOTE: inode# = object ID - EXOFS_OBJ_OFF
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 0f52e76..31cfd6d 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -49,9 +49,8 @@ struct page_collect {
 	struct inode *inode;
 	unsigned expected_pages;
 
-	struct bio *bio;
-	unsigned nr_pages;
-	unsigned long length;
+	struct osd_pages_array opa;
+	unsigned pg_alloc_count;
 	long pg_first;
 };
 
@@ -66,9 +65,8 @@ void _pcol_init(struct page_collect *pcol, unsigned expected_pages,
 	pcol->inode = inode;
 	pcol->expected_pages = expected_pages;
 
-	pcol->bio = NULL;
-	pcol->nr_pages = 0;
-	pcol->length = 0;
+	memset(&pcol->opa, 0, sizeof(pcol->opa));
+	pcol->pg_alloc_count = 0;
 	pcol->pg_first = -1;
 
 	EXOFS_DBGMSG("_pcol_init ino=0x%lx expected_pages=%u\n", inode->i_ino,
@@ -77,11 +75,10 @@ void _pcol_init(struct page_collect *pcol, unsigned expected_pages,
 
 void _pcol_reset(struct page_collect *pcol)
 {
-	pcol->expected_pages -= min(pcol->nr_pages, pcol->expected_pages);
+	pcol->expected_pages -= min(pcol->opa.nr_pages, pcol->expected_pages);
 
-	pcol->bio = NULL;
-	pcol->nr_pages = 0;
-	pcol->length = 0;
+	memset(&pcol->opa, 0, sizeof(pcol->opa));
+	pcol->pg_alloc_count = 0;
 	pcol->pg_first = -1;
 	EXOFS_DBGMSG("_pcol_reset ino=0x%lx expected_pages=%u\n",
 		     pcol->inode->i_ino, pcol->expected_pages);
@@ -98,9 +95,12 @@ int pcol_try_alloc(struct page_collect *pcol)
 	int pages = min_t(unsigned, pcol->expected_pages, BIO_MAX_PAGES);
 
 	for (; pages; pages >>= 1) {
-		pcol->bio = bio_alloc(GFP_KERNEL, pages);
-		if (likely(pcol->bio))
+		pcol->opa.pages = kcalloc(pages, sizeof(struct page *),
+					  GFP_KERNEL);
+		if (likely(pcol->opa.pages)) {
+			pcol->pg_alloc_count = pages;
 			return 0;
+		}
 	}
 
 	EXOFS_ERR("Failed to kcalloc expected_pages=%d\n",
@@ -110,21 +110,25 @@ int pcol_try_alloc(struct page_collect *pcol)
 
 void pcol_free(struct page_collect *pcol)
 {
-	bio_put(pcol->bio);
-	pcol->bio = NULL;
+	kfree(pcol->opa.pages);
+	pcol->opa.pages = NULL;
+	pcol->pg_alloc_count = 0;
 }
 
-int pcol_add_page(struct page_collect *pcol, struct page *page, unsigned len)
+int pcol_add_page(struct page_collect *pcol, struct page *page, int len)
 {
-	int added_len = bio_add_pc_page(pcol->req_q, pcol->bio, page, len, 0);
-	if (unlikely(len != added_len))
+	if (pcol->opa.nr_pages >= pcol->pg_alloc_count)
 		return -ENOMEM;
 
-	++pcol->nr_pages;
-	pcol->length += len;
+	pcol->opa.pages[pcol->opa.nr_pages++] = page;
+	pcol->opa.length += len;
 	return 0;
 }
 
+#define __pcol_for_each_segment(page, pcol, i, s) \
+	for (page = pcol->opa.pages[s], i = s; i < pcol->opa.nr_pages; \
+		page = pcol->opa.pages[++(i)])
+
 static int update_read_page(struct page *page, int ret)
 {
 	if (ret == 0) {
@@ -164,7 +168,7 @@ static int _readpage(struct page *page, bool is_sync);
 static int __readpages_done(struct osd_request *or, struct page_collect *pcol,
 			    bool do_unlock)
 {
-	struct bio_vec *bvec;
+	struct page *page;
 	int i;
 	u64 resid;
 	u64 good_bytes;
@@ -174,19 +178,18 @@ static int __readpages_done(struct osd_request *or, struct page_collect *pcol,
 	osd_end_request(or);
 
 	if (!ret)
-		good_bytes = pcol->length;
+		good_bytes = pcol->opa.length;
 	else if (ret && !resid)
 		good_bytes = 0;
 	else
-		good_bytes = pcol->length - resid;
+		good_bytes = pcol->opa.length - resid;
 
 	EXOFS_DBGMSG("readpages_done(%ld) good_bytes=%llx"
 		     " length=%zx nr_pages=%u\n",
-		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
-		     pcol->nr_pages);
+		     pcol->inode->i_ino, _LLU(good_bytes), pcol->opa.length,
+		     pcol->opa.nr_pages);
 
-	__bio_for_each_segment(bvec, pcol->bio, i, 0) {
-		struct page *page = bvec->bv_page;
+	__pcol_for_each_segment(page, pcol, i, 0) {
 		struct inode *inode = page->mapping->host;
 
 		if (inode != pcol->inode)
@@ -210,7 +213,8 @@ static int __readpages_done(struct osd_request *or, struct page_collect *pcol,
 			_readpage(page, false);
 		}
 
-		length += bvec->bv_len;
+		length += min_t(u64,
+				pcol->opa.length - length, PAGE_CACHE_SIZE);
 	}
 
 	pcol_free(pcol);
@@ -229,12 +233,10 @@ static void readpages_done(struct osd_request *or, void *p)
 
 void _unlock_pcol_pages(struct page_collect *pcol, int ret, int rw)
 {
-	struct bio_vec *bvec;
+	struct page *page;
 	int i;
 
-	__bio_for_each_segment(bvec, pcol->bio, i, 0) {
-		struct page *page = bvec->bv_page;
-
+	__pcol_for_each_segment(page, pcol, i, 0) {
 		if (rw == READ)
 			update_read_page(page, ret);
 		else
@@ -255,11 +257,11 @@ int read_exec(struct page_collect *pcol, bool is_sync)
 	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
 	int ret;
 
-	if (!pcol->bio)
+	if (!pcol->opa.pages)
 		return 0;
 
 	/* see comment in _readpage() about sync reads */
-	WARN_ON(is_sync && (pcol->nr_pages != 1));
+	WARN_ON(is_sync && (pcol->opa.nr_pages != 1));
 
 	or = osd_start_request(pcol->sbi->s_dev, GFP_KERNEL);
 	if (unlikely(!or)) {
@@ -267,7 +269,7 @@ int read_exec(struct page_collect *pcol, bool is_sync)
 		goto err;
 	}
 
-	osd_req_read(or, &obj, pcol->bio, i_start);
+	osd_req_read(or, &obj, &pcol->opa, i_start);
 
 	if (is_sync) {
 		exofs_sync_op(or, pcol->sbi->s_timeout, oi->i_cred);
@@ -288,7 +290,7 @@ int read_exec(struct page_collect *pcol, bool is_sync)
 	atomic_inc(&pcol->sbi->s_curr_pending);
 
 	EXOFS_DBGMSG("read_exec obj=%llx start=%llx length=%zx\n",
-		  obj.id, _LLU(i_start), pcol->length);
+		  obj.id, _LLU(i_start), pcol->opa.length);
 
 	/* pages ownership was passed to pcol_copy */
 	_pcol_reset(pcol);
@@ -346,7 +348,7 @@ try_again:
 
 	if (unlikely(pcol->pg_first == -1)) {
 		pcol->pg_first = page->index;
-	} else if (unlikely((pcol->pg_first + pcol->nr_pages) !=
+	} else if (unlikely((pcol->pg_first + pcol->opa.nr_pages) !=
 		   page->index)) {
 		/* Discontinuity detected, split the request */
 		ret = read_exec(pcol, false);
@@ -355,7 +357,7 @@ try_again:
 		goto try_again;
 	}
 
-	if (!pcol->bio) {
+	if (!pcol->opa.pages) {
 		ret = pcol_try_alloc(pcol);
 		if (unlikely(ret))
 			goto fail;
@@ -371,7 +373,7 @@ try_again:
 	if (ret) {
 		EXOFS_DBGMSG("Failed pcol_add_page pages[i]=%p "
 			  "len=%zx nr_pages=%u length=%zx\n",
-			  page, len, pcol->nr_pages, pcol->length);
+			  page, len, pcol->opa.nr_pages, pcol->opa.length);
 
 		/* split the request, and start again with current page */
 		ret = read_exec(pcol, false);
@@ -439,31 +441,30 @@ static int exofs_writepage(struct page *page, struct writeback_control *wbc2);
 static void writepages_done(struct osd_request *or, void *p)
 {
 	struct page_collect *pcol = p;
-	struct bio_vec *bvec;
+	struct page *page;
 	int i;
 	u64 resid;
 	u64  good_bytes;
 	u64  length = 0;
-
+	
 	int ret = exofs_check_ok_resid(or, NULL, &resid);
 
 	osd_end_request(or);
 	atomic_dec(&pcol->sbi->s_curr_pending);
 
 	if (likely(!ret))
-		good_bytes = pcol->length;
+		good_bytes = pcol->opa.length;
 	else if (ret && !resid)
 		good_bytes = 0;
 	else
-		good_bytes = pcol->length - resid;
+		good_bytes = pcol->opa.length - resid;
 
 	EXOFS_DBGMSG("writepages_done(%lx) good_bytes=%llx"
 		     " length=%zx nr_pages=%u\n",
-		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
-		     pcol->nr_pages);
+		     pcol->inode->i_ino, _LLU(good_bytes), pcol->opa.length,
+		     pcol->opa.nr_pages);
 
-	__bio_for_each_segment(bvec, pcol->bio, i, 0) {
-		struct page *page = bvec->bv_page;
+	__pcol_for_each_segment(page, pcol, i, 0) {
 		struct inode *inode = page->mapping->host;
 
 		if (inode != pcol->inode)
@@ -485,7 +486,8 @@ static void writepages_done(struct osd_request *or, void *p)
 			exofs_writepage(page, NULL);
 		}
 
-		length += bvec->bv_len;
+		length += min_t(u64,
+				pcol->opa.length - length, PAGE_CACHE_SIZE);
 	}
 
 	pcol_free(pcol);
@@ -503,7 +505,7 @@ int write_exec(struct page_collect *pcol)
 	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
 	int ret;
 
-	if (!pcol->bio)
+	if (!pcol->opa.pages)
 		return 0;
 
 	or = osd_start_request(pcol->sbi->s_dev, GFP_KERNEL);
@@ -522,7 +524,7 @@ int write_exec(struct page_collect *pcol)
 
 	*pcol_copy = *pcol;
 
-	osd_req_write(or, &obj, pcol_copy->bio, i_start);
+	osd_req_write(or, &obj, &pcol_copy->opa, i_start);
 	ret = exofs_async_op(or, writepages_done, pcol_copy, oi->i_cred);
 	if (unlikely(ret)) {
 		EXOFS_ERR("write_exec: exofs_async_op() Faild\n");
@@ -532,7 +534,7 @@ int write_exec(struct page_collect *pcol)
 	atomic_inc(&pcol->sbi->s_curr_pending);
 	EXOFS_DBGMSG("write_exec(%lx, %lx) start=%llx length=%zx\n",
 		  pcol->inode->i_ino, pcol->pg_first, _LLU(i_start),
-		  pcol->length);
+		  pcol->opa.length);
 	/* pages ownership was passed to pcol_copy */
 	_pcol_reset(pcol);
 	return 0;
@@ -586,7 +588,7 @@ try_again:
 
 	if (unlikely(pcol->pg_first == -1)) {
 		pcol->pg_first = page->index;
-	} else if (unlikely((pcol->pg_first + pcol->nr_pages) !=
+	} else if (unlikely((pcol->pg_first + pcol->opa.nr_pages) !=
 		   page->index)) {
 		/* Discontinuity detected, split the request */
 		ret = write_exec(pcol);
@@ -595,7 +597,7 @@ try_again:
 		goto try_again;
 	}
 
-	if (!pcol->bio) {
+	if (!pcol->opa.pages) {
 		ret = pcol_try_alloc(pcol);
 		if (unlikely(ret))
 			goto fail;
@@ -608,7 +610,7 @@ try_again:
 	if (unlikely(ret)) {
 		EXOFS_DBGMSG("Failed pcol_add_page "
 			     "nr_pages=%u total_length=%zx\n",
-			     pcol->nr_pages, pcol->length);
+			     pcol->opa.nr_pages, pcol->opa.length);
 
 		/* split the request, next loop will start again */
 		ret = write_exec(pcol);
-- 
1.6.2.1


