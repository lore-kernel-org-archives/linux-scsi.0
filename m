From: Douglas Gilbert <dougg@torque.net>
Subject: [2.6 patch] drivers/scsi/sg.c: several against 2.6.12-rc1
Date: Mon, 28 Mar 2005 19:48:10 +1000
Message-ID: <4247D2DA.5010009@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020508090707070007080108"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:62617 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261481AbVC1JvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 04:51:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bunk@stusta.de, yum.rayan@gmail.com, James.Bottomley@SteelEye.com, rddunlap@osdl.org

This is a multi-part message in MIME format.
--------------020508090707070007080108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attachment combines the most recent patch from
Yum Rayan <yum.rayan@gmail.com> (to reduce sg stack
usage), Adrian Bunk <bunk@stusta.de> (to fix check
after use) and me (fix elapsed time calculation
(duration) on ia64 machines).

I have modified the patch from Yum Rayan so kmalloc()
in sg_read() is only called for the (rare) code paths
that need them.

Changelog:
   - reduce stack usage in sg_ioctl() and sg_read()
   - fix check after use in sg_mmap()
   - hold duration internally in milliseconds and
     check current time later than held time

Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------020508090707070007080108
Content-Type: text/x-patch;
 name="sg2612rc1a1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2612rc1a1.diff"

--- linux/drivers/scsi/sg.c	2005-03-19 11:38:32.000000000 +1000
+++ linux/drivers/scsi/sg.c2612rc1a1	2005-03-28 12:16:58.000000000 +1000
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30532;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.32"
+static int sg_version_num = 30533;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.33"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -60,7 +60,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050117";
+static char *sg_version_date = "20050328";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
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
 	sg_io_hdr_t *hp;
+	struct sg_header *old_hdr = NULL;
+	int retval = 0;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
@@ -346,98 +345,138 @@
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
-			return -EFAULT;
-		if (old_hdr.reply_len < 0) {
+		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
+		if (!old_hdr)
+			return -ENOMEM;
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
+	if (old_hdr == NULL) {
+		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
+		if (! old_hdr) {
+			retval = -ENOMEM;
+			goto free_old_hdr;
+		}
+	}
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
+	if (old_hdr)
+		kfree(old_hdr);
+	return retval;
 }
 
 static ssize_t
@@ -724,7 +763,7 @@
 	srp->data.sglist_len = 0;
 	srp->data.bufflen = 0;
 	srp->data.buffer = NULL;
-	hp->duration = jiffies;	/* unit jiffies now, millisecs after done */
+	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
 	scsi_do_req(SRpnt, (void *) cmnd,
@@ -937,8 +976,13 @@
 		if (!access_ok(VERIFY_WRITE, p, SZ_SG_REQ_INFO * SG_MAX_QUEUE))
 			return -EFAULT;
 		else {
-			sg_req_info_t rinfo[SG_MAX_QUEUE];
-			Sg_request *srp;
+			sg_req_info_t *rinfo;
+			unsigned int ms;
+
+			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
+								GFP_KERNEL);
+			if (!rinfo)
+				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
 			     ++val, srp = srp ? srp->nextrp : srp) {
@@ -949,19 +993,30 @@
 					    srp->header.masked_status & 
 					    srp->header.host_status & 
 					    srp->header.driver_status;
-					rinfo[val].duration =
-					    srp->done ? srp->header.duration :
-					    jiffies_to_msecs(
-						jiffies - srp->header.duration);
+					if (srp->done)
+						rinfo[val].duration =
+							srp->header.duration;
+					else {
+						ms = jiffies_to_msecs(jiffies);
+						rinfo[val].duration =
+						    (ms > srp->header.duration) ?
+						    (ms - srp->header.duration) : 0;
+					}
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
@@ -1208,11 +1263,12 @@
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	Sg_fd *sfp;
-	unsigned long req_sz = vma->vm_end - vma->vm_start;
+	unsigned long req_sz;
 	Sg_scatter_hold *rsv_schp;
 
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
+	req_sz = vma->vm_end - vma->vm_start;
 	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
 				   (void *) vma->vm_start, (int) req_sz));
 	if (vma->vm_pgoff)
@@ -1259,6 +1315,7 @@
 	Sg_fd *sfp;
 	Sg_request *srp = NULL;
 	unsigned long iflags;
+	unsigned int ms;
 
 	if (SCpnt && (SRpnt = SCpnt->sc_request))
 		srp = (Sg_request *) SRpnt->upper_private_data;
@@ -1295,9 +1352,9 @@
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
 		sdp->disk->disk_name, srp->header.pack_id, (int) SRpnt->sr_result));
 	srp->header.resid = SCpnt->resid;
-	/* N.B. unit of duration changes here from jiffies to millisecs */
-	srp->header.duration =
-	    jiffies_to_msecs(jiffies - srp->header.duration);
+	ms = jiffies_to_msecs(jiffies);
+	srp->header.duration = (ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
 	if (0 != SRpnt->sr_result) {
 		struct scsi_sense_hdr sshdr;
 
@@ -2395,7 +2452,7 @@
 	}
 	if (resp) {
 		resp->nextrp = NULL;
-		resp->header.duration = jiffies;
+		resp->header.duration = jiffies_to_msecs(jiffies);
 		resp->my_cmdp = NULL;
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
@@ -2990,6 +3047,7 @@
 	Sg_fd *fp;
 	const sg_io_hdr_t *hp;
 	const char * cp;
+	unsigned int ms;
 
 	for (k = 0; (fp = sg_get_nth_sfp(sdp, k)); ++k) {
 		seq_printf(s, "   FD(%d): timeout=%dms bufflen=%d "
@@ -3028,10 +3086,13 @@
 				   srp->header.pack_id, blen);
 			if (srp->done)
 				seq_printf(s, " dur=%d", hp->duration);
-			else
+			else {
+				ms = jiffies_to_msecs(jiffies);
 				seq_printf(s, " t_o/elap=%d/%d",
-				  new_interface ? hp->timeout : jiffies_to_msecs(fp->timeout),
-				  jiffies_to_msecs(hp->duration ? (jiffies - hp->duration) : 0));
+					(new_interface ? hp->timeout :
+						  jiffies_to_msecs(fp->timeout)),
+					(ms > hp->duration ? ms - hp->duration : 0));
+			}
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
 		}

--------------020508090707070007080108--
