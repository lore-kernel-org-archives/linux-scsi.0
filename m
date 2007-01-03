From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] convert sg dio to use the block layer functions
Date: Wed, 03 Jan 2007 17:17:42 +0900
Message-ID: <20070103171742C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:48858 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbXACIRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2007 03:17:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, michaelc@cs.wisc.edu

This patch makes sg dio use the block layer functions
(blk_rq_map_user, blk_execute_rq_nowait, etc). It's an updated version
of the following patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=116527334121826&w=2

This doesn't break any existing features. While it converts sg dio to
use the block layer functions, sg mmap and indirect io still use
scsi_execute_async.

This is against the Linus' tree (uses the latest block layer API)
since the scsi-misc is a bit out-of-data.

On a side note, Mike has been working on converting sg mmap and
indirectio to the block layer functions.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |  201 ++++++++++++++++-------------------------------------
 1 files changed, 59 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 81e3bc7..304e34b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -136,6 +136,8 @@ typedef struct sg_request {	/* SG_MAX_QU
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
+	struct request *rq;
+	struct bio *bio;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -690,6 +692,11 @@ sg_new_write(Sg_fd * sfp, const char __u
 	return count;
 }
 
+static void sg_rq_end_io(struct request *rq, int uptodate)
+{
+	sg_cmd_done(rq->end_io_data, rq->sense, rq->errors, rq->data_len);
+}
+
 static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
@@ -742,6 +749,14 @@ sg_common_write(Sg_fd * sfp, Sg_request
 	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
+	if (hp->info & SG_INFO_DIRECT_IO) {
+		memcpy(srp->rq->cmd, cmnd, hp->cmd_len);
+		srp->rq->timeout = timeout;
+		blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
+					  srp->rq, 1, sg_rq_end_io);
+		return 0;
+	}
+
 	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
 				hp->dxfer_len, srp->data.k_use_sg, timeout,
 				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
@@ -1651,7 +1666,10 @@ sg_finish_rem_req(Sg_request * srp)
 	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
-	else
+	else if (req_schp->dio_in_use) {
+		blk_rq_unmap_user(srp->bio);
+		blk_put_request(srp->rq);
+	} else
 		sg_remove_scat(req_schp);
 	sg_remove_request(sfp, srp);
 }
@@ -1677,122 +1695,20 @@ sg_build_sgat(Sg_scatter_hold * schp, co
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
-		/* if (TestSetPageLocked(pages[i]))
-		   goto out_unlock; */
-        }
-
-	sgl[0].page = pages[0];
-	sgl[0].offset = uaddr & ~PAGE_MASK;
-	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
-		for (i=1; i < nr_pages ; i++) {
-			sgl[i].page = pages[i]; 
-			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
-			count -= PAGE_SIZE;
-		}
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
+/* taken from the bsg tree */
+static int blk_fill_sghdr_rq(request_queue_t *q, struct request *rq,
+			     struct sg_io_hdr *hdr, int has_write_perm)
 {
-	int i;
-
-	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
-
-		if (dirtied)
-			SetPageDirty(page);
-		/* unlock_page(page); */
-		/* FIXME: cache flush missing for rw==READ
-		 * FIXME: call the correct reference counting function
-		 */
-		page_cache_release(page);
-	}
+	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
+	/*
+	 * fill in request structure
+	 */
+	rq->cmd_len = hdr->cmd_len;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
 	return 0;
 }
 
-/* ^^^^^^^^  above code borrowed from st driver's direct IO ^^^^^^^^^ */
-#endif
-
-
 /* Returns: -ve -> error, 0 -> done, 1 -> try indirect */
 static int
 sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len)
@@ -1800,26 +1716,34 @@ sg_build_direct(Sg_request * srp, Sg_fd
 #ifdef SG_ALLOW_DIO_CODE
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int mx_sc_elems, res;
-	struct scsi_device *sdev = sfp->parentdp->device;
+	int res, rw;
+	request_queue_t *q = sfp->parentdp->device->request_queue;
+	struct request *rq;
 
-	if (((unsigned long)hp->dxferp &
-			queue_dma_alignment(sdev->request_queue)) != 0)
+	if (((unsigned long)hp->dxferp & queue_dma_alignment(q)))
 		return 1;
 
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
+	rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
+
+	rq = blk_get_request(q, rw, GFP_ATOMIC);
+	if (!rq)
+		return -ENOMEM;
+
+	res = blk_fill_sghdr_rq(q, rq, hp, rw);
+	if (res) {
+		blk_put_request(rq);
+		return res;
+	}
+
+	res = blk_rq_map_user(q, rq, hp->dxferp, dxfer_len);
+	if (res) {
+		blk_put_request(rq);
+		return res;
 	}
-	schp->k_use_sg = res;
+
+	srp->rq = rq;
+	srp->bio = rq->bio;
+	rq->end_io_data = srp;
 	schp->dio_in_use = 1;
 	hp->info |= SG_INFO_DIRECT_IO;
 	return 0;
@@ -2002,23 +1926,16 @@ static void
 sg_remove_scat(Sg_scatter_hold * schp)
 {
 	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
+
 	if (schp->buffer && (schp->sglist_len > 0)) {
 		struct scatterlist *sg = schp->buffer;
+		int k;
 
-		if (schp->dio_in_use) {
-#ifdef SG_ALLOW_DIO_CODE
-			st_unmap_user_pages(sg, schp->k_use_sg, TRUE);
-#endif
-		} else {
-			int k;
-
-			for (k = 0; (k < schp->k_use_sg) && sg->page;
-			     ++k, ++sg) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg->page, sg->length));
-				sg_page_free(sg->page, sg->length);
-			}
+		for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, ++sg) {
+			SCSI_LOG_TIMEOUT(5, printk(
+						 "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
+						 k, sg->page, sg->length));
+			sg_page_free(sg->page, sg->length);
 		}
 		kfree(schp->buffer);
 	}
-- 
1.4.3.2

