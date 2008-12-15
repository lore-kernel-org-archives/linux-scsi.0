From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: tell the user when a disk's capacity is adjusted
Date: Mon, 15 Dec 2008 10:32:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812151031290.2525-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38487 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754381AbYLOPdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 10:33:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1188) combines the tests for decrementing a drive's
reported capacity and expands the comment.  It also adds an
informational message to the system log, informing the user when the
reported value has been changed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1384,18 +1384,22 @@ repeat:
 		sd_read_protection_type(sdkp, buffer);
 	}	
 
-	/* Some devices return the total number of sectors, not the
-	 * highest sector number.  Make the necessary adjustment. */
-	if (sdp->fix_capacity) {
+	/* Some devices are known to return the total number of blocks,
+	 * not the highest block number.  Some devices have versions
+	 * which do this and others which do not.  Some devices we might
+	 * suspect of doing this but we don't know for certain.
+	 *
+	 * If we know the reported capacity is wrong, decrement it.  If
+	 * we can only guess, then assume the number of blocks is even
+	 * (usually true but not always) and err on the side of lowering
+	 * the capacity.
+	 */
+	if (sdp->fix_capacity ||
+	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
+		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
+				"from its reported value: %llu\n",
+				(unsigned long long) sdkp->capacity);
 		--sdkp->capacity;
-
-	/* Some devices have version which report the correct sizes
-	 * and others which do not. We guess size according to a heuristic
-	 * and err on the side of lowering the capacity. */
-	} else {
-		if (sdp->guess_capacity)
-			if (sdkp->capacity & 0x01) /* odd sizes are odd */
-				--sdkp->capacity;
 	}
 
 got_data:

