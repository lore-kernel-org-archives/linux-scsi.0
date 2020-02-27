Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9C5C35E15
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85852246A1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgB0RAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 12:00:03 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47324 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbgB0RAC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 12:00:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id BC4F320418D;
        Thu, 27 Feb 2020 18:00:00 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7RMtnfqqA94c; Thu, 27 Feb 2020 17:59:58 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 4842B204194;
        Thu, 27 Feb 2020 17:59:51 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v7 36/38] sg: rework mmap support
Date:   Thu, 27 Feb 2020 11:59:00 -0500
Message-Id: <20200227165902.11861-37-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227165902.11861-1-dgilbert@interlog.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
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

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 150 +++++++++++++++++++++++++++-------------------
 1 file changed, 87 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 091be488ab32..18066aabd195 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -281,7 +281,8 @@ static void sg_dfs_exit(void);
 static int sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp,
 			int dxfer_dir);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
-static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen);
+static int sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen,
+		      bool for_mmap);
 static int sg_v3_submit(struct file *filp, struct sg_fd *sfp,
 			struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
@@ -2240,13 +2241,39 @@ sg_fasync(int fd, struct file *filp, int mode)
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
@@ -2272,7 +2299,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
 		goto out_err;
 	}
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	mutex_lock(&sfp->f_mutex);
 	rsv_schp = &srp->sgat_h;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= (unsigned int)rsv_schp->buflen) {
@@ -2280,44 +2307,37 @@ sg_vma_fault(struct vm_fault *vmf)
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
 
@@ -2328,40 +2348,44 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
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
+		if (res)
+			goto fini;
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
@@ -2955,7 +2979,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	}
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
-	us_xfer = !(srp->rq_flags & SG_FLAG_NO_DXFER);
+	us_xfer = !(srp->rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
 	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
 	reserved = (sfp->rsv_srp == srp);
 	rq->end_io_data = srp;
@@ -2985,7 +3009,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		} else if (req_schp->buflen == 0) {
 			int up_sz = max_t(int, dxfer_len, sfp->sgat_elem_sz);
 
-			res = sg_mk_sgat(srp, sfp, up_sz);
+			res = sg_mk_sgat(srp, sfp, up_sz, false);
 		}
 		if (unlikely(res))
 			goto fini;
@@ -3093,14 +3117,14 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 }
 
 static int
-sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
+sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen,
+	   bool for_mmap)
 {
-	int j, k, rem_sz, order, align_sz;
+	int j, k, rem_sz, order, align_sz, elem_sz;
 	__maybe_unused int o_order;
 	int m_size = minlen;
 	int rup_sz = 0;
 	int mx_sgat_elems = sfp->parentdp->max_sgat_elems;
-	u32 elem_sz;
 	const size_t struct_page_sz = sizeof(struct page *);
 	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
@@ -3113,14 +3137,14 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 		++m_size;	/* don't remember why */
 	/* round request up to next highest SG_DEF_SECTOR_SZ byte boundary */
 	align_sz = ALIGN(m_size, SG_DEF_SECTOR_SZ);
-
 	schp->pages = kcalloc(mx_sgat_elems, struct_page_sz, mask_kz);
 	SG_LOG(4, sfp, "%s: minlen=%d [sz=%zu, 0x%pK ++]\n", __func__, minlen,
 	       mx_sgat_elems * struct_page_sz, schp->pages);
 	if (unlikely(!schp->pages))
 		return -ENOMEM;
 
-	elem_sz = sfp->sgat_elem_sz;    /* power of 2 and >= PAGE_SIZE */
+	/* elem_sz must be power of 2 and >= PAGE_SIZE */
+	elem_sz = for_mmap ? PAGE_SIZE : sfp->sgat_elem_sz;
 	if (sdp && unlikely(sdp->device->host->unchecked_isa_dma))
 		mask_ap |= GFP_DMA;
 	/* PAGE_SIZE == (1 << PAGE_SHIFT) == (2 ** PAGE_SHIFT) */
@@ -3134,7 +3158,7 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 		schp->pages[k] = alloc_pages(mask_ap, order);
 		if (!schp->pages[k])
 			goto err_out;
-		SG_LOG(5, sfp, "%s: k=%d, rup_sz=%d [0x%pK ++]\n", __func__, k,
+		SG_LOG(6, sfp, "%s: k=%d, rup_sz=%d [0x%pK ++]\n", __func__, k,
 		       rup_sz, schp->pages[k]);
 	}
 	schp->page_order = order;
@@ -3168,7 +3192,7 @@ sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 		return;
 	for (k = 0; k < schp->num_sgat; ++k) {
 		p = schp->pages[k];
-		SG_LOG(5, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
+		SG_LOG(6, sfp, "%s: pg[%d]=0x%pK --\n", __func__, k, p);
 		if (unlikely(!p))
 			continue;
 		__free_pages(p, schp->page_order);
@@ -3299,7 +3323,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 	}
 	return NULL;
 good:
-	SG_LOG(6, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
+	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
 	       pack_id, srp);
 	return srp;
 }
@@ -3338,7 +3362,7 @@ sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 	if (IS_ERR(n_srp))
 		return n_srp;
 	if (db_len > 0) {
-		res = sg_mk_sgat(n_srp, sfp, db_len);
+		res = sg_mk_sgat(n_srp, sfp, db_len, false);
 		if (unlikely(res)) {
 			kfree(n_srp);
 			return ERR_PTR(res);
@@ -3371,7 +3395,7 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 			buflen = PAGE_SIZE;
 			go_out = true;
 		}
-		res = sg_mk_sgat(srp, sfp, buflen);
+		res = sg_mk_sgat(srp, sfp, buflen, false);
 		if (res == 0) {
 			SG_LOG(4, sfp, "%s: final buflen=%d, srp=0x%pK ++\n",
 			       __func__, buflen, srp);
-- 
2.25.1

