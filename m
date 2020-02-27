Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0ECCC35E0E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 16:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC7222469F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 16:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgB0Q7r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 11:59:47 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47247 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729581AbgB0Q7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 11:59:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id EED0320418D;
        Thu, 27 Feb 2020 17:59:44 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id k6tgOT1Q6aSR; Thu, 27 Feb 2020 17:59:42 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 6D51B20418F;
        Thu, 27 Feb 2020 17:59:36 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v7 23/38] sg: xarray for fds in device
Date:   Thu, 27 Feb 2020 11:58:47 -0500
Message-Id: <20200227165902.11861-24-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227165902.11861-1-dgilbert@interlog.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add xarray in each sg_device object holding pointers to
children. The children are sg_fd objects, each associated
with an open file descriptor. The xarray replaces a doubly
linked list and its access lock.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 157 +++++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 92 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20dd3e57d37b..de4b35aabe40 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -42,6 +42,7 @@ static char *sg_version_date = "20190606";
 #include <linux/uio.h>
 #include <linux/cred.h> /* for sg_check_file_access() */
 #include <linux/proc_fs.h>
+#include <linux/xarray.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -52,7 +53,6 @@ static char *sg_version_date = "20190606";
 
 #include "scsi_logging.h"
 
-
 #define SG_ALLOW_DIO_DEF 0
 
 #define SG_MAX_DEVS 32768
@@ -175,13 +175,13 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 };
 
 struct sg_fd {		/* holds the state of a file descriptor */
-	struct list_head sfd_entry;	/* member sg_device::sfds list */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	spinlock_t rq_list_lock;	/* protect access to list in req_arr */
 	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
+	u32 idx;		/* my index within parent's sfp_arr */
 	atomic_t submitted;	/* number inflight or awaiting read */
 	atomic_t waiting;	/* number of requests awaiting read */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
@@ -204,7 +204,6 @@ struct sg_device { /* holds the state of each scsi generic device */
 	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
 	struct mutex open_rel_lock;     /* held when in open() or release() */
 	struct list_head sfds;
-	rwlock_t sfd_lock;      /* protect access to sfd list */
 	int max_sgat_elems;     /* adapter's max number of elements in sgat */
 	int max_sgat_sz;	/* max number of bytes in sgat list */
 	u32 index;		/* device index number */
@@ -212,6 +211,7 @@ struct sg_device { /* holds the state of each scsi generic device */
 	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
+	struct xarray sfp_arr;
 	struct kref d_ref;
 };
 
@@ -249,12 +249,7 @@ static struct sg_request *sg_add_request(struct sg_fd *sfp);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
-static void sg_calc_sgat_param(struct sg_device *sdp);
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
-static void sg_rep_rq_state_fail(struct sg_fd *sfp,
-				 enum sg_rq_state exp_old_st,
-				 enum sg_rq_state want_st,
-				 enum sg_rq_state act_old_st);
 
 #define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
@@ -263,7 +258,6 @@ static void sg_rep_rq_state_fail(struct sg_fd *sfp,
 #define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
 #define SG_RS_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RS_INACTIVE)
-#define SG_RS_AWAIT_READ(srp) (atomic_read(&(srp)->rq_st) == SG_RS_AWAIT_RCV)
 
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
@@ -402,6 +396,7 @@ sg_open(struct inode *inode, struct file *filp)
 	int min_dev = iminor(inode);
 	int op_flags = filp->f_flags;
 	int res;
+	__maybe_unused int o_count;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 
@@ -451,20 +446,18 @@ sg_open(struct inode *inode, struct file *filp)
 	if (o_excl)
 		set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 
-	if (atomic_read(&sdp->open_cnt) < 1)	/* no existing opens */
-		sg_calc_sgat_param(sdp);
+	o_count = atomic_inc_return(&sdp->open_cnt);
 	sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
 	if (IS_ERR(sfp)) {
+		atomic_dec(&sdp->open_cnt);
 		res = PTR_ERR(sfp);
 		goto out_undo;
 	}
 
 	filp->private_data = sfp;
-	atomic_inc(&sdp->open_cnt);
 	mutex_unlock(&sdp->open_rel_lock);
-	SG_LOG(3, sfp, "%s: minor=%d, op_flags=0x%x; %s count prior=%d%s\n",
-	       __func__, min_dev, op_flags, "device open",
-	       atomic_read(&sdp->open_cnt),
+	SG_LOG(3, sfp, "%s: minor=%d, op_flags=0x%x; %s count after=%d%s\n",
+	       __func__, min_dev, op_flags, "device open", o_count,
 	       ((op_flags & O_NONBLOCK) ? " O_NONBLOCK" : ""));
 
 	res = 0;
@@ -492,26 +485,30 @@ sg_open(struct inode *inode, struct file *filp)
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
+	int o_count;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 
 	sfp = filp->private_data;
-	sdp = sfp->parentdp;
-	SG_LOG(3, sfp, "%s: device open count prior=%d\n", __func__,
-	       atomic_read(&sdp->open_cnt));
-	if (!sdp)
+	sdp = sfp ? sfp->parentdp : NULL;
+	if (unlikely(!sdp))
 		return -ENXIO;
 
 	mutex_lock(&sdp->open_rel_lock);
+	o_count = atomic_read(&sdp->open_cnt);
+	SG_LOG(3, sfp, "%s: open count before=%d\n", __func__, o_count);
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
-	atomic_dec(&sdp->open_cnt);
 
+	/*
+	 * Possibly many open()s waiting on exlude clearing, start many;
+	 * only open(O_EXCL)'s wait when open_cnt<2 and only start one.
+	 */
 	/* possibly many open()s waiting on exlude clearing, start many;
 	 * only open(O_EXCL)s wait on 0==open_cnt so only start one */
 	if (test_and_clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm))
 		wake_up_interruptible_all(&sdp->open_wait);
-	else if (atomic_read(&sdp->open_cnt) == 0)
+	else if (o_count < 2)
 		wake_up_interruptible(&sdp->open_wait);
 	mutex_unlock(&sdp->open_rel_lock);
 	return 0;
@@ -791,21 +788,6 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	return 0;
 }
 
-static inline int
-sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
-	      enum sg_rq_state new_st)
-{
-	enum sg_rq_state act_old_st = (enum sg_rq_state)
-				atomic_cmpxchg(&srp->rq_st, old_st, new_st);
-
-	if (act_old_st == old_st)
-		return 0;	/* implies new_st --> srp->rq_st */
-	else if (IS_ENABLED(CONFIG_SCSI_LOGGING))
-		sg_rep_rq_state_fail(srp->parentfp, old_st, new_st,
-				     act_old_st);
-	return -EPROTOTYPE;
-}
-
 /*
  * This function is called by wait_event_interruptible in sg_read() and
  * sg_ctl_ioreceive(). wait_event_interruptible will return if this one
@@ -866,32 +848,6 @@ sg_rec_state_v3(struct sg_fd *sfp, struct sg_request *srp)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_SCSI_LOGGING)
-static void
-sg_rep_rq_state_fail(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
-		     enum sg_rq_state want_st, enum sg_rq_state act_old_st)
-{
-	const char *eors = "expected old rq_st: ";
-	const char *aors = "actual old rq_st: ";
-
-	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
-		SG_LOG(1, sfp, "%s: %s%s, %s%s, wanted rq_st: %s\n", __func__,
-		       eors, sg_rq_st_str(exp_old_st, false),
-		       aors, sg_rq_st_str(act_old_st, false),
-		       sg_rq_st_str(want_st, false));
-	else
-		pr_info("sg: %s: %s%d, %s%d, wanted rq_st: %d\n", __func__,
-			eors, (int)exp_old_st, aors, (int)act_old_st,
-			(int)want_st);
-}
-#else
-static void
-sg_rep_rq_state_fail(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
-		     enum sg_rq_state want_st, enum sg_rq_state act_old_st)
-{
-}
-#endif
-
 static ssize_t
 sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, size_t count,
 	      void __user *p)
@@ -1495,6 +1451,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		if (result)
 			return result;
 		assign_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm, val);
+		if (val == 0)	/* user can force recalculation */
+			sg_calc_sgat_param(sdp);
 		return 0;
 	case BLKSECTGET:
 		SG_LOG(3, sfp, "%s:    BLKSECTGET\n", __func__);
@@ -1922,11 +1880,9 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->disk = disk;
 	sdp->device = scsidp;
 	mutex_init(&sdp->open_rel_lock);
-	INIT_LIST_HEAD(&sdp->sfds);
+	xa_init_flags(&sdp->sfp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	init_waitqueue_head(&sdp->open_wait);
 	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
-	rwlock_init(&sdp->sfd_lock);
-	sg_calc_sgat_param(sdp);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 	error = 0;
@@ -1999,6 +1955,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	} else
 		pr_warn("%s: sg_sys Invalid\n", __func__);
 
+	sg_calc_sgat_param(sdp);
 	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
 		    "type %d\n", sdp->index, scsidp->type);
 
@@ -2030,6 +1987,7 @@ sg_device_destroy(struct kref *kref)
 	 * any other cleanup.
 	 */
 
+	xa_destroy(&sdp->sfp_arr);
 	write_lock_irqsave(&sg_index_lock, flags);
 	idr_remove(&sg_index_idr, sdp->index);
 	write_unlock_irqrestore(&sg_index_lock, flags);
@@ -2046,7 +2004,7 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	struct sg_device *sdp = dev_get_drvdata(cl_dev);
-	unsigned long iflags;
+	unsigned long idx;
 	struct sg_fd *sfp;
 
 	if (!sdp)
@@ -2058,13 +2016,13 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, sdp->device,
 					"%s: 0x%pK\n", __func__, sdp));
 
-	read_lock_irqsave(&sdp->sfd_lock, iflags);
-	list_for_each_entry(sfp, &sdp->sfds, sfd_entry) {
+	xa_for_each(&sdp->sfp_arr, idx, sfp) {
+		if (!sfp)
+			continue;
 		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
 	wake_up_interruptible_all(&sdp->open_wait);
-	read_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
@@ -2605,9 +2563,11 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 static struct sg_fd *
 sg_add_sfp(struct sg_device *sdp)
 {
-	int rbuf_len;
+	int rbuf_len, res;
+	u32 idx;
 	unsigned long iflags;
 	struct sg_fd *sfp;
+	struct xa_limit xal;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
@@ -2635,14 +2595,10 @@ sg_add_sfp(struct sg_device *sdp)
 	atomic_set(&sfp->submitted, 0);
 	atomic_set(&sfp->waiting, 0);
 
-	write_lock_irqsave(&sdp->sfd_lock, iflags);
 	if (SG_IS_DETACHING(sdp)) {
-		write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 		kfree(sfp);
 		return ERR_PTR(-ENODEV);
 	}
-	list_add_tail(&sfp->sfd_entry, &sdp->sfds);
-	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SG_LOG(3, sfp, "%s: sfp=0x%pK\n", __func__, sfp);
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2651,6 +2607,20 @@ sg_add_sfp(struct sg_device *sdp)
 	if (rbuf_len > 0)
 		sg_build_reserve(sfp, rbuf_len);
 
+	xa_lock_irqsave(&sdp->sfp_arr, iflags);
+	xal.min = 0;
+	xal.max = atomic_read(&sdp->open_cnt);
+	res = __xa_alloc(&sdp->sfp_arr, &idx, sfp, xal, GFP_KERNEL);
+	xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+	if (res < 0) {
+		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n",
+			__func__, xal.max, -res);
+		if (rbuf_len > 0)
+			sg_remove_sgat(sfp, &sfp->reserve);
+		kfree(sfp);
+		return ERR_PTR(res);
+	}
+	sfp->idx = idx;
 	kref_get(&sdp->d_ref);
 	__module_get(THIS_MODULE);
 	SG_LOG(3, sfp, "%s: success, sfp=0x%pK ++\n", __func__, sfp);
@@ -2669,9 +2639,11 @@ sg_add_sfp(struct sg_device *sdp)
 static void
 sg_remove_sfp_usercontext(struct work_struct *work)
 {
+	__maybe_unused int o_count;
 	unsigned long iflags;
-	struct sg_fd *sfp = container_of(work, struct sg_fd, ew_fd.work);
 	struct sg_device *sdp;
+	struct sg_fd *sfp = container_of(work, struct sg_fd, ew_fd.work);
+	struct sg_fd *e_sfp;
 	struct sg_request *srp;
 
 	if (!sfp) {
@@ -2696,7 +2668,15 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 		sg_remove_sgat(sfp, &sfp->reserve);
 	}
 
-	SG_LOG(6, sfp, "%s: sfp=0x%pK\n", __func__, sfp);
+	xa_lock_irqsave(&sdp->sfp_arr, iflags);
+	e_sfp = __xa_erase(&sdp->sfp_arr, sfp->idx);
+	xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+	if (unlikely(sfp != e_sfp))
+		SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
+		       __func__);
+	o_count = atomic_dec_return(&sdp->open_cnt);
+	SG_LOG(3, sfp, "%s: dev o_count after=%d: sfp=0x%pK --\n", __func__,
+	       o_count, sfp);
 	kfree(sfp);
 
 	if (sdp) {
@@ -2709,13 +2689,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 static void
 sg_remove_sfp(struct kref *kref)
 {
-	unsigned long iflags;
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
-	struct sg_device *sdp = sfp->parentdp;
-
-	write_lock_irqsave(&sdp->sfd_lock, iflags);
-	list_del(&sfp->sfd_entry);
-	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	INIT_WORK(&sfp->ew_fd.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew_fd.work);
@@ -3030,6 +3004,7 @@ static void
 sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 {
 	int k, new_interface, blen, usg;
+	unsigned long idx;
 	struct sg_request *srp;
 	struct sg_fd *fp;
 	const struct sg_io_hdr *hp;
@@ -3037,15 +3012,15 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 	unsigned int ms;
 
 	k = 0;
-	list_for_each_entry(fp, &sdp->sfds, sfd_entry) {
+	xa_for_each(&sdp->sfp_arr, idx, fp) {
+		if (!fp)
+			continue;
 		k++;
 		spin_lock(&fp->rq_list_lock); /* irqs already disabled */
-		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d "
-			   "(res)sgat=%d low_dma=%d\n", k,
-			   jiffies_to_msecs(fp->timeout),
-			   fp->reserve.buflen,
-			   (int)fp->reserve.num_sgat,
-			   (int) sdp->device->host->unchecked_isa_dma);
+		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d (res)sgat=%d low_dma=%d idx=%lu\n",
+			   k, jiffies_to_msecs(fp->timeout),
+			   fp->reserve.buflen, (int)fp->reserve.num_sgat,
+			   (int)sdp->device->host->unchecked_isa_dma, idx);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
@@ -3109,8 +3084,7 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	if (NULL == sdp)
 		goto skip;
-	read_lock(&sdp->sfd_lock);
-	if (!list_empty(&sdp->sfds)) {
+	if (!xa_empty(&sdp->sfp_arr)) {
 		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
 		if (SG_IS_DETACHING(sdp))
 			seq_puts(s, "detaching pending close ");
@@ -3128,7 +3102,6 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 			   atomic_read(&sdp->open_cnt));
 		sg_proc_debug_helper(s, sdp);
 	}
-	read_unlock(&sdp->sfd_lock);
 skip:
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
-- 
2.25.1

