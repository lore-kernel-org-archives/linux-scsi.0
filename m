Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB78C55186
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88C2C20738
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgDUVxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:53:36 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43095 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgDUVxc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 17:53:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 44A17204259;
        Tue, 21 Apr 2020 23:53:30 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EZeWMSVTpWrB; Tue, 21 Apr 2020 23:53:27 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id D663C204248;
        Tue, 21 Apr 2020 23:53:23 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v9 18/40] sg: rework scatter gather handling
Date:   Tue, 21 Apr 2020 17:52:36 -0400
Message-Id: <20200421215258.14348-19-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421215258.14348-1-dgilbert@interlog.com>
References: <20200421215258.14348-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename sg_build_indirect() to sg_mk_sgat() and sg_remove_scat()
to sg_remove_sgat(). Re-implement those functions. Add
sg_calc_sgat_param() to calculate various scatter gather
list parameters. Some other minor clean-ups.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 289 ++++++++++++++++++++++++++--------------------
 1 file changed, 162 insertions(+), 127 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b30c41e308a0..b60bbc7add82 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -90,7 +90,6 @@ static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_DEF_SECTOR_SZ 512
 
@@ -145,6 +144,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	atomic_t submitted;	/* number inflight or awaiting read */
 	atomic_t waiting;	/* number of requests awaiting read */
+	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	struct sg_scatter_hold reserve;	/* buffer for this file descriptor */
 	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
@@ -165,6 +165,7 @@ struct sg_device { /* holds the state of each scsi generic device */
 	struct mutex open_rel_lock;     /* held when in open() or release() */
 	struct list_head sfds;
 	rwlock_t sfd_lock;      /* protect access to sfd list */
+	int max_sgat_elems;     /* adapter's max number of elements in sgat */
 	int max_sgat_sz;	/* max number of bytes in sgat list */
 	u32 index;		/* device index number */
 	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
@@ -187,8 +188,8 @@ static void sg_rq_end_io(struct request *rq, blk_status_t status);
 static int sg_proc_init(void);
 static int sg_start_req(struct sg_request *srp, u8 *cmd);
 static void sg_finish_scsi_blk_rq(struct sg_request *srp);
-static int sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
-			     int buff_size);
+static int sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp,
+		      int minlen);
 static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
 			 const char __user *buf, size_t count, bool blocking,
 			 bool read_only, bool sg_io_owned,
@@ -196,7 +197,7 @@ static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
 static int sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
-static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
+static void sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
 static void sg_build_reserve(struct sg_fd *sfp, int req_size);
 static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
 			    int size);
@@ -207,6 +208,7 @@ static struct sg_request *sg_add_request(struct sg_fd *sfp);
 static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
+static void sg_calc_sgat_param(struct sg_device *sdp);
 
 #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
@@ -352,7 +354,6 @@ sg_open(struct inode *inode, struct file *filp)
 	int min_dev = iminor(inode);
 	int op_flags = filp->f_flags;
 	int res;
-	struct request_queue *q;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 
@@ -411,16 +412,12 @@ sg_open(struct inode *inode, struct file *filp)
 	if (o_excl)
 		set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 
-	if (atomic_read(&sdp->open_cnt) < 1) {  /* no existing opens */
-		clear_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm);
-		q = sdp->device->request_queue;
-		sdp->max_sgat_sz = queue_max_segments(q);
-	}
+	if (atomic_read(&sdp->open_cnt) < 1)	/* no existing opens */
+		sg_calc_sgat_param(sdp);
 	sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
 	if (IS_ERR(sfp)) {
 		res = PTR_ERR(sfp);
-		goto out_undo;
-	}
+		goto out_undo; }
 
 	filp->private_data = sfp;
 	atomic_inc(&sdp->open_cnt);
@@ -993,10 +990,43 @@ max_sectors_bytes(struct request_queue *q)
 	unsigned int max_sectors = queue_max_sectors(q);
 
 	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
-
 	return max_sectors << 9;
 }
 
+/*
+ * Calculates sg_device::max_sgat_elems and sg_device::max_sgat_sz. It uses
+ * the device's request queue. If q not available sets max_sgat_elems to 1
+ * and max_sgat_sz to PAGE_SIZE. If potential max_sgat_sz is greater than
+ * 2^30 scales down the implied max_segment_size so the product of the
+ * max_segment_size and max_sgat_elems is less than or equal to 2^30 .
+ */
+static void
+sg_calc_sgat_param(struct sg_device *sdp)
+{
+	int sz;
+	u64 m;
+	struct scsi_device *sdev = sdp->device;
+	struct request_queue *q = sdev ? sdev->request_queue : NULL;
+
+	clear_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm);
+	if (!q) {
+		sdp->max_sgat_elems = 1;
+		sdp->max_sgat_sz = PAGE_SIZE;
+		return;
+	}
+	sdp->max_sgat_elems = queue_max_segments(q);
+	m = (u64)queue_max_segment_size(q) * queue_max_segments(q);
+	if (m < PAGE_SIZE) {
+		sdp->max_sgat_elems = 1;
+		sdp->max_sgat_sz = PAGE_SIZE;
+		return;
+	}
+	sz = (int)min_t(u64, m, 1 << 30);
+	if (sz == (1 << 30))	/* round down so: sz = elems * elem_sz */
+		sz = ((1 << 30) / sdp->max_sgat_elems) * sdp->max_sgat_elems;
+	sdp->max_sgat_sz = sz;
+}
+
 static void
 sg_fill_request_table(struct sg_fd *sfp, struct sg_req_info *rinfo)
 {
@@ -1062,7 +1092,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	}
 	srp->orphan = 1;
 	spin_unlock_irq(&sfp->rq_list_lock);
-	return res;	/* -ERESTARTSYS because signal hit process */
+	return res;
 }
 
 static int
@@ -1073,8 +1103,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 		    sfp->res_in_use) {
 			return -EBUSY;
 		}
-
-		sg_remove_scat(sfp, &sfp->reserve);
+		sg_remove_sgat(sfp, &sfp->reserve);
 		sg_build_reserve(sfp, want_rsv_sz);
 	}
 	return 0;
@@ -1543,8 +1572,18 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 {
 	struct sg_request *srp = container_of(work, struct sg_request,
 					      ew_orph.work);
-	struct sg_fd *sfp = srp->parentfp;
+	struct sg_fd *sfp;
 
+	if (!srp) {
+		WARN_ONCE("%s: srp unexpectedly NULL\n", __func__);
+		return;
+	}
+	sfp = srp->parentfp;
+	if (!sfp) {
+		WARN_ONCE(1, "%s: sfp unexpectedly NULL\n", __func__);
+		return;
+	}
+	SG_LOG(3, sfp, "%s: srp=0x%p\n", __func__, srp);
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
@@ -1676,7 +1715,6 @@ static bool sg_sysfs_valid;
 static struct sg_device *
 sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 {
-	struct request_queue *q = scsidp->request_queue;
 	struct sg_device *sdp;
 	unsigned long iflags;
 	int error;
@@ -1716,7 +1754,7 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	init_waitqueue_head(&sdp->open_wait);
 	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
 	rwlock_init(&sdp->sfd_lock);
-	sdp->max_sgat_sz = queue_max_segments(q);
+	sg_calc_sgat_param(sdp);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 	error = 0;
@@ -1885,24 +1923,25 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
+	if (scatter_elem_sz < (int)PAGE_SIZE)
 		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
+	else if (scatter_elem_sz != (1 << ilog2(scatter_elem_sz)))
+		scatter_elem_sz = 1 << ilog2(scatter_elem_sz);
+	/* scatter_elem_sz rounded down to power of 2, or PAGE_SIZE */
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
 	else
 		def_reserved_size = sg_big_buff;
 
-	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
+	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				    SG_MAX_DEVS, "sg");
 	if (rc)
 		return rc;
         sg_sysfs_class = class_create(THIS_MODULE, "scsi_generic");
         if ( IS_ERR(sg_sysfs_class) ) {
 		rc = PTR_ERR(sg_sysfs_class);
-		goto err_out;
-        }
+		goto err_out_unreg;
+	}
 	sg_sysfs_valid = true;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
@@ -1910,7 +1949,7 @@ init_sg(void)
 		return 0;
 	}
 	class_destroy(sg_sysfs_class);
-err_out:
+err_out_unreg:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	return rc;
 }
@@ -2015,7 +2054,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 			mutex_unlock(&sfp->f_mutex);
 			return res;
 		} else {
-			res = sg_build_indirect(req_schp, sfp, dxfer_len);
+			res = sg_mk_sgat(req_schp, sfp, dxfer_len);
 			if (res) {
 				mutex_unlock(&sfp->f_mutex);
 				return res;
@@ -2102,117 +2141,106 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
 	else
-		sg_remove_scat(sfp, req_schp);
-}
-
-static int
-sg_build_sgat(struct sg_scatter_hold *schp, const struct sg_fd *sfp,
-	      int tablesize)
-{
-	int sg_buflen = tablesize * sizeof(struct page *);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
-
-	schp->pages = kzalloc(sg_buflen, gfp_flags);
-	if (!schp->pages)
-		return -ENOMEM;
-	schp->sglist_len = sg_buflen;
-	return tablesize;	/* number of scat_gath elements allocated */
+		sg_remove_sgat(sfp, req_schp);
 }
 
 static int
-sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
-		  int buff_size)
-{
-	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
-	int max_sgat_sz = sfp->parentdp->max_sgat_sz;
-	int blk_size = buff_size, order;
-	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
+sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
+{
+	int j, k, rem_sz, order, align_sz;
+	__maybe_unused int o_order;
+	int m_size = minlen;
+	int rup_sz = 0;
+	int mx_sgat_elems = sfp->parentdp->max_sgat_elems;
+	u32 elem_sz;
+	const size_t struct_page_sz = sizeof(struct page *);
+	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
+	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
 	struct sg_device *sdp = sfp->parentdp;
 
-	if (blk_size < 0)
+	if (unlikely(m_size < 0))
 		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
+	if (unlikely(m_size == 0))
+		++m_size;	/* don't remember why */
 	/* round request up to next highest SG_DEF_SECTOR_SZ byte boundary */
-	blk_size = ALIGN(blk_size, SG_DEF_SECTOR_SZ);
-	SG_LOG(4, sfp, "%s: buff_size=%d, blk_size=%d\n", __func__, buff_size,
-	       blk_size);
-
-	/* N.B. ret_sz carried into this block ... */
-	mx_sc_elems = sg_build_sgat(schp, sfp, max_sgat_sz);
-	if (mx_sc_elems < 0)
-		return mx_sc_elems;	/* most likely -ENOMEM */
-
-	num = scatter_elem_sz;
-	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
-			scatter_elem_sz = PAGE_SIZE;
-			scatter_elem_sz_prev = PAGE_SIZE;
-		} else
-			scatter_elem_sz_prev = num;
-	}
+	align_sz = ALIGN(m_size, SG_DEF_SECTOR_SZ);
 
-	if (sdp->device->host->unchecked_isa_dma)
-		gfp_mask |= GFP_DMA;
-
-	order = get_order(num);
-retry:
-	ret_sz = 1 << (PAGE_SHIFT + order);
-
-	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
-	     k++, rem_sz -= ret_sz) {
-
-		num = (rem_sz > scatter_elem_sz_prev) ?
-			scatter_elem_sz_prev : rem_sz;
+	schp->pages = kcalloc(mx_sgat_elems, struct_page_sz, mask_kz);
+	SG_LOG(4, sfp, "%s: minlen=%d, align_sz=%d [sz=%zu, 0x%p ++]\n",
+	       __func__, minlen, align_sz, mx_sgat_elems * struct_page_sz,
+	       schp->pages);
+	if (unlikely(!schp->pages))
+		return -ENOMEM;
 
-		schp->pages[k] = alloc_pages(gfp_mask, order);
+	elem_sz = sfp->sgat_elem_sz;    /* power of 2 and >= PAGE_SIZE */
+	if (sdp && unlikely(sdp->device->host->unchecked_isa_dma))
+		mask_ap |= GFP_DMA;
+	/* PAGE_SIZE == (1 << PAGE_SHIFT) == (2 ** PAGE_SHIFT) */
+	order = get_order(elem_sz); /* --> ilog2(1+((elem_sz-1)/PAGE_SIZE)) */
+	o_order = order;
+again:
+	rup_sz = 1 << (PAGE_SHIFT + order);	/* round up size */
+
+	for (k = 0, rem_sz = align_sz; rem_sz > 0 && k < mx_sgat_elems;
+	     ++k, rem_sz -= rup_sz) {
+		schp->pages[k] = alloc_pages(mask_ap, order);
 		if (!schp->pages[k])
-			goto out;
-
-		if (num == scatter_elem_sz_prev) {
-			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
-				scatter_elem_sz = ret_sz;
-				scatter_elem_sz_prev = ret_sz;
-			}
-		}
-		SG_LOG(5, sfp, "%s: k=%d, num=%d, ret_sz=%d\n", __func__, k,
-		       num, ret_sz);
-	}		/* end of for loop */
-
+			goto err_out;
+		SG_LOG(5, sfp, "%s: k=%d, rup_sz=%d [0x%p ++]\n", __func__, k,
+		       rup_sz, schp->pages[k]);
+	}
 	schp->page_order = order;
 	schp->num_sgat = k;
-	SG_LOG(5, sfp, "%s: num_sgat=%d, order=%d\n", __func__, k, order);
-	schp->buflen = blk_size;
-	if (rem_sz > 0)	/* must have failed */
-		return -ENOMEM;
+	SG_LOG(((order != o_order || rem_sz > 0) ? 2 : 5), sfp,
+	       "%s: num_sgat=%d, order=%d,%d\n", __func__, k, o_order, order);
+	if (unlikely(rem_sz > 0)) {	/* hit mx_sgat_elems */
+		order = 0;		/* force exit */
+		goto err_out;
+	}
+	schp->buflen = align_sz;
 	return 0;
-out:
-	for (i = 0; i < k; i++)
-		__free_pages(schp->pages[i], order);
+err_out:
+	for (j = 0; j < k; ++j)
+		__free_pages(schp->pages[j], order);
 
 	if (--order >= 0)
-		goto retry;
-
+		goto again;
+	kfree(schp->pages);
+	schp->pages = NULL;
 	return -ENOMEM;
 }
 
 static void
-sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
+sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 {
-	SG_LOG(4, sfp, "%s: num_sgat=%d\n", __func__, schp->num_sgat);
-	if (schp->pages && schp->sglist_len > 0) {
-		if (!schp->dio_in_use) {
-			int k;
+	int k;
+	void *p;
 
-			for (k = 0; k < schp->num_sgat && schp->pages[k]; k++) {
-				SG_LOG(5, sfp, "%s: pg[%d]=0x%p --\n",
-				       __func__, k, schp->pages[k]);
-				__free_pages(schp->pages[k], schp->page_order);
-			}
-			kfree(schp->pages);
-		}
+	if (!schp->pages)
+		return;
+	for (k = 0; k < schp->num_sgat; ++k) {
+		p = schp->pages[k];
+		SG_LOG(5, sfp, "%s: pg[%d]=0x%p --\n", __func__, k, p);
+		if (unlikely(!p))
+			continue;
+		__free_pages(p, schp->page_order);
 	}
-	memset(schp, 0, sizeof (*schp));
+	SG_LOG(5, sfp, "%s: pg_order=%u, free pgs=0x%p --\n", __func__,
+	       schp->page_order, schp->pages);
+	kfree(schp->pages);
+}
+
+/* Remove the data (possibly a sgat list) held by srp, not srp itself */
+static void
+sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
+{
+	SG_LOG(4, sfp, "%s: num_sgat=%d%s\n", __func__, schp->num_sgat,
+	       ((sfp ? (&sfp->reserve == schp) : false) ?
+		" [rsv]" : ""));
+	if (!schp->dio_in_use)
+		sg_remove_sgat_helper(sfp, schp);
+
+	memset(schp, 0, sizeof(*schp));         /* zeros buflen and dlen */
 }
 
 /*
@@ -2234,12 +2262,12 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 	for (k = 0; k < schp->num_sgat && schp->pages[k]; k++) {
 		if (num > num_xfer) {
 			if (copy_to_user(outp, page_address(schp->pages[k]),
-					   num_xfer))
+					 num_xfer))
 				return -EFAULT;
 			break;
 		} else {
 			if (copy_to_user(outp, page_address(schp->pages[k]),
-					   num))
+					 num))
 				return -EFAULT;
 			num_xfer -= num;
 			if (num_xfer <= 0)
@@ -2259,10 +2287,10 @@ sg_build_reserve(struct sg_fd *sfp, int req_size)
 	do {
 		if (req_size < PAGE_SIZE)
 			req_size = PAGE_SIZE;
-		if (0 == sg_build_indirect(schp, sfp, req_size))
+		if (sg_mk_sgat(schp, sfp, req_size) == 0)
 			return;
 		else
-			sg_remove_scat(sfp, schp);
+			sg_remove_sgat(sfp, schp);
 		req_size >>= 1;	/* divide by 2 */
 	} while (req_size > (PAGE_SIZE / 2));
 }
@@ -2366,8 +2394,8 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 static struct sg_fd *
 sg_add_sfp(struct sg_device *sdp)
 {
+	int rbuf_len;
 	unsigned long iflags;
-	int bufflen;
 	struct sg_fd *sfp;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
@@ -2384,6 +2412,14 @@ sg_add_sfp(struct sg_device *sdp)
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
+	/*
+	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
+	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
+	 * Any user provided number will be changed to be PAGE_SIZE as a
+	 * minimum, otherwise it will be rounded down (if required) to a
+	 * power of 2. So it will always be a power of 2.
+	 */
+	sfp->sgat_elem_sz = scatter_elem_sz;
 	sfp->parentdp = sdp;
 	atomic_set(&sfp->submitted, 0);
 	atomic_set(&sfp->waiting, 0);
@@ -2400,14 +2436,13 @@ sg_add_sfp(struct sg_device *sdp)
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
-	bufflen = min_t(int, sg_big_buff,
-			max_sectors_bytes(sdp->device->request_queue));
-	sg_build_reserve(sfp, bufflen);
-	SG_LOG(3, sfp, "%s: bufflen=%d, num_sgat=%d\n", __func__,
-	       sfp->reserve.buflen, sfp->reserve.num_sgat);
+	rbuf_len = min_t(int, sg_big_buff, sdp->max_sgat_sz);
+	if (rbuf_len > 0)
+		sg_build_reserve(sfp, rbuf_len);
 
 	kref_get(&sdp->d_ref);
 	__module_get(THIS_MODULE);
+	SG_LOG(3, sfp, "%s: success, sfp=0x%p ++\n", __func__, sfp);
 	return sfp;
 }
 
@@ -2438,7 +2473,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	if (sfp->reserve.buflen > 0) {
 		SG_LOG(6, sfp, "%s:    buflen=%d, num_sgat=%d\n", __func__,
 		       (int)sfp->reserve.buflen, (int)sfp->reserve.num_sgat);
-		sg_remove_scat(sfp, &sfp->reserve);
+		sg_remove_sgat(sfp, &sfp->reserve);
 	}
 
 	SG_LOG(6, sfp, "%s: sfp=0x%p\n", __func__, sfp);
-- 
2.26.1

