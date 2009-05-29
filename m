From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/6] SCSI: eliminate scsi_target_reap_usercontext()
Date: Fri, 29 May 2009 16:06:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905291554030.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40240 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757261AbZE2UGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 16:06:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1247) simplifies the SCSI target implementation.  Since
scsi_target_reap() is always called in process context, there's no
need to run any part of it in a workqueue.  The patch merges
scsi_target_reap_usercontext() in with scsi_target_reap().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -248,7 +248,6 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
-	struct execute_work	ew;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -466,16 +466,6 @@ static struct scsi_target *scsi_alloc_ta
 	goto retry;
 }
 
-static void scsi_target_reap_usercontext(struct work_struct *work)
-{
-	struct scsi_target *starget =
-		container_of(work, struct scsi_target, ew.work);
-
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	scsi_target_destroy(starget);
-}
-
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  * @starget: target to be checked
@@ -502,11 +492,11 @@ void scsi_target_reap(struct scsi_target
 
 	BUG_ON(state == STARGET_DEL);
 	starget->state = STARGET_DEL;
-	if (state == STARGET_CREATED)
-		scsi_target_destroy(starget);
-	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+	if (state == STARGET_RUNNING) {
+		transport_remove_device(&starget->dev);
+		device_del(&starget->dev);
+	}
+	scsi_target_destroy(starget);
 }
 
 /**


