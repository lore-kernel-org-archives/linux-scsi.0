From: akpm@linux-foundation.org
Subject: [patch 13/15] sd: tell the user when a disk's capacity is adjusted
Date: Wed, 04 Mar 2009 12:06:16 -0800
Message-ID: <200903042006.n24K6G9m029301@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756349AbZCDU0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 15:26:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, stern@rowland.harvard.edu, jens.axboe@oracle.com

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1188) combines the tests for decrementing a drive's reported
capacity and expands the comment.  It also adds an informational message
to the system log, informing the user when the reported value has been
changed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/sd.c~sd-tell-the-user-when-a-disks-capacity-is-adjusted drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~sd-tell-the-user-when-a-disks-capacity-is-adjusted
+++ a/drivers/scsi/sd.c
@@ -1387,18 +1387,22 @@ repeat:
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
_
