From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] first cut at fixing unable to requeue with no outstanding
 commands
Date: Mon, 30 Sep 2002 17:06:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209302106.g8UL6ab29262@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_10991490980"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA09221
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 14:06:42 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id OAA08985
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 14:06:39 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g8UL6ab29262
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2002 17:06:39 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_10991490980
Content-Type: text/plain; charset=us-ascii

The attached represents an attempt to break the scsi mid-layer of the 
assumption that any device can queue at least one command.

What essentially happens if the host rejects a command with no other 
outstanding commands, it does a very crude countdown (basically counts the 
number of cycles through the scsi request function) until the device gets 
enabled again when the count reaches zero.  I think the iteration in the 
request function is better than a fixed timer because it makes the system more 
responsive to I/O pressure (and also, it's easier to code).

I've tested this by making a SCSI driver artificially reject commands with 
none outstanding (and run it on my root device).  A value of seven seems to 
cause a delay of between half and five seconds before the host starts up again 
(depending on the I/O load).

If this approach looks acceptable, I plan the following enhancements

1. Make device_busy count down in the same fashion
2. give ->queuecommand() a two value return (one for blocking the entire host 
and another for just blocking the device).
3. Make the countdown tuneable from the host template.

James



--==_Exmh_10991490980
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== hosts.c 1.9 vs edited =====
--- 1.9/drivers/scsi/hosts.c	Tue Jun 11 15:43:08 2002
+++ edited/hosts.c	Mon Sep 30 15:29:56 2002
@@ -210,7 +210,7 @@
     retval->eh_notify   = NULL;    /* Who we notify when we exit. */
 
 
-    retval->host_blocked = FALSE;
+    retval->host_blocked = 0;
     retval->host_self_blocked = FALSE;
 
 #ifdef DEBUG
===== hosts.h 1.12 vs edited =====
--- 1.12/drivers/scsi/hosts.h	Sun Jul 21 03:55:49 2002
+++ edited/hosts.h	Mon Sep 30 15:25:53 2002
@@ -395,11 +395,6 @@
     unsigned use_blk_tcq:1;
 
     /*
-     * Host has rejected a command because it was busy.
-     */
-    unsigned host_blocked:1;
-
-    /*
      * Host has requested that no further requests come through for the
      * time being.
      */
@@ -417,6 +412,19 @@
      */
     unsigned some_device_starved:1;
    
+    /*
+     * Host has rejected a command because it was busy.
+     */
+    unsigned int host_blocked;
+
+    /*
+     * Initial value for the blocking.  If the queue is empty, host_blocked
+     * counts down in the request_fn until it restarts host operations as
+     * zero is reached.  
+     *
+     * FIXME: This should probably be a value in the template */
+    #define SCSI_START_HOST_BLOCKED	7
+
     void (*select_queue_depths)(struct Scsi_Host *, Scsi_Device *);
 
     /*
===== scsi.c 1.36 vs edited =====
--- 1.36/drivers/scsi/scsi.c	Fri Sep 20 00:40:42 2002
+++ edited/scsi.c	Mon Sep 30 15:26:41 2002
@@ -643,7 +643,7 @@
 				return 0;
 			}
 		}
-		host->host_blocked = TRUE;
+		host->host_blocked = SCSI_START_HOST_BLOCKED;
 	} else {
 		if (cmd->device->device_busy == 0) {
 			if (scsi_retry_command(cmd) == 0) {
@@ -1443,7 +1443,7 @@
          * for both the queue full condition on a device, and for a
          * host full condition on the host.
          */
-        host->host_blocked = FALSE;
+        host->host_blocked = 0;
         device->device_blocked = FALSE;
 
 	/*
===== scsi_lib.c 1.30 vs edited =====
--- 1.30/drivers/scsi/scsi_lib.c	Wed Sep 18 11:36:10 2002
+++ edited/scsi_lib.c	Mon Sep 30 15:33:00 2002
@@ -754,6 +754,16 @@
 		if (SHpnt->in_recovery || blk_queue_plugged(q))
 			return;
 
+		if(SHpnt->host_busy == 0 && SHpnt->host_blocked) {
+			/* unblock after host_blocked iterates to zero */
+			if(--SHpnt->host_blocked == 0) {
+				printk("scsi%d unblocking host at zero depth\n", SHpnt->host_no);
+			} else {
+				blk_plug_device(q);
+				break;
+			}
+		}
+				
 		/*
 		 * If the device cannot accept another request, then quit.
 		 */

--==_Exmh_10991490980--


