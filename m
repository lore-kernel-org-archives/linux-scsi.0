From: Andre Noll <maan@systemlinux.org>
Subject: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Date: Thu, 10 Jan 2008 19:05:29 +0100
Message-ID: <20080110180529.GA32640@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759805AbYAJSGa@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Richard Knutsson <ricknu-0@student.ltu.se>
List-Id: linux-scsi@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Resent with proper subject and to additional recipients]

This patch against linus-current is compile-tested on x86 and x86-64.

Please review
Andre
---

Change sg.c to use the unlocked_ioctl instead of the ioctl handler.
The patch moves the BKL into sg.c and is thus a first step to get
rid of the BKL in the scsi code.

Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f1871ea..3063307 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -48,6 +48,7 @@ static int sg_version_num =3D 30534;	/* 2 digits for each=
 component */
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/smp_lock.h>
=20
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -764,20 +765,22 @@ sg_srp_done(Sg_request *srp, Sg_fd *sfp)
 	return done;
 }
=20
-static int
-sg_ioctl(struct inode *inode, struct file *filp,
-	 unsigned int cmd_in, unsigned long arg)
+static long
+sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p =3D (void __user *)arg;
 	int __user *ip =3D p;
-	int result, val, read_only;
+	int val, read_only;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	Sg_request *srp;
 	unsigned long iflags;
+	long result;
=20
+	lock_kernel();
+	result =3D -ENXIO;
 	if ((!(sfp =3D (Sg_fd *) filp->private_data)) || (!(sdp =3D sfp->parentdp=
)))
-		return -ENXIO;
+		goto out;
 	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=3D0x%x\n",
 				   sdp->disk->disk_name, (int) cmd_in));
 	read_only =3D (O_RDWR !=3D (filp->f_flags & O_ACCMODE));
@@ -787,57 +790,66 @@ sg_ioctl(struct inode *inode, struct file *filp,
 		{
 			int blocking =3D 1;	/* ignore O_NONBLOCK flag */
=20
+			result =3D -ENODEV;
 			if (sdp->detached)
-				return -ENODEV;
+				goto out;
+			result =3D -ENXIO;
 			if (!scsi_block_when_processing_errors(sdp->device))
-				return -ENXIO;
+				goto out;
+			result =3D -EFAULT;
 			if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
-				return -EFAULT;
-			result =3D
-			    sg_new_write(sfp, p, SZ_SG_IO_HDR,
-					 blocking, read_only, &srp);
+				goto out;
+			result =3D sg_new_write(sfp, p, SZ_SG_IO_HDR, blocking,
+				read_only, &srp);
 			if (result < 0)
-				return result;
+				goto out;
 			srp->sg_io_owned =3D 1;
 			while (1) {
 				result =3D 0;	/* following macro to beat race condition */
 				__wait_event_interruptible(sfp->read_wait,
 					(sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
 							   result);
-				if (sdp->detached)
-					return -ENODEV;
+				if (sdp->detached) {
+					result =3D -ENODEV;
+					goto out;
+				}
 				if (sfp->closed)
-					return 0;	/* request packet dropped already */
+					goto out;	/* request packet dropped already */
 				if (0 =3D=3D result)
 					break;
 				srp->orphan =3D 1;
-				return result;	/* -ERESTARTSYS because signal hit process */
+				goto out;	/* -ERESTARTSYS because signal hit process */
 			}
 			write_lock_irqsave(&sfp->rq_list_lock, iflags);
 			srp->done =3D 2;
 			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result =3D sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
-			return (result < 0) ? result : 0;
+			if (result > 0)
+				result =3D 0;
+			goto out;
 		}
 	case SG_SET_TIMEOUT:
 		result =3D get_user(val, ip);
 		if (result)
-			return result;
+			goto out;
+		result =3D -EIO;
 		if (val < 0)
-			return -EIO;
-		if (val >=3D MULDIV (INT_MAX, USER_HZ, HZ))
-		    val =3D MULDIV (INT_MAX, USER_HZ, HZ);
+			goto out;
+		if (val >=3D MULDIV(INT_MAX, USER_HZ, HZ))
+			val =3D MULDIV(INT_MAX, USER_HZ, HZ);
 		sfp->timeout_user =3D val;
 		sfp->timeout =3D MULDIV (val, HZ, USER_HZ);
=20
-		return 0;
+		result =3D 0;
+		goto out;
 	case SG_GET_TIMEOUT:	/* N.B. User receives timeout as return value */
 				/* strange ..., for backward compatibility */
-		return sfp->timeout_user;
+		result =3D sfp->timeout_user;
+		goto out;
 	case SG_SET_FORCE_LOW_DMA:
 		result =3D get_user(val, ip);
 		if (result)
-			return result;
+			goto out;
 		if (val) {
 			sfp->low_dma =3D 1;
 			if ((0 =3D=3D sfp->low_dma) && (0 =3D=3D sg_res_in_use(sfp))) {
@@ -846,21 +858,26 @@ sg_ioctl(struct inode *inode, struct file *filp,
 				sg_build_reserve(sfp, val);
 			}
 		} else {
+			result =3D -ENODEV;
 			if (sdp->detached)
-				return -ENODEV;
+				goto out;
 			sfp->low_dma =3D sdp->device->host->unchecked_isa_dma;
 		}
-		return 0;
+		result =3D 0;
+		goto out;
 	case SG_GET_LOW_DMA:
-		return put_user((int) sfp->low_dma, ip);
+		result =3D put_user((int) sfp->low_dma, ip);
+		goto out;
 	case SG_GET_SCSI_ID:
+		result =3D -EFAULT;
 		if (!access_ok(VERIFY_WRITE, p, sizeof (sg_scsi_id_t)))
-			return -EFAULT;
-		else {
+			goto out;
+		{
 			sg_scsi_id_t __user *sg_idp =3D p;
=20
+			result =3D -ENODEV;
 			if (sdp->detached)
-				return -ENODEV;
+				goto out;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
 			__put_user((int) sdp->device->channel,
@@ -874,29 +891,33 @@ sg_ioctl(struct inode *inode, struct file *filp,
 				   &sg_idp->d_queue_depth);
 			__put_user(0, &sg_idp->unused[0]);
 			__put_user(0, &sg_idp->unused[1]);
-			return 0;
+			result =3D 0;
+			goto out;
 		}
 	case SG_SET_FORCE_PACK_ID:
 		result =3D get_user(val, ip);
 		if (result)
-			return result;
+			goto out;
 		sfp->force_packid =3D val ? 1 : 0;
-		return 0;
+		result =3D 0;
+		goto out;
 	case SG_GET_PACK_ID:
+		result =3D -EFAULT;
 		if (!access_ok(VERIFY_WRITE, ip, sizeof (int)))
-			return -EFAULT;
+			goto out;
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
+		result =3D 0;
 		for (srp =3D sfp->headrp; srp; srp =3D srp->nextrp) {
 			if ((1 =3D=3D srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
 				__put_user(srp->header.pack_id, ip);
-				return 0;
+				goto out;
 			}
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 		__put_user(-1, ip);
-		return 0;
+		goto out;
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		for (val =3D 0, srp =3D sfp->headrp; srp; srp =3D srp->nextrp) {
@@ -904,67 +925,76 @@ sg_ioctl(struct inode *inode, struct file *filp,
 				++val;
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-		return put_user(val, ip);
+		result =3D put_user(val, ip);
+		goto out;
 	case SG_GET_SG_TABLESIZE:
-		return put_user(sdp->sg_tablesize, ip);
+		result =3D put_user(sdp->sg_tablesize, ip);
+		goto out;
 	case SG_SET_RESERVED_SIZE:
 		result =3D get_user(val, ip);
 		if (result)
-			return result;
-                if (val < 0)
-                        return -EINVAL;
+			goto out;
+		result =3D -EINVAL;
+		if (val < 0)
+			goto out;
 		val =3D min_t(int, val,
 				sdp->device->request_queue->max_sectors * 512);
 		if (val !=3D sfp->reserve.bufflen) {
+			result =3D -EBUSY;
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
-				return -EBUSY;
+				goto out;
 			sg_remove_scat(&sfp->reserve);
 			sg_build_reserve(sfp, val);
 		}
-		return 0;
+		result =3D 0;
+		goto out;
 	case SG_GET_RESERVED_SIZE:
 		val =3D min_t(int, sfp->reserve.bufflen,
 				sdp->device->request_queue->max_sectors * 512);
-		return put_user(val, ip);
+		result =3D put_user(val, ip);
+		goto out;
 	case SG_SET_COMMAND_Q:
 		result =3D get_user(val, ip);
-		if (result)
-			return result;
-		sfp->cmd_q =3D val ? 1 : 0;
-		return 0;
+		if (!result)
+			sfp->cmd_q =3D val ? 1 : 0;
+		goto out;
 	case SG_GET_COMMAND_Q:
-		return put_user((int) sfp->cmd_q, ip);
+		result =3D put_user((int) sfp->cmd_q, ip);
+		goto out;
 	case SG_SET_KEEP_ORPHAN:
 		result =3D get_user(val, ip);
-		if (result)
-			return result;
-		sfp->keep_orphan =3D val;
-		return 0;
+		if (!result)
+			sfp->keep_orphan =3D val;
+		goto out;
 	case SG_GET_KEEP_ORPHAN:
-		return put_user((int) sfp->keep_orphan, ip);
+		result =3D put_user((int) sfp->keep_orphan, ip);
+		goto out;
 	case SG_NEXT_CMD_LEN:
 		result =3D get_user(val, ip);
-		if (result)
-			return result;
-		sfp->next_cmd_len =3D (val > 0) ? val : 0;
-		return 0;
+		if (!result)
+			sfp->next_cmd_len =3D (val > 0) ? val : 0;
+		goto out;
 	case SG_GET_VERSION_NUM:
-		return put_user(sg_version_num, ip);
+		result =3D put_user(sg_version_num, ip);
+		goto out;
 	case SG_GET_ACCESS_COUNT:
 		/* faked - we don't have a real access count anymore */
 		val =3D (sdp->device ? 1 : 0);
-		return put_user(val, ip);
+		result =3D put_user(val, ip);
+		goto out;
 	case SG_GET_REQUEST_TABLE:
+		result =3D -EFAULT;
 		if (!access_ok(VERIFY_WRITE, p, SZ_SG_REQ_INFO * SG_MAX_QUEUE))
-			return -EFAULT;
-		else {
+			goto out;
+		{
 			sg_req_info_t *rinfo;
 			unsigned int ms;
=20
 			rinfo =3D kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
 								GFP_KERNEL);
+			result =3D -ENOMEM;
 			if (!rinfo)
-				return -ENOMEM;
+				goto out;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			for (srp =3D sfp->headrp, val =3D 0; val < SG_MAX_QUEUE;
 			     ++val, srp =3D srp ? srp->nextrp : srp) {
@@ -998,25 +1028,29 @@ sg_ioctl(struct inode *inode, struct file *filp,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result =3D result ? -EFAULT : 0;
 			kfree(rinfo);
-			return result;
 		}
+		goto out;
 	case SG_EMULATED_HOST:
 		if (sdp->detached)
-			return -ENODEV;
-		return put_user(sdp->device->host->hostt->emulated, ip);
+			result =3D -ENODEV;
+		else
+			result =3D put_user(sdp->device->host->hostt->emulated, ip);
+		goto out;
 	case SG_SCSI_RESET:
+		result =3D -ENODEV;
 		if (sdp->detached)
-			return -ENODEV;
+			goto out;
+		result =3D -EBUSY;
 		if (filp->f_flags & O_NONBLOCK) {
 			if (scsi_host_in_recovery(sdp->device->host))
-				return -EBUSY;
+				goto out;
 		} else if (!scsi_block_when_processing_errors(sdp->device))
-			return -EBUSY;
+			goto out;
 		result =3D get_user(val, ip);
 		if (result)
-			return result;
+			goto out;
 		if (SG_SCSI_RESET_NOTHING =3D=3D val)
-			return 0;
+			goto out;
 		switch (val) {
 		case SG_SCSI_RESET_DEVICE:
 			val =3D SCSI_TRY_RESET_DEVICE;
@@ -1028,46 +1062,60 @@ sg_ioctl(struct inode *inode, struct file *filp,
 			val =3D SCSI_TRY_RESET_HOST;
 			break;
 		default:
-			return -EINVAL;
+			result =3D -EINVAL;
+			goto out;
 		}
+		result =3D -EACCES;
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return (scsi_reset_provider(sdp->device, val) =3D=3D
-			SUCCESS) ? 0 : -EIO;
+			goto out;
+		result =3D scsi_reset_provider(sdp->device, val) =3D=3D SUCCESS?
+			0 : -EIO;
+		goto out;
 	case SCSI_IOCTL_SEND_COMMAND:
+		result =3D -ENODEV;
 		if (sdp->detached)
-			return -ENODEV;
+			goto out;
 		if (read_only) {
 			unsigned char opcode =3D WRITE_6;
 			Scsi_Ioctl_Command __user *siocp =3D p;
=20
+			result =3D -EFAULT;
 			if (copy_from_user(&opcode, siocp->data, 1))
-				return -EFAULT;
+				goto out;
+			result =3D -EPERM;
 			if (!sg_allow_access(opcode, sdp->device->type))
-				return -EPERM;
+				goto out;
 		}
-		return sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
+		result =3D sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
+		goto out;
 	case SG_SET_DEBUG:
 		result =3D get_user(val, ip);
-		if (result)
-			return result;
-		sdp->sgdebug =3D (char) val;
-		return 0;
+		if (!result)
+			sdp->sgdebug =3D (char) val;
+		goto out;
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
+		result =3D -ENODEV;
 		if (sdp->detached)
-			return -ENODEV;
-		return scsi_ioctl(sdp->device, cmd_in, p);
+			goto out;
+		result =3D scsi_ioctl(sdp->device, cmd_in, p);
+		goto out;
 	case BLKSECTGET:
-		return put_user(sdp->device->request_queue->max_sectors * 512,
+		result =3D put_user(sdp->device->request_queue->max_sectors * 512,
 				ip);
+		goto out;
 	default:
+		result =3D -EPERM;	/* don't know so take safe approach */
 		if (read_only)
-			return -EPERM;	/* don't know so take safe approach */
-		return scsi_ioctl(sdp->device, cmd_in, p);
+			goto out;
+		result =3D scsi_ioctl(sdp->device, cmd_in, p);
+		goto out;
 	}
+out:
+	unlock_kernel();
+	return result;
 }
=20
 #ifdef CONFIG_COMPAT
@@ -1314,7 +1362,7 @@ static struct file_operations sg_fops =3D {
 	.read =3D sg_read,
 	.write =3D sg_write,
 	.poll =3D sg_poll,
-	.ioctl =3D sg_ioctl,
+	.unlocked_ioctl =3D sg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =3D sg_compat_ioctl,
 #endif
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHhl5pWto1QDEAkw8RAmWFAJ0dYgMA8Ph5m3SOdu86rBXSfPAcFgCcCQLP
UjihHBe8CDqwsGeQ4ALPrEI=
=Ad5s
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
