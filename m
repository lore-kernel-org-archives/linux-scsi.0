From: Tom Coughlan <coughlan@redhat.com>
Subject: [patch] 2.4 fix for sg driver cmd_done oops
Date: Thu, 30 Sep 2004 15:40:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096573241.5631.3697.camel@bianchi.boston.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6Zhn5MUBFmPGv58slrjS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36256 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S269442AbUI3Tnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 15:43:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: petrides@redhat.com, dougg@torque.net


--=-6Zhn5MUBFmPGv58slrjS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Brian King posted a patch for 2.6 that fixes a race in sg cmd_done:

http://marc.theaimsgroup.com/?l=linux-scsi&m=108636386217512&w=2

This problem has also been seen on 2.4.  The attached patch is a
straight-forward port of Brian's patch to 2.4.28-pre3. Are there any
2.4-specific issues that this does not address?

Thanks,

Tom

--=-6Zhn5MUBFmPGv58slrjS
Content-Disposition: attachment; filename=sg_cmd_done_race_2.4.28-pre3.patch
Content-Type: text/plain; name=sg_cmd_done_race_2.4.28-pre3.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

--- linux-2.4.28-pre3/drivers/scsi/sg.c.orig
+++ linux-2.4.28-pre3/drivers/scsi/sg.c
@@ -752,6 +752,18 @@ static inline unsigned sg_jif_to_ms(int 
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
@@ -786,7 +798,8 @@ static int sg_ioctl(struct inode * inode
 	    while (1) {
 		result = 0;  /* following macro to beat race condition */
 		__wait_event_interruptible(sfp->read_wait,
-		       (sdp->detached || sfp->closed || srp->done), result);
+		       (sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),
+					   result);
 		if (sdp->detached)
 		    return -ENODEV;
 		if (sfp->closed)
@@ -796,7 +809,9 @@ static int sg_ioctl(struct inode * inode
 		srp->orphan = 1;
 		return result; /* -ERESTARTSYS because signal hit process */
 	    }
+	    write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	    srp->done = 2;
+	    write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	    result = sg_new_read(sfp, (char *)arg, SZ_SG_IO_HDR, srp);
 	    return (result < 0) ? result : 0;
 	}
@@ -1207,6 +1222,7 @@ static void sg_cmd_done_bh(Scsi_Cmnd * S
     Sg_device * sdp = NULL;
     Sg_fd * sfp;
     Sg_request * srp = NULL;
+    unsigned long iflags;
 
     read_lock(&sg_dev_arr_lock);
     if (sg_dev_arr && (dev >= 0)) {
@@ -1316,8 +1332,11 @@ static void sg_cmd_done_bh(Scsi_Cmnd * S
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
 
@@ -1507,7 +1526,7 @@ static void sg_detach(Scsi_Device * scsi
 	    	tsfp = sfp->nextfp;
 		for (srp = sfp->headrp; srp; srp = tsrp) {
 		    tsrp = srp->nextrp;
-		    if (sfp->closed || (0 == srp->done))
+		    if (sfp->closed || (0 == sg_srp_done(srp, sfp)))
 			sg_finish_rem_req(srp);
 		}
 		if (sfp->closed) {
@@ -2425,7 +2444,7 @@ static int sg_remove_sfp(Sg_device * sdp
 
     for (srp = sfp->headrp; srp; srp = tsrp) {
 	tsrp = srp->nextrp;
-	if (srp->done)
+	if (sg_srp_done(srp, sfp))
 	    sg_finish_rem_req(srp);
 	else
 	    ++dirty;

--=-6Zhn5MUBFmPGv58slrjS--

