From: Yum Rayan <yum.rayan@gmail.com>
Subject: [PATCH] Reduce stack usage in sg.c
Date: Tue, 22 Mar 2005 00:03:42 -0800
Message-ID: <df35dfeb05032200034d3ab10c@mail.gmail.com>
Reply-To: Yum Rayan <yum.rayan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.205]:13012 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262544AbVCVIDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 03:03:42 -0500
Received: by wproxy.gmail.com with SMTP id 70so1654244wra
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 00:03:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, dgilbert@interlog.com, james.bottomley@steeleye.com

Attempt to reduce stack usage in sg.c.

Used checkstack.pl script to measure stack usage and noted follows:

Before patch:
sg_ioctl - 412
sg_read - 200

After patch:
sg_ioctl - 92
sg_read -  96

Thanks,
Rayan

Signed-off-by: Yum Rayan <yum.rayan@gmail.com>

diff -Nur linux-2.6.11.5.orig/drivers/scsi/sg.c linux-2.6.11.5/drivers/scsi/sg.c
--- linux-2.6.11.5.orig/drivers/scsi/sg.c	2005-03-18 22:34:56.000000000 -0800
+++ linux-2.6.11.5/drivers/scsi/sg.c	2005-03-21 23:48:52.000000000 -0800
@@ -335,109 +335,143 @@
 	Sg_fd *sfp;
 	Sg_request *srp;
 	int req_pack_id = -1;
-	struct sg_header old_hdr;
-	sg_io_hdr_t new_hdr;
+	struct sg_header *old_hdr;
 	sg_io_hdr_t *hp;
+	int retval = 0;
+	
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
-	if ((k = verify_area(VERIFY_WRITE, buf, count)))
-		return k;
+	old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
+	if (!old_hdr)
+		return -ENOMEM;
+	if ((k = verify_area(VERIFY_WRITE, buf, count))) {
+		retval = k;
+		goto free_old_hdr;
+	}
 	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
-			return -EFAULT;
-		if (old_hdr.reply_len < 0) {
+		if (__copy_from_user(old_hdr, buf, SZ_SG_HEADER)){
+			retval = -EFAULT;
+			goto free_old_hdr;
+		}
+		if (old_hdr->reply_len < 0) {
 			if (count >= SZ_SG_IO_HDR) {
-				if (__copy_from_user
-				    (&new_hdr, buf, SZ_SG_IO_HDR))
-					return -EFAULT;
-				req_pack_id = new_hdr.pack_id;
+				sg_io_hdr_t *new_hdr;
+				new_hdr = kmalloc(SZ_SG_IO_HDR,	GFP_KERNEL);
+				if (!new_hdr) {
+					retval = -ENOMEM;
+					goto free_old_hdr;
+				}
+				retval = __copy_from_user(new_hdr, buf,
+								SZ_SG_IO_HDR);
+				req_pack_id = new_hdr->pack_id;
+				kfree(new_hdr);
+				if (retval) {
+					retval = -EFAULT;
+					goto free_old_hdr;
+				}
 			}
 		} else
-			req_pack_id = old_hdr.pack_id;
+			req_pack_id = old_hdr->pack_id;
 	}
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (sdp->detached)
-			return -ENODEV;
-		if (filp->f_flags & O_NONBLOCK)
-			return -EAGAIN;
+		if (sdp->detached) {
+			retval = -ENODEV;
+			goto free_old_hdr;
+		}
+		if (filp->f_flags & O_NONBLOCK) {
+			retval = -EAGAIN;
+			goto free_old_hdr;
+		}
 		while (1) {
-			res = 0;	/* following is a macro that beats race condition */
+			res = 0; /* following macro beats race condition */
 			__wait_event_interruptible(sfp->read_wait,
-				(sdp->detached || (srp = sg_get_rq_mark(sfp, req_pack_id))), 
-						   res);
-			if (sdp->detached)
-				return -ENODEV;
+				(sdp->detached ||
+				(srp = sg_get_rq_mark(sfp, req_pack_id))), 
+				 res);
+			if (sdp->detached) {
+				retval = -ENODEV;
+				goto free_old_hdr;
+			}
 			if (0 == res)
 				break;
-			return res;	/* -ERESTARTSYS because signal hit process */
+			retval = res; /* -ERESTARTSYS as signal hit process */
+			goto free_old_hdr;
 		}
 	}
-	if (srp->header.interface_id != '\0')
-		return sg_new_read(sfp, buf, count, srp);
+	if (srp->header.interface_id != '\0') {
+		retval = sg_new_read(sfp, buf, count, srp);
+		goto free_old_hdr;
+	}
 
 	hp = &srp->header;
-	memset(&old_hdr, 0, SZ_SG_HEADER);
-	old_hdr.reply_len = (int) hp->timeout;
-	old_hdr.pack_len = old_hdr.reply_len; /* very old, strange behaviour */
-	old_hdr.pack_id = hp->pack_id;
-	old_hdr.twelve_byte =
+	memset(old_hdr, 0, SZ_SG_HEADER);
+	old_hdr->reply_len = (int) hp->timeout;
+	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
+	old_hdr->pack_id = hp->pack_id;
+	old_hdr->twelve_byte =
 	    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
-	old_hdr.target_status = hp->masked_status;
-	old_hdr.host_status = hp->host_status;
-	old_hdr.driver_status = hp->driver_status;
+	old_hdr->target_status = hp->masked_status;
+	old_hdr->host_status = hp->host_status;
+	old_hdr->driver_status = hp->driver_status;
 	if ((CHECK_CONDITION & hp->masked_status) ||
 	    (DRIVER_SENSE & hp->driver_status))
-		memcpy(old_hdr.sense_buffer, srp->sense_b,
-		       sizeof (old_hdr.sense_buffer));
+		memcpy(old_hdr->sense_buffer, srp->sense_b,
+		       sizeof (old_hdr->sense_buffer));
 	switch (hp->host_status) {
 	/* This setup of 'result' is for backward compatibility and is best
 	   ignored by the user who should use target, host + driver status */
 	case DID_OK:
 	case DID_PASSTHROUGH:
 	case DID_SOFT_ERROR:
-		old_hdr.result = 0;
+		old_hdr->result = 0;
 		break;
 	case DID_NO_CONNECT:
 	case DID_BUS_BUSY:
 	case DID_TIME_OUT:
-		old_hdr.result = EBUSY;
+		old_hdr->result = EBUSY;
 		break;
 	case DID_BAD_TARGET:
 	case DID_ABORT:
 	case DID_PARITY:
 	case DID_RESET:
 	case DID_BAD_INTR:
-		old_hdr.result = EIO;
+		old_hdr->result = EIO;
 		break;
 	case DID_ERROR:
-		old_hdr.result = (srp->sense_b[0] == 0 && 
+		old_hdr->result = (srp->sense_b[0] == 0 && 
 				  hp->masked_status == GOOD) ? 0 : EIO;
 		break;
 	default:
-		old_hdr.result = EIO;
+		old_hdr->result = EIO;
 		break;
 	}
 
 	/* Now copy the result back to the user buffer.  */
 	if (count >= SZ_SG_HEADER) {
-		if (__copy_to_user(buf, &old_hdr, SZ_SG_HEADER))
-			return -EFAULT;
+		if (__copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
+			retval = -EFAULT;
+			goto free_old_hdr;
+		}
 		buf += SZ_SG_HEADER;
-		if (count > old_hdr.reply_len)
-			count = old_hdr.reply_len;
+		if (count > old_hdr->reply_len)
+			count = old_hdr->reply_len;
 		if (count > SZ_SG_HEADER) {
 			if ((res =
 			     sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)))
-				return -EFAULT;
+				retval = -EFAULT;
+				goto free_old_hdr;
 		}
 	} else
-		count = (old_hdr.result == 0) ? 0 : -EIO;
+		count = (old_hdr->result == 0) ? 0 : -EIO;
 	sg_finish_rem_req(srp);
-	return count;
+	retval = count;
+free_old_hdr:
+	kfree(old_hdr);
+	return retval;
 }
 
 static ssize_t
@@ -943,8 +977,11 @@
 		if (result)
 			return result;
 		else {
-			sg_req_info_t rinfo[SG_MAX_QUEUE];
-			Sg_request *srp;
+			sg_req_info_t *rinfo;
+			rinfo = kmalloc(SG_MAX_QUEUE * SZ_SG_REQ_INFO,
+								GFP_KERNEL);
+			if (!rinfo)
+				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
 			     ++val, srp = srp ? srp->nextrp : srp) {
@@ -966,8 +1003,11 @@
 				}
 			}
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			return (__copy_to_user(p, rinfo,
-			        SZ_SG_REQ_INFO * SG_MAX_QUEUE) ? -EFAULT : 0);
+			result = __copy_to_user(p, rinfo, SZ_SG_REQ_INFO *
+							SG_MAX_QUEUE);
+			result = result ? -EFAULT : 0;
+			kfree(rinfo);
+			return result;
 		}
 	case SG_EMULATED_HOST:
 		if (sdp->detached)
