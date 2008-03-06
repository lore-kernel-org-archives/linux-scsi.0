From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [12/21] Remove unchecked_isa_dma checks in sg.c
Date: Thu,  6 Mar 2008 21:51:33 +0100 (CET)
Message-ID: <20080306205133.2D0F71B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53297 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761526AbYCFUvm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:42 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


They are only used to allocate data buffers, and those are bounced
by the block layer anyways.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/sg.c |   47 ++++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

Index: linux/drivers/scsi/sg.c
===================================================================
--- linux.orig/drivers/scsi/sg.c
+++ linux/drivers/scsi/sg.c
@@ -150,7 +150,6 @@ typedef struct sg_fd {		/* holds the sta
 	Sg_request *headrp;	/* head of request slist, NULL->empty */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
-	char low_dma;		/* as in parent but possibly overridden to 1 */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	volatile char closed;	/* 1 -> fd closed but request(s) outstanding */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
@@ -195,7 +194,7 @@ static void sg_remove_scat(Sg_scatter_ho
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static struct page *sg_page_malloc(int rqSz, int lowDma, int *retSzp);
+static struct page *sg_page_malloc(struct scsi_device *dev, int rqSz, int *retSzp);
 static void sg_page_free(struct page *page, int size);
 static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
 static int sg_remove_sfp(Sg_device * sdp, Sg_fd * sfp);
@@ -844,8 +843,7 @@ sg_ioctl(struct inode *inode, struct fil
 		if (result)
 			return result;
 		if (val) {
-			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
+			if (0 == sg_res_in_use(sfp)) {
 				val = (int) sfp->reserve.bufflen;
 				sg_remove_scat(&sfp->reserve);
 				sg_build_reserve(sfp, val);
@@ -853,11 +851,10 @@ sg_ioctl(struct inode *inode, struct fil
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
@@ -1622,8 +1619,7 @@ sg_start_req(Sg_request * srp)
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
-	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
-	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
+	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count)) {
 		res = sg_build_direct(srp, sfp, dxfer_len);
 		if (res <= 0)	/* -ve -> error, 0 -> done, 1 -> try indirect */
 			return res;
@@ -1660,14 +1656,6 @@ sg_build_sgat(Sg_scatter_hold * schp, co
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
@@ -1860,7 +1848,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 		
 		num = (rem_sz > scatter_elem_sz_prev) ?
 		      scatter_elem_sz_prev : rem_sz;
-		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
+		p = sg_page_malloc(sfp->parentdp->device, num, &ret_sz);
 		if (!p)
 			return -ENOMEM;
 
@@ -2345,8 +2333,6 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
-	sfp->low_dma = (SG_DEF_FORCE_LOW_DMA == 0) ?
-	    sdp->device->host->unchecked_isa_dma : 1;
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
@@ -2456,7 +2442,7 @@ sg_res_in_use(Sg_fd * sfp)
 
 /* The size fetched (value output via retSzp) set when non-NULL return */
 static struct page *
-sg_page_malloc(int rqSz, int lowDma, int *retSzp)
+sg_page_malloc(struct scsi_device *dev, int rqSz, int *retSzp)
 {
 	struct page *resp = NULL;
 	gfp_t page_mask;
@@ -2466,15 +2452,12 @@ sg_page_malloc(int rqSz, int lowDma, int
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
+	resp = blk_alloc_pages(dev->request_queue, page_mask, resSz);
 	while ((!resp) && order) {
 		--order;
 		a_size >>= 1;	/* divide by 2, until PAGE_SIZE */
@@ -2492,13 +2475,8 @@ sg_page_malloc(int rqSz, int lowDma, int
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
+		blk_free_pages(page, size);
 }
 
 #ifndef MAINTENANCE_IN_CMD
@@ -2869,11 +2847,10 @@ static void sg_proc_debug_helper(struct 
 
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
