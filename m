From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v4] sg: O_EXCL and other lock handling
Date: Fri, 13 Jun 2014 16:18:42 -0400
Message-ID: <539B5CA2.2050005@interlog.com>
References: <539A453F.5020502@interlog.com> <20140613090316.GA18032@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020203050208090507070201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40400 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbaFMUSt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 16:18:49 -0400
In-Reply-To: <20140613090316.GA18032@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, vaughan <vaughan.cao@oracle.com>

This is a multi-part message in MIME format.
--------------020203050208090507070201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 14-06-13 05:03 AM, Christoph Hellwig wrote:
> Hi Doug,
>
> this looks generally good to me, but I don't think open_cnt and exclude
> have to use atomic_t, as they are only ever modified under open_rel_lock.
>
> Can you take a look at the version below?  This changes open_cnt to an
> int, exclude to a bool, removes the open_cnt underflow check that
> the VFS takes care for, and streamlines the open path a little bit:

As a follow-up attached is a first cut of replacing the locks
around sg_request::done with an atomic. It assumes the patch
from Christoph earlier in this thread. The interesting part is
the removal of the write lock in the completion part of the
SG_IO ioctl.

Testing ongoing.

Doug Gilbert


--------------020203050208090507070201
Content-Type: text/x-patch;
 name="sg_done_atomic1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_done_atomic1.patch"

--- a/drivers/scsi/sg.c	2014-06-13 09:39:54.962003585 -0400
+++ b/drivers/scsi/sg.c	2014-06-13 13:11:49.796632281 -0400
@@ -138,7 +138,7 @@ typedef struct sg_request {	/* SG_MAX_QU
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	/* done protected by rq_list_lock */
-	char done;		/* 0->before bh, 1->before read, 2->read */
+	atomic_t done;		/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
 	struct execute_work ew;
@@ -809,17 +809,6 @@ sg_common_write(Sg_fd * sfp, Sg_request
 	return 0;
 }
 
-static int srp_done(Sg_fd *sfp, Sg_request *srp)
-{
-	unsigned long flags;
-	int ret;
-
-	read_lock_irqsave(&sfp->rq_list_lock, flags);
-	ret = srp->done;
-	read_unlock_irqrestore(&sfp->rq_list_lock, flags);
-	return ret;
-}
-
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -851,16 +840,17 @@ sg_ioctl(struct file *filp, unsigned int
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
-			(srp_done(sfp, srp) || atomic_read(&sdp->detaching)));
+				(atomic_read(&srp->done) ||
+				 atomic_read(&sdp->detaching)));
 		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
-		write_lock_irq(&sfp->rq_list_lock);
-		if (srp->done) {
-			srp->done = 2;
-			write_unlock_irq(&sfp->rq_list_lock);
+		if (likely(atomic_add_unless(&srp->done, 1, 0))) {
+			/* srp->done bumped from 1 to 2 which is expected */
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
 			return (result < 0) ? result : 0;
 		}
+		/* here if srp->done was 0, abnormal */
+		write_lock_irq(&sfp->rq_list_lock);
 		srp->orphan = 1;
 		write_unlock_irq(&sfp->rq_list_lock);
 		return result;	/* -ERESTARTSYS because signal hit process */
@@ -932,7 +922,8 @@ sg_ioctl(struct file *filp, unsigned int
 			return -EFAULT;
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		for (srp = sfp->headrp; srp; srp = srp->nextrp) {
-			if ((1 == srp->done) && (!srp->sg_io_owned)) {
+			if ((1 == atomic_read(&srp->done)) &&
+			    (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
 				__put_user(srp->header.pack_id, ip);
@@ -945,7 +936,8 @@ sg_ioctl(struct file *filp, unsigned int
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		for (val = 0, srp = sfp->headrp; srp; srp = srp->nextrp) {
-			if ((1 == srp->done) && (!srp->sg_io_owned))
+			if ((1 == atomic_read(&srp->done)) &&
+			    (!srp->sg_io_owned))
 				++val;
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
@@ -1015,12 +1007,13 @@ sg_ioctl(struct file *filp, unsigned int
 			     ++val, srp = srp ? srp->nextrp : srp) {
 				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
 				if (srp) {
-					rinfo[val].req_state = srp->done + 1;
+					rinfo[val].req_state =
+						atomic_read(&srp->done) + 1;
 					rinfo[val].problem =
-					    srp->header.masked_status & 
-					    srp->header.host_status & 
-					    srp->header.driver_status;
-					if (srp->done)
+						srp->header.masked_status & 
+						srp->header.host_status & 
+						srp->header.driver_status;
+					if (atomic_read(&srp->done))
 						rinfo[val].duration =
 							srp->header.duration;
 					else {
@@ -1173,7 +1166,8 @@ sg_poll(struct file *filp, poll_table *
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
 	for (srp = sfp->headrp; srp; srp = srp->nextrp) {
 		/* if any read waiting, flag it */
-		if ((0 == res) && (1 == srp->done) && (!srp->sg_io_owned))
+		if ((0 == res) && (1 == atomic_read(&srp->done)) &&
+		    (!srp->sg_io_owned))
 			res = POLLIN | POLLRDNORM;
 		++count;
 	}
@@ -1303,7 +1297,7 @@ sg_rq_end_io(struct request *rq, int upt
 	char *sense;
 	int result, resid, done = 1;
 
-	if (WARN_ON(srp->done != 0))
+	if (WARN_ON(atomic_read(&srp->done) != 0))
 		return;
 
 	sfp = srp->parentfp;
@@ -1318,8 +1312,8 @@ sg_rq_end_io(struct request *rq, int upt
 	result = rq->errors;
 	resid = rq->resid_len;
 
-	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
-		sdp->disk->disk_name, srp->header.pack_id, result));
+	SCSI_LOG_TIMEOUT(4, printk("%s: %s, pack_id=%d, res=0x%x\n",
+		__func__, sdp->disk->disk_name, srp->header.pack_id, result));
 	srp->header.resid = resid;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
@@ -1358,7 +1352,7 @@ sg_rq_end_io(struct request *rq, int upt
 		else
 			done = 0;
 	}
-	srp->done = done;
+	atomic_set(&srp->done, done);
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
@@ -1999,9 +1993,10 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	for (resp = sfp->headrp; resp; resp = resp->nextrp) {
 		/* look for requests that are ready + not SG_IO owned */
-		if ((1 == resp->done) && (!resp->sg_io_owned) &&
+		if ((1 == atomic_read(&resp->done)) && (!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
-			resp->done = 2;	/* guard against other readers */
+			/* guard against other readers */
+			atomic_set(&resp->done, 2);
 			break;
 		}
 	}
@@ -2047,6 +2042,7 @@ sg_add_request(Sg_fd * sfp)
 	if (resp) {
 		resp->nextrp = NULL;
 		resp->header.duration = jiffies_to_msecs(jiffies);
+		atomic_set(&resp->done, 0);
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return resp;
@@ -2556,7 +2552,7 @@ static int sg_proc_seq_show_devstrs(stru
 /* must be called while holding sg_index_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
-	int k, m, new_interface, blen, usg;
+	int k, m, new_interface, blen, usg, done;
 	Sg_request *srp;
 	Sg_fd *fp;
 	const sg_io_hdr_t *hp;
@@ -2596,12 +2592,12 @@ static void sg_proc_debug_helper(struct
 			seq_puts(s, cp);
 			blen = srp->data.bufflen;
 			usg = srp->data.k_use_sg;
-			seq_puts(s, srp->done ?
-				 ((1 == srp->done) ?  "rcv:" : "fin:")
-				  : "act:");
+			done = atomic_read(&srp->done);
+			seq_puts(s, done ?  ((1 == done) ?  "rcv:" : "fin:")
+					 : "act:");
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
-			if (srp->done)
+			if (done)
 				seq_printf(s, " dur=%d", hp->duration);
 			else {
 				ms = jiffies_to_msecs(jiffies);

--------------020203050208090507070201--
