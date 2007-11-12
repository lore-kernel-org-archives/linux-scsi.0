From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] scsi: move single_lun flag from scsi_device to scsi_target
Date: Mon, 12 Nov 2007 10:00:44 -0500
Message-ID: <47386A9C.6050207@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:2394 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbXKLPAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 10:00:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Some SCSI tape medium changers that need the BLIST_SINGLELUN flag have
the medium changer at one LUN and the tape drive at a different LUN.
The inquiry string of the tape drive may be different from that of the
medium changer.  In order for single_lun to be effective, every
scsi_device under a given scsi_target must have it set.  This means that
there needs to be a blacklist entry for BOTH the medium changer AND the
tape drive, which is impractical because some medium changers may be
paired with a variety of different tape drive models.  It makes more
sense to put the single_lun flag in scsi_target instead of scsi_device,
which causes every device at a given target ID to inherit the single_lun
flag from one LUN.  This makes it possible to blacklist just the medium
changer and not the tape drive.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
diff -urpN linux-2.6.24-rc2-vanilla/drivers/scsi/scsi_lib.c linux-2.6.24-rc2/drivers/scsi/scsi_lib.c
--- linux-2.6.24-rc2-vanilla/drivers/scsi/scsi_lib.c	2007-11-09 16:48:57.000000000 -0500
+++ linux-2.6.24-rc2/drivers/scsi/scsi_lib.c	2007-11-09 16:54:27.000000000 -0500
@@ -524,7 +524,7 @@ static void scsi_run_queue(struct reques
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
-	if (sdev->single_lun)
+	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -1557,7 +1557,7 @@ static void scsi_request_fn(struct reque
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto not_ready;
-		if (sdev->single_lun) {
+		if (scsi_target(sdev)->single_lun) {
 			if (scsi_target(sdev)->starget_sdev_user &&
 			    scsi_target(sdev)->starget_sdev_user != sdev)
 				goto not_ready;
diff -urpN linux-2.6.24-rc2-vanilla/drivers/scsi/scsi_scan.c linux-2.6.24-rc2/drivers/scsi/scsi_scan.c
--- linux-2.6.24-rc2-vanilla/drivers/scsi/scsi_scan.c	2007-11-09 16:48:57.000000000 -0500
+++ linux-2.6.24-rc2/drivers/scsi/scsi_scan.c	2007-11-09 16:55:59.000000000 -0500
@@ -863,7 +863,7 @@ static int scsi_add_lun(struct scsi_devi
 		sdev->no_start_on_add = 1;
 
 	if (*bflags & BLIST_SINGLELUN)
-		sdev->single_lun = 1;
+		scsi_target(sdev)->single_lun = 1;
 
 	sdev->use_10_for_rw = 1;
 
diff -urpN linux-2.6.24-rc2-vanilla/include/scsi/scsi_device.h linux-2.6.24-rc2/include/scsi/scsi_device.h
--- linux-2.6.24-rc2-vanilla/include/scsi/scsi_device.h	2007-11-09 16:49:05.000000000 -0500
+++ linux-2.6.24-rc2/include/scsi/scsi_device.h	2007-11-09 16:53:43.000000000 -0500
@@ -122,9 +122,6 @@ struct scsi_device {
 	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
 	unsigned simple_tags:1;	/* simple queue tag messages are enabled */
 	unsigned ordered_tags:1;/* ordered queue tag messages are enabled */
-	unsigned single_lun:1;	/* Indicates we should only allow I/O to
-				 * one of the luns for the device at a 
-				 * time. */
 	unsigned was_reset:1;	/* There was a bus reset on the bus for 
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
@@ -202,6 +199,9 @@ struct scsi_target {
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
 	unsigned int		create:1; /* signal that it needs to be added */
+	unsigned int		single_lun:1;	/* Indicates we should only
+						 * allow I/O to one of the luns
+						 * for the device at a time. */
 	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
 						/* means no lun present */
 


