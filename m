From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [patch] 2.4 fix for sg driver cmd_done oops
Date: Mon, 04 Oct 2004 15:47:11 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4160E3DF.4010704@torque.net>
References: <04Sep30.175341edt.332209@cyborg.cybernetics.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090907000401040401040504"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:24775 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268439AbUJDFsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2004 01:48:06 -0400
In-Reply-To: <04Sep30.175341edt.332209@cyborg.cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: 'Tom Coughlan' <coughlan@redhat.com>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, petrides@redhat.com, marcelo.tosatti@cyclades.com

This is a multi-part message in MIME format.
--------------090907000401040401040504
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Tony Battersby wrote:
>>This problem has also been seen on 2.4.  The attached patch is a
>>straight-forward port of Brian's patch to 2.4.28-pre3. Are there any
>>2.4-specific issues that this does not address?
> 
> 
> Try this patch instead, which deletes one line containing "srp->done =
> 1;" compared to your patch.  The 2.6 sg.c moved this line down to fix a
> race condition and then later added the locks around it; your patch adds
> the line after it was moved but doesn't delete the original line.

Tom,
Could you confirm whether this patch from Tony fixes the
problem that you reported and if so we can ask Marcelo
to apply it.

Doug Gilbert

--------------090907000401040401040504
Content-Type: text/x-patch;
 name="sg_cmd_done_race_2.4.28-pre3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_cmd_done_race_2.4.28-pre3.patch"

--- linux-2.4.28-pre3/drivers/scsi/sg.c.orig	Thu Sep 30 17:39:10 2004
+++ linux-2.4.28-pre3/drivers/scsi/sg.c	Thu Sep 30 17:39:37 2004
@@ -752,6 +752,18 @@
     }
 }
 
+static int
+sg_srp_done(Sg_request *srp, Sg_fd *sfp)
+{
+	unsigned long iflags;
+	int done;
+
+	read_lock_irqsave(&sfp->rq_list_lock, iflags);
+	done = srp->done;
+	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return done;
+}
+
 static int sg_ioctl(struct inode * inode, struct file * filp,
                     unsigned int cmd_in, unsigned long arg)
 {
@@ -786,7 +798,8 @@
 	    while (1) {
 		result = 0;  /* following macro to beat race condition */
 		__wait_event_interruptible(sfp->read_wait,
-		       (sdp->detached || sfp->closed || srp->done), result);
+		       (sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
+					   result);
 		if (sdp->detached)
 		    return -ENODEV;
 		if (sfp->closed)
@@ -796,7 +809,9 @@
 		srp->orphan = 1;
 		return result; /* -ERESTARTSYS because signal hit process */
 	    }
+	    write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	    srp->done = 2;
+	    write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	    result = sg_new_read(sfp, (char *)arg, SZ_SG_IO_HDR, srp);
 	    return (result < 0) ? result : 0;
 	}
@@ -1207,6 +1222,7 @@
     Sg_device * sdp = NULL;
     Sg_fd * sfp;
     Sg_request * srp = NULL;
+    unsigned long iflags;
 
     read_lock(&sg_dev_arr_lock);
     if (sg_dev_arr && (dev >= 0)) {
@@ -1253,7 +1269,6 @@
     SRpnt->sr_request.rq_dev = MKDEV(0, 0);  /* "sg" _disowns_ request blk */
 
     srp->my_cmdp = NULL;
-    srp->done = 1;
     read_unlock(&sg_dev_arr_lock);
 
     SCSI_LOG_TIMEOUT(4, printk("sg...bh: dev=%d, pack_id=%d, res=0x%x\n",
@@ -1316,8 +1331,11 @@
     }
     if (sfp && srp) {
 	/* Now wake up any sg_read() that is waiting for this packet. */
-	wake_up_interruptible(&sfp->read_wait);
 	kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	srp->done = 1;
+	wake_up_interruptible(&sfp->read_wait);
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
     }
 }
 
@@ -1507,7 +1525,7 @@
 	    	tsfp = sfp->nextfp;
 		for (srp = sfp->headrp; srp; srp = tsrp) {
 		    tsrp = srp->nextrp;
-		    if (sfp->closed || (0 == srp->done))
+		    if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
 			sg_finish_rem_req(srp);
 		}
 		if (sfp->closed) {
@@ -2425,7 +2443,7 @@
 
     for (srp = sfp->headrp; srp; srp = tsrp) {
 	tsrp = srp->nextrp;
-	if (srp->done)
+	if (sg_srp_done(srp, sfp))
 	    sg_finish_rem_req(srp);
 	else
 	    ++dirty;

--------------090907000401040401040504--
