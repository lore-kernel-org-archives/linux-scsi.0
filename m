From: Yum Rayan <yum.rayan@gmail.com>
Subject: Re: [PATCH] Reduce stack usage in sg.c
Date: Fri, 25 Mar 2005 00:20:07 -0800
Message-ID: <df35dfeb05032500201480039e@mail.gmail.com>
References: <df35dfeb05032200034d3ab10c@mail.gmail.com>
	 <4240E8D5.4080602@osdl.org>
Reply-To: Yum Rayan <yum.rayan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.207]:51666 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261538AbVCYIUH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 03:20:07 -0500
Received: by wproxy.gmail.com with SMTP id 71so717740wri
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2005 00:20:07 -0800 (PST)
In-Reply-To: <4240E8D5.4080602@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com, james.bottomley@steeleye.com

> Mostly looks OK to me.  However, I would rather see patches
> against the current -bk instead of 2.6.x.y.

Point noted. Dug around for info on BK. Cloned
http://linux.bkbits.net/linux-2.6 and updated with pull from
bk://linux-scsi.bkbits.net/scsi-misc-2.6. Generated bk patch with -hdu
option. Hope this new little BK grasshoper got it right :)

> This patch section looks suspect to me:
> Notice that the second '+' sign begins an illegal construct,
> probably missing an 'if' line or 2.
> Or the '+' should be '-'.
> 
> >               while (1) {
> > -                     res = 0;        /* following is a macro that beats race condition */
> > +                     res = 0; /* following macro beats race condition */
> >                       __wait_event_interruptible(sfp->read_wait,
> > -                             (sdp->detached || (srp = sg_get_rq_mark(sfp, req_pack_id))),
> > -                                                res);
> > -                     if (sdp->detached)
> > -                             return -ENODEV;
> > +                             (sdp->detached ||
> > +                             (srp = sg_get_rq_mark(sfp, req_pack_id))),
> > +                              res);
> > +                     if (sdp->detached) {

I adjusted long lines in and around my changes to fit in 80 column
editor. The second "+" is not a statement but the second argument of
the __wait_event_interruptible macro. So this is verified good.

Reworked patch follows.

Regards,
Rayan

Summary: Reduce stack usage in sg_read() and sg_ioctl()
Signed-off-by: Yum Rayan <yum.rayan@gmail.com>

diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	2005-03-24 00:36:05 -08:00
+++ b/drivers/scsi/sg.c	2005-03-24 00:36:05 -08:00
@@ -330,14 +330,13 @@
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 {
-	int res;
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	Sg_request *srp;
 	int req_pack_id = -1;
-	struct sg_header old_hdr;
-	sg_io_hdr_t new_hdr;
+	struct sg_header *old_hdr;
 	sg_io_hdr_t *hp;
+	int retval = 0;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -345,99 +344,131 @@
 				   sdp->disk->disk_name, (int) count));
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
+	old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
+	if (!old_hdr)
+		return -ENOMEM;
 	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
-			return -EFAULT;
-		if (old_hdr.reply_len < 0) {
+		if (__copy_from_user(old_hdr, buf, SZ_SG_HEADER)) {
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
+				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
+				if (!new_hdr) {
+					retval = -ENOMEM;
+					goto free_old_hdr;
+				}
+				retval =__copy_from_user
+				    (new_hdr, buf, SZ_SG_IO_HDR);
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
+			retval = 0; /* following macro beats race condition */
 			__wait_event_interruptible(sfp->read_wait,
-				(sdp->detached || (srp = sg_get_rq_mark(sfp, req_pack_id))), 
-						   res);
-			if (sdp->detached)
-				return -ENODEV;
-			if (0 == res)
+				(sdp->detached ||
+				(srp = sg_get_rq_mark(sfp, req_pack_id))), 
+				retval);
+			if (sdp->detached) {
+				retval = -ENODEV;
+				goto free_old_hdr;
+			}
+			if (0 == retval)
 				break;
-			return res;	/* -ERESTARTSYS because signal hit process */
+
+			/* -ERESTARTSYS as signal hit process */
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
-			if ((res =
-			     sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)))
-				return -EFAULT;
+			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
+				retval = -EFAULT;
+				goto free_old_hdr;
+			}
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
@@ -937,8 +968,11 @@
 		if (!access_ok(VERIFY_WRITE, p, SZ_SG_REQ_INFO * SG_MAX_QUEUE))
 			return -EFAULT;
 		else {
-			sg_req_info_t rinfo[SG_MAX_QUEUE];
-			Sg_request *srp;
+			sg_req_info_t *rinfo;
+			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
+								GFP_KERNEL);
+			if (!rinfo)
+				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
 			     ++val, srp = srp ? srp->nextrp : srp) {
@@ -954,14 +988,20 @@
 					    jiffies_to_msecs(
 						jiffies - srp->header.duration);
 					rinfo[val].orphan = srp->orphan;
-					rinfo[val].sg_io_owned = srp->sg_io_owned;
-					rinfo[val].pack_id = srp->header.pack_id;
-					rinfo[val].usr_ptr = srp->header.usr_ptr;
+					rinfo[val].sg_io_owned =
+							srp->sg_io_owned;
+					rinfo[val].pack_id =
+							srp->header.pack_id;
+					rinfo[val].usr_ptr =
+							srp->header.usr_ptr;
 				}
 			}
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			return (__copy_to_user(p, rinfo,
-			        SZ_SG_REQ_INFO * SG_MAX_QUEUE) ? -EFAULT : 0);
+			result = __copy_to_user(p, rinfo, 
+						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
+			result = result ? -EFAULT : 0;
+			kfree(rinfo);
+			return result;
 		}
 	case SG_EMULATED_HOST:
 		if (sdp->detached)
