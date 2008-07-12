From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: [Patch] convert drivers/scsi/sg.c use .unlocked_ioctl
Date: Fri, 11 Jul 2008 20:13:36 -0500
Message-ID: <6d291e080807111813m6f535798hd444c43e89400775@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert drivers/scsi/sg.c to use the unlocked_ioctl. This is based on
the linux-next tree.

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>

diff -uprN linux-next/drivers/scsi/sg.c devel/drivers/scsi/sg.c
--- linux-next/drivers/scsi/sg.c	2008-07-11 05:14:06.000000000 -0500
+++ devel/drivers/scsi/sg.c	2008-07-11 07:33:43.000000000 -0500
@@ -779,20 +779,23 @@ sg_srp_done(Sg_request *srp, Sg_fd *sfp)
 	return done;
 }

-static int
-sg_ioctl(struct inode *inode, struct file *filp,
-	 unsigned int cmd_in, unsigned long arg)
+static long
+sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
-	int result, val, read_only;
+	int result, val, read_only, error;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	Sg_request *srp;
 	unsigned long iflags;

-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
-		return -ENXIO;
+	lock_kernel();
+
+	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp))) {
+		error = -ENXIO;
+		goto out;
+	}
 	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
 				   sdp->disk->disk_name, (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
@@ -802,57 +805,80 @@ sg_ioctl(struct inode *inode, struct fil
 		{
 			int blocking = 1;	/* ignore O_NONBLOCK flag */

-			if (sdp->detached)
-				return -ENODEV;
-			if (!scsi_block_when_processing_errors(sdp->device))
-				return -ENXIO;
-			if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
-				return -EFAULT;
+			if (sdp->detached) {
+				error = -ENODEV;
+				goto out;
+			}
+			if (!scsi_block_when_processing_errors(sdp->device)) {
+				error = -ENXIO;
+				goto out;
+			}
+			if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR)) {
+				error = -EFAULT;
+				goto out;
+			}
 			result =
 			    sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
 					 blocking, read_only, &srp);
-			if (result < 0)
-				return result;
+			if (result < 0) {
+				error = result;
+				goto out;
+			}
 			srp->sg_io_owned = 1;
 			while (1) {
 				result = 0;	/* following macro to beat race condition */
 				__wait_event_interruptible(sfp->read_wait,
 					(sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
 							   result);
-				if (sdp->detached)
-					return -ENODEV;
-				if (sfp->closed)
-					return 0;	/* request packet dropped already */
+				if (sdp->detached) {
+					error = -ENODEV;
+					goto out;
+				}
+				if (sfp->closed) {
+					error = 0;	/* request packet dropped already */
+					goto out;
+				}
 				if (0 == result)
 					break;
 				srp->orphan = 1;
-				return result;	/* -ERESTARTSYS because signal hit process */
+
+				error = result;	/* -ERESTARTSYS because signal hit process */
+				goto out;
 			}
 			write_lock_irqsave(&sfp->rq_list_lock, iflags);
 			srp->done = 2;
 			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
-			return (result < 0) ? result : 0;
+			error = (result < 0) ? result : 0;
+			goto out;
 		}
 	case SG_SET_TIMEOUT:
 		result = get_user(val, ip);
-		if (result)
-			return result;
-		if (val < 0)
-			return -EIO;
+		if (result) {
+			error = result;
+			goto out;
+		}
+		if (val < 0) {
+			error = -EIO;
+			goto out;
+		}
 		if (val >= MULDIV (INT_MAX, USER_HZ, HZ))
 		    val = MULDIV (INT_MAX, USER_HZ, HZ);
 		sfp->timeout_user = val;
 		sfp->timeout = MULDIV (val, HZ, USER_HZ);

-		return 0;
+		error = 0;
+		goto out;
 	case SG_GET_TIMEOUT:	/* N.B. User receives timeout as return value */
 				/* strange ..., for backward compatibility */
-		return sfp->timeout_user;
+		error = sfp->timeout_user;
+		goto out;
 	case SG_SET_FORCE_LOW_DMA:
 		result = get_user(val, ip);
-		if (result)
-			return result;
+		if (result) {
+			error = result;
+			goto out;
+		}
 		if (val) {
 			sfp->low_dma = 1;
 			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
@@ -861,21 +887,29 @@ sg_ioctl(struct inode *inode, struct fil
 				sg_build_reserve(sfp, val);
 			}
 		} else {
-			if (sdp->detached)
-				return -ENODEV;
+			if (sdp->detached) {
+				error = -ENODEV;
+				goto out;
+			}
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
 		}
-		return 0;
+		error = 0;
+		goto out;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
+		error = put_user((int) sfp->low_dma, ip);
+		goto out;
 	case SG_GET_SCSI_ID:
-		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
-			return -EFAULT;
+		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t))) {
+			error = -EFAULT;
+			goto out;
+		}
 		else {
 			sg_scsi_id_t __user *sg_idp = p;

-			if (sdp->detached)
-				return -ENODEV;
+			if (sdp->detached) {
+				error = -ENODEV;
+				goto out;
+			}
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
 			__put_user((int) sdp->device->channel,
@@ -889,29 +923,37 @@ sg_ioctl(struct inode *inode, struct fil
 				   &sg_idp->d_queue_depth);
 			__put_user(0, &sg_idp->unused[0]);
 			__put_user(0, &sg_idp->unused[1]);
-			return 0;
+			error = 0;
+			goto out;
 		}
 	case SG_SET_FORCE_PACK_ID:
 		result = get_user(val, ip);
 		if (result)
-			return result;
-		sfp->force_packid = val ? 1 : 0;
-		return 0;
+			error = result;
+		else {
+			sfp->force_packid = val ? 1 : 0;
+			error = 0;
+		}
+		goto out;
 	case SG_GET_PACK_ID:
-		if (!access_ok(VERIFY_WRITE, ip, sizeof (int)))
-			return -EFAULT;
+		if (!access_ok(VERIFY_WRITE, ip, sizeof (int))) {
+			error = -EFAULT;
+			goto out;
+		}
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		for (srp = sfp->headrp; srp; srp = srp->nextrp) {
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
 				__put_user(srp->header.pack_id, ip);
-				return 0;
+				error = 0;
+				goto out;
 			}
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 		__put_user(-1, ip);
-		return 0;
+		error = 0;
+		goto out;
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		for (val = 0, srp = sfp->headrp; srp; srp = srp->nextrp) {
@@ -919,67 +961,94 @@ sg_ioctl(struct inode *inode, struct fil
 				++val;
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-		return put_user(val, ip);
+		error = put_user(val, ip);
+		goto out;
 	case SG_GET_SG_TABLESIZE:
-		return put_user(sdp->sg_tablesize, ip);
+		error = put_user(sdp->sg_tablesize, ip);
+		goto out;
 	case SG_SET_RESERVED_SIZE:
 		result = get_user(val, ip);
-		if (result)
-			return result;
-                if (val < 0)
-                        return -EINVAL;
+		if (result) {
+			error = result;
+			goto out;
+		}
+		if (val < 0) {
+			error = -EINVAL;
+			goto out;
+		}
 		val = min_t(int, val,
 				sdp->device->request_queue->max_sectors * 512);
 		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
-				return -EBUSY;
+			if (sg_res_in_use(sfp) || sfp->mmap_called) {
+				error = -EBUSY;
+				goto out;
+			}
 			sg_remove_scat(&sfp->reserve);
 			sg_build_reserve(sfp, val);
 		}
-		return 0;
+		error = 0;
+		goto out;
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
 				sdp->device->request_queue->max_sectors * 512);
-		return put_user(val, ip);
+		error = put_user(val, ip);
+		goto out;
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
 		if (result)
-			return result;
-		sfp->cmd_q = val ? 1 : 0;
-		return 0;
+			error = result;
+		else {
+			sfp->cmd_q = val ? 1 : 0;
+			error = 0;
+		}
+		goto out;
 	case SG_GET_COMMAND_Q:
-		return put_user((int) sfp->cmd_q, ip);
+		error = put_user((int) sfp->cmd_q, ip);
+		goto out;
 	case SG_SET_KEEP_ORPHAN:
 		result = get_user(val, ip);
 		if (result)
-			return result;
-		sfp->keep_orphan = val;
-		return 0;
+			error = result;
+		else {
+			sfp->keep_orphan = val;
+			error = 0;
+		}
+		goto out;
 	case SG_GET_KEEP_ORPHAN:
-		return put_user((int) sfp->keep_orphan, ip);
+		error = put_user((int) sfp->keep_orphan, ip);
+		goto out;
 	case SG_NEXT_CMD_LEN:
 		result = get_user(val, ip);
 		if (result)
-			return result;
-		sfp->next_cmd_len = (val > 0) ? val : 0;
-		return 0;
+			error = result;
+		else {
+			sfp->next_cmd_len = (val > 0) ? val : 0;
+			error = 0;
+		}
+		goto out;
 	case SG_GET_VERSION_NUM:
-		return put_user(sg_version_num, ip);
+		error = put_user(sg_version_num, ip);
+		goto out;
 	case SG_GET_ACCESS_COUNT:
 		/* faked - we don't have a real access count anymore */
 		val = (sdp->device ? 1 : 0);
-		return put_user(val, ip);
+		error = put_user(val, ip);
+		goto out;
 	case SG_GET_REQUEST_TABLE:
-		if (!access_ok(VERIFY_WRITE, p, SZ_SG_REQ_INFO * SG_MAX_QUEUE))
-			return -EFAULT;
+		if (!access_ok(VERIFY_WRITE, p, SZ_SG_REQ_INFO * SG_MAX_QUEUE)) {
+			error = -EFAULT;
+			goto out;
+		}
 		else {
 			sg_req_info_t *rinfo;
 			unsigned int ms;

 			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
 								GFP_KERNEL);
-			if (!rinfo)
-				return -ENOMEM;
+			if (!rinfo) {
+				error = -ENOMEM;
+				goto out;
+			}
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
 			     ++val, srp = srp ? srp->nextrp : srp) {
@@ -1013,25 +1082,38 @@ sg_ioctl(struct inode *inode, struct fil
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result = result ? -EFAULT : 0;
 			kfree(rinfo);
-			return result;
+			error = result;
+			goto out;
 		}
 	case SG_EMULATED_HOST:
 		if (sdp->detached)
-			return -ENODEV;
-		return put_user(sdp->device->host->hostt->emulated, ip);
+			error = -ENODEV;
+		else
+			error = put_user(sdp->device->host->hostt->emulated, ip);
+		goto out;
 	case SG_SCSI_RESET:
-		if (sdp->detached)
-			return -ENODEV;
+		if (sdp->detached) {
+			error = -ENODEV;
+			goto out;
+		}
 		if (filp->f_flags & O_NONBLOCK) {
-			if (scsi_host_in_recovery(sdp->device->host))
-				return -EBUSY;
-		} else if (!scsi_block_when_processing_errors(sdp->device))
-			return -EBUSY;
+			if (scsi_host_in_recovery(sdp->device->host)) {
+				error = -EBUSY;
+				goto out;
+			}
+		} else if (!scsi_block_when_processing_errors(sdp->device)) {
+			error = -EBUSY;
+			goto out;
+		}
 		result = get_user(val, ip);
-		if (result)
-			return result;
-		if (SG_SCSI_RESET_NOTHING == val)
-			return 0;
+		if (result) {
+			error = result;
+			goto out;
+		}
+		if (SG_SCSI_RESET_NOTHING == val) {
+			error = 0;
+			goto out;
+		}
 		switch (val) {
 		case SG_SCSI_RESET_DEVICE:
 			val = SCSI_TRY_RESET_DEVICE;
@@ -1046,57 +1128,81 @@ sg_ioctl(struct inode *inode, struct fil
 			val = SCSI_TRY_RESET_HOST;
 			break;
 		default:
-			return -EINVAL;
+			error = -EINVAL;
+			goto out;
 		}
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return (scsi_reset_provider(sdp->device, val) ==
-			SUCCESS) ? 0 : -EIO;
+			error = -EACCES;
+		else
+			error = (scsi_reset_provider(sdp->device, val) == SUCCESS) ? 0 : -EIO;
+		goto out;
 	case SCSI_IOCTL_SEND_COMMAND:
-		if (sdp->detached)
-			return -ENODEV;
+		if (sdp->detached) {
+			error = -ENODEV;
+			goto out;
+		}
 		if (read_only) {
 			unsigned char opcode = WRITE_6;
 			Scsi_Ioctl_Command __user *siocp = p;

-			if (copy_from_user(&opcode, siocp->data, 1))
-				return -EFAULT;
-			if (!blk_verify_command(filp, &opcode))
-				return -EPERM;
+			if (copy_from_user(&opcode, siocp->data, 1)) {
+				error = -EFAULT;
+				goto out;
+			}
+			if (!blk_verify_command(filp, &opcode)) {
+				error = -EPERM;
+				goto out;
+			}
 		}
-		return sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
+		error = sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
+		goto out;
 	case SG_SET_DEBUG:
 		result = get_user(val, ip);
 		if (result)
-			return result;
-		sdp->sgdebug = (char) val;
-		return 0;
+			error = result;
+		else {
+			sdp->sgdebug = (char) val;
+			error = 0;
+		}
+		goto out;
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
 		if (sdp->detached)
-			return -ENODEV;
-		return scsi_ioctl(sdp->device, cmd_in, p);
+			error = -ENODEV;
+		else
+			error = scsi_ioctl(sdp->device, cmd_in, p);
+		goto out;
 	case BLKSECTGET:
-		return put_user(sdp->device->request_queue->max_sectors * 512,
-				ip);
+		error = put_user(sdp->device->request_queue->max_sectors * 512, ip);
+		goto out;
 	case BLKTRACESETUP:
-		return blk_trace_setup(sdp->device->request_queue,
-				       sdp->disk->disk_name,
-				       sdp->device->sdev_gendev.devt,
-				       (char *)arg);
+		error = blk_trace_setup(sdp->device->request_queue,
+					sdp->disk->disk_name,
+					sdp->device->sdev_gendev.devt,
+					(char *)arg);
+		goto out;
 	case BLKTRACESTART:
-		return blk_trace_startstop(sdp->device->request_queue, 1);
+		error = blk_trace_startstop(sdp->device->request_queue, 1);
+		goto out;
 	case BLKTRACESTOP:
-		return blk_trace_startstop(sdp->device->request_queue, 0);
+		error =	blk_trace_startstop(sdp->device->request_queue, 0);
+		goto out;
 	case BLKTRACETEARDOWN:
-		return blk_trace_remove(sdp->device->request_queue);
+		error = blk_trace_remove(sdp->device->request_queue);
+		goto out;
 	default:
 		if (read_only)
-			return -EPERM;	/* don't know so take safe approach */
-		return scsi_ioctl(sdp->device, cmd_in, p);
+			error = -EPERM;	/* don't know so take safe approach */
+		else
+			error = scsi_ioctl(sdp->device, cmd_in, p);
+		goto out;
 	}
+
+out:
+	unlock_kernel();
+	return error;
 }

 #ifdef CONFIG_COMPAT
@@ -1342,7 +1448,7 @@ static struct file_operations sg_fops =
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.ioctl = sg_ioctl,
+	.unlocked_ioctl = sg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
