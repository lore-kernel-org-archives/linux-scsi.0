From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg O_EXCL on open() lk 2.6.0-test9
Date: Mon, 17 Nov 2003 08:30:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB7FA92.8070607@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010802030601000501090707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:47109 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263189AbTKPWbB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2003 17:31:01 -0500
Received: from torque.net (d-240-244.stlucia.uq.net.au [203.101.240.244])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id hAGMUrHa014691
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2003 08:30:57 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010802030601000501090707
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

While on the subject of bugs in sg, one came
to light recently (only in lk 2.6, not lk 2.4).

Changelog:
   When detecting a locked sg device (O_EXCL) return
   -EBUSY (rather than 0) from sg_open()

Doug Gilbert

--------------010802030601000501090707
Content-Type: text/plain;
 name="sg290t9ma.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg290t9ma.diff"

--- linux/drivers/scsi/sg.c	2003-10-28 09:18:32.000000000 +1000
+++ linux/drivers/scsi/sg.c260t9ma	2003-11-14 20:15:20.000000000 +1000
@@ -243,7 +243,7 @@
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	int res;
-	int retval = -EBUSY;
+	int retval;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
@@ -270,8 +270,10 @@
 			retval = -EPERM; /* Can't lock it with read only access */
 			goto error_out;
 		}
-		if (sdp->headfp && (flags & O_NONBLOCK))
+		if (sdp->headfp && (flags & O_NONBLOCK)) {
+			retval = -EBUSY;
 			goto error_out;
+		}
 		res = 0;
 		__wait_event_interruptible(sdp->o_excl_wait,
 			((sdp->headfp || sdp->exclude) ? 0 : (sdp->exclude = 1)), res);
@@ -280,8 +282,10 @@
 			goto error_out;
 		}
 	} else if (sdp->exclude) {	/* some other fd has an exclusive lock on dev */
-		if (flags & O_NONBLOCK)
+		if (flags & O_NONBLOCK) {
+			retval = -EBUSY;
 			goto error_out;
+		}
 		res = 0;
 		__wait_event_interruptible(sdp->o_excl_wait, (!sdp->exclude),
 					   res);

--------------010802030601000501090707--

