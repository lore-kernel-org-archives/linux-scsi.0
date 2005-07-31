From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394/sbp2: fix for hot-unplug
Date: Mon, 1 Aug 2005 00:57:56 +0200 (CEST)
Message-ID: <200507312258.j6VMvw6B007691@einhorn.in-berlin.de>
References: <20050731191658.GC19681@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49638 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S262027AbVGaXBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 19:01:05 -0400
In-Reply-To: <20050731191658.GC19681@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

When a FireWire CD-ROM or RBC harddisk was detached, the ieee1394
subsystem and probably the scsi subsystem was locked up. The fix
unblocks the sbp2 host before attempting to remove scsi devices.
Commands from scsi highlevel are no longer blocked, but rather
completed with DID_NO_CONNECT when the FireWire node was detached.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Index: sbp2.c
===================================================================
--- sbp2.c	(revision 1316)
+++ sbp2.c	(working copy)
@@ -637,8 +637,11 @@
 	scsi_id = ud->device.driver_data;
 
 	/* Trigger shutdown functions in scsi's highlevel. */
-	if (scsi_id && scsi_id->sdev)
+	if (scsi_id) {
+		BUG_ON(!scsi_id->scsi_host || !scsi_id->sdev);
+		scsi_unblock_requests(scsi_id->scsi_host);
 		scsi_remove_device(scsi_id->sdev);
+	}
 
 	sbp2_logout_device(scsi_id);
 	sbp2_remove_device(scsi_id);
@@ -2310,6 +2313,7 @@
 	struct scsi_id_instance_data *scsi_id =
 		(struct scsi_id_instance_data *)SCpnt->device->host->hostdata[0];
 	struct sbp2scsi_host_info *hi;
+	int result = DID_NO_CONNECT << 16;
 
 	SBP2_DEBUG("sbp2scsi_queuecommand");
 
@@ -2317,30 +2321,28 @@
 	 * If scsi_id is null, it means there is no device in this slot,
 	 * so we should return selection timeout.
 	 */
-	if (!scsi_id) {
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done (SCpnt);
-		return 0;
-	}
+	if (!scsi_id)
+		goto done;
 
+	/*
+	 * Node was detached.
+	 */
+	if (scsi_id->ne->in_limbo)
+		goto done;
+
 	hi = scsi_id->hi;
 
 	if (!hi) {
 		SBP2_ERR("sbp2scsi_host_info is NULL - this is bad!");
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done (SCpnt);
-		return(0);
+		goto done;
 	}
 
 	/*
 	 * Until we handle multiple luns, just return selection time-out
 	 * to any IO directed at non-zero LUNs
 	 */
-	if (SCpnt->device->lun) {
-		SCpnt->result = DID_NO_CONNECT << 16;
-		done (SCpnt);
-		return(0);
-	}
+	if (SCpnt->device->lun)
+		goto done;
 
 	/*
 	 * Check for request sense command, and handle it here
@@ -2351,7 +2353,7 @@
 		memcpy(SCpnt->request_buffer, SCpnt->sense_buffer, SCpnt->request_bufflen);
 		memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
 		sbp2scsi_complete_command(scsi_id, SBP2_SCSI_STATUS_GOOD, SCpnt, done);
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -2359,9 +2361,8 @@
 	 */
 	if (!hpsb_node_entry_valid(scsi_id->ne)) {
 		SBP2_ERR("Bus reset in progress - rejecting command");
-		SCpnt->result = DID_BUS_BUSY << 16;
-		done (SCpnt);
-		return(0);
+		result = DID_BUS_BUSY << 16;
+		goto done;
 	}
 
 	/*
@@ -2372,8 +2373,12 @@
 		sbp2scsi_complete_command(scsi_id, SBP2_SCSI_STATUS_SELECTION_TIMEOUT,
 					  SCpnt, done);
 	}
+	return 0;
 
-	return(0);
+done:
+	SCpnt->result = result;
+	done(SCpnt);
+	return 0;
 }
 
 /*

