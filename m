From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] 2.4.21 fix race condition in sg.c
Date: Thu, 26 Jun 2003 11:18:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002801c33bf6$24672940$e0019d89@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:62734 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261868AbTFZPD4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2003 11:03:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org

The function sg_cmd_done_bh() sets srp->done = 1 before setting other fields
to be returned to userspace (such as srp->header.resid).  This is a race
condition since other code assumes that done == 1 means that all fields to
be returned to userspace (via read()) have already been set.  I am seeing
this race condition manifest in a program that uses poll() to wait for any
one of several outstanding commands to complete.  The symptom is that every
once in a while the resid value returned for the command is 0 rather than
the correct value, since poll() showed that the command was complete and
read() returned the completion status for it before sg_cmd_done_bh() had
gotten to the line "srp->header.resid = SCpnt->resid".

This patch against 2.4.21 fixes the problem.

--- drivers/scsi/sg.c.orig	Fri Jun 13 10:51:36 2003
+++ drivers/scsi/sg.c	Thu Jun 26 11:07:28 2003
@@ -1241,7 +1241,6 @@
     SRpnt->sr_request.rq_dev = MKDEV(0, 0);  /* "sg" _disowns_ request blk
*/

     srp->my_cmdp = NULL;
-    srp->done = 1;
     read_unlock(&sg_dev_arr_lock);

     SCSI_LOG_TIMEOUT(4, printk("sg...bh: dev=%d, pack_id=%d, res=0x%x\n",
@@ -1274,6 +1273,8 @@
     }
     /* Rely on write phase to clean out srp status values, so no "else" */

+    srp->done = 1;
+
     scsi_release_request(SRpnt);
     SRpnt = NULL;
     if (sfp->closed) { /* whoops this fd already released, cleanup */

---------------

Anthony J. Battersby
Cybernetics

