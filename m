From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix small buglets in the sr driver
Date: Thu, 29 Sep 2005 14:16:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509291402310.6137-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:16080 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932340AbVI2SQz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 14:16:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

I found some small errors in the sr driver while working on something 
else (patch for that to follow).  In this patch (as571):

	Update the s_size variable when the block length is changed.
	This seems like such an obvious mistake, I have to wonder if
	I have misunderstood the code.

	Set SCpnt->underflow to the sector size instead of the transfer
	size.  If even one sector is transferred successfully, we
	should accept it and try to move forward -- don't decide that
	the whole thing failed.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/scsi/sr.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sr.c
+++ usb-2.6/drivers/scsi/sr.c
@@ -352,9 +352,10 @@ static int sr_init_command(struct scsi_c
 	 */
 	s_size = cd->device->sector_size;
 	if (s_size > 2048) {
-		if (!in_interrupt())
+		if (!in_interrupt()) {
 			sr_set_blocklength(cd, 2048);
-		else
+			s_size = 2048;
+		} else
 			printk("sr: can't switch blocksize: in interrupt\n");
 	}
 
@@ -431,8 +432,7 @@ static int sr_init_command(struct scsi_c
 	 * host adapter, it's safe to assume that we can at least transfer
 	 * this many bytes between each connect / disconnect.
 	 */
-	SCpnt->transfersize = cd->device->sector_size;
-	SCpnt->underflow = this_count << 9;
+	SCpnt->transfersize = SCpnt->underflow = s_size;
 
 queue:
 	SCpnt->allowed = MAX_RETRIES;

