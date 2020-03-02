Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB78C3F2D4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825F422B48
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCBDdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:33:17 -0500
Received: from smtp.infotech.no ([82.134.31.41]:60565 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgCBDdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Mar 2020 22:33:16 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0DDC4204258;
        Mon,  2 Mar 2020 04:33:13 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6wpPW7WjmsN4; Mon,  2 Mar 2020 04:33:09 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 93AF420426C;
        Mon,  2 Mar 2020 04:33:04 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v8 10/38] sg: improve naming
Date:   Sun,  1 Mar 2020 22:32:21 -0500
Message-Id: <20200302033249.4515-11-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302033249.4515-1-dgilbert@interlog.com>
References: <20200302033249.4515-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove use of typedef sg_io_hdr_t and replace with struct
sg_io_hdr. Change some names on driver wide structure fields
and comment them. Rename sg_alloc() to sg_add_device_helper()
to reflect its current role.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 240 ++++++++++++++++++++++++----------------------
 1 file changed, 127 insertions(+), 113 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 246c630d3523..eb3b333ea30b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -92,7 +92,7 @@ static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 static int scatter_elem_sz = SG_SCATTER_SZ;
 static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
-#define SG_SECTOR_SZ 512
+#define SG_DEF_SECTOR_SZ 512
 
 static int sg_add_device(struct device *, struct class_interface *);
 static void sg_remove_device(struct device *, struct class_interface *);
@@ -105,12 +105,13 @@ static struct class_interface sg_interface = {
 	.remove_dev     = sg_remove_device,
 };
 
-struct sg_scatter_hold { /* holding area for scsi scatter gather info */
-	u16 k_use_sg; /* Count of kernel scatter-gather pieces */
+struct sg_scatter_hold {     /* holding area for scsi scatter gather info */
+	struct page **pages;	/* num_sgat element array of struct page* */
+	int buflen;		/* capacity in bytes (dlen<=buflen) */
+	int dlen;		/* current valid data length of this req */
+	u16 page_order;		/* byte_len = (page_size*(2**page_order)) */
+	u16 num_sgat;		/* actual number of scatter-gather segments */
 	unsigned int sglist_len; /* size of malloc'd scatter-gather list ++ */
-	unsigned int bufflen;	/* Size of (aggregate) data buffer */
-	struct page **pages;
-	int page_order;
 	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
 	u8 cmd_opcode;		/* first byte of command */
 };
@@ -122,20 +123,20 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	struct list_head entry;	/* list entry */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
 	struct sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
-	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
+	struct sg_io_hdr header;  /* scsi command+info, see <scsi/sg.h> */
 	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	/* done protected by rq_list_lock */
 	char done;		/* 0->before bh, 1->before read, 2->read */
-	struct request *rq;
-	struct bio *bio;
-	struct execute_work ew;
+	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
+	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
+	struct execute_work ew_orph;	/* harvest orphan request */
 };
 
 struct sg_fd {		/* holds the state of a file descriptor */
-	struct list_head sfd_siblings;  /* protected by device's sfd_lock */
+	struct list_head sfd_entry;	/* member sg_device::sfds list */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -155,7 +156,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
 	char res_in_use;	/* 1 -> 'reserve' array in use */
 	struct kref f_ref;
-	struct execute_work ew;
+	struct execute_work ew_fd;  /* harvest all fd resources and lists */
 };
 
 struct sg_device { /* holds the state of each scsi generic device */
@@ -164,7 +165,7 @@ struct sg_device { /* holds the state of each scsi generic device */
 	struct mutex open_rel_lock;     /* held when in open() or release() */
 	struct list_head sfds;
 	rwlock_t sfd_lock;      /* protect access to sfd list */
-	int max_sgat_elems;	/* adapter's max sgat number of elements */
+	int max_sgat_sz;	/* max number of bytes in sgat list */
 	u32 index;		/* device index number */
 	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
 	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
@@ -407,7 +408,7 @@ sg_open(struct inode *inode, struct file *filp)
 	if (atomic_read(&sdp->open_cnt) < 1) {  /* no existing opens */
 		clear_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm);
 		q = sdp->device->request_queue;
-		sdp->max_sgat_elems = queue_max_segments(q);
+		sdp->max_sgat_sz = queue_max_segments(q);
 	}
 	sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
 	if (IS_ERR(sfp)) {
@@ -474,16 +475,18 @@ sg_release(struct inode *inode, struct file *filp)
 }
 
 static ssize_t
-sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
+sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 {
 	bool blocking = !(filp->f_flags & O_NONBLOCK);
-	u8 opcode;
 	int mxsize, cmd_size, input_size, res;
+	u8 opcode;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
-	struct sg_header old_hdr;
-	sg_io_hdr_t *hp;
+	struct sg_header ov2hdr;
+	struct sg_io_hdr v3hdr;
+	struct sg_header *ohp = &ov2hdr;
+	struct sg_io_hdr *h3p = &v3hdr;
 	u8 cmnd[SG_MAX_CDB_SIZE];
 
 	res = sg_check_file_access(filp, __func__);
@@ -493,22 +496,33 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	sfp = filp->private_data;
 	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: write(3rd arg) count=%d\n", __func__, (int)count);
-	res = sg_allow_if_err_recovery(sdp, !blocking);
+	res = sg_allow_if_err_recovery(sdp, !!(filp->f_flags & O_NONBLOCK));
 	if (res)
 		return res;
 
 	if (count < SZ_SG_HEADER)
 		return -EIO;
-	if (copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
+	if (copy_from_user(ohp, p, SZ_SG_HEADER))
 		return -EFAULT;
-	if (old_hdr.reply_len < 0)
-		return sg_submit(sfp, filp, buf, count, blocking, false, false,
+	if (ohp->reply_len < 0) {	/* assume this is v3 */
+		struct sg_io_hdr *reinter_2p = (struct sg_io_hdr *)ohp;
+
+		if (count < SZ_SG_IO_HDR)
+			return -EIO;
+		if (reinter_2p->interface_id != 'S') {
+			pr_info_once("sg: %s: v3 interface only here\n",
+				     __func__);
+			return -EPERM;
+		}
+		return sg_submit(sfp, filp, p, count,
+				 !(filp->f_flags & O_NONBLOCK), false, false,
 				 NULL);
+	}
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
-	buf += SZ_SG_HEADER;
-	if (get_user(opcode, buf))
+	p += SZ_SG_HEADER;
+	if (get_user(opcode, p))
 		return -EFAULT;
 
 	if (!(srp = sg_add_request(sfp))) {
@@ -520,56 +534,57 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		cmd_size = sfp->next_cmd_len;
 		sfp->next_cmd_len = 0;	/* reset so only this write() effected */
 	} else {
-		cmd_size = COMMAND_SIZE(opcode);	/* based on SCSI command group */
-		if ((opcode >= 0xc0) && old_hdr.twelve_byte)
+		cmd_size = COMMAND_SIZE(opcode);  /* old: SCSI command group */
+		if (opcode >= 0xc0 && ohp->twelve_byte)
 			cmd_size = 12;
 	}
 	mutex_unlock(&sfp->f_mutex);
 	SG_LOG(4, sfp, "%s:   scsi opcode=0x%02x, cmd_size=%d\n", __func__,
 	       (unsigned int)opcode, cmd_size);
 	input_size = count - cmd_size;
-	mxsize = (input_size > old_hdr.reply_len) ? input_size : old_hdr.reply_len;
+	mxsize = max_t(int, input_size, ohp->reply_len);
 	mxsize -= SZ_SG_HEADER;
 	input_size -= SZ_SG_HEADER;
 	if (input_size < 0) {
 		sg_remove_request(sfp, srp);
 		return -EIO;	/* User did not pass enough bytes for this command. */
 	}
-	hp = &srp->header;
-	hp->interface_id = '\0';	/* indicator of old interface tunnelled */
-	hp->cmd_len = (u8)cmd_size;
-	hp->iovec_count = 0;
-	hp->mx_sb_len = 0;
+	h3p = &srp->header;
+	h3p->interface_id = '\0';  /* indicator of old interface tunnelled */
+	h3p->cmd_len = (u8)cmd_size;
+	h3p->iovec_count = 0;
+	h3p->mx_sb_len = 0;
 	if (input_size > 0)
-		hp->dxfer_direction = (old_hdr.reply_len > SZ_SG_HEADER) ?
+		h3p->dxfer_direction = (ohp->reply_len > SZ_SG_HEADER) ?
 		    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
 	else
-		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
-	hp->dxfer_len = mxsize;
-	if ((hp->dxfer_direction == SG_DXFER_TO_DEV) ||
-	    (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV))
-		hp->dxferp = (char __user *)buf + cmd_size;
+		h3p->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV :
+						      SG_DXFER_NONE;
+	h3p->dxfer_len = mxsize;
+	if (h3p->dxfer_direction == SG_DXFER_TO_DEV ||
+	    h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV)
+		h3p->dxferp = (char __user *)p + cmd_size;
 	else
-		hp->dxferp = NULL;
-	hp->sbp = NULL;
-	hp->timeout = old_hdr.reply_len;	/* structure abuse ... */
-	hp->flags = input_size;	/* structure abuse ... */
-	hp->pack_id = old_hdr.pack_id;
-	hp->usr_ptr = NULL;
-	if (copy_from_user(cmnd, buf, cmd_size))
+		h3p->dxferp = NULL;
+	h3p->sbp = NULL;
+	h3p->timeout = ohp->reply_len;	/* structure abuse ... */
+	h3p->flags = input_size;	/* structure abuse ... */
+	h3p->pack_id = ohp->pack_id;
+	h3p->usr_ptr = NULL;
+	if (copy_from_user(cmnd, p, cmd_size))
 		return -EFAULT;
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
 	 * is a non-zero input_size, so emit a warning.
 	 */
-	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
+	if (h3p->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
 		printk_ratelimited(KERN_WARNING
 				   "sg_write: data in/out %d/%d bytes "
 				   "for SCSI command 0x%x-- guessing "
 				   "data in;\n   program %s not setting "
 				   "count and/or reply_len properly\n",
-				   old_hdr.reply_len - (int)SZ_SG_HEADER,
+				   ohp->reply_len - (int)SZ_SG_HEADER,
 				   input_size, (unsigned int) cmnd[0],
 				   current->comm);
 	}
@@ -595,7 +610,7 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 {
 	int k;
 	struct sg_request *srp;
-	sg_io_hdr_t *hp;
+	struct sg_io_hdr *hp;
 	u8 cmnd[SG_MAX_CDB_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
@@ -619,7 +634,7 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 		return -ENOSYS;
 	}
 	if (hp->flags & SG_FLAG_MMAP_IO) {
-		if (hp->dxfer_len > sfp->reserve.bufflen) {
+		if (hp->dxfer_len > sfp->reserve.buflen) {
 			sg_remove_request(sfp, srp);
 			return -ENOMEM;	/* MMAP_IO size must fit in reserve buffer */
 		}
@@ -660,7 +675,7 @@ sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 {
 	int k, at_head;
 	struct sg_device *sdp = sfp->parentdp;
-	sg_io_hdr_t *hp = &srp->header;
+	struct sg_io_hdr *hp = &srp->header;
 
 	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
 	hp->status = 0;
@@ -741,7 +756,7 @@ static ssize_t
 sg_new_read(struct sg_fd *sfp, char __user *buf, size_t count,
 	    struct sg_request *srp)
 {
-	sg_io_hdr_t *hp = &srp->header;
+	struct sg_io_hdr *hp = &srp->header;
 	int err = 0, err2;
 	int len;
 
@@ -801,7 +816,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 	struct sg_request *srp;
 	int req_pack_id = -1;
 	int ret = 0;
-	sg_io_hdr_t *hp;
+	struct sg_io_hdr *hp;
 	struct sg_header *old_hdr = NULL;
 
 	/*
@@ -831,7 +846,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 		}
 		if (old_hdr->reply_len < 0) {
 			if (count >= SZ_SG_IO_HDR) {
-				sg_io_hdr_t *new_hdr;
+				struct sg_io_hdr *new_hdr;
 
 				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
 				if (!new_hdr) {
@@ -1126,7 +1141,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_GET_NUM_WAITING:
 		return put_user(atomic_read(&sfp->waiting), ip);
 	case SG_GET_SG_TABLESIZE:
-		return put_user(sdp->max_sgat_elems, ip);
+		return put_user(sdp->max_sgat_sz, ip);
 	case SG_SET_RESERVED_SIZE:
 		result = get_user(val, ip);
 		if (result)
@@ -1136,7 +1151,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		val = min_t(int, val,
 			    max_sectors_bytes(sdp->device->request_queue));
 		mutex_lock(&sfp->f_mutex);
-		if (val != sfp->reserve.bufflen) {
+		if (val != sfp->reserve.buflen) {
 			if (sfp->mmap_called ||
 			    sfp->res_in_use) {
 				mutex_unlock(&sfp->f_mutex);
@@ -1149,7 +1164,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		mutex_unlock(&sfp->f_mutex);
 		return 0;
 	case SG_GET_RESERVED_SIZE:
-		val = min_t(int, sfp->reserve.bufflen,
+		val = min_t(int, sfp->reserve.buflen,
 			    max_sectors_bytes(sdp->device->request_queue));
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
@@ -1349,12 +1364,12 @@ sg_vma_fault(struct vm_fault *vmf)
 	}
 	rsv_schp = &sfp->reserve;
 	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
+	if (offset >= rsv_schp->buflen)
 		return VM_FAULT_SIGBUS;
 	sa = vma->vm_start;
 	SG_LOG(3, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__, sa, offset);
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
+	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; k++) {
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
@@ -1398,14 +1413,14 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL;	/* want no offset */
 	rsv_schp = &sfp->reserve;
 	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
+	if (req_sz > rsv_schp->buflen) {
 		ret = -ENOMEM;	/* cannot map more than reserved buffer */
 		goto out;
 	}
 
 	sa = vma->vm_start;
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
+	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; k++) {
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		sa += len;
@@ -1423,7 +1438,8 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 static void
 sg_rq_end_io_usercontext(struct work_struct *work)
 {
-	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_request *srp = container_of(work, struct sg_request,
+					      ew_orph.work);
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_scsi_blk_rq(srp);
@@ -1529,8 +1545,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else {
-		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
-		schedule_work(&srp->ew.work);
+		INIT_WORK(&srp->ew_orph.work, sg_rq_end_io_usercontext);
+		schedule_work(&srp->ew_orph.work);
 	}
 }
 
@@ -1555,7 +1571,7 @@ static struct class *sg_sysfs_class;
 static int sg_sysfs_valid = 0;
 
 static struct sg_device *
-sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
+sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct request_queue *q = scsidp->request_queue;
 	struct sg_device *sdp;
@@ -1597,7 +1613,7 @@ sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	init_waitqueue_head(&sdp->open_wait);
 	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
 	rwlock_init(&sdp->sfd_lock);
-	sdp->max_sgat_elems = queue_max_segments(q);
+	sdp->max_sgat_sz = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 	error = 0;
@@ -1639,9 +1655,8 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &sg_fops;
 
-	sdp = sg_alloc(disk, scsidp);
+	sdp = sg_add_device_helper(disk, scsidp);
 	if (IS_ERR(sdp)) {
-		pr_warn("%s: sg_alloc failed\n", __func__);
 		error = PTR_ERR(sdp);
 		goto out;
 	}
@@ -1731,7 +1746,7 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 					"%s: 0x%p\n", __func__, sdp));
 
 	read_lock_irqsave(&sdp->sfd_lock, iflags);
-	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
+	list_for_each_entry(sfp, &sdp->sfds, sfd_entry) {
 		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
@@ -1825,7 +1840,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 	struct request *rq;
 	struct scsi_request *req;
 	struct sg_fd *sfp = srp->parentfp;
-	sg_io_hdr_t *hp = &srp->header;
+	struct sg_io_hdr *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
 	int dxfer_dir = hp->dxfer_direction;
 	unsigned int iov_count = hp->iovec_count;
@@ -1886,13 +1901,13 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 
 	if (md) {
 		mutex_lock(&sfp->f_mutex);
-		if (dxfer_len <= rsv_schp->bufflen &&
+		if (dxfer_len <= rsv_schp->buflen &&
 		    !sfp->res_in_use) {
 			sfp->res_in_use = 1;
 			sg_link_reserve(sfp, srp, dxfer_len);
 		} else if (hp->flags & SG_FLAG_MMAP_IO) {
 			res = -EBUSY; /* sfp->res_in_use == 1 */
-			if (dxfer_len > rsv_schp->bufflen)
+			if (dxfer_len > rsv_schp->buflen)
 				res = -ENOMEM;
 			mutex_unlock(&sfp->f_mutex);
 			return res;
@@ -1907,7 +1922,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 
 		md->pages = req_schp->pages;
 		md->page_order = req_schp->page_order;
-		md->nr_entries = req_schp->k_use_sg;
+		md->nr_entries = req_schp->num_sgat;
 		md->offset = 0;
 		md->null_mapped = hp->dxferp ? 0 : 1;
 		if (dxfer_dir == SG_DXFER_TO_FROM_DEV)
@@ -1988,13 +2003,13 @@ static int
 sg_build_sgat(struct sg_scatter_hold *schp, const struct sg_fd *sfp,
 	      int tablesize)
 {
-	int sg_bufflen = tablesize * sizeof(struct page *);
+	int sg_buflen = tablesize * sizeof(struct page *);
 	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
 
-	schp->pages = kzalloc(sg_bufflen, gfp_flags);
+	schp->pages = kzalloc(sg_buflen, gfp_flags);
 	if (!schp->pages)
 		return -ENOMEM;
-	schp->sglist_len = sg_bufflen;
+	schp->sglist_len = sg_buflen;
 	return tablesize;	/* number of scat_gath elements allocated */
 }
 
@@ -2003,7 +2018,7 @@ sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 		  int buff_size)
 {
 	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
-	int max_sgat_elems = sfp->parentdp->max_sgat_elems;
+	int max_sgat_sz = sfp->parentdp->max_sgat_sz;
 	int blk_size = buff_size, order;
 	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	struct sg_device *sdp = sfp->parentdp;
@@ -2012,13 +2027,13 @@ sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 		return -EFAULT;
 	if (0 == blk_size)
 		++blk_size;	/* don't know why */
-	/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = ALIGN(blk_size, SG_SECTOR_SZ);
+	/* round request up to next highest SG_DEF_SECTOR_SZ byte boundary */
+	blk_size = ALIGN(blk_size, SG_DEF_SECTOR_SZ);
 	SG_LOG(4, sfp, "%s: buff_size=%d, blk_size=%d\n", __func__, buff_size,
 	       blk_size);
 
 	/* N.B. ret_sz carried into this block ... */
-	mx_sc_elems = sg_build_sgat(schp, sfp, max_sgat_elems);
+	mx_sc_elems = sg_build_sgat(schp, sfp, max_sgat_sz);
 	if (mx_sc_elems < 0)
 		return mx_sc_elems;	/* most likely -ENOMEM */
 
@@ -2059,9 +2074,9 @@ sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 	}		/* end of for loop */
 
 	schp->page_order = order;
-	schp->k_use_sg = k;
-	SG_LOG(5, sfp, "%s: k_use_sg=%d, order=%d\n", __func__, k, order);
-	schp->bufflen = blk_size;
+	schp->num_sgat = k;
+	SG_LOG(5, sfp, "%s: num_sgat=%d, order=%d\n", __func__, k, order);
+	schp->buflen = blk_size;
 	if (rem_sz > 0)	/* must have failed */
 		return -ENOMEM;
 	return 0;
@@ -2078,12 +2093,12 @@ sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 static void
 sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 {
-	SG_LOG(4, sfp, "%s: num_sgat=%d\n", __func__, schp->k_use_sg);
+	SG_LOG(4, sfp, "%s: num_sgat=%d\n", __func__, schp->num_sgat);
 	if (schp->pages && schp->sglist_len > 0) {
 		if (!schp->dio_in_use) {
 			int k;
 
-			for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
+			for (k = 0; k < schp->num_sgat && schp->pages[k]; k++) {
 				SG_LOG(5, sfp, "%s: pg[%d]=0x%p --\n",
 				       __func__, k, schp->pages[k]);
 				__free_pages(schp->pages[k], schp->page_order);
@@ -2110,7 +2125,7 @@ sg_rd_append(struct sg_request *srp, void __user *outp, int num_xfer)
 		return 0;
 
 	num = 1 << (PAGE_SHIFT + schp->page_order);
-	for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
+	for (k = 0; k < schp->num_sgat && schp->pages[k]; k++) {
 		if (num > num_xfer) {
 			if (copy_to_user(outp, page_address(schp->pages[k]),
 					   num_xfer))
@@ -2158,22 +2173,21 @@ sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp, int size)
 	rem = size;
 
 	num = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg; k++) {
+	for (k = 0; k < rsv_schp->num_sgat; k++) {
 		if (rem <= num) {
-			req_schp->k_use_sg = k + 1;
+			req_schp->num_sgat = k + 1;
 			req_schp->sglist_len = rsv_schp->sglist_len;
 			req_schp->pages = rsv_schp->pages;
 
-			req_schp->bufflen = size;
+			req_schp->buflen = size;
 			req_schp->page_order = rsv_schp->page_order;
 			break;
 		} else
 			rem -= num;
 	}
 
-	if (k >= rsv_schp->k_use_sg) {
+	if (k >= rsv_schp->num_sgat)
 		SG_LOG(1, sfp, "%s: BAD size\n", __func__);
-	}
 }
 
 static void
@@ -2181,10 +2195,10 @@ sg_unlink_reserve(struct sg_fd *sfp, struct sg_request *srp)
 {
 	struct sg_scatter_hold *req_schp = &srp->data;
 
-	SG_LOG(4, srp->parentfp, "%s: req->k_use_sg=%d\n", __func__,
-	       (int)req_schp->k_use_sg);
-	req_schp->k_use_sg = 0;
-	req_schp->bufflen = 0;
+	SG_LOG(4, srp->parentfp, "%s: req->num_sgat=%d\n", __func__,
+	       (int)req_schp->num_sgat);
+	req_schp->num_sgat = 0;
+	req_schp->buflen = 0;
 	req_schp->pages = NULL;
 	req_schp->page_order = 0;
 	req_schp->sglist_len = 0;
@@ -2274,7 +2288,7 @@ sg_add_sfp(struct sg_device *sdp)
 		kfree(sfp);
 		return ERR_PTR(-ENODEV);
 	}
-	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
+	list_add_tail(&sfp->sfd_entry, &sdp->sfds);
 	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SG_LOG(3, sfp, "%s: sfp=0x%p\n", __func__, sfp);
 	if (unlikely(sg_big_buff != def_reserved_size))
@@ -2283,8 +2297,8 @@ sg_add_sfp(struct sg_device *sdp)
 	bufflen = min_t(int, sg_big_buff,
 			max_sectors_bytes(sdp->device->request_queue));
 	sg_build_reserve(sfp, bufflen);
-	SG_LOG(3, sfp, "%s: bufflen=%d, k_use_sg=%d\n", __func__,
-	       sfp->reserve.bufflen, sfp->reserve.k_use_sg);
+	SG_LOG(3, sfp, "%s: bufflen=%d, num_sgat=%d\n", __func__,
+	       sfp->reserve.buflen, sfp->reserve.num_sgat);
 
 	kref_get(&sdp->d_ref);
 	__module_get(THIS_MODULE);
@@ -2294,7 +2308,7 @@ sg_add_sfp(struct sg_device *sdp)
 static void
 sg_remove_sfp_usercontext(struct work_struct *work)
 {
-	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
+	struct sg_fd *sfp = container_of(work, struct sg_fd, ew_fd.work);
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
 	unsigned long iflags;
@@ -2309,9 +2323,9 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
-	if (sfp->reserve.bufflen > 0) {
-		SG_LOG(6, sfp, "%s:    bufflen=%d, k_use_sg=%d\n", __func__,
-		       (int)sfp->reserve.bufflen, (int)sfp->reserve.k_use_sg);
+	if (sfp->reserve.buflen > 0) {
+		SG_LOG(6, sfp, "%s:    buflen=%d, num_sgat=%d\n", __func__,
+		       (int)sfp->reserve.buflen, (int)sfp->reserve.num_sgat);
 		sg_remove_scat(sfp, &sfp->reserve);
 	}
 
@@ -2331,11 +2345,11 @@ sg_remove_sfp(struct kref *kref)
 	unsigned long iflags;
 
 	write_lock_irqsave(&sdp->sfd_lock, iflags);
-	list_del(&sfp->sfd_siblings);
+	list_del(&sfp->sfd_entry);
 	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
-	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
-	schedule_work(&sfp->ew.work);
+	INIT_WORK(&sfp->ew_fd.work, sg_remove_sfp_usercontext);
+	schedule_work(&sfp->ew_fd.work);
 }
 
 static int
@@ -2622,19 +2636,19 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 	int k, new_interface, blen, usg;
 	struct sg_request *srp;
 	struct sg_fd *fp;
-	const sg_io_hdr_t *hp;
+	const struct sg_io_hdr *hp;
 	const char * cp;
 	unsigned int ms;
 
 	k = 0;
-	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
+	list_for_each_entry(fp, &sdp->sfds, sfd_entry) {
 		k++;
 		read_lock(&fp->rq_list_lock); /* irqs already disabled */
-		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
+		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d "
 			   "(res)sgat=%d low_dma=%d\n", k,
 			   jiffies_to_msecs(fp->timeout),
-			   fp->reserve.bufflen,
-			   (int) fp->reserve.k_use_sg,
+			   fp->reserve.buflen,
+			   (int)fp->reserve.num_sgat,
 			   (int) sdp->device->host->unchecked_isa_dma);
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
@@ -2658,8 +2672,8 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 					cp = "     ";
 			}
 			seq_puts(s, cp);
-			blen = srp->data.bufflen;
-			usg = srp->data.k_use_sg;
+			blen = srp->data.buflen;
+			usg = srp->data.num_sgat;
 			seq_puts(s, srp->done ?
 				 ((1 == srp->done) ?  "rcv:" : "fin:")
 				  : "act:");
@@ -2712,8 +2726,8 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 				   scsidp->lun,
 				   scsidp->host->hostt->emulated);
 		}
-		seq_printf(s, " max_sgat_elems=%d excl=%d open_cnt=%d\n",
-			   sdp->max_sgat_elems, SG_HAVE_EXCLUDE(sdp),
+		seq_printf(s, " max_sgat_sz=%d excl=%d open_cnt=%d\n",
+			   sdp->max_sgat_sz, SG_HAVE_EXCLUDE(sdp),
 			   atomic_read(&sdp->open_cnt));
 		sg_proc_debug_helper(s, sdp);
 	}
-- 
2.25.1

