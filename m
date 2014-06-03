From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] scsi: Implement sg_printk()
Date: Tue,  3 Jun 2014 13:22:53 +0200
Message-ID: <1401794577-102277-3-git-send-email-hare@suse.de>
References: <1401794577-102277-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbaFCLXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 07:23:01 -0400
In-Reply-To: <1401794577-102277-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Doug Gilbert <dgilbert@interlog.com>

Update the sg driver to use dev_printk() variants instead of
plain printk(); this will prefix logging messages with the
appropriate device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 189 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 109 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..aeee4de 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -197,11 +197,11 @@ static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
-static void sg_remove_scat(Sg_scatter_hold * schp);
+static void sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp);
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
 static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
-static Sg_fd *sg_add_sfp(Sg_device * sdp, int dev);
+static Sg_fd *sg_add_sfp(Sg_device * sdp);
 static void sg_remove_sfp(struct kref *);
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
@@ -215,6 +215,10 @@ static void sg_put_dev(Sg_device *sdp);
 #define SZ_SG_IOVEC sizeof(sg_iovec_t)
 #define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
 
+#define sg_printk(prefix, sdp, fmt, a...) \
+	sdev_printk(prefix, (sdp)->device, "[%s] " fmt, \
+		    (sdp)->disk->disk_name, ##a)
+
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = filp->private_data;
@@ -269,13 +273,14 @@ sg_open(struct inode *inode, struct file *filp)
 	int retval;
 
 	nonseekable_open(inode, filp);
-	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
 	if (IS_ERR(sdp)) {
 		retval = PTR_ERR(sdp);
 		sdp = NULL;
 		goto sg_put;
 	}
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_open: flags=0x%x\n", flags));
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
@@ -329,7 +334,7 @@ sg_open(struct inode *inode, struct file *filp)
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
-	if ((sfp = sg_add_sfp(sdp, dev)))
+	if ((sfp = sg_add_sfp(sdp)))
 		filp->private_data = sfp;
 	else {
 		if (flags & O_EXCL) {
@@ -361,7 +366,7 @@ sg_release(struct inode *inode, struct file *filp)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
 
 	set_exclude(sdp, 0);
 	wake_up_interruptible(&sdp->o_excl_wait);
@@ -384,8 +389,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
-				   sdp->disk->disk_name, (int) count));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_read: count=%d\n", (int) count));
 
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
@@ -570,8 +575,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
-				   sdp->disk->disk_name, (int) count));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_write: count=%d\n", (int) count));
 	if (sdp->detached)
 		return -ENODEV;
 	if (!((filp->f_flags & O_NONBLOCK) ||
@@ -592,14 +597,16 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
 	if (!(srp = sg_add_request(sfp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_write: queue full\n"));
+		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sdp,
+					      "sg_write: queue full\n"));
 		return -EDOM;
 	}
 	buf += SZ_SG_HEADER;
 	__get_user(opcode, buf);
 	if (sfp->next_cmd_len > 0) {
 		if (sfp->next_cmd_len > MAX_COMMAND_SIZE) {
-			SCSI_LOG_TIMEOUT(1, printk("sg_write: command length too long\n"));
+			SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sdp,
+				"sg_write: command length too long\n"));
 			sfp->next_cmd_len = 0;
 			sg_remove_request(sfp, srp);
 			return -EIO;
@@ -611,7 +618,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		if ((opcode >= 0xc0) && old_hdr.twelve_byte)
 			cmd_size = 12;
 	}
-	SCSI_LOG_TIMEOUT(4, printk(
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
 		"sg_write:   scsi opcode=0x%02x, cmd_size=%d\n", (int) opcode, cmd_size));
 /* Determine buffer size.  */
 	input_size = count - cmd_size;
@@ -686,7 +693,8 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 
 	sfp->cmd_q = 1;	/* when sg_io_hdr seen, set command queuing on */
 	if (!(srp = sg_add_request(sfp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_new_write: queue full\n"));
+		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
+					      "sg_new_write: queue full\n"));
 		return -EDOM;
 	}
 	srp->sg_io_owned = sg_io_owned;
@@ -755,12 +763,14 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	hp->host_status = 0;
 	hp->driver_status = 0;
 	hp->resid = 0;
-	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
-			  (int) cmnd[0], (int) hp->cmd_len));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
+			(int) cmnd[0], (int) hp->cmd_len));
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
+		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
+			"sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
@@ -820,8 +830,8 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
-				   sdp->disk->disk_name, (int) cmd_in));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
 
 	switch (cmd_in) {
@@ -873,7 +883,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			sfp->low_dma = 1;
 			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
 				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(&sfp->reserve);
+				sg_remove_scat(sfp, &sfp->reserve);
 				sg_build_reserve(sfp, val);
 			}
 		} else {
@@ -949,7 +959,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;
-			sg_remove_scat(&sfp->reserve);
+			sg_remove_scat(sfp, &sfp->reserve);
 			sg_build_reserve(sfp, val);
 		}
 		return 0;
@@ -1172,8 +1182,8 @@ sg_poll(struct file *filp, poll_table * wait)
 			res |= POLLOUT | POLLWRNORM;
 	} else if (count < SG_MAX_QUEUE)
 		res |= POLLOUT | POLLWRNORM;
-	SCSI_LOG_TIMEOUT(3, printk("sg_poll: %s, res=0x%x\n",
-				   sdp->disk->disk_name, (int) res));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_poll: res=0x%x\n", (int) res));
 	return res;
 }
 
@@ -1185,8 +1195,8 @@ sg_fasync(int fd, struct file *filp, int mode)
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
-	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
-				   sdp->disk->disk_name, mode));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_fasync: mode=%d\n", mode));
 
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
@@ -1205,8 +1215,9 @@ sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rsv_schp->bufflen)
 		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
-				   offset, rsv_schp->k_use_sg));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "sg_vma_fault: offset=%lu, scatg=%d\n",
+				      offset, rsv_schp->k_use_sg));
 	sa = vma->vm_start;
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
 	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
@@ -1241,8 +1252,9 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
 	req_sz = vma->vm_end - vma->vm_start;
-	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-				   (void *) vma->vm_start, (int) req_sz));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "sg_mmap starting, vm_start=%p, len=%d\n",
+				      (void *) vma->vm_start, (int) req_sz));
 	if (vma->vm_pgoff)
 		return -EINVAL;	/* want no offset */
 	rsv_schp = &sfp->reserve;
@@ -1296,14 +1308,16 @@ static void sg_rq_end_io(struct request *rq, int uptodate)
 
 	sdp = sfp->parentdp;
 	if (unlikely(sdp->detached))
-		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+		sg_printk(KERN_INFO, sdp,
+			  "sg_rq_end_io: device detached\n");
 
 	sense = rq->sense;
 	result = rq->errors;
 	resid = rq->resid_len;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, result));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
+				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
+				      srp->header.pack_id, result));
 	srp->header.resid = resid;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
@@ -1399,18 +1413,19 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	if (error < 0) {
 		if (error == -ENOSPC) {
 			sdev_printk(KERN_WARNING, scsidp,
-				    "Unable to attach sg device type=%d, minor number exceeds %d\n",
+				    "Unable to attach sg device type=%d, "
+				    "minor number exceeds %d\n",
 				    scsidp->type, SG_MAX_DEVS - 1);
 			error = -ENODEV;
 		} else {
-			printk(KERN_WARNING
-			       "idr allocation Sg_device failure: %d\n", error);
+			sdev_printk(KERN_WARNING, scsidp,
+				    "idr allocation Sg_device failure: %d\n",
+				    error);
 		}
 		goto out_unlock;
 	}
 	k = error;
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_alloc: dev=%d \n", k));
 	sprintf(disk->disk_name, "sg%d", k);
 	disk->first_minor = k;
 	sdp->disk = disk;
@@ -1421,6 +1436,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 	error = 0;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_alloc: dev=%d \n", k));
 
 out_unlock:
 	write_unlock_irqrestore(&sg_index_lock, iflags);
@@ -1445,7 +1462,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 
 	disk = alloc_disk(1);
 	if (!disk) {
-		printk(KERN_WARNING "alloc_disk failed\n");
+		sdev_printk(KERN_WARNING, scsidp, "alloc_disk failed\n");
 		return -ENOMEM;
 	}
 	disk->major = SCSI_GENERIC_MAJOR;
@@ -1453,7 +1470,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 	error = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev) {
-		printk(KERN_WARNING "cdev_alloc failed\n");
+		sdev_printk(KERN_WARNING, scsidp, "cdev_alloc failed\n");
 		goto out;
 	}
 	cdev->owner = THIS_MODULE;
@@ -1461,7 +1478,7 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 
 	sdp = sg_alloc(disk, scsidp);
 	if (IS_ERR(sdp)) {
-		printk(KERN_WARNING "sg_alloc failed\n");
+		sdev_printk(KERN_WARNING, scsidp, "sg_alloc failed\n");
 		error = PTR_ERR(sdp);
 		goto out;
 	}
@@ -1479,18 +1496,18 @@ sg_add(struct device *cl_dev, struct class_interface *cl_intf)
 						      sdp->index),
 						sdp, "%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
-			printk(KERN_ERR "sg_add: "
-			       "device_create failed\n");
+			sdev_printk(KERN_ERR, scsidp, "sg_add: "
+				    "device_create failed\n");
 			error = PTR_ERR(sg_class_member);
 			goto cdev_add_err;
 		}
 		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
 		if (error)
-			printk(KERN_ERR "sg_add: unable to make symlink "
-					"'generic' back to sg%d\n", sdp->index);
+			sdev_printk(KERN_ERR, scsidp, "sg_add: "
+				    "unable to make symlink 'generic'\n");
 	} else
-		printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
+		sdev_printk(KERN_WARNING, scsidp, "sg_add: sg_sys Invalid\n");
 
 	sdev_printk(KERN_NOTICE, scsidp,
 		    "Attached scsi generic sg%d type %d\n", sdp->index,
@@ -1528,8 +1545,7 @@ static void sg_device_destroy(struct kref *kref)
 	write_unlock_irqrestore(&sg_index_lock, flags);
 
 	SCSI_LOG_TIMEOUT(3,
-		printk("sg_device_destroy: %s\n",
-			sdp->disk->disk_name));
+		sg_printk(KERN_INFO, sdp, "sg_device_destroy\n"));
 
 	put_disk(sdp->disk);
 	kfree(sdp);
@@ -1545,7 +1561,7 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 	if (!sdp || sdp->detached)
 		return;
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_remove\n"));
 
 	/* Need a write lock to set sdp->detached. */
 	write_lock_irqsave(&sg_index_lock, iflags);
@@ -1646,8 +1662,9 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	struct rq_map_data *md, map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
 
-	SCSI_LOG_TIMEOUT(4, printk(KERN_INFO "sg_start_req: dxfer_len=%d\n",
-				   dxfer_len));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+				      "sg_start_req: dxfer_len=%d\n",
+				      dxfer_len));
 
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
 	if (!rq)
@@ -1734,7 +1751,9 @@ static int sg_finish_rem_req(Sg_request * srp)
 	Sg_fd *sfp = srp->parentfp;
 	Sg_scatter_hold *req_schp = &srp->data;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+				      "sg_finish_rem_req: res_used=%d\n",
+				      (int) srp->res_used));
 	if (srp->rq) {
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
@@ -1745,7 +1764,7 @@ static int sg_finish_rem_req(Sg_request * srp)
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
 	else
-		sg_remove_scat(req_schp);
+		sg_remove_scat(sfp, req_schp);
 
 	sg_remove_request(sfp, srp);
 
@@ -1779,8 +1798,9 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		++blk_size;	/* don't know why */
 	/* round request up to next highest SG_SECTOR_SZ byte boundary */
 	blk_size = ALIGN(blk_size, SG_SECTOR_SZ);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+		"sg_build_indirect: buff_size=%d, blk_size=%d\n",
+		buff_size, blk_size));
 
 	/* N.B. ret_sz carried into this block ... */
 	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
@@ -1823,14 +1843,16 @@ retry:
 			}
 		}
 
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
-				 "ret_sz=%d\n", k, num, ret_sz));
+		SCSI_LOG_TIMEOUT(5, sg_printk(KERN_INFO, sfp->parentdp,
+				 "sg_build_indirect: k=%d, num=%d, ret_sz=%d\n",
+				 k, num, ret_sz));
 	}		/* end of for loop */
 
 	schp->page_order = order;
 	schp->k_use_sg = k;
-	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
-			 "rem_sz=%d\n", k, rem_sz));
+	SCSI_LOG_TIMEOUT(5, sg_printk(KERN_INFO, sfp->parentdp,
+			 "sg_build_indirect: k_use_sg=%d, rem_sz=%d\n",
+			 k, rem_sz));
 
 	schp->bufflen = blk_size;
 	if (rem_sz > 0)	/* must have failed */
@@ -1847,17 +1869,19 @@ out:
 }
 
 static void
-sg_remove_scat(Sg_scatter_hold * schp)
+sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp)
 {
-	SCSI_LOG_TIMEOUT(4, printk("sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+			 "sg_remove_scat: k_use_sg=%d\n", schp->k_use_sg));
 	if (schp->pages && schp->sglist_len > 0) {
 		if (!schp->dio_in_use) {
 			int k;
 
 			for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
-				SCSI_LOG_TIMEOUT(5, printk(
-				    "sg_remove_scat: k=%d, pg=0x%p\n",
-				    k, schp->pages[k]));
+				SCSI_LOG_TIMEOUT(5,
+					sg_printk(KERN_INFO, sfp->parentdp,
+					"sg_remove_scat: k=%d, pg=0x%p\n",
+					k, schp->pages[k]));
 				__free_pages(schp->pages[k], schp->page_order);
 			}
 
@@ -1873,8 +1897,9 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	Sg_scatter_hold *schp = &srp->data;
 	int k, num;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_oxfer: num_read_xfer=%d\n",
-				   num_read_xfer));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, srp->parentfp->parentdp,
+			 "sg_read_oxfer: num_read_xfer=%d\n",
+			 num_read_xfer));
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
@@ -1904,14 +1929,15 @@ sg_build_reserve(Sg_fd * sfp, int req_size)
 {
 	Sg_scatter_hold *schp = &sfp->reserve;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_reserve: req_size=%d\n", req_size));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+			 "sg_build_reserve: req_size=%d\n", req_size));
 	do {
 		if (req_size < PAGE_SIZE)
 			req_size = PAGE_SIZE;
 		if (0 == sg_build_indirect(schp, sfp, req_size))
 			return;
 		else
-			sg_remove_scat(schp);
+			sg_remove_scat(sfp, schp);
 		req_size >>= 1;	/* divide by 2 */
 	} while (req_size > (PAGE_SIZE / 2));
 }
@@ -1924,7 +1950,8 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 	int k, num, rem;
 
 	srp->res_used = 1;
-	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
+			 "sg_link_reserve: size=%d\n", size));
 	rem = size;
 
 	num = 1 << (PAGE_SHIFT + rsv_schp->page_order);
@@ -1942,7 +1969,8 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 	}
 
 	if (k >= rsv_schp->k_use_sg)
-		SCSI_LOG_TIMEOUT(1, printk("sg_link_reserve: BAD size\n"));
+		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
+				 "sg_link_reserve: BAD size\n"));
 }
 
 static void
@@ -1950,8 +1978,9 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
 {
 	Sg_scatter_hold *req_schp = &srp->data;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_unlink_reserve: req->k_use_sg=%d\n",
-				   (int) req_schp->k_use_sg));
+	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, srp->parentfp->parentdp,
+				      "sg_unlink_reserve: req->k_use_sg=%d\n",
+				      (int) req_schp->k_use_sg));
 	req_schp->k_use_sg = 0;
 	req_schp->bufflen = 0;
 	req_schp->pages = NULL;
@@ -2056,7 +2085,7 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
 }
 
 static Sg_fd *
-sg_add_sfp(Sg_device * sdp, int dev)
+sg_add_sfp(Sg_device * sdp)
 {
 	Sg_fd *sfp;
 	unsigned long iflags;
@@ -2081,15 +2110,17 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	write_lock_irqsave(&sg_index_lock, iflags);
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
-	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+				      "sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
 	bufflen = min_t(int, sg_big_buff,
 			queue_max_sectors(sdp->device->request_queue) * 512);
 	sg_build_reserve(sfp, bufflen);
-	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
-			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
+			 "sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
+			 sfp->reserve.bufflen, sfp->reserve.k_use_sg));
 
 	kref_get(&sdp->d_ref);
 	__module_get(THIS_MODULE);
@@ -2106,17 +2137,15 @@ static void sg_remove_sfp_usercontext(struct work_struct *work)
 		sg_finish_rem_req(sfp->headrp);
 
 	if (sfp->reserve.bufflen > 0) {
-		SCSI_LOG_TIMEOUT(6,
-			printk("sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
+		SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
+				"sg_remove_sfp:    bufflen=%d, k_use_sg=%d\n",
 				(int) sfp->reserve.bufflen,
 				(int) sfp->reserve.k_use_sg));
-		sg_remove_scat(&sfp->reserve);
+		sg_remove_scat(sfp, &sfp->reserve);
 	}
 
-	SCSI_LOG_TIMEOUT(6,
-		printk("sg_remove_sfp: %s, sfp=0x%p\n",
-			sdp->disk->disk_name,
-			sfp));
+	SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
+			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
-- 
1.7.12.4

