From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] fix race condition in sg.c
Date: Mon, 1 Nov 2004 18:02:12 -0500
Message-ID: <04Nov1.180150est.332955@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:41485 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S289804AbUKAXWI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2004 18:22:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Marcelo Tosatti' <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, coughlan@redhat.com

This patch fixes a command completion race condition in the SCSI generic
driver.  There are several variations of this patch floating around:

#1: Original patch from me:
http://marc.theaimsgroup.com/?t=105664088400001&r=1&w=2

#2: Better patch from Brian King for lk 2.6.x:
http://marc.theaimsgroup.com/?t=107843139000002&r=1&w=2

#3: Patch for a related problem from Brian King for lk 2.6.x:
http://marc.theaimsgroup.com/?t=108636397100004&r=1&w=2

#4: Port of combined #2 and #3 to lk 2.4.x from Tom Coughlan:
http://marc.theaimsgroup.com/?t=109657360500004&r=1&w=2

#5: Correction of #4 by me:
http://marc.theaimsgroup.com/?l=linux-scsi&m=109658140509138&w=2

None of these fixes have made it into lk 2.4.x yet.  Below is a port of patch
#2 to 2.4.x which has been extensively tested by my company.  Patch #5 which
includes these changes would be better, but I haven't tested it.  Please
apply this patch, and the additional changes for patch #5 can be merged later
if and when they are tested by those interested.

--- linux-2.4.28-pre2-vanilla/drivers/scsi/sg.c	Thu Aug 26 14:33:30 2004
+++ linux-2.4.28-pre2-asp/drivers/scsi/sg.c	Thu Aug 26 14:41:29 2004
@@ -1253,7 +1253,6 @@
     SRpnt->sr_request.rq_dev = MKDEV(0, 0);  /* "sg" _disowns_ request blk */
 
     srp->my_cmdp = NULL;
-    srp->done = 1;
     read_unlock(&sg_dev_arr_lock);
 
     SCSI_LOG_TIMEOUT(4, printk("sg...bh: dev=%d, pack_id=%d, res=0x%x\n",
@@ -1316,8 +1315,9 @@
     }
     if (sfp && srp) {
 	/* Now wake up any sg_read() that is waiting for this packet. */
-	wake_up_interruptible(&sfp->read_wait);
 	kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+	srp->done = 1;
+	wake_up_interruptible(&sfp->read_wait);
     }
 }
 

Anthony J. Battersby
Cybernetics

