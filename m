From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] hptiop: backout ioctl mess
Date: Sun, 30 Jul 2006 19:13:36 +0200
Message-ID: <20060730171336.GA31646@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35022 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751321AbWG3ROE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 13:14:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, linux@highpoint-tech.com
Cc: linux-scsi@vger.kernel.org

The hptiop just got merged with a horrible amount of really bad ioctl
code that is against the standards for new scsi drivers.  This patch
backs it out (and fixes a small bug where scsi_add_host is called to
early).  We can re-add proper APIs once we agree on them.

Please send this to Linus for 2.6.19 so that the ioctls don't make it
into a release.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/hptiop.c
===================================================================
--- linux-2.6.orig/drivers/scsi/hptiop.c	2006-07-06 14:21:19.000000000 +0200
+++ linux-2.6/drivers/scsi/hptiop.c	2006-07-07 16:10:47.000000000 +0200
@@ -45,10 +45,6 @@
 static const char driver_name_long[] = "RocketRAID 3xxx SATA Controller driver";
 static const char driver_ver[] = "v1.0 (060426)";
 
-static DEFINE_SPINLOCK(hptiop_hba_list_lock);
-static LIST_HEAD(hptiop_hba_list);
-static int hptiop_cdev_major = -1;
-
 static void hptiop_host_request_callback(struct hptiop_hba *hba, u32 tag);
 static void hptiop_iop_request_callback(struct hptiop_hba *hba, u32 tag);
 static void hptiop_message_callback(struct hptiop_hba *hba, u32 msg);
@@ -620,532 +616,11 @@
 	return queue_depth;
 }
 
-struct hptiop_getinfo {
-	char __user *buffer;
-	loff_t buflength;
-	loff_t bufoffset;
-	loff_t buffillen;
-	loff_t filpos;
-};
-
-static void hptiop_copy_mem_info(struct hptiop_getinfo *pinfo,
-					char *data, int datalen)
-{
-	if (pinfo->filpos < pinfo->bufoffset) {
-		if (pinfo->filpos + datalen <= pinfo->bufoffset) {
-			pinfo->filpos += datalen;
-			return;
-		} else {
-			data += (pinfo->bufoffset - pinfo->filpos);
-			datalen  -= (pinfo->bufoffset - pinfo->filpos);
-			pinfo->filpos = pinfo->bufoffset;
-		}
-	}
-
-	pinfo->filpos += datalen;
-	if (pinfo->buffillen == pinfo->buflength)
-		return;
-
-	if (pinfo->buflength - pinfo->buffillen < datalen)
-		datalen = pinfo->buflength - pinfo->buffillen;
-
-	if (copy_to_user(pinfo->buffer + pinfo->buffillen, data, datalen))
-		return;
-
-	pinfo->buffillen += datalen;
-}
-
-static int hptiop_copy_info(struct hptiop_getinfo *pinfo, char *fmt, ...)
-{
-	va_list args;
-	char buf[128];
-	int len;
-
-	va_start(args, fmt);
-	len = vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
-	hptiop_copy_mem_info(pinfo, buf, len);
-	return len;
-}
-
-static void hptiop_ioctl_done(struct hpt_ioctl_k *arg)
-{
-	arg->done = NULL;
-	wake_up(&arg->hba->ioctl_wq);
-}
-
-static void hptiop_do_ioctl(struct hpt_ioctl_k *arg)
-{
-	struct hptiop_hba *hba = arg->hba;
-	u32 val;
-	struct hpt_iop_request_ioctl_command __iomem *req;
-	int ioctl_retry = 0;
-
-	dprintk("scsi%d: hptiop_do_ioctl\n", hba->host->host_no);
-
-	/*
-	 * check (in + out) buff size from application.
-	 * outbuf must be dword aligned.
-	 */
-	if (((arg->inbuf_size + 3) & ~3) + arg->outbuf_size >
-			hba->max_request_size
-				- sizeof(struct hpt_iop_request_header)
-				- 4 * sizeof(u32)) {
-		dprintk("scsi%d: ioctl buf size (%d/%d) is too large\n",
-				hba->host->host_no,
-				arg->inbuf_size, arg->outbuf_size);
-		arg->result = HPT_IOCTL_RESULT_FAILED;
-		return;
-	}
-
-retry:
-	spin_lock_irq(hba->host->host_lock);
-
-	val = readl(&hba->iop->inbound_queue);
-	if (val == IOPMU_QUEUE_EMPTY) {
-		spin_unlock_irq(hba->host->host_lock);
-		dprintk("scsi%d: no free req for ioctl\n", hba->host->host_no);
-		arg->result = -1;
-		return;
-	}
-
-	req = (struct hpt_iop_request_ioctl_command __iomem *)
-			((unsigned long)hba->iop + val);
-
-	writel(HPT_CTL_CODE_LINUX_TO_IOP(arg->ioctl_code),
-			&req->ioctl_code);
-	writel(arg->inbuf_size, &req->inbuf_size);
-	writel(arg->outbuf_size, &req->outbuf_size);
-
-	/*
-	 * use the buffer on the IOP local memory first, then copy it
-	 * back to host.
-	 * the caller's request buffer shoudl be little-endian.
-	 */
-	if (arg->inbuf_size)
-		memcpy_toio(req->buf, arg->inbuf, arg->inbuf_size);
-
-	/* correct the controller ID for IOP */
-	if ((arg->ioctl_code == HPT_IOCTL_GET_CHANNEL_INFO ||
-		arg->ioctl_code == HPT_IOCTL_GET_CONTROLLER_INFO_V2 ||
-		arg->ioctl_code == HPT_IOCTL_GET_CONTROLLER_INFO)
-		&& arg->inbuf_size >= sizeof(u32))
-		writel(0, req->buf);
-
-	writel(IOP_REQUEST_TYPE_IOCTL_COMMAND, &req->header.type);
-	writel(0, &req->header.flags);
-	writel(offsetof(struct hpt_iop_request_ioctl_command, buf)
-			+ arg->inbuf_size, &req->header.size);
-	writel((u32)(unsigned long)arg, &req->header.context);
-	writel(BITS_PER_LONG > 32 ? (u32)((unsigned long)arg>>32) : 0,
-			&req->header.context_hi32);
-	writel(IOP_RESULT_PENDING, &req->header.result);
-
-	arg->result = HPT_IOCTL_RESULT_FAILED;
-	arg->done = hptiop_ioctl_done;
-
-	writel(val, &hba->iop->inbound_queue);
-	hptiop_pci_posting_flush(hba->iop);
-
-	spin_unlock_irq(hba->host->host_lock);
-
-	wait_event_timeout(hba->ioctl_wq, arg->done == NULL, 60 * HZ);
-
-	if (arg->done != NULL) {
-		hptiop_reset_hba(hba);
-		if (ioctl_retry++ < 3)
-			goto retry;
-	}
-
-	dprintk("hpt_iop_ioctl %x result %d\n",
-			arg->ioctl_code, arg->result);
-}
-
-static int __hpt_do_ioctl(struct hptiop_hba *hba, u32 code, void *inbuf,
-			u32 insize, void *outbuf, u32 outsize)
-{
-	struct hpt_ioctl_k arg;
-	arg.hba = hba;
-	arg.ioctl_code = code;
-	arg.inbuf = inbuf;
-	arg.outbuf = outbuf;
-	arg.inbuf_size = insize;
-	arg.outbuf_size = outsize;
-	arg.bytes_returned = NULL;
-	hptiop_do_ioctl(&arg);
-	return arg.result;
-}
-
-static inline int hpt_id_valid(__le32 id)
-{
-	return id != 0 && id != cpu_to_le32(0xffffffff);
-}
-
-static int hptiop_get_controller_info(struct hptiop_hba *hba,
-					struct hpt_controller_info *pinfo)
-{
-	int id = 0;
-
-	return __hpt_do_ioctl(hba, HPT_IOCTL_GET_CONTROLLER_INFO,
-		&id, sizeof(int), pinfo, sizeof(*pinfo));
-}
-
-
-static int hptiop_get_channel_info(struct hptiop_hba *hba, int bus,
-					struct hpt_channel_info *pinfo)
-{
-	u32 ids[2];
-
-	ids[0] = 0;
-	ids[1] = bus;
-	return __hpt_do_ioctl(hba, HPT_IOCTL_GET_CHANNEL_INFO,
-				ids, sizeof(ids), pinfo, sizeof(*pinfo));
-
-}
-
-static int hptiop_get_logical_devices(struct hptiop_hba *hba,
-					__le32 *pids, int maxcount)
-{
-	int i;
-	u32 count = maxcount - 1;
-
-	if (__hpt_do_ioctl(hba, HPT_IOCTL_GET_LOGICAL_DEVICES,
-			&count, sizeof(u32),
-			pids, sizeof(u32) * maxcount))
-		return -1;
-
-	maxcount = le32_to_cpu(pids[0]);
-	for (i = 0; i < maxcount; i++)
-		pids[i] = pids[i+1];
-
-	return maxcount;
-}
-
-static int hptiop_get_device_info_v3(struct hptiop_hba *hba, __le32 id,
-				struct hpt_logical_device_info_v3 *pinfo)
-{
-	return __hpt_do_ioctl(hba, HPT_IOCTL_GET_DEVICE_INFO_V3,
-				&id, sizeof(u32),
-				pinfo, sizeof(*pinfo));
-}
-
-static const char *get_array_status(struct hpt_logical_device_info_v3 *devinfo)
-{
-	static char s[64];
-	u32 flags = le32_to_cpu(devinfo->u.array.flags);
-	u32 trans_prog = le32_to_cpu(devinfo->u.array.transforming_progress);
-	u32 reb_prog = le32_to_cpu(devinfo->u.array.rebuilding_progress);
-
-	if (flags & ARRAY_FLAG_DISABLED)
-		return "Disabled";
-	else if (flags & ARRAY_FLAG_TRANSFORMING)
-		sprintf(s, "Expanding/Migrating %d.%d%%%s%s",
-			trans_prog / 100,
-			trans_prog % 100,
-			(flags & (ARRAY_FLAG_NEEDBUILDING|ARRAY_FLAG_BROKEN))?
-					", Critical" : "",
-			((flags & ARRAY_FLAG_NEEDINITIALIZING) &&
-			 !(flags & ARRAY_FLAG_REBUILDING) &&
-			 !(flags & ARRAY_FLAG_INITIALIZING))?
-					", Unintialized" : "");
-	else if ((flags & ARRAY_FLAG_BROKEN) &&
-				devinfo->u.array.array_type != AT_RAID6)
-		return "Critical";
-	else if (flags & ARRAY_FLAG_REBUILDING)
-		sprintf(s,
-			(flags & ARRAY_FLAG_NEEDINITIALIZING)?
-				"%sBackground initializing %d.%d%%" :
-					"%sRebuilding %d.%d%%",
-			(flags & ARRAY_FLAG_BROKEN)? "Critical, " : "",
-			reb_prog / 100,
-			reb_prog % 100);
-	else if (flags & ARRAY_FLAG_VERIFYING)
-		sprintf(s, "%sVerifying %d.%d%%",
-			(flags & ARRAY_FLAG_BROKEN)? "Critical, " : "",
-			reb_prog / 100,
-			reb_prog % 100);
-	else if (flags & ARRAY_FLAG_INITIALIZING)
-		sprintf(s, "%sForground initializing %d.%d%%",
-			(flags & ARRAY_FLAG_BROKEN)? "Critical, " : "",
-			reb_prog / 100,
-			reb_prog % 100);
-	else if (flags & ARRAY_FLAG_NEEDTRANSFORM)
-		sprintf(s,"%s%s%s", "Need Expanding/Migrating",
-			(flags & ARRAY_FLAG_BROKEN)? "Critical, " : "",
-			((flags & ARRAY_FLAG_NEEDINITIALIZING) &&
-			 !(flags & ARRAY_FLAG_REBUILDING) &&
-			 !(flags & ARRAY_FLAG_INITIALIZING))?
-				", Unintialized" : "");
-	else if (flags & ARRAY_FLAG_NEEDINITIALIZING &&
-		!(flags & ARRAY_FLAG_REBUILDING) &&
-		!(flags & ARRAY_FLAG_INITIALIZING))
-		sprintf(s,"%sUninitialized",
-			(flags & ARRAY_FLAG_BROKEN)? "Critical, " : "");
-	else if ((flags & ARRAY_FLAG_NEEDBUILDING) ||
-			(flags & ARRAY_FLAG_BROKEN))
-		return "Critical";
-	else
-		return "Normal";
-	return s;
-}
-
-static void hptiop_dump_devinfo(struct hptiop_hba *hba,
-			struct hptiop_getinfo *pinfo, __le32 id, int indent)
-{
-	struct hpt_logical_device_info_v3 devinfo;
-	int i;
-	u64 capacity;
-
-	for (i = 0; i < indent; i++)
-		hptiop_copy_info(pinfo, "\t");
-
-	if (hptiop_get_device_info_v3(hba, id, &devinfo)) {
-		hptiop_copy_info(pinfo, "unknown\n");
-		return;
-	}
-
-	switch (devinfo.type) {
-
-	case LDT_DEVICE: {
-		struct hd_driveid *driveid;
-		u32 flags = le32_to_cpu(devinfo.u.device.flags);
-
-		driveid = (struct hd_driveid *)devinfo.u.device.ident;
-		/* model[] is 40 chars long, but we just want 20 chars here */
-		driveid->model[20] = 0;
-
-		if (indent)
-			if (flags & DEVICE_FLAG_DISABLED)
-				hptiop_copy_info(pinfo,"Missing\n");
-			else
-				hptiop_copy_info(pinfo, "CH%d %s\n",
-					devinfo.u.device.path_id + 1,
-					driveid->model);
-		else {
-			capacity = le64_to_cpu(devinfo.capacity) * 512;
-			do_div(capacity, 1000000);
-			hptiop_copy_info(pinfo,
-				"CH%d %s, %lluMB, %s %s%s%s%s\n",
-				devinfo.u.device.path_id + 1,
-				driveid->model,
-				capacity,
-				(flags & DEVICE_FLAG_DISABLED)?
-					"Disabled" : "Normal",
-				devinfo.u.device.read_ahead_enabled?
-						"[RA]" : "",
-				devinfo.u.device.write_cache_enabled?
-						"[WC]" : "",
-				devinfo.u.device.TCQ_enabled?
-						"[TCQ]" : "",
-				devinfo.u.device.NCQ_enabled?
-						"[NCQ]" : ""
-			);
-		}
-		break;
-	}
-
-	case LDT_ARRAY:
-		if (devinfo.target_id != INVALID_TARGET_ID)
-			hptiop_copy_info(pinfo, "[DISK %d_%d] ",
-					devinfo.vbus_id, devinfo.target_id);
-
-		capacity = le64_to_cpu(devinfo.capacity) * 512;
-		do_div(capacity, 1000000);
-		hptiop_copy_info(pinfo, "%s (%s), %lluMB, %s\n",
-			devinfo.u.array.name,
-			devinfo.u.array.array_type==AT_RAID0? "RAID0" :
-				devinfo.u.array.array_type==AT_RAID1? "RAID1" :
-				devinfo.u.array.array_type==AT_RAID5? "RAID5" :
-				devinfo.u.array.array_type==AT_RAID6? "RAID6" :
-				devinfo.u.array.array_type==AT_JBOD? "JBOD" :
-					"unknown",
-			capacity,
-			get_array_status(&devinfo));
-		for (i = 0; i < devinfo.u.array.ndisk; i++) {
-			if (hpt_id_valid(devinfo.u.array.members[i])) {
-				if (cpu_to_le16(1<<i) &
-					devinfo.u.array.critical_members)
-					hptiop_copy_info(pinfo, "\t*");
-				hptiop_dump_devinfo(hba, pinfo,
-					devinfo.u.array.members[i], indent+1);
-			}
-			else
-				hptiop_copy_info(pinfo, "\tMissing\n");
-		}
-		if (id == devinfo.u.array.transform_source) {
-			hptiop_copy_info(pinfo, "\tExpanding/Migrating to:\n");
-			hptiop_dump_devinfo(hba, pinfo,
-				devinfo.u.array.transform_target, indent+1);
-		}
-		break;
-	}
-}
-
 static ssize_t hptiop_show_version(struct class_device *class_dev, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", driver_ver);
 }
 
-static ssize_t hptiop_cdev_read(struct file *filp, char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct hptiop_hba *hba = filp->private_data;
-	struct hptiop_getinfo info;
-	int i, j, ndev;
-	struct hpt_controller_info con_info;
-	struct hpt_channel_info chan_info;
-	__le32 ids[32];
-
-	info.buffer     = buf;
-	info.buflength  = count;
-	info.bufoffset  = ppos ? *ppos : 0;
-	info.filpos     = 0;
-	info.buffillen  = 0;
-
-	if (hptiop_get_controller_info(hba, &con_info))
-		return -EIO;
-
-	for (i = 0; i < con_info.num_buses; i++) {
-		if (hptiop_get_channel_info(hba, i, &chan_info) == 0) {
-			if (hpt_id_valid(chan_info.devices[0]))
-				hptiop_dump_devinfo(hba, &info,
-						chan_info.devices[0], 0);
-			if (hpt_id_valid(chan_info.devices[1]))
-				hptiop_dump_devinfo(hba, &info,
-						chan_info.devices[1], 0);
-		}
-	}
-
-	ndev = hptiop_get_logical_devices(hba, ids,
-					sizeof(ids) / sizeof(ids[0]));
-
-	/*
-	 * if hptiop_get_logical_devices fails, ndev==-1 and it just
-	 * output nothing here
-	 */
-	for (j = 0; j < ndev; j++)
-		hptiop_dump_devinfo(hba, &info, ids[j], 0);
-
-	if (ppos)
-		*ppos += info.buffillen;
-
-	return info.buffillen;
-}
-
-static int hptiop_cdev_ioctl(struct inode *inode,  struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	struct hptiop_hba *hba = file->private_data;
-	struct hpt_ioctl_u ioctl_u;
-	struct hpt_ioctl_k ioctl_k;
-	u32 bytes_returned;
-	int err = -EINVAL;
-
-	if (copy_from_user(&ioctl_u,
-		(void __user *)arg, sizeof(struct hpt_ioctl_u)))
-		return -EINVAL;
-
-	if (ioctl_u.magic != HPT_IOCTL_MAGIC)
-		return -EINVAL;
-
-	ioctl_k.ioctl_code = ioctl_u.ioctl_code;
-	ioctl_k.inbuf = NULL;
-	ioctl_k.inbuf_size = ioctl_u.inbuf_size;
-	ioctl_k.outbuf = NULL;
-	ioctl_k.outbuf_size = ioctl_u.outbuf_size;
-	ioctl_k.hba = hba;
-	ioctl_k.bytes_returned = &bytes_returned;
-
-	/* verify user buffer */
-	if ((ioctl_k.inbuf_size && !access_ok(VERIFY_READ,
-			ioctl_u.inbuf, ioctl_k.inbuf_size)) ||
-		(ioctl_k.outbuf_size && !access_ok(VERIFY_WRITE,
-			ioctl_u.outbuf, ioctl_k.outbuf_size)) ||
-		(ioctl_u.bytes_returned && !access_ok(VERIFY_WRITE,
-			ioctl_u.bytes_returned, sizeof(u32))) ||
-		ioctl_k.inbuf_size + ioctl_k.outbuf_size > 0x10000) {
-
-		dprintk("scsi%d: got bad user address\n", hba->host->host_no);
-		return -EINVAL;
-	}
-
-	/* map buffer to kernel. */
-	if (ioctl_k.inbuf_size) {
-		ioctl_k.inbuf = kmalloc(ioctl_k.inbuf_size, GFP_KERNEL);
-		if (!ioctl_k.inbuf) {
-			dprintk("scsi%d: fail to alloc inbuf\n",
-					hba->host->host_no);
-			err = -ENOMEM;
-			goto err_exit;
-		}
-
-		if (copy_from_user(ioctl_k.inbuf,
-				ioctl_u.inbuf, ioctl_k.inbuf_size)) {
-			goto err_exit;
-		}
-	}
-
-	if (ioctl_k.outbuf_size) {
-		ioctl_k.outbuf = kmalloc(ioctl_k.outbuf_size, GFP_KERNEL);
-		if (!ioctl_k.outbuf) {
-			dprintk("scsi%d: fail to alloc outbuf\n",
-					hba->host->host_no);
-			err = -ENOMEM;
-			goto err_exit;
-		}
-	}
-
-	hptiop_do_ioctl(&ioctl_k);
-
-	if (ioctl_k.result == HPT_IOCTL_RESULT_OK) {
-		if (ioctl_k.outbuf_size &&
-			copy_to_user(ioctl_u.outbuf,
-				ioctl_k.outbuf, ioctl_k.outbuf_size))
-			goto err_exit;
-
-		if (ioctl_u.bytes_returned &&
-			copy_to_user(ioctl_u.bytes_returned,
-				&bytes_returned, sizeof(u32)))
-			goto err_exit;
-
-		err = 0;
-	}
-
-err_exit:
-	kfree(ioctl_k.inbuf);
-	kfree(ioctl_k.outbuf);
-
-	return err;
-}
-
-static int hptiop_cdev_open(struct inode *inode, struct file *file)
-{
-	struct hptiop_hba *hba;
-	unsigned i = 0, minor = iminor(inode);
-	int ret = -ENODEV;
-
-	spin_lock(&hptiop_hba_list_lock);
-	list_for_each_entry(hba, &hptiop_hba_list, link) {
-		if (i == minor) {
-			file->private_data = hba;
-			ret = 0;
-			goto out;
-		}
-		i++;
-	}
-
-out:
-	spin_unlock(&hptiop_hba_list_lock);
-	return ret;
-}
-
-static struct file_operations hptiop_cdev_fops = {
-	.owner = THIS_MODULE,
-	.read  = hptiop_cdev_read,
-	.ioctl = hptiop_cdev_ioctl,
-	.open  = hptiop_cdev_open,
-};
-
 static ssize_t hptiop_show_fw_version(struct class_device *class_dev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(class_dev);
@@ -1296,19 +771,13 @@
 		goto unmap_pci_bar;
 	}
 
-	if (scsi_add_host(host, &pcidev->dev)) {
-		printk(KERN_ERR "scsi%d: scsi_add_host failed\n",
-					hba->host->host_no);
-		goto unmap_pci_bar;
-	}
-
 	pci_set_drvdata(pcidev, host);
 
 	if (request_irq(pcidev->irq, hptiop_intr, IRQF_SHARED,
 					driver_name, hba)) {
 		printk(KERN_ERR "scsi%d: request irq %d failed\n",
 					hba->host->host_no, pcidev->irq);
-		goto remove_scsi_host;
+		goto unmap_pci_bar;
 	}
 
 	/* Allocate request mem */
@@ -1355,9 +824,12 @@
 	if (hptiop_initialize_iop(hba))
 		goto free_request_mem;
 
-	spin_lock(&hptiop_hba_list_lock);
-	list_add_tail(&hba->link, &hptiop_hba_list);
-	spin_unlock(&hptiop_hba_list_lock);
+	if (scsi_add_host(host, &pcidev->dev)) {
+		printk(KERN_ERR "scsi%d: scsi_add_host failed\n",
+					hba->host->host_no);
+		goto free_request_mem;
+	}
+
 
 	scsi_scan_host(host);
 
@@ -1372,9 +844,6 @@
 free_request_irq:
 	free_irq(hba->pcidev->irq, hba);
 
-remove_scsi_host:
-	scsi_remove_host(host);
-
 unmap_pci_bar:
 	iounmap(hba->iop);
 
@@ -1422,10 +891,6 @@
 
 	scsi_remove_host(host);
 
-	spin_lock(&hptiop_hba_list_lock);
-	list_del_init(&hba->link);
-	spin_unlock(&hptiop_hba_list_lock);
-
 	hptiop_shutdown(pcidev);
 
 	free_irq(hba->pcidev->irq, hba);
@@ -1462,27 +927,12 @@
 
 static int __init hptiop_module_init(void)
 {
-	int error;
-
 	printk(KERN_INFO "%s %s\n", driver_name_long, driver_ver);
-
-	error = pci_register_driver(&hptiop_pci_driver);
-	if (error < 0)
-		return error;
-
-	hptiop_cdev_major = register_chrdev(0, "hptiop", &hptiop_cdev_fops);
-	if (hptiop_cdev_major < 0) {
-		printk(KERN_WARNING "unable to register hptiop device.\n");
-		return hptiop_cdev_major;
-	}
-
-	return 0;
+	return pci_register_driver(&hptiop_pci_driver);
 }
 
 static void __exit hptiop_module_exit(void)
 {
-	dprintk("hptiop_module_exit\n");
-	unregister_chrdev(hptiop_cdev_major, "hptiop");
 	pci_unregister_driver(&hptiop_pci_driver);
 }
 
