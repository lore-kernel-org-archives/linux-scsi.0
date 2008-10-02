From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [13/21] SCSI-ISA-DMA: Use blk_q_mask/get_pages_mask in sg driver
Date: Thu,  2 Oct 2008 09:58:51 +0200 (CEST)
Message-ID: <20081002075851.56FFE3E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57106 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYJBH6x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:53 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Instead of using GFP_DMA directly.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/sg.c |   48 +++++++++++++-----------------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

Index: linux/drivers/scsi/sg.c
===================================================================
--- linux.orig/drivers/scsi/sg.c
+++ linux/drivers/scsi/sg.c
@@ -50,6 +50,7 @@ static int sg_version_num = 30534;	/* 2 
 #include <linux/scatterlist.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
+#include <linux/gfp.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -151,7 +152,6 @@ typedef struct sg_fd {		/* holds the sta
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
-	char low_dma;		/* as in parent but possibly overridden to 1 */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	volatile char closed;	/* 1 -> fd closed but request(s) outstanding */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
@@ -197,7 +197,7 @@ static void sg_remove_scat(Sg_scatter_ho
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static struct page *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
+static struct page *sg_page_malloc(struct scsi_device *dev, int rqSz, int *retSzp);
 static void sg_page_free(struct page *page, int size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
 static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
@@ -867,8 +867,7 @@ sg_ioctl(struct inode *inode, struct fil
 		if (result)
 			return result;
 		if (val) {
-			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
+			if (0 == sg_res_in_use(sfp)) {
 				val = (int) sfp->reserve.bufflen;
 				sg_remove_scat(&sfp->reserve);
 				sg_build_reserve(sfp, val);
@@ -876,11 +875,10 @@ sg_ioctl(struct inode *inode, struct fil
 		} else {
 			if (sdp->detached)
 				return -ENODEV;
-			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
 		}
 		return 0;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
+		return put_user(0, ip);
 	case SG_GET_SCSI_ID:
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
 			return -EFAULT;
@@ -1649,8 +1647,7 @@ sg_start_req(Sg_request * srp)
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
-	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
-	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
+	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count)) {
 		res = sg_build_direct(srp, sfp, dxfer_len);
 		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
 			return res;
@@ -1687,14 +1684,6 @@ sg_build_sgat(Sg_scatter_hold * schp, co
 	int sg_bufflen = tablesize * sizeof(struct scatterlist);
 	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
 
-	/*
-	 * TODO: test without low_dma, we should not need it since
-	 * the block layer will bounce the buffer for us
-	 *
-	 * XXX(hch): we shouldn't need GFP_DMA for the actual S/G list.
-	 */
-	if (sfp->low_dma)
-		 gfp_flags |= GFP_DMA;
 	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
 	if (!schp->buffer)
 		return -ENOMEM;
@@ -1887,7 +1876,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 		
 		num = (rem_sz > scatter_elem_sz_prev) ?
 		      scatter_elem_sz_prev : rem_sz;
-		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
+		p = sg_page_malloc(sfp->parentdp->device, num, &ret_sz);
 		if (!p)
 			return -ENOMEM;
 
@@ -2372,8 +2361,6 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
-	sfp->low_dma = (SG_DEF_FORCE_LOW_DMA == 0) ?
-	    sdp->device->host->unchecked_isa_dma : 1;
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
@@ -2483,7 +2470,7 @@ sg_res_in_use(Sg_fd * sfp)
 
 /* The size fetched (value output via retSzp) set when non-NULL return */
 static struct page *
-sg_page_malloc(int rqSz, int lowDma, int *retSzp)
+sg_page_malloc(struct scsi_device *dev, int rqSz, int *retSzp)
 {
 	struct page *resp = NULL;
 	gfp_t page_mask;
@@ -2493,15 +2480,12 @@ sg_page_malloc(int rqSz, int lowDma, int
 	if ((rqSz <= 0) || (NULL == retSzp))
 		return resp;
 
-	if (lowDma)
-		page_mask = GFP_ATOMIC | GFP_DMA | __GFP_COMP | __GFP_NOWARN;
-	else
-		page_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
+	page_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN;
 
 	for (order = 0, a_size = PAGE_SIZE; a_size < rqSz;
 	     order++, a_size <<= 1) ;
 	resSz = a_size;		/* rounded up if necessary */
-	resp = alloc_pages(page_mask, order);
+	resp = get_pages_mask(page_mask, resSz, blk_q_mask(dev->request_queue));
 	while ((!resp) && order) {
 		--order;
 		a_size >>= 1;	/* divide by 2, until PAGE_SIZE */
@@ -2519,13 +2503,8 @@ sg_page_malloc(int rqSz, int lowDma, int
 static void
 sg_page_free(struct page *page, int size)
 {
-	int order, a_size;
-
-	if (!page)
-		return;
-	for (order = 0, a_size = PAGE_SIZE; a_size < size;
-	     order++, a_size <<= 1) ;
-	__free_pages(page, order);
+	if (page)
+		__free_pages_mask(page, size);
 }
 
 #ifdef CONFIG_SCSI_PROC_FS
@@ -2868,11 +2847,10 @@ static void sg_proc_debug_helper(struct 
 
 	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
 		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
-			   "(res)sgat=%d low_dma=%d\n", k + 1,
+			   "(res)sgat=%d\n", k + 1,
 			   jiffies_to_msecs(fp->timeout),
 			   fp->reserve.bufflen,
-			   (int) fp->reserve.k_use_sg,
-			   (int) fp->low_dma);
+			   (int) fp->reserve.k_use_sg);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=%d\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan, (int) fp->closed);
