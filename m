From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/5] sg: convert the indirect IO path to use the block layer
Date: Tue, 26 Aug 2008 11:10:54 +0900
Message-ID: <1219716654-27827-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219716654-27827-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219716654-27827-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219716654-27827-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219716654-27827-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46420 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbYHZCNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 22:13:12 -0400
In-Reply-To: <1219716654-27827-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

This patch converts the indirect IO path (including mmap IO and old
struct sg_header) to use the block layer functions (blk_get_request,
blk_execute_rq_nowait, blk_rq_map_user, etc) instead of
scsi_execute_async().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sg.c |  393 ++++++++++++++---------------------------------------
 1 files changed, 103 insertions(+), 290 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 10a285e..66a2c31 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -47,7 +47,6 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/seq_file.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/scatterlist.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
 
@@ -119,7 +118,8 @@ typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
 	unsigned sglist_len; /* size of malloc'd scatter-gather list ++ */
 	unsigned bufflen;	/* Size of (aggregate) data buffer */
 	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
-	struct scatterlist *buffer;/* scatter list */
+	struct page **pages;
+	int page_order;
 	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
 	unsigned char cmd_opcode; /* first byte of command */
 } Sg_scatter_hold;
@@ -190,8 +190,6 @@ static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			int read_only, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
-static int sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-		      int wr_xf, int *countp, unsigned char __user **up);
 static int sg_write_xfer(Sg_request * srp);
 static int sg_read_xfer(Sg_request * srp);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
@@ -199,8 +197,6 @@ static void sg_remove_scat(Sg_scatter_hold * schp);
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static struct page *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
-static void sg_page_free(struct page *page, int size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
 static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
 static void __sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
@@ -770,26 +766,11 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		break;
 	}
 	hp->duration = jiffies_to_msecs(jiffies);
-/* Now send everything of to mid-level. The next time we hear about this
-   packet is when sg_cmd_done() is called (i.e. a callback). */
-	if (srp->rq) {
-		srp->rq->timeout = timeout;
-		blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
-				      srp->rq, 1, sg_rq_end_io);
-		return 0;
-	}
-	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
-				hp->dxfer_len, srp->data.k_use_sg, timeout,
-				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
-				GFP_ATOMIC)) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: scsi_execute_async failed\n"));
-		/*
-		 * most likely out of mem, but could also be a bad map
-		 */
-		sg_finish_rem_req(srp);
-		return -ENOMEM;
-	} else
-		return 0;
+
+	srp->rq->timeout = timeout;
+	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
+			      srp->rq, 1, sg_rq_end_io);
+	return 0;
 }
 
 static int
@@ -1205,8 +1186,7 @@ sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	Sg_fd *sfp;
 	unsigned long offset, len, sa;
 	Sg_scatter_hold *rsv_schp;
-	struct scatterlist *sg;
-	int k;
+	int k, length;
 
 	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
 		return VM_FAULT_SIGBUS;
@@ -1216,15 +1196,14 @@ sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
 				   offset, rsv_schp->k_use_sg));
-	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
-	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, sg = sg_next(sg)) {
+	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
+	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
 		len = vma->vm_end - sa;
-		len = (len < sg->length) ? len : sg->length;
+		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page;
-			page = virt_to_page(page_address(sg_page(sg)) + offset);
+			struct page *page = nth_page(rsv_schp->pages[k],
+						     offset >> PAGE_SHIFT);
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
@@ -1246,8 +1225,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	Sg_fd *sfp;
 	unsigned long req_sz, len, sa;
 	Sg_scatter_hold *rsv_schp;
-	int k;
-	struct scatterlist *sg;
+	int k, length;
 
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
@@ -1261,11 +1239,10 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -ENOMEM;	/* cannot map more than reserved buffer */
 
 	sa = vma->vm_start;
-	sg = rsv_schp->buffer;
-	for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-	     ++k, sg = sg_next(sg)) {
+	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
+	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
 		len = vma->vm_end - sa;
-		len = (len < sg->length) ? len : sg->length;
+		len = (len < length) ? len : length;
 		sa += len;
 	}
 
@@ -1309,7 +1286,6 @@ sg_cmd_done(void *data, char *sense, int result, int resid)
 	if (0 != result) {
 		struct scsi_sense_hdr sshdr;
 
-		memcpy(srp->sense_b, sense, sizeof (srp->sense_b));
 		srp->header.status = 0xff & result;
 		srp->header.masked_status = status_byte(result);
 		srp->header.msg_status = msg_byte(result);
@@ -1685,34 +1661,51 @@ sg_start_req(Sg_request * srp, unsigned char *cmd)
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 	unsigned long alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	struct rq_map_data map_data;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
 
+	res = __sg_start_req(srp, hp, cmd);
+	if (res)
+		return res;
+
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
-		return __sg_start_req(srp, hp, cmd);
+		return 0;
 
 #ifdef SG_ALLOW_DIO_CODE
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
 	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
 	    (!sfp->parentdp->device->host->unchecked_isa_dma) &&
-	    !(uaddr & alignment) && !(dxfer_len & alignment)) {
-		res = __sg_start_req(srp, hp, cmd);
-		if (!res)
-			res = sg_build_direct(srp, sfp, dxfer_len);
-
-		return res;
-	}
+	    !(uaddr & alignment) && !(dxfer_len & alignment))
+		return sg_build_direct(srp, sfp, dxfer_len);
 #endif
 	if ((!sg_res_in_use(sfp)) && (dxfer_len <= rsv_schp->bufflen))
 		sg_link_reserve(sfp, srp, dxfer_len);
-	else {
+	else
 		res = sg_build_indirect(req_schp, sfp, dxfer_len);
-		if (res) {
-			sg_remove_scat(req_schp);
-			return res;
-		}
+
+	if (!res) {
+		struct request *rq = srp->rq;
+		Sg_scatter_hold *schp = &srp->data;
+		int iovec_count = (int) hp->iovec_count;
+
+		map_data.pages = schp->pages;
+		map_data.page_order = schp->page_order;
+		map_data.nr_entries = schp->k_use_sg;
+
+		if (iovec_count)
+			res = blk_rq_map_user_iov(q, rq, &map_data, hp->dxferp,
+						  iovec_count,
+						  hp->dxfer_len, GFP_ATOMIC);
+		else
+			res = blk_rq_map_user(q, rq, &map_data, hp->dxferp, hp->dxfer_len,
+					      GFP_ATOMIC);
+
+		if (!res)
+			srp->bio = rq->bio;
 	}
-	return 0;
+
+	return res;
 }
 
 static void
@@ -1730,6 +1723,7 @@ sg_finish_rem_req(Sg_request * srp)
 	if (srp->rq) {
 		if (srp->bio)
 			blk_rq_unmap_user(srp->bio);
+
 		blk_put_request(srp->rq);
 	}
 
@@ -1739,21 +1733,12 @@ sg_finish_rem_req(Sg_request * srp)
 static int
 sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 {
-	int sg_bufflen = tablesize * sizeof(struct scatterlist);
+	int sg_bufflen = tablesize * sizeof(struct page *);
 	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
 
-	/*
-	 * TODO: test without low_dma, we should not need it since
-	 * the block layer will bounce the buffer for us
-	 *
-	 * XXX(hch): we shouldn't need GFP_DMA for the actual S/G list.
-	 */
-	if (sfp->low_dma)
-		 gfp_flags |= GFP_DMA;
-	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
-	if (!schp->buffer)
+	schp->pages = kzalloc(sg_bufflen, gfp_flags);
+	if (!schp->pages)
 		return -ENOMEM;
-	sg_init_table(schp->buffer, tablesize);
 	schp->sglist_len = sg_bufflen;
 	return tablesize;	/* number of scat_gath elements allocated */
 }
@@ -1780,11 +1765,10 @@ sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len)
 static int
 sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 {
-	struct scatterlist *sg;
-	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
+	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
 	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int blk_size = buff_size;
-	struct page *p = NULL;
+	int blk_size = buff_size, order;
+	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
 
 	if (blk_size < 0)
 		return -EFAULT;
@@ -1808,15 +1792,26 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		} else
 			scatter_elem_sz_prev = num;
 	}
-	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
-	     (rem_sz > 0) && (k < mx_sc_elems);
-	     ++k, rem_sz -= ret_sz, sg = sg_next(sg)) {
-		
+
+	if (sfp->low_dma)
+		gfp_mask |= GFP_DMA;
+
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		gfp_mask |= __GFP_ZERO;
+
+	order = get_order(num);
+retry:
+	ret_sz = 1 << (PAGE_SHIFT + order);
+
+	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
+	     k++, rem_sz -= ret_sz) {
+
 		num = (rem_sz > scatter_elem_sz_prev) ?
-		      scatter_elem_sz_prev : rem_sz;
-		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
-		if (!p)
-			return -ENOMEM;
+			scatter_elem_sz_prev : rem_sz;
+
+		schp->pages[k] = alloc_pages(gfp_mask, order);
+		if (!schp->pages[k])
+			goto out;
 
 		if (num == scatter_elem_sz_prev) {
 			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
@@ -1824,12 +1819,12 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 				scatter_elem_sz_prev = ret_sz;
 			}
 		}
-		sg_set_page(sg, p, (ret_sz > num) ? num : ret_sz, 0);
 
 		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
 				 "ret_sz=%d\n", k, num, ret_sz));
 	}		/* end of for loop */
 
+	schp->page_order = order;
 	schp->k_use_sg = k;
 	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
 			 "rem_sz=%d\n", k, rem_sz));
@@ -1837,8 +1832,15 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	schp->bufflen = blk_size;
 	if (rem_sz > 0)	/* must have failed */
 		return -ENOMEM;
-
 	return 0;
+out:
+	for (i = 0; i < k; i++)
+		__free_pages(schp->pages[k], order);
+
+	if (--order >= 0)
+		goto retry;
+
+	return -ENOMEM;
 }
 
 static int
@@ -1846,13 +1848,8 @@ sg_write_xfer(Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
 	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
-	int iovec_count = (int) hp->iovec_count;
 	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
 	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
 
 	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
@@ -1868,103 +1865,26 @@ sg_write_xfer(Sg_request * srp)
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_write_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
 			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
-
-	ksglen = sg->length;
-	p = page_address(sg_page(sg));
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
-		if (res)
-			return res;
-
-		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg_page(sg))) {
-			if (usglen <= 0)
-				break;
-			if (ksglen > usglen) {
-				if (usglen >= num_xfer) {
-					if (__copy_from_user(p, up, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_from_user(p, up, usglen))
-					return -EFAULT;
-				p += usglen;
-				ksglen -= usglen;
-				break;
-			} else {
-				if (ksglen >= num_xfer) {
-					if (__copy_from_user(p, up, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_from_user(p, up, ksglen))
-					return -EFAULT;
-				up += ksglen;
-				usglen -= ksglen;
-			}
-			++k;
-			if (k >= schp->k_use_sg)
-				return 0;
-		}
-	}
 
 	return 0;
 }
 
-static int
-sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
-	   int wr_xf, int *countp, unsigned char __user **up)
-{
-	int num_xfer = (int) hp->dxfer_len;
-	unsigned char __user *p = hp->dxferp;
-	int count;
-
-	if (0 == sg_num) {
-		if (wr_xf && ('\0' == hp->interface_id))
-			count = (int) hp->flags;	/* holds "old" input_size */
-		else
-			count = num_xfer;
-	} else {
-		sg_iovec_t iovec;
-		if (__copy_from_user(&iovec, p + ind*SZ_SG_IOVEC, SZ_SG_IOVEC))
-			return -EFAULT;
-		p = iovec.iov_base;
-		count = (int) iovec.iov_len;
-	}
-	if (!access_ok(wr_xf ? VERIFY_READ : VERIFY_WRITE, p, count))
-		return -EFAULT;
-	if (up)
-		*up = p;
-	if (countp)
-		*countp = count;
-	return 0;
-}
-
 static void
 sg_remove_scat(Sg_scatter_hold * schp)
 {
 	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
-	if (schp->buffer && (schp->sglist_len > 0)) {
-		struct scatterlist *sg = schp->buffer;
-
+	if (schp->pages && schp->sglist_len > 0) {
 		if (!schp->dio_in_use) {
 			int k;
 
-			for (k = 0; (k < schp->k_use_sg) && sg_page(sg);
-			     ++k, sg = sg_next(sg)) {
+			for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
 				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg_page(sg), sg->length));
-				sg_page_free(sg_page(sg), sg->length);
+				    "sg_remove_scat: k=%d, pg=0x%p\n",
+				    k, page));
+				__free_pages(schp->pages[k], schp->page_order);
 			}
 
-			kfree(schp->buffer);
+			kfree(schp->pages);
 		}
 	}
 	memset(schp, 0, sizeof (*schp));
@@ -1975,13 +1895,8 @@ sg_read_xfer(Sg_request * srp)
 {
 	sg_io_hdr_t *hp = &srp->header;
 	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
 	int num_xfer = 0;
-	int j, k, onum, usglen, ksglen, res;
-	int iovec_count = (int) hp->iovec_count;
 	int dxfer_dir = hp->dxfer_direction;
-	unsigned char *p;
-	unsigned char __user *up;
 	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
 
 	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_FROM_DEV == dxfer_dir)
@@ -1996,53 +1911,7 @@ sg_read_xfer(Sg_request * srp)
 		return 0;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, iovec_count, schp->k_use_sg));
-	if (iovec_count) {
-		onum = iovec_count;
-		if (!access_ok(VERIFY_READ, hp->dxferp, SZ_SG_IOVEC * onum))
-			return -EFAULT;
-	} else
-		onum = 1;
-
-	p = page_address(sg_page(sg));
-	ksglen = sg->length;
-	for (j = 0, k = 0; j < onum; ++j) {
-		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
-		if (res)
-			return res;
-
-		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg_page(sg))) {
-			if (usglen <= 0)
-				break;
-			if (ksglen > usglen) {
-				if (usglen >= num_xfer) {
-					if (__copy_to_user(up, p, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_to_user(up, p, usglen))
-					return -EFAULT;
-				p += usglen;
-				ksglen -= usglen;
-				break;
-			} else {
-				if (ksglen >= num_xfer) {
-					if (__copy_to_user(up, p, num_xfer))
-						return -EFAULT;
-					return 0;
-				}
-				if (__copy_to_user(up, p, ksglen))
-					return -EFAULT;
-				up += ksglen;
-				usglen -= ksglen;
-			}
-			++k;
-			if (k >= schp->k_use_sg)
-				return 0;
-		}
-	}
-
+			  num_xfer, (int)hp->iovec_count, schp->k_use_sg));
 	return 0;
 }
 
@@ -2050,7 +1919,6 @@ static int
 sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 {
 	Sg_scatter_hold *schp = &srp->data;
-	struct scatterlist *sg = schp->buffer;
 	int k, num;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
@@ -2058,15 +1926,18 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	for (k = 0; (k < schp->k_use_sg) && sg_page(sg); ++k, sg = sg_next(sg)) {
-		num = sg->length;
+	blk_rq_unmap_user(srp->bio);
+	srp->bio = NULL;
+
+	num = 1 << (PAGE_SHIFT + schp->page_order);
+	for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
 		if (num > num_read_xfer) {
-			if (__copy_to_user(outp, page_address(sg_page(sg)),
+			if (__copy_to_user(outp, page_address(schp->pages[k]),
 					   num_read_xfer))
 				return -EFAULT;
 			break;
 		} else {
-			if (__copy_to_user(outp, page_address(sg_page(sg)),
+			if (__copy_to_user(outp, page_address(schp->pages[k]),
 					   num))
 				return -EFAULT;
 			num_read_xfer -= num;
@@ -2101,24 +1972,22 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 {
 	Sg_scatter_hold *req_schp = &srp->data;
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
-	struct scatterlist *sg = rsv_schp->buffer;
 	int k, num, rem;
 
 	srp->res_used = 1;
 	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
 	rem = size;
 
-	for (k = 0; k < rsv_schp->k_use_sg; ++k, sg = sg_next(sg)) {
-		num = sg->length;
+	num = 1 << (PAGE_SHIFT + rsv_schp->page_order);
+	for (k = 0; k < rsv_schp->k_use_sg; k++) {
 		if (rem <= num) {
-			sfp->save_scat_len = num;
-			sg->length = rem;
 			req_schp->k_use_sg = k + 1;
 			req_schp->sglist_len = rsv_schp->sglist_len;
-			req_schp->buffer = rsv_schp->buffer;
+			req_schp->pages = rsv_schp->pages;
 
 			req_schp->bufflen = size;
 			req_schp->b_malloc_len = rsv_schp->b_malloc_len;
+			req_schp->page_order = rsv_schp->page_order;
 			break;
 		} else
 			rem -= num;
@@ -2132,22 +2001,13 @@ static void
 sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 {
 	Sg_scatter_hold *req_schp = &srp->data;
-	Sg_scatter_hold *rsv_schp = &sfp->reserve;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
 				   (int) req_schp->k_use_sg));
-	if ((rsv_schp->k_use_sg > 0) && (req_schp->k_use_sg > 0)) {
-		struct scatterlist *sg = rsv_schp->buffer;
-
-		if (sfp->save_scat_len > 0)
-			(sg + (req_schp->k_use_sg - 1))->length =
-			    (unsigned) sfp->save_scat_len;
-		else
-			SCSI_LOG_TIMEOUT(1, printk ("sg_unlink_reserve: BAD save_scat_len\n"));
-	}
 	req_schp->k_use_sg = 0;
 	req_schp->bufflen = 0;
-	req_schp->buffer = NULL;
+	req_schp->pages = NULL;
+	req_schp->page_order = 0;
 	req_schp->sglist_len = 0;
 	sfp->save_scat_len = 0;
 	srp->res_used = 0;
@@ -2405,53 +2265,6 @@ sg_res_in_use(Sg_fd * sfp)
 	return srp ? 1 : 0;
 }
 
-/* The size fetched (value output via retSzp) set when non-NULL return */
-static struct page *
-sg_page_malloc(int rqSz, int lowDma, int *retSzp)
-{
-	struct page *resp = NULL;
-	gfp_t page_mask;
-	int order, a_size;
-	int resSz;
-
-	if ((rqSz <= 0) || (NULL == retSzp))
-		return resp;
-
-	if (lowDma)
-		page_mask = GFP_ATOMIC | GFP_DMA | __GFP_COMP | __GFP_NOWARN;
-	else
-		page_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
-
-	for (order = 0, a_size = PAGE_SIZE; a_size < rqSz;
-	     order++, a_size <<= 1) ;
-	resSz = a_size;		/* rounded up if necessary */
-	resp = alloc_pages(page_mask, order);
-	while ((!resp) && order) {
-		--order;
-		a_size >>= 1;	/* divide by 2, until PAGE_SIZE */
-		resp =  alloc_pages(page_mask, order);	/* try half */
-		resSz = a_size;
-	}
-	if (resp) {
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			memset(page_address(resp), 0, resSz);
-		*retSzp = resSz;
-	}
-	return resp;
-}
-
-static void
-sg_page_free(struct page *page, int size)
-{
-	int order, a_size;
-
-	if (!page)
-		return;
-	for (order = 0, a_size = PAGE_SIZE; a_size < size;
-	     order++, a_size <<= 1) ;
-	__free_pages(page, order);
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 static int
 sg_idr_max_id(int id, void *p, void *data)
-- 
1.5.5.GIT

