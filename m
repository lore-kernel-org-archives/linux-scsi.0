Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FF9FA373D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJXDZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJXDXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:03 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48DD332EC4
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 758F72041CE;
        Mon, 24 Oct 2022 05:21:52 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id J49BR7svqaGD; Mon, 24 Oct 2022 05:21:52 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 4062C2041AF;
        Mon, 24 Oct 2022 05:21:51 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 34/44] sg: rework mmap support
Date:   Sun, 23 Oct 2022 23:20:48 -0400
Message-Id: <20221024032058.14077-35-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Linux has an issue with mmap-ed multiple pages issued by
alloc_pages() [with order > 0]. So when mmap(2) is called if the
reserve request's scatter gather (sgat) list is either:
  - not big enough, or
  - made up of elements of order > 0 (i.e. size > PAGE_SIZE)
then throw away reserve requests sgat list and rebuild it meeting
those requirements.
Clean up related code and stop doing mmap+indirect_io.

This new mmap implementation is marginally more flexible (but
still compatible with) the production driver. Previously if the
user wanted a larger mmap(2) 'length' than the reserve request's
size, then they needed to use ioctl(SG_SET_RESERVED_SIZE) to set
the new size first. Now mmap(2) called on a sg device node will
adjust to the size given by 'length' [mmap's second parameter].

Tweak some SG_LOG() levels to control the amount of debug
output. Add some WRITE_ONCE() macros when bitop integers are
being initialised.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 181 ++++++++++++++++++++++++++++------------------
 1 file changed, 109 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5ccd410e4a53..cb110ff18047 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -118,6 +118,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_NO_US_XFER	3	/* no user space transfer of data */
 #define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
 #define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
+#define SG_FRQ_FOR_MMAP		8	/* request needs PAGE_SIZE elements */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -707,7 +708,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			 input_size, (unsigned int)opcode, current->comm);
 	}
 	cwr.h3p = h3p;
-	cwr.frq_bm[0] = 0;
+	WRITE_ONCE(cwr.frq_bm[0], 0);
 	cwr.timeout = sfp->timeout;
 	cwr.cmd_len = cmd_size;
 	cwr.filp = filp;
@@ -769,7 +770,7 @@ sg_v3_submit(struct file *filp, struct sg_fd *sfp, struct sg_io_hdr *hp,
 	/* when v3 seen, allow cmd_q on this fd (def: no cmd_q) */
 	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	cwr.frq_bm[0] = 0;
+	WRITE_ONCE(cwr.frq_bm[0], 0);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
 	cwr.h3p = hp;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
@@ -810,7 +811,7 @@ sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
 	cwr.filp = filp;
 	cwr.sfp = sfp;
-	cwr.frq_bm[0] = 0;
+	WRITE_ONCE(cwr.frq_bm[0], 0);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
 	__set_bit(SG_FRQ_IS_V4I, cwr.frq_bm);
 	cwr.h4p = h4p;
@@ -1753,6 +1754,8 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 	srp = sfp->rsv_srp;
 	if (!srp)
 		return -EPROTO;
+	if (test_bit(SG_FRQ_FOR_MMAP, srp->frq_bm))
+		return -EBUSY;
 	new_sz = min_t(int, want_rsv_sz, sfp->parentdp->max_sgat_sz);
 	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
 	blen = srp->sgat_h.buflen;
@@ -2144,13 +2147,39 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
+static void
+sg_vma_open(struct vm_area_struct *vma)
+{
+	struct sg_fd *sfp = vma->vm_private_data;
+
+	if (unlikely(!sfp)) {
+		pr_warn("%s: sfp null\n", __func__);
+		return;
+	}
+	kref_get(&sfp->f_ref);
+}
+
+static void
+sg_vma_close(struct vm_area_struct *vma)
+{
+	struct sg_fd *sfp = vma->vm_private_data;
+
+	if (unlikely(!sfp)) {
+		pr_warn("%s: sfp null\n", __func__);
+		return;
+	}
+	kref_put(&sfp->f_ref, sg_remove_sfp); /* get in: sg_vma_open() */
+}
+
 /* Note: the error return: VM_FAULT_SIGBUS causes a "bus error" */
 static vm_fault_t
 sg_vma_fault(struct vm_fault *vmf)
 {
-	int k, length;
-	unsigned long offset, len, sa, iflags;
+	int k, n, length;
+	int res = VM_FAULT_SIGBUS;
+	unsigned long offset;
 	struct vm_area_struct *vma = vmf->vma;
+	struct page *page;
 	struct sg_scatter_hold *rsv_schp;
 	struct sg_request *srp;
 	struct sg_device *sdp;
@@ -2176,7 +2205,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
 		goto out_err;
 	}
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	mutex_lock(&sfp->f_mutex);
 	rsv_schp = &srp->sgat_h;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= (unsigned int)rsv_schp->buflen) {
@@ -2184,44 +2213,37 @@ sg_vma_fault(struct vm_fault *vmf)
 		       offset);
 		goto out_err_unlock;
 	}
-	sa = vma->vm_start;
-	SG_LOG(3, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__, sa, offset);
+	SG_LOG(5, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__,
+	       vma->vm_start, offset);
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; ++k) {
-		len = vma->vm_end - sa;
-		len = min_t(int, len, (int)length);
-		if (offset < len) {
-			struct page *page;
-			struct page *pp;
-
-			pp = rsv_schp->pages[k];
-			xa_unlock_irqrestore(&sfp->srp_arr, iflags);
-			page = nth_page(pp, offset >> PAGE_SHIFT);
-			get_page(page); /* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
-	}
+	k = (int)offset / length;
+	n = ((int)offset % length) >> PAGE_SHIFT;
+	page = nth_page(rsv_schp->pages[k], n);
+	get_page(page);
+	vmf->page = page;
+	res = 0;
 out_err_unlock:
-	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	mutex_unlock(&sfp->f_mutex);
 out_err:
-	return VM_FAULT_SIGBUS;
+	return res;
 }
 
 static const struct vm_operations_struct sg_mmap_vm_ops = {
 	.fault = sg_vma_fault,
+	.open = sg_vma_open,
+	.close = sg_vma_close,
 };
 
-/* Entry point for mmap(2) system call */
+/*
+ * Entry point for mmap(2) system call. For mmap(2) to work, request's
+ * scatter gather list needs to be order 0 which it is unlikely to be
+ * by default. mmap(2) cannot be called more than once per fd.
+ */
 static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	int k, length;
-	int ret = 0;
-	unsigned long req_sz, len, sa, iflags;
-	struct sg_scatter_hold *rsv_schp;
+	int res = 0;
+	unsigned long req_sz;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
 
@@ -2232,40 +2254,48 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		pr_warn("sg: %s: sfp is NULL\n", __func__);
 		return -ENXIO;
 	}
+	mutex_lock(&sfp->f_mutex);
 	req_sz = vma->vm_end - vma->vm_start;
 	SG_LOG(3, sfp, "%s: vm_start=%pK, len=%d\n", __func__,
 	       (void *)vma->vm_start, (int)req_sz);
-	if (vma->vm_pgoff)
-		return -EINVAL; /* only an offset of 0 accepted */
+	if (vma->vm_pgoff) {
+		res = -EINVAL; /* only an offset of 0 accepted */
+		goto fini;
+	}
 	/* Check reserve request is inactive and has large enough buffer */
-	mutex_lock(&sfp->f_mutex);
 	srp = sfp->rsv_srp;
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	if (SG_RS_ACTIVE(srp)) {
-		ret = -EBUSY;
-		goto out;
+		res = -EBUSY;
+		goto fini;
 	}
-	rsv_schp = &srp->sgat_h;
-	if (req_sz > (unsigned long)rsv_schp->buflen) {
-		ret = -ENOMEM;
-		goto out;
+	if (req_sz > SG_WRITE_COUNT_LIMIT) {	/* sanity check */
+		res = -ENOMEM;
+		goto fini;
 	}
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; ++k) {
-		len = vma->vm_end - sa;
-		len = min_t(unsigned long, len, (unsigned long)length);
-		sa += len;
+	if (test_and_set_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm)) {
+		SG_LOG(1, sfp, "%s: multiple invocations on this fd\n",
+		       __func__);
+		res = -EADDRINUSE;
+		goto fini;
+	}
+	if (srp->sgat_h.page_order > 0 ||
+	    req_sz > (unsigned long)srp->sgat_h.buflen) {
+		sg_remove_sgat(srp);
+		set_bit(SG_FRQ_FOR_MMAP, srp->frq_bm);
+		res = sg_mk_sgat(&srp->sgat_h, sfp, req_sz);
+		if (res) {
+			SG_LOG(1, sfp, "%s: sg_mk_sgat failed, wanted=%lu\n",
+			       __func__, req_sz);
+			goto fini;
+		}
 	}
-
-	set_bit(SG_FFD_MMAP_CALLED, sfp->ffd_bm);
 	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	sg_vma_open(vma);
+fini:
 	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	return res;
 }
 
 static void
@@ -2844,7 +2874,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		goto fini;
 	scmd->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scmd->cmnd[0];
-	us_xfer = !(srp->rq_flags & SG_FLAG_NO_DXFER);
+	us_xfer = !(srp->rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
 	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
 	reserved = (sfp->rsv_srp == srp);
 	rq->end_io_data = srp;
@@ -2945,10 +2975,11 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 {
 	int j, k, rem_sz, align_sz, order, o_order;
 	int mx_sgat_elems = sfp->parentdp->max_sgat_elems;
-	unsigned int elem_sz;
+	unsigned int elem_sz = sfp->sgat_elem_sz;
 	const size_t ptr_sz = sizeof(struct page *);
 	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
+	struct page **pgp;
 
 	if (unlikely(minlen <= 0)) {
 		if (minlen < 0)
@@ -2963,30 +2994,35 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 	       mx_sgat_elems * ptr_sz, schp->pages);
 	if (unlikely(!schp->pages))
 		return -ENOMEM;
-	elem_sz = sfp->sgat_elem_sz;	/* power of 2 and >= PAGE_SIZE */
+
+	/* elem_sz must be power of 2 and >= PAGE_SIZE */
 	o_order = get_order(elem_sz);
 	order = o_order;
 
 again:
-	for (k = 0, rem_sz = align_sz; rem_sz > 0 && k < mx_sgat_elems;
-	     ++k, rem_sz -= elem_sz) {
-		schp->pages[k] = alloc_pages(mask_ap, order);
-		if (!schp->pages[k])
+	if (elem_sz * mx_sgat_elems < align_sz) {	/* misfit ? */
+		SG_LOG(1, sfp, "%s: align_sz=%d too big\n", __func__,
+		       align_sz);
+		goto b4_alloc_pages;
+	}
+	rem_sz = align_sz;
+	for (pgp = schp->pages; rem_sz > 0; ++pgp, rem_sz -= elem_sz) {
+		*pgp = alloc_pages(mask_ap, order);
+		if (unlikely(!*pgp))
 			goto err_out;
-		SG_LOG(5, sfp, "%s: k=%d, order=%d [0x%pK ++]\n", __func__, k,
-		       order, schp->pages[k]);
+		SG_LOG(6, sfp, "%s: elem_sz=%d [0x%pK ++]\n", __func__,
+		       elem_sz, *pgp);
 	}
+	k = pgp - schp->pages;
+	SG_LOG(((order != o_order || rem_sz > 0) ? 2 : 5), sfp,
+	       "%s: num_sgat=%d, order=%d,%d  rem_sz=%d\n", __func__, k,
+	       o_order, order, rem_sz);
 	schp->page_order = order;
 	schp->num_sgat = k;
-	SG_LOG(((order != o_order || rem_sz > 0) ? 2 : 5), sfp,
-	       "%s: num_sgat=%d, order=%d,%d\n", __func__, k, o_order, order);
-	if (unlikely(rem_sz > 0)) {	/* hit mx_sgat_elems */
-		order = 0;		/* force exit */
-		goto err_out;
-	}
 	schp->buflen = align_sz;
 	return 0;
 err_out:
+	k = pgp - schp->pages;
 	for (j = 0; j < k; ++j)
 		__free_pages(schp->pages[j], order);
 
@@ -2994,6 +3030,7 @@ sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 		elem_sz >>= 1;
 		goto again;
 	}
+b4_alloc_pages:
 	kfree(schp->pages);
 	schp->pages = NULL;
 	return -ENOMEM;
@@ -3009,7 +3046,7 @@ sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 		return;
 	for (k = 0; k < schp->num_sgat; ++k) {
 		p = schp->pages[k];
-		SG_LOG(5, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
+		SG_LOG(6, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
 		if (unlikely(!p))
 			continue;
 		__free_pages(p, schp->page_order);
@@ -3154,7 +3191,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 	}
 	return NULL;
 good:
-	SG_LOG(6, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
+	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
 	       pack_id, srp);
 	return srp;
 }
@@ -3350,7 +3387,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		r_srp->parentfp = fp;
 		SG_LOG(4, fp, "%s: mk_new_srp=0x%pK ++\n", __func__, r_srp);
 	}
-	r_srp->frq_bm[0] = cwrp->frq_bm[0];	/* assumes <= 32 req flags */
+	WRITE_ONCE(r_srp->frq_bm[0], cwrp->frq_bm[0]);	/* assumes <= 32 req flags */
 	r_srp->sgat_h.dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
 fini:
@@ -3377,7 +3414,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 		return;
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
-	srp->frq_bm[0] = 0;
+	WRITE_ONCE(srp->frq_bm[0], 0);
 	sg_rq_state_chg(srp, 0, SG_RS_INACTIVE, true /* force */, __func__);
 	/* maybe orphaned req, thus never read */
 	if (sbp)
-- 
2.37.3

