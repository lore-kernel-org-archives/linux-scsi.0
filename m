From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] complete version of rework of queueing with no outstanding
 commands assumptions
Date: Tue, 01 Oct 2002 19:17:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210012317.g91NHH706634@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_19072929400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA02687
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 16:17:21 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id QAA02550
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 16:17:19 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g91NHH706634
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 19:17:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_19072929400
Content-Type: text/plain; charset=us-ascii

This version rolls the ability to queue a command even if the host has none 
outstanding with:

- queuecommand can now say whether it wants the entire host stalled (the 
default and the old behaviour) or if it just wants the device stalled
- countdown limits for host_busy and device_busy are now in the relevant 
scsi_host and scsi_device structures (scsi_host->max_host_blocked is taken 
from the host template)
- I've rolled BUSY status handling.  Now if a device returns BUSY and it has 
no outstanding commands, we stall the device for a while (if it does have 
outstanding commands, we behave the same as for QUEUE_FULL).

This should hopefully fix two of the outstanding annoying issues in the scsi 
mid-layer.

It survived a full -j 8 kernel compile here with my host adapter driver 
randomly throwing host blocked and device blocked returns (and also returning 
BUSY status) with no other outstanding commands.

James


--==_Exmh_19072929400
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.664   -> 1.668  
#	drivers/scsi/scsi_error.c	1.15    -> 1.16   
#	drivers/scsi/hosts.c	1.10    -> 1.13   
#	 drivers/scsi/scsi.h	1.20    -> 1.21   
#	drivers/scsi/hosts.h	1.13    -> 1.15   
#	drivers/scsi/scsi_lib.c	1.30    -> 1.33   
#	 drivers/scsi/scsi.c	1.37    -> 1.39   
#	drivers/scsi/scsi_scan.c	1.21    -> 1.22   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/10/01	jejb@mulgrave.(none)	1.665
# [PATCH] first cut at fixing unable to requeue with no outstanding
#  commands
# 
# The attached represents an attempt to break the scsi mid-layer of the 
# assumption that any device can queue at least one command.
# 
# What essentially happens if the host rejects a command with no other 
# outstanding commands, it does a very crude countdown (basically counts the 
# number of cycles through the scsi request function) until the device gets 
# enabled again when the count reaches zero.  I think the iteration in the 
# request function is better than a fixed timer because it makes the system more 
# responsive to I/O pressure (and also, it's easier to code).
# 
# I've tested this by making a SCSI driver artificially reject commands with 
# none outstanding (and run it on my root device).  A value of seven seems to 
# cause a delay of between half and five seconds before the host starts up again 
# (depending on the I/O load).
# 
# If this approach looks acceptable, I plan the following enhancements
# 
# 1. Make device_busy count down in the same fashion
# 2. give ->queuecommand() a two value return (one for blocking the entire host 
# and another for just blocking the device).
# 3. Make the countdown tuneable from the host template.
# --------------------------------------------
# 02/10/01	jejb@mulgrave.(none)	1.666
# [PATCH] remove mid-layer assumption that devices must be able to queue at least one command
# 
# This allows the request_fn() to recover properly from either host_blocked
# or device_blocked at zero command depth.
# 
# Also adds the facility for queuecommand() to tell us whether it wants
# the host or only the device blocked
# --------------------------------------------
# 02/10/01	jejb@mulgrave.(none)	1.667
# [PATCH SCSI] make BUSY status stall the device for a while
# --------------------------------------------
# 02/10/01	jejb@mulgrave.(none)	1.668
# [SCSI] remove debugging from zero depth queue handling
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/hosts.c	Tue Oct  1 18:37:33 2002
@@ -209,8 +209,9 @@
     retval->ehandler = NULL;    /* Initial value until the thing starts up. */
     retval->eh_notify   = NULL;    /* Who we notify when we exit. */
 
+    retval->max_host_blocked = tpnt->max_host_blocked ? tpnt->max_host_blocked : SCSI_DEFAULT_HOST_BLOCKED;
 
-    retval->host_blocked = FALSE;
+    retval->host_blocked = 0;
     retval->host_self_blocked = FALSE;
 
 #ifdef DEBUG
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/hosts.h	Tue Oct  1 18:37:33 2002
@@ -297,6 +297,19 @@
      */
     char *proc_name;
 
+    /*
+     * countdown for host blocking with no commands outstanding
+     */
+    unsigned int max_host_blocked;
+
+    /*
+     * Default value for the blocking.  If the queue is empty, host_blocked
+     * counts down in the request_fn until it restarts host operations as
+     * zero is reached.  
+     *
+     * FIXME: This should probably be a value in the template */
+    #define SCSI_DEFAULT_HOST_BLOCKED	7
+
 } Scsi_Host_Template;
 
 /*
@@ -395,11 +408,6 @@
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
@@ -417,6 +425,16 @@
      */
     unsigned some_device_starved:1;
    
+    /*
+     * Host has rejected a command because it was busy.
+     */
+    unsigned int host_blocked;
+
+    /*
+     * Value host_blocked counts down from
+     */
+    unsigned int max_host_blocked;
+
     void (*select_queue_depths)(struct Scsi_Host *, Scsi_Device *);
 
     /*
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/scsi.c	Tue Oct  1 18:37:33 2002
@@ -622,19 +622,9 @@
 	 * possibly work anyways.
 	 */
 	if (reason == SCSI_MLQUEUE_HOST_BUSY) {
-		if (host->host_busy == 0) {
-			if (scsi_retry_command(cmd) == 0) {
-				return 0;
-			}
-		}
-		host->host_blocked = TRUE;
+		host->host_blocked = host->max_host_blocked;
 	} else {
-		if (cmd->device->device_busy == 0) {
-			if (scsi_retry_command(cmd) == 0) {
-				return 0;
-			}
-		}
-		cmd->device->device_blocked = TRUE;
+                cmd->device->device_blocked = cmd->device->max_device_blocked;
 	}
 
 	/*
@@ -793,7 +783,7 @@
 			spin_unlock_irqrestore(host->host_lock, flags);
 			if (rtn != 0) {
 				scsi_delete_timer(SCpnt);
-				scsi_mlqueue_insert(SCpnt, SCSI_MLQUEUE_HOST_BUSY);
+				scsi_mlqueue_insert(SCpnt, rtn == SCSI_MLQUEUE_DEVICE_BUSY ? rtn : SCSI_MLQUEUE_HOST_BUSY);
 				SCSI_LOG_MLQUEUE(3,
 				   printk("queuecommand : request rejected\n"));                                
 			}
@@ -1396,8 +1386,8 @@
          * for both the queue full condition on a device, and for a
          * host full condition on the host.
          */
-        host->host_blocked = FALSE;
-        device->device_blocked = FALSE;
+        host->host_blocked = 0;
+        device->device_blocked = 0;
 
 	/*
 	 * If we have valid sense information, then some kind of recovery
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/scsi.h	Tue Oct  1 18:37:33 2002
@@ -611,11 +611,17 @@
 				 * this device */
 	unsigned expecting_cc_ua:1;	/* Expecting a CHECK_CONDITION/UNIT_ATTN
 					 * because we did a bus reset. */
-	unsigned device_blocked:1;	/* Device returned QUEUE_FULL. */
 	unsigned ten:1;		/* support ten byte read / write */
 	unsigned remap:1;	/* support remapping  */
 	unsigned starved:1;	/* unable to process commands because
 				   host busy */
+
+	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
+
+	unsigned int max_device_blocked; /* what device_blocked counts down from  */
+  	/* default value if the device doesn't override */
+	#define SCSI_DEFAULT_DEVICE_BLOCKED	3
+
 
 	// Flag to allow revalidate to succeed in sd_open
 	int allow_revalidate;
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/scsi_error.c	Tue Oct  1 18:37:33 2002
@@ -1341,6 +1341,13 @@
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.
 		 */
+	case BUSY:
+		/*
+		 * device can't talk to us at the moment.  Should only
+		 * occur (SAM-3) when the task queue is empty, so will cause
+		 * the empty queue handling to trigger a stall in the
+		 * device.
+		 */
 		return ADD_TO_MLQUEUE;
 	case GOOD:
 	case COMMAND_TERMINATED:
@@ -1358,8 +1365,6 @@
 		 * who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
-	case BUSY:
-		goto maybe_retry;
 
 	case RESERVATION_CONFLICT:
 		printk("scsi%d (%d,%d,%d) : reservation conflict\n", 
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/scsi_lib.c	Tue Oct  1 18:37:33 2002
@@ -754,6 +754,24 @@
 		if (SHpnt->in_recovery || blk_queue_plugged(q))
 			return;
 
+		if(SHpnt->host_busy == 0 && SHpnt->host_blocked) {
+			/* unblock after host_blocked iterates to zero */
+			if(--SHpnt->host_blocked == 0) {
+				SCSI_LOG_MLQUEUE(3, printk("scsi%d unblocking host at zero depth\n", SHpnt->host_no));
+			} else {
+				blk_plug_device(q);
+				break;
+			}
+		}
+		if(SDpnt->device_busy == 0 && SDpnt->device_blocked) {
+			/* unblock after device_blocked iterates to zero */
+			if(--SDpnt->device_blocked == 0) {
+				SCSI_LOG_MLQUEUE(3, printk("scsi%d (%d:%d) unblocking device at zero depth\n", SHpnt->host_no, SDpnt->id, SDpnt->lun));
+			} else {
+				blk_plug_device(q);
+				break;
+			}
+		}
 		/*
 		 * If the device cannot accept another request, then quit.
 		 */
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Tue Oct  1 18:37:33 2002
+++ b/drivers/scsi/scsi_scan.c	Tue Oct  1 18:37:33 2002
@@ -1461,6 +1461,10 @@
 	if (*bflags & BLIST_SINGLELUN)
 		sdev->single_lun = 1;
 
+	/* if the device needs this changing, it may do so in the detect
+	 * function */
+	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
+
 	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
 		if (sdt->detect)
 			sdev->attached += (*sdt->detect) (sdev);

--==_Exmh_19072929400--


