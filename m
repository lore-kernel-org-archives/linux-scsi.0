From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: Re: [PATCH] 2.4.21 fix race condition in sg.c
Date: Fri, 27 Jun 2003 09:52:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002901c33cb3$4b262730$e0019d89@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:7438 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S264281AbTF0Nhw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 09:37:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: marcelo@conectiva.com.br, alan@lxorguk.ukuu.org.uk
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

Marcelo & Alan:

This patch against 2.4.21 fixes a race condition in the SCSI generic driver.
It has been approved by Doug Gilbert for inclusion.  A similar fix is also
needed for 2.5, although I don't have the 2.5 source tree available to make
a patch.

Note: I have added smp_wmb() since the last time I sent this patch.  I think
it is necessary for 100% correctness.

Anthony J. Battersby
Cybernetics

--- drivers/scsi/sg.c.orig	Fri Jun 13 10:51:36 2003
+++ drivers/scsi/sg.c	Fri Jun 27 09:27:40 2003
@@ -1241,7 +1241,6 @@
     SRpnt->sr_request.rq_dev = MKDEV(0, 0);  /* "sg" _disowns_ request blk */
 
     srp->my_cmdp = NULL;
-    srp->done = 1;
     read_unlock(&sg_dev_arr_lock);
 
     SCSI_LOG_TIMEOUT(4, printk("sg...bh: dev=%d, pack_id=%d, res=0x%x\n",
@@ -1274,6 +1273,9 @@
     }
     /* Rely on write phase to clean out srp status values, so no "else" */
 
+    smp_wmb();
+    srp->done = 1;
+
     scsi_release_request(SRpnt);
     SRpnt = NULL;
     if (sfp->closed) { /* whoops this fd already released, cleanup */

