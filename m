Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A572C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiJXDXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiJXDWi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:22:38 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F7A31AD8E
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 57BE52041CF;
        Mon, 24 Oct 2022 05:21:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Pnp-669-gEZe; Mon, 24 Oct 2022 05:21:10 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 0C05B2041AF;
        Mon, 24 Oct 2022 05:21:08 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH v25 05/44] sg: bitops in sg_device
Date:   Sun, 23 Oct 2022 23:20:19 -0400
Message-Id: <20221024032058.14077-6-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce bitops in sg_device to replace an atomic, a bool and a
char. That char (sgdebug) had been reduced to only two states.
Add some associated macros to make the code a little clearer.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 98 ++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 17e5294fb3e9..6fd70322ade0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -79,6 +79,11 @@ static char *sg_version_date = "20190606";
 
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
+/* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
+#define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
+#define SG_FDEV_DETACHING	1	/* may be unexpected device removal */
+#define SG_FDEV_LOG_SENSE	2	/* set by ioctl(SG_SET_DEBUG) */
+
 static int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /* N.B. This variable is readable and writeable via
    /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
@@ -160,14 +165,12 @@ struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
 	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
 	struct mutex open_rel_lock;     /* held when in open() or release() */
-	int sg_tablesize;	/* adapter's max scatter-gather table size */
-	u32 index;		/* device index number */
 	struct list_head sfds;
 	rwlock_t sfd_lock;      /* protect access to sfd list */
-	atomic_t detaching;     /* 0->device usable, 1->device detaching */
-	bool exclude;		/* 1->open(O_EXCL) succeeded and is active */
+	int sg_tablesize;	/* adapter's max scatter-gather table size */
+	u32 index;		/* device index number */
 	int open_cnt;		/* count of opens (perhaps < num(sfds) ) */
-	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
+	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
 	char name[DISK_NAME_LEN];
 	struct cdev *cdev;
 	struct kref d_ref;
@@ -207,6 +210,9 @@ static void sg_device_destroy(struct kref *kref);
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
 #define SZ_SG_REQ_INFO ((int)sizeof(struct sg_req_info))
 
+#define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
+#define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
+
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
  * 'depth' is a number between 1 (most severe) and 7 (most noisy, most
@@ -275,26 +281,26 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 		while (sdp->open_cnt > 0) {
 			mutex_unlock(&sdp->open_rel_lock);
 			retval = wait_event_interruptible(sdp->open_wait,
-					(atomic_read(&sdp->detaching) ||
+					(SG_IS_DETACHING(sdp) ||
 					 !sdp->open_cnt));
 			mutex_lock(&sdp->open_rel_lock);
 
 			if (retval) /* -ERESTARTSYS */
 				return retval;
-			if (atomic_read(&sdp->detaching))
+			if (SG_IS_DETACHING(sdp))
 				return -ENODEV;
 		}
 	} else {
-		while (sdp->exclude) {
+		while (SG_HAVE_EXCLUDE(sdp)) {
 			mutex_unlock(&sdp->open_rel_lock);
 			retval = wait_event_interruptible(sdp->open_wait,
-					(atomic_read(&sdp->detaching) ||
-					 !sdp->exclude));
+					(SG_IS_DETACHING(sdp) ||
+					 !SG_HAVE_EXCLUDE(sdp)));
 			mutex_lock(&sdp->open_rel_lock);
 
 			if (retval) /* -ERESTARTSYS */
 				return retval;
-			if (atomic_read(&sdp->detaching))
+			if (SG_IS_DETACHING(sdp))
 				return -ENODEV;
 		}
 	}
@@ -356,7 +362,7 @@ sg_open(struct inode *inode, struct file *filp)
 				goto error_mutex_locked;
 			}
 		} else {
-			if (sdp->exclude) {
+			if (SG_HAVE_EXCLUDE(sdp)) {
 				retval = -EBUSY;
 				goto error_mutex_locked;
 			}
@@ -369,10 +375,10 @@ sg_open(struct inode *inode, struct file *filp)
 
 	/* N.B. at this point we are holding the open_rel_lock */
 	if (o_excl)
-		sdp->exclude = true;
+		set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 
 	if (sdp->open_cnt < 1) {  /* no existing opens */
-		sdp->sgdebug = 0;
+		clear_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm);
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
@@ -395,8 +401,8 @@ sg_open(struct inode *inode, struct file *filp)
 	return retval;
 
 out_undo:
-	if (o_excl) {
-		sdp->exclude = false;   /* undo if error */
+	if (o_excl) {		/* undo if error */
+		clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
 		wake_up_interruptible(&sdp->open_wait);
 	}
 error_mutex_locked:
@@ -430,12 +436,10 @@ sg_release(struct inode *inode, struct file *filp)
 
 	/* possibly many open()s waiting on exclude clearing, start many;
 	 * only open(O_EXCL)s wait on 0==open_cnt so only start one */
-	if (sdp->exclude) {
-		sdp->exclude = false;
+	if (test_and_clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm))
 		wake_up_interruptible_all(&sdp->open_wait);
-	} else if (0 == sdp->open_cnt) {
+	else if (sdp->open_cnt == 0)
 		wake_up_interruptible(&sdp->open_wait);
-	}
 	mutex_unlock(&sdp->open_rel_lock);
 	return 0;
 }
@@ -463,7 +467,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	SG_LOG(3, sfp, "%s: write(3rd arg) count=%d\n", __func__, (int)count);
 	if (!sdp)
 		return -ENXIO;
-	if (atomic_read(&sdp->detaching))
+	if (SG_IS_DETACHING(sdp))
 		return -ENODEV;
 	if (!((filp->f_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device)))
@@ -661,7 +665,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 		sg_remove_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if (atomic_read(&sdp->detaching)) {
+	if (SG_IS_DETACHING(sdp)) {
 		if (srp->bio) {
 			blk_mq_free_request(srp->rq);
 			srp->rq = NULL;
@@ -809,7 +813,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 			return -EAGAIN;
 		retval = wait_event_interruptible(sfp->read_wait,
 			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
-			(!busy && atomic_read(&sdp->detaching))));
+			(!busy && SG_IS_DETACHING(sdp))));
 		if (!srp)
 			/* signal or detaching */
 			return retval ? retval : -ENODEV;
@@ -975,7 +979,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	switch (cmd_in) {
 	case SG_IO:
-		if (atomic_read(&sdp->detaching))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
@@ -1024,7 +1028,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		{
 			sg_scsi_id_t v;
 
-			if (atomic_read(&sdp->detaching))
+			if (SG_IS_DETACHING(sdp))
 				return -ENODEV;
 			memset(&v, 0, sizeof(v));
 			v.host_no = sdp->device->host->host_no;
@@ -1144,18 +1148,18 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 			return result;
 		}
 	case SG_EMULATED_HOST:
-		if (atomic_read(&sdp->detaching))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return put_user(sdp->device->host->hostt->emulated, ip);
 	case SCSI_IOCTL_SEND_COMMAND:
-		if (atomic_read(&sdp->detaching))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, filp->f_mode, cmd_in, p);
 	case SG_SET_DEBUG:
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		sdp->sgdebug = (char) val;
+		assign_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm, val);
 		return 0;
 	case BLKSECTGET:
 		return put_user(max_sectors_bytes(sdp->device->request_queue),
@@ -1175,7 +1179,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
 	case SG_SCSI_RESET:
-		if (atomic_read(&sdp->detaching))
+		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
 		break;
 	default:
@@ -1232,7 +1236,7 @@ sg_poll(struct file *filp, poll_table * wait)
 	}
 	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
-	if (sfp->parentdp && atomic_read(&sfp->parentdp->detaching)) {
+	if (sfp->parentdp && SG_IS_DETACHING(sfp->parentdp)) {
 		p_res |= EPOLLHUP;
 	} else if (!sfp->cmd_q) {
 		if (count == 0)
@@ -1380,7 +1384,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		return RQ_END_IO_NONE;
 
 	sdp = sfp->parentdp;
-	if (unlikely(atomic_read(&sdp->detaching)))
+	if (unlikely(SG_IS_DETACHING(sdp)))
 		pr_info("%s: device detaching\n", __func__);
 
 	sense = scmd->sense_buffer;
@@ -1401,9 +1405,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		srp->header.msg_status = COMMAND_COMPLETE;
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
-		if ((sdp->sgdebug > 0) &&
-		    ((CHECK_CONDITION == srp->header.masked_status) ||
-		     (COMMAND_TERMINATED == srp->header.masked_status)))
+		if (test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm) &&
+		    (srp->header.masked_status == CHECK_CONDITION ||
+		     srp->header.masked_status == COMMAND_TERMINATED))
 			__scsi_print_sense(sdp->device, __func__, sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
@@ -1514,7 +1518,7 @@ sg_alloc(struct scsi_device *scsidp)
 	mutex_init(&sdp->open_rel_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
 	init_waitqueue_head(&sdp->open_wait);
-	atomic_set(&sdp->detaching, 0);
+	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
 	rwlock_init(&sdp->sfd_lock);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
@@ -1630,13 +1634,11 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 	struct sg_device *sdp = dev_get_drvdata(cl_dev);
 	unsigned long iflags;
 	struct sg_fd *sfp;
-	int val;
 
 	if (!sdp)
 		return;
-	/* want sdp->detaching non-zero as soon as possible */
-	val = atomic_inc_return(&sdp->detaching);
-	if (val > 1)
+	/* set this flag as soon as possible as it could be a surprise */
+	if (test_and_set_bit(SG_FDEV_DETACHING, sdp->fdev_bm))
 		return; /* only want to do following once per device */
 
 	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, sdp->device,
@@ -2169,7 +2171,7 @@ sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
 	 * removed the last response, which would leave nothing for them to
 	 * return other than -ENODEV.
 	 */
-	if (unlikely(atomic_read(&sfp->parentdp->detaching)))
+	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
 		wake_up_interruptible_all(&sfp->read_wait);
 
 	return res;
@@ -2198,7 +2200,7 @@ sg_add_sfp(struct sg_device *sdp)
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
 	write_lock_irqsave(&sdp->sfd_lock, iflags);
-	if (atomic_read(&sdp->detaching)) {
+	if (SG_IS_DETACHING(sdp)) {
 		write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 		kfree(sfp);
 		return ERR_PTR(-ENODEV);
@@ -2295,8 +2297,8 @@ sg_get_dev(int dev)
 	sdp = sg_lookup_dev(dev);
 	if (!sdp)
 		sdp = ERR_PTR(-ENXIO);
-	else if (atomic_read(&sdp->detaching)) {
-		/* If sdp->detaching, then the refcount may already be 0, in
+	else if (SG_IS_DETACHING(sdp)) {
+		/* If detaching, then the refcount may already be 0, in
 		 * which case it would be a bug to do kref_get().
 		 */
 		sdp = ERR_PTR(-ENODEV);
@@ -2510,8 +2512,7 @@ sg_proc_seq_show_dev(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if ((NULL == sdp) || (NULL == sdp->device) ||
-	    (atomic_read(&sdp->detaching)))
+	if (!sdp || !sdp->device || SG_IS_DETACHING(sdp))
 		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
 	else {
 		scsidp = sdp->device;
@@ -2538,7 +2539,7 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
 	scsidp = sdp ? sdp->device : NULL;
-	if (sdp && scsidp && (!atomic_read(&sdp->detaching)))
+	if (sdp && scsidp && !SG_IS_DETACHING(sdp))
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
@@ -2629,7 +2630,7 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 	read_lock(&sdp->sfd_lock);
 	if (!list_empty(&sdp->sfds)) {
 		seq_printf(s, " >>> device=%s ", sdp->name);
-		if (atomic_read(&sdp->detaching))
+		if (SG_IS_DETACHING(sdp))
 			seq_puts(s, "detaching pending close ");
 		else if (sdp->device) {
 			struct scsi_device *scsidp = sdp->device;
@@ -2641,7 +2642,8 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 				   scsidp->host->hostt->emulated);
 		}
 		seq_printf(s, " sg_tablesize=%d excl=%d open_cnt=%d\n",
-			   sdp->sg_tablesize, sdp->exclude, sdp->open_cnt);
+			   sdp->sg_tablesize, SG_HAVE_EXCLUDE(sdp),
+			   sdp->open_cnt);
 		sg_proc_debug_helper(s, sdp);
 	}
 	read_unlock(&sdp->sfd_lock);
-- 
2.37.3

