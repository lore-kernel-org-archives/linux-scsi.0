Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225DAC5518A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 084F520724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDUVx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:53:57 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43196 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726493AbgDUVxw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 17:53:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 284742041BB;
        Tue, 21 Apr 2020 23:53:50 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CPu5LJNcfNEU; Tue, 21 Apr 2020 23:53:47 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A4F142041D4;
        Tue, 21 Apr 2020 23:53:43 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v9 36/40] sg: rework mmap support
Date:   Tue, 21 Apr 2020 17:52:54 -0400
Message-Id: <20200421215258.14348-37-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421215258.14348-1-dgilbert@interlog.com>
References: <20200421215258.14348-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
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
output.

*** Reviewed-by: Hannes Reinecke <hare@suse.de>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 193 +++++++++++++++++++++++++++-------------------
 1 file changed, 112 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9c4eb5125b84..e355d472aa72 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -279,7 +279,8 @@ static void sg_dfs_exit(void);
 static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp,
 			int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
-static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen);
+static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen,
+		      bool for_mmap);
 static int sg_v3_submit(struct file *filp, struct sg_fd *sfp,
 			struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
@@ -2235,13 +2236,39 @@ sg_fasync(int fd, struct file *filp, int mode)
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
@@ -2267,7 +2294,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
 		goto out_err;
 	}
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	mutex_lock(&sfp->f_mutex);
 	rsv_schp = &srp->sgat_h;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= (unsigned int)rsv_schp->buflen) {
@@ -2275,44 +2302,37 @@ sg_vma_fault(struct vm_fault *vmf)
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
 
@@ -2323,40 +2343,47 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
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
+		res = sg_mk_sgat(srp, sfp, req_sz, true);
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
 
 /*
@@ -2950,7 +2977,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	}
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
-	us_xfer = !(srp->rq_flags & SG_FLAG_NO_DXFER);
+	us_xfer = !(srp->rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
 	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
 	reserved = (sfp->rsv_srp == srp);
 	rq->end_io_data = srp;
@@ -2979,7 +3006,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		} else if (req_schp->buflen == 0) {
 			int up_sz = max_t(int, dxfer_len, sfp->sgat_elem_sz);
 
-			res = sg_mk_sgat(srp, sfp, up_sz);
+			res = sg_mk_sgat(srp, sfp, up_sz, false);
 		}
 		if (unlikely(res))
 			goto fini;
@@ -3087,66 +3114,70 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 }
 
 static int
-sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
+sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen,
+	   bool for_mmap)
 {
-	int j, k, rem_sz, order, align_sz;
+	int j, k, rem_sz, order, align_sz, elem_sz;
 	__maybe_unused int o_order;
-	int m_size = minlen;
 	int rup_sz = 0;
 	int mx_sgat_elems = sfp->parentdp->max_sgat_elems;
-	u32 elem_sz;
 	const size_t struct_page_sz = sizeof(struct page *);
 	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_scatter_hold *schp = &srp->sgat_h;
+	struct page **pgp;
 
-	if (unlikely(m_size < 0))
+	if (unlikely(minlen < 0))
 		return -EFAULT;
-	if (unlikely(m_size == 0))
-		++m_size;	/* don't remember why */
+	if (unlikely(minlen == 0))
+		++minlen;	/* don't remember why */
 	/* round request up to next highest SG_DEF_SECTOR_SZ byte boundary */
-	align_sz = ALIGN(m_size, SG_DEF_SECTOR_SZ);
-
+	align_sz = ALIGN(minlen, SG_DEF_SECTOR_SZ);
 	schp->pages = kcalloc(mx_sgat_elems, struct_page_sz, mask_kz);
 	SG_LOG(4, sfp, "%s: minlen=%d [sz=%zu, 0x%pK ++]\n", __func__, minlen,
 	       mx_sgat_elems * struct_page_sz, schp->pages);
 	if (unlikely(!schp->pages))
 		return -ENOMEM;
 
-	elem_sz = sfp->sgat_elem_sz;    /* power of 2 and >= PAGE_SIZE */
+	/* elem_sz must be power of 2 and >= PAGE_SIZE */
+	elem_sz = for_mmap ? (int)PAGE_SIZE : sfp->sgat_elem_sz;
 	if (sdp && unlikely(sdp->device->host->unchecked_isa_dma))
 		mask_ap |= GFP_DMA;
 	/* PAGE_SIZE == (1 << PAGE_SHIFT) == (2 ** PAGE_SHIFT) */
 	order = get_order(elem_sz); /* --> ilog2(1+((elem_sz-1)/PAGE_SIZE)) */
 	o_order = order;
 again:
-	rup_sz = 1 << (PAGE_SHIFT + order);	/* round up size */
-
-	for (k = 0, rem_sz = align_sz; rem_sz > 0 && k < mx_sgat_elems;
-	     ++k, rem_sz -= rup_sz) {
-		schp->pages[k] = alloc_pages(mask_ap, order);
-		if (!schp->pages[k])
+	rup_sz = 1 << (PAGE_SHIFT + order);     /* round up element size */
+	if (rup_sz * mx_sgat_elems < align_sz) {        /* misfit ? */
+		SG_LOG(1, sfp, "%s: align_sz=%d too big\n", __func__,
+		       align_sz);
+		goto b4_alloc_pages;
+	}
+	rem_sz = align_sz;
+	for (pgp = schp->pages; rem_sz > 0; ++pgp, rem_sz -= rup_sz) {
+		*pgp = alloc_pages(mask_ap, order);
+		if (unlikely(!*pgp))
 			goto err_out;
-		SG_LOG(5, sfp, "%s: k=%d, rup_sz=%d [0x%pK ++]\n", __func__, k,
-		       rup_sz, schp->pages[k]);
+		SG_LOG(6, sfp, "%s: rup_sz=%d [0x%pK ++]\n", __func__,
+		       rup_sz, *pgp);
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
 
 	if (--order >= 0)
 		goto again;
+b4_alloc_pages:
 	kfree(schp->pages);
 	schp->pages = NULL;
 	return -ENOMEM;
@@ -3162,7 +3193,7 @@ sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 		return;
 	for (k = 0; k < schp->num_sgat; ++k) {
 		p = schp->pages[k];
-		SG_LOG(5, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
+		SG_LOG(6, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
 		if (unlikely(!p))
 			continue;
 		__free_pages(p, schp->page_order);
@@ -3292,7 +3323,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 	}
 	return NULL;
 good:
-	SG_LOG(6, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
+	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
 	       pack_id, srp);
 	return srp;
 }
@@ -3331,7 +3362,7 @@ sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 	if (IS_ERR(n_srp))
 		return n_srp;
 	if (db_len > 0) {
-		res = sg_mk_sgat(n_srp, sfp, db_len);
+		res = sg_mk_sgat(n_srp, sfp, db_len, false);
 		if (unlikely(res)) {
 			kfree(n_srp);
 			return ERR_PTR(res);
@@ -3364,7 +3395,7 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 			buflen = PAGE_SIZE;
 			go_out = true;
 		}
-		res = sg_mk_sgat(srp, sfp, buflen);
+		res = sg_mk_sgat(srp, sfp, buflen, false);
 		if (res == 0) {
 			SG_LOG(4, sfp, "%s: final buflen=%d, srp=0x%pK ++\n",
 			       __func__, buflen, srp);
-- 
2.26.1

