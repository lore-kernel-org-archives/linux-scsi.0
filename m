From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: improve logic and efficiecy of media-change detection
Date: Tue, 7 Sep 2010 11:44:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1009071142100.1848-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54366 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757281Ab0IGPoB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 11:44:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1415) improves the formerly incomprehensible logic in
sd_media_changed() (the current code refers to "changed" as a state,
whereas in fact it is a relation between two states).  It also adds a
big comment so that everyone can understand what is really going on.

The patch also improves efficiency by not reporting a media change
when no medium was ever present.  If no medium was present the last
time we checked and there's still no medium, it's not necessary to
tell the caller that a change occurred.  Doing so merely causes the
caller to attempt to revalidate a non-existent disk, which is a waste
of time.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -561,7 +561,7 @@ static int sd_prep_fn(struct request_que
 		 * quietly refuse to do anything to a changed disc until 
 		 * the changed bit has been reset
 		 */
-		/* printk("SCSI disk has been changed. Prohibiting further I/O.\n"); */
+		/* printk("SCSI disk has been changed or is not present. Prohibiting further I/O.\n"); */
 		goto out;
 	}
 
@@ -1001,7 +1001,6 @@ static int sd_media_changed(struct gendi
 	 */
 	if (!scsi_device_online(sdp)) {
 		set_media_not_present(sdkp);
-		retval = 1;
 		goto out;
 	}
 
@@ -1032,7 +1031,6 @@ static int sd_media_changed(struct gendi
 		       /* 0x3a is medium not present */
 		       sshdr->asc == 0x3a)) {
 		set_media_not_present(sdkp);
-		retval = 1;
 		goto out;
 	}
 
@@ -1043,12 +1041,27 @@ static int sd_media_changed(struct gendi
 	 */
 	sdkp->media_present = 1;
 
-	retval = sdp->changed;
-	sdp->changed = 0;
 out:
-	if (retval != sdkp->previous_state)
+	/*
+	 * Report a media change under the following conditions:
+	 *
+	 *	Medium is present now and wasn't present before.
+	 *	Medium wasn't present before and is present now.
+	 *	Medium was present at all times, but it changed while
+	 *		we weren't looking (sdp->changed is set).
+	 *
+	 * If there was no medium before and there is no medium now then
+	 * don't report a change, even if a medium was inserted and removed
+	 * while we weren't looking.
+	 */
+	retval = (sdkp->media_present != sdkp->previous_state ||
+			(sdkp->media_present && sdp->changed));
+	if (retval)
 		sdev_evt_send_simple(sdp, SDEV_EVT_MEDIA_CHANGE, GFP_KERNEL);
-	sdkp->previous_state = retval;
+	sdkp->previous_state = sdkp->media_present;
+
+	/* sdp->changed indicates medium was changed or is not present */
+	sdp->changed = !sdkp->media_present;
 	kfree(sshdr);
 	return retval;
 }

