From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [patch] 2.4 fix for sg driver cmd_done oops
Date: Thu, 30 Sep 2004 17:53:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Sep30.175341edt.332209@cyborg.cybernetics.com>
References: <1096573241.5631.3697.camel@bianchi.boston.redhat.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_004D_01C4A716.6E64DEC0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:2320 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S269535AbUI3Vxo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 17:53:44 -0400
In-Reply-To: <1096573241.5631.3697.camel@bianchi.boston.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: 'Tom Coughlan' <coughlan@redhat.com>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>
Cc: petrides@redhat.com, dougg@torque.net

This is a multi-part message in MIME format.

------=_NextPart_000_004D_01C4A716.6E64DEC0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

> This problem has also been seen on 2.4.  The attached patch is a
> straight-forward port of Brian's patch to 2.4.28-pre3. Are there any
> 2.4-specific issues that this does not address?

Try this patch instead, which deletes one line containing "srp->done =
1;" compared to your patch.  The 2.6 sg.c moved this line down to fix a
race condition and then later added the locks around it; your patch adds
the line after it was moved but doesn't delete the original line.

Anthony J. Battersby
Cybernetics

------=_NextPart_000_004D_01C4A716.6E64DEC0
Content-Type: application/octet-stream;
	name="sg_cmd_done_race_2.4.28-pre3.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="sg_cmd_done_race_2.4.28-pre3.patch"

--- linux-2.4.28-pre3/drivers/scsi/sg.c.orig	Thu Sep 30 17:39:10 2004=0A=
+++ linux-2.4.28-pre3/drivers/scsi/sg.c	Thu Sep 30 17:39:37 2004=0A=
@@ -752,6 +752,18 @@=0A=
     }=0A=
 }=0A=
 =0A=
+static int=0A=
+sg_srp_done(Sg_request *srp, Sg_fd *sfp)=0A=
+{=0A=
+	unsigned long iflags;=0A=
+	int done;=0A=
+=0A=
+	read_lock_irqsave(&sfp->rq_list_lock, iflags);=0A=
+	done =3D srp->done;=0A=
+	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);=0A=
+	return done;=0A=
+}=0A=
+=0A=
 static int sg_ioctl(struct inode * inode, struct file * filp,=0A=
                     unsigned int cmd_in, unsigned long arg)=0A=
 {=0A=
@@ -786,7 +798,8 @@=0A=
 	    while (1) {=0A=
 		result =3D 0;  /* following macro to beat race condition */=0A=
 		__wait_event_interruptible(sfp->read_wait,=0A=
-		       (sdp->detached || sfp->closed || srp->done), result);=0A=
+		       (sdp->detached || sfp->closed || sg_srp_done(srp, sfp)),=0A=
+					   result);=0A=
 		if (sdp->detached)=0A=
 		    return -ENODEV;=0A=
 		if (sfp->closed)=0A=
@@ -796,7 +809,9 @@=0A=
 		srp->orphan =3D 1;=0A=
 		return result; /* -ERESTARTSYS because signal hit process */=0A=
 	    }=0A=
+	    write_lock_irqsave(&sfp->rq_list_lock, iflags);=0A=
 	    srp->done =3D 2;=0A=
+	    write_unlock_irqrestore(&sfp->rq_list_lock, iflags);=0A=
 	    result =3D sg_new_read(sfp, (char *)arg, SZ_SG_IO_HDR, srp);=0A=
 	    return (result < 0) ? result : 0;=0A=
 	}=0A=
@@ -1207,6 +1222,7 @@=0A=
     Sg_device * sdp =3D NULL;=0A=
     Sg_fd * sfp;=0A=
     Sg_request * srp =3D NULL;=0A=
+    unsigned long iflags;=0A=
 =0A=
     read_lock(&sg_dev_arr_lock);=0A=
     if (sg_dev_arr && (dev >=3D 0)) {=0A=
@@ -1253,7 +1269,6 @@=0A=
     SRpnt->sr_request.rq_dev =3D MKDEV(0, 0);  /* "sg" _disowns_ =
request blk */=0A=
 =0A=
     srp->my_cmdp =3D NULL;=0A=
-    srp->done =3D 1;=0A=
     read_unlock(&sg_dev_arr_lock);=0A=
 =0A=
     SCSI_LOG_TIMEOUT(4, printk("sg...bh: dev=3D%d, pack_id=3D%d, =
res=3D0x%x\n",=0A=
@@ -1316,8 +1331,11 @@=0A=
     }=0A=
     if (sfp && srp) {=0A=
 	/* Now wake up any sg_read() that is waiting for this packet. */=0A=
-	wake_up_interruptible(&sfp->read_wait);=0A=
 	kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);=0A=
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);=0A=
+	srp->done =3D 1;=0A=
+	wake_up_interruptible(&sfp->read_wait);=0A=
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);=0A=
     }=0A=
 }=0A=
 =0A=
@@ -1507,7 +1525,7 @@=0A=
 	    	tsfp =3D sfp->nextfp;=0A=
 		for (srp =3D sfp->headrp; srp; srp =3D tsrp) {=0A=
 		    tsrp =3D srp->nextrp;=0A=
-		    if (sfp->closed || (0 =3D=3D srp->done))=0A=
+		    if (sfp->closed || (0 =3D=3D sg_srp_done(srp, sfp)))=0A=
 			sg_finish_rem_req(srp);=0A=
 		}=0A=
 		if (sfp->closed) {=0A=
@@ -2425,7 +2443,7 @@=0A=
 =0A=
     for (srp =3D sfp->headrp; srp; srp =3D tsrp) {=0A=
 	tsrp =3D srp->nextrp;=0A=
-	if (srp->done)=0A=
+	if (sg_srp_done(srp, sfp))=0A=
 	    sg_finish_rem_req(srp);=0A=
 	else=0A=
 	    ++dirty;=0A=

------=_NextPart_000_004D_01C4A716.6E64DEC0--

