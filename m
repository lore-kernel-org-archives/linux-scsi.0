Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCD0C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJXD0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiJXDXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:00 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68CDA5F7F7
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A99FA2041DC;
        Mon, 24 Oct 2022 05:21:27 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cxWT8vgRfM7P; Mon, 24 Oct 2022 05:21:27 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 30FAB2041AF;
        Mon, 24 Oct 2022 05:21:26 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v25 17/44] sg: rework scatter gather handling
Date:   Sun, 23 Oct 2022 23:20:31 -0400
Message-Id: <20221024032058.14077-18-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename sg_build_indirect() to sg_mk_sgat() and sg_remove_scat()
to sg_remove_sgat(). Re-implement those functions. Add
sg_calc_sgat_param() to calculate various scatter gather
list parameters. Some other minor clean-ups.

Earlier versions of this patch made the order and o_order
variables in sg_mk_sgat() unsigned int but that breaks
'if (--order >= 0)' as pointed out by test robot. Make
those variable signed again.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 290 +++++++++++++++++++++++++---------------------
 1 file changed, 160 insertions(+), 130 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 16bafe358186..68950cdae163 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -95,7 +95,6 @@ static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_DEF_SECTOR_SZ 512
 
@@ -150,6 +149,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	atomic_t submitted;	/* number inflight or awaiting read */
 	atomic_t waiting;	/* number of requests awaiting read */
+	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	struct sg_scatter_hold reserve;	/* buffer for this file descriptor */
 	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
@@ -170,6 +170,7 @@ struct sg_device { /* holds the state of each scsi generic device */
 	struct mutex open_rel_lock;     /* held when in open() or release() */
 	struct list_head sfds;
 	rwlock_t sfd_lock;      /* protect access to sfd list */
+	int max_sgat_elems;     /* adapter's max number of elements in sgat */
 	int max_sgat_sz;	/* max number of bytes in sgat list */
 	u32 index;		/* device index number */
 	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
@@ -192,8 +193,8 @@ static enum rq_end_io_ret sg_rq_end_io(struct request *rq, blk_status_t status);
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
@@ -201,7 +202,7 @@ static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
 static int sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
-static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
+static void sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
 static void sg_build_reserve(struct sg_fd *sfp, int req_size);
 static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
 			    int size);
@@ -214,6 +215,7 @@ static struct sg_request *sg_setup_req(struct sg_fd *sfp);
 static int sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
+static void sg_calc_sgat_param(struct sg_device *sdp);
 
 #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
@@ -354,7 +356,6 @@ sg_open(struct inode *inode, struct file *filp)
 	int min_dev = iminor(inode);
 	int op_flags = filp->f_flags;
 	int res;
-	struct request_queue *q;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 
@@ -413,16 +414,12 @@ sg_open(struct inode *inode, struct file *filp)
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
@@ -970,10 +967,43 @@ max_sectors_bytes(struct request_queue *q)
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
@@ -1037,7 +1067,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	}
 	srp->orphan = 1;
 	spin_unlock_irq(&sfp->rq_list_lock);
-	return res;	/* -ERESTARTSYS because signal hit process */
+	return res;
 }
 
 static int
@@ -1048,8 +1078,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 		    sfp->res_in_use) {
 			return -EBUSY;
 		}
-
-		sg_remove_scat(sfp, &sfp->reserve);
+		sg_remove_sgat(sfp, &sfp->reserve);
 		sg_build_reserve(sfp, want_rsv_sz);
 	}
 	return 0;
@@ -1493,8 +1522,18 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 {
 	struct sg_request *srp = container_of(work, struct sg_request,
 					      ew_orph.work);
-	struct sg_fd *sfp = srp->parentfp;
+	struct sg_fd *sfp;
 
+	if (!srp) {
+		WARN_ONCE(1, "%s: srp unexpectedly NULL\n", __func__);
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
@@ -1624,7 +1663,6 @@ static bool sg_sysfs_valid;
 static struct sg_device *
 sg_add_device_helper(struct scsi_device *scsidp)
 {
-	struct request_queue *q = scsidp->request_queue;
 	struct sg_device *sdp;
 	unsigned long iflags;
 	int error;
@@ -1662,7 +1700,7 @@ sg_add_device_helper(struct scsi_device *scsidp)
 	init_waitqueue_head(&sdp->open_wait);
 	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
 	rwlock_init(&sdp->sfd_lock);
-	sdp->max_sgat_sz = queue_max_segments(q);
+	sg_calc_sgat_param(sdp);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 	error = 0;
@@ -1854,24 +1892,24 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
+	if (scatter_elem_sz < (int)PAGE_SIZE)
 		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
+	else if (!is_power_of_2(scatter_elem_sz))
+		scatter_elem_sz = roundup_pow_of_two(scatter_elem_sz);
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
@@ -1880,7 +1918,7 @@ init_sg(void)
 	}
 	class_destroy(sg_sysfs_class);
 	register_sg_sysctls();
-err_out:
+err_out_unreg:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	return rc;
 }
@@ -1971,7 +2009,7 @@ sg_start_req(struct sg_request *srp, unsigned char *cmd)
 			mutex_unlock(&sfp->f_mutex);
 			return res;
 		} else {
-			res = sg_build_indirect(req_schp, sfp, dxfer_len);
+			res = sg_mk_sgat(req_schp, sfp, dxfer_len);
 			if (res) {
 				mutex_unlock(&sfp->f_mutex);
 				return res;
@@ -2031,113 +2069,100 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
 	else
-		sg_remove_scat(sfp, req_schp);
+		sg_remove_sgat(sfp, req_schp);
 }
 
 static int
-sg_build_sgat(struct sg_scatter_hold *schp, const struct sg_fd *sfp,
-	      int tablesize)
+sg_mk_sgat(struct sg_scatter_hold *schp, struct sg_fd *sfp, int minlen)
 {
-	int sg_buflen = tablesize * sizeof(struct page *);
-	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
-
-	schp->pages = kzalloc(sg_buflen, gfp_flags);
-	if (!schp->pages)
-		return -ENOMEM;
-	schp->sglist_len = sg_buflen;
-	return tablesize;	/* number of scat_gath elements allocated */
-}
+	int j, k, rem_sz, align_sz, order, o_order;
+	int mx_sgat_elems = sfp->parentdp->max_sgat_elems;
+	unsigned int elem_sz;
+	const size_t ptr_sz = sizeof(struct page *);
+	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
+	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
 
-static int
-sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
-		  int buff_size)
-{
-	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
-	int max_sgat_sz = sfp->parentdp->max_sgat_sz;
-	int blk_size = buff_size, order;
-	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
-
-	if (blk_size < 0)
-		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
-	/* round request up to next highest SG_DEF_SECTOR_SZ byte boundary */
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
+	if (unlikely(minlen <= 0)) {
+		if (minlen < 0)
+			return -EFAULT;
+		++minlen;	/* don't remember why */
 	}
+	/* round request up to next highest SG_DEF_SECTOR_SZ byte boundary */
+	align_sz = ALIGN(minlen, SG_DEF_SECTOR_SZ);
 
-	order = get_order(num);
-retry:
-	ret_sz = 1 << (PAGE_SHIFT + order);
-
-	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
-	     k++, rem_sz -= ret_sz) {
-
-		num = (rem_sz > scatter_elem_sz_prev) ?
-			scatter_elem_sz_prev : rem_sz;
-
-		schp->pages[k] = alloc_pages(gfp_mask, order);
+	schp->pages = kcalloc(mx_sgat_elems, ptr_sz, mask_kz);
+	SG_LOG(4, sfp, "%s: minlen=%d, align_sz=%d [sz=%zu, 0x%p ++]\n",
+	       __func__, minlen, align_sz, mx_sgat_elems * ptr_sz,
+	       schp->pages);
+	if (unlikely(!schp->pages))
+		return -ENOMEM;
+	elem_sz = sfp->sgat_elem_sz;	/* power of 2 and >= PAGE_SIZE */
+	o_order = get_order(elem_sz);
+	order = o_order;
+
+again:
+	for (k = 0, rem_sz = align_sz; rem_sz > 0 && k < mx_sgat_elems;
+	     ++k, rem_sz -= elem_sz) {
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
+		SG_LOG(5, sfp, "%s: k=%d, order=%d [0x%p ++]\n", __func__, k,
+		       order, schp->pages[k]);
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
-
-	if (--order >= 0)
-		goto retry;
+err_out:
+	for (j = 0; j < k; ++j)
+		__free_pages(schp->pages[j], order);
 
+	if (--order >= 0) {
+		elem_sz >>= 1;
+		goto again;
+	}
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
+	memset(schp, 0, sizeof(*schp));		/* zeros buflen and dlen */
 }
 
 /*
@@ -2159,12 +2184,12 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
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
@@ -2184,10 +2209,10 @@ sg_build_reserve(struct sg_fd *sfp, int req_size)
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
@@ -2329,8 +2354,8 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 static struct sg_fd *
 sg_add_sfp(struct sg_device *sdp)
 {
+	int rbuf_len;
 	unsigned long iflags;
-	int bufflen;
 	struct sg_fd *sfp;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
@@ -2347,6 +2372,14 @@ sg_add_sfp(struct sg_device *sdp)
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
@@ -2363,14 +2396,13 @@ sg_add_sfp(struct sg_device *sdp)
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
 
@@ -2401,16 +2433,14 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	if (sfp->reserve.buflen > 0) {
 		SG_LOG(6, sfp, "%s:    buflen=%d, num_sgat=%d\n", __func__,
 		       (int)sfp->reserve.buflen, (int)sfp->reserve.num_sgat);
-		sg_remove_scat(sfp, &sfp->reserve);
+		sg_remove_sgat(sfp, &sfp->reserve);
 	}
 
 	SG_LOG(6, sfp, "%s: sfp=0x%p\n", __func__, sfp);
 	kfree(sfp);
 
-	if (sdp) {
-		scsi_device_put(sdp->device);
-		kref_put(&sdp->d_ref, sg_device_destroy);
-	}
+	scsi_device_put(sdp->device);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	module_put(THIS_MODULE);
 }
 
-- 
2.37.3

