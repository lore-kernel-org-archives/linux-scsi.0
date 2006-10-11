From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Reduce polling in sd.c
Date: Wed, 11 Oct 2006 16:48:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610111646090.6437-100000@iolanthe.rowland.org>
References: <1160578569.3447.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:63759 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1161263AbWJKUs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 16:48:29 -0400
In-Reply-To: <1160578569.3447.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

If a drive reports that no media is present, there's no point in
continuing to ask it about media status.  This patch (as696) cuts the
TUR polling short as soon as the drive reports no media instead of
going a full 3 iterations.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

On Wed, 11 Oct 2006, James Bottomley wrote:

> On Wed, 2006-10-11 at 10:32 -0400, Alan Stern wrote:
> > Andrew Morton says you rejected the patch below.  Any particular 
reason?
>
> I haven't said anything at all about this patch since my comments in
> June, which were basically
>
> - could we do more to reduce flag duplication
> - since the change impacts the cdrom layer we'll wait to see what the cd
> maintainers want to do.
 
Hmmm...  Well never mind that for now.  This particular patch has nothing
to do with flag duplication or the cdrom layer; it is entirely
self-contained.  I'd like to submit it on its own merits.

Alan Stern



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1051,6 +1051,14 @@
 						      &sshdr, SD_TIMEOUT,
 						      SD_MAX_RETRIES);
 
+			/*
+			 * If the drive has indicated to us that it
+			 * doesn't have any media in it, don't bother
+			 * with any more polling.
+			 */
+			if (media_not_present(sdkp, &sshdr))
+				return;
+
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
@@ -1059,14 +1067,6 @@
 			  ((driver_byte(the_result) & DRIVER_SENSE) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		/*
-		 * If the drive has indicated to us that it doesn't have
-		 * any media in it, don't bother with any of the rest of
-		 * this crap.
-		 */
-		if (media_not_present(sdkp, &sshdr))
-			return;
-
 		if ((driver_byte(the_result) & DRIVER_SENSE) == 0) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */

