From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/5] sg: convert the direct IO path to use the block layer
Date: Thu, 28 Aug 2008 16:17:08 +0900
Message-ID: <1219907829-27365-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080828070725.GP20055@kernel.dk>
 <1219907829-27365-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219907829-27365-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219907829-27365-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39576 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYH1HTI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 03:19:08 -0400
In-Reply-To: <1219907829-27365-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch converts the direct IO path (SG_FLAG_DIRECT_IO) to use the
block layer functions (blk_get_request, blk_execute_rq_nowait,
blk_rq_map_user, etc) instead of scsi_execute_async().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sg.c |  173 ++++++++--------------------------------------------
 1 files changed, 27 insertions(+), 146 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 487c777..cb6de07 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -138,6 +138,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
+	struct bio *bio;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -1679,21 +1680,29 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
+	unsigned long uaddr = (unsigned long)hp->dxferp;
 	Sg_scatter_hold *req_schp = &srp->data;
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+	unsigned long alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
 
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return __sg_start_req(srp, hp, cmd);
 
+#ifdef SG_ALLOW_DIO_CODE
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
 	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
-	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
-		res = sg_build_direct(srp, sfp, dxfer_len);
-		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
-			return res;
+	    (!sfp->parentdp->device->host->unchecked_isa_dma) &&
+	    !(uaddr & alignment) && !(dxfer_len & alignment)) {
+		res = __sg_start_req(srp, hp, cmd);
+		if (!res)
+			res = sg_build_direct(srp, sfp, dxfer_len);
+
+		return res;
 	}
+#endif
 	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
 		sg_link_reserve(sfp, srp, dxfer_len);
 	else {
@@ -1718,8 +1727,11 @@ sg_finish_rem_req(Sg_request * srp)
 	else
 		sg_remove_scat(req_schp);
 
-	if (srp->rq)
+	if (srp->rq) {
+		if (srp->bio)
+			blk_rq_unmap_user(srp->bio);
 		blk_put_request(srp->rq);
+	}
 
 	sg_remove_request(sfp, srp);
 }
@@ -1746,151 +1758,23 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 	return tablesize;	/* number of scat_gath elements allocated */
 }
 
-#ifdef SG_ALLOW_DIO_CODE
-/* vvvvvvvv  following code borrowed from st driver's direct IO vvvvvvvvv */
-	/* TODO: hopefully we can use the generic block layer code */
-
-/* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
-   - mapping of all pages not successful
-   (i.e., either completely successful or fails)
-*/
-static int 
-st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
-	          unsigned long uaddr, size_t count, int rw)
-{
-	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = uaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
-	int res, i, j;
-	struct page **pages;
-
-	/* User attempted Overflow! */
-	if ((uaddr + count) < uaddr)
-		return -EINVAL;
-
-	/* Too big */
-        if (nr_pages > max_pages)
-		return -ENOMEM;
-
-	/* Hmm? */
-	if (count == 0)
-		return 0;
-
-	if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_ATOMIC)) == NULL)
-		return -ENOMEM;
-
-        /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
-        /* rw==READ means read from drive, write into memory area */
-	res = get_user_pages(
-		current,
-		current->mm,
-		uaddr,
-		nr_pages,
-		rw == READ,
-		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
-
-	/* Errors and no page mapped should return here */
-	if (res < nr_pages)
-		goto out_unmap;
-
-        for (i=0; i < nr_pages; i++) {
-                /* FIXME: flush superflous for rw==READ,
-                 * probably wrong function for rw==WRITE
-                 */
-		flush_dcache_page(pages[i]);
-		/* ?? Is locking needed? I don't think so */
-		/* if (!trylock_page(pages[i]))
-		   goto out_unlock; */
-        }
-
-	sg_set_page(sgl, pages[0], 0, uaddr & ~PAGE_MASK);
-	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
-		for (i=1; i < nr_pages ; i++)
-			sg_set_page(&sgl[i], pages[i], count < PAGE_SIZE ? count : PAGE_SIZE, 0);
-	}
-	else {
-		sgl[0].length = count;
-	}
-
-	kfree(pages);
-	return nr_pages;
-
- out_unmap:
-	if (res > 0) {
-		for (j=0; j < res; j++)
-			page_cache_release(pages[j]);
-		res = 0;
-	}
-	kfree(pages);
-	return res;
-}
-
-
-/* And unmap them... */
-static int 
-st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
-		    int dirtied)
-{
-	int i;
-
-	for (i=0; i < nr_pages; i++) {
-		struct page *page = sg_page(&sgl[i]);
-
-		if (dirtied)
-			SetPageDirty(page);
-		/* unlock_page(page); */
-		/* FIXME: cache flush missing for rw==READ
-		 * FIXME: call the correct reference counting function
-		 */
-		page_cache_release(page);
-	}
-
-	return 0;
-}
-
-/* ^^^^^^^^  above code borrowed from st driver's direct IO ^^^^^^^^^ */
-#endif
-
-
 /* Returns: -ve -> error, 0 -> done, 1 -> try indirect */
 static int
 sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len)
 {
-#ifdef SG_ALLOW_DIO_CODE
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int mx_sc_elems, res;
-	struct scsi_device *sdev = sfp->parentdp->device;
-
-	if (((unsigned long)hp->dxferp &
-			queue_dma_alignment(sdev->request_queue)) != 0)
-		return 1;
+	int res;
+	struct request *rq = srp->rq;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
 
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-        if (mx_sc_elems <= 0) {
-                return 1;
-        }
-	res = st_map_user_pages(schp->buffer, mx_sc_elems,
-				(unsigned long)hp->dxferp, dxfer_len, 
-				(SG_DXFER_TO_DEV == hp->dxfer_direction) ? 1 : 0);
-	if (res <= 0) {
-		sg_remove_scat(schp);
-		return 1;
-	}
-	schp->k_use_sg = res;
+	res = blk_rq_map_user(q, rq, NULL, hp->dxferp, dxfer_len, GFP_ATOMIC);
+	if (res)
+		return res;
+	srp->bio = rq->bio;
 	schp->dio_in_use = 1;
 	hp->info |= SG_INFO_DIRECT_IO;
 	return 0;
-#else
-	return 1;
-#endif
 }
 
 static int
@@ -2069,11 +1953,7 @@ sg_remove_scat(Sg_scatter_hold * schp)
 	if (schp->buffer && (schp->sglist_len > 0)) {
 		struct scatterlist *sg = schp->buffer;
 
-		if (schp->dio_in_use) {
-#ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sg, schp->k_use_sg, TRUE);
-#endif
-		} else {
+		if (!schp->dio_in_use) {
 			int k;
 
 			for (k = 0; (k < schp->k_use_sg) && sg_page(sg);
@@ -2083,8 +1963,9 @@ sg_remove_scat(Sg_scatter_hold * schp)
 				    k, sg_page(sg), sg->length));
 				sg_page_free(sg_page(sg), sg->length);
 			}
+
+			kfree(schp->buffer);
 		}
-		kfree(schp->buffer);
 	}
 	memset(schp, 0, sizeof (*schp));
 }
-- 
1.5.5.GIT

