From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as355) Fix test for valid sense data present
Date: Tue, 3 Aug 2004 15:25:43 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408031517480.6693-100000@ida.rowland.org>
References: <1088721250.40e4916212bed@wwws.torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20228 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266807AbUHCTZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 15:25:43 -0400
In-Reply-To: <1088721250.40e4916212bed@wwws.torque.net>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, dougg@triode.net.au

James:

This patch fixes a bug in several upper-level SCSI drivers.  According to 
Douglas Gilbert, masking with 0x7f is wrong.  Note that in several other 
places we already have code that masks the first sense_buffer byte with 
0x70.

Alan Stern


On Thu, 1 Jul 2004 dougg@torque.net wrote:

> > 	The test given for valid data in the sense_buffer isn't correct.
> > 	The actual test used is ((cmd->sense_buffer[0] & 0x7f) == 0x70).
> > 	This is mentioned in a couple of places in the document.
> 
> If that comparison is in linux code then the comparison
> is wrong! The comparison that is correct is bits 4, 5 and 6
> all being set. So we don't care about bit 7 and the bottom
> two bits can be 0x0, 0x1, 0x2 or 0x3. The fact that linux
> can't handle sense buffer "descriptor" format is an issue
> that needs to be addressed soon (but is unlikely to be an
> issue for usb-storage devices for some time).



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/scsi_lib.c 1.56 vs edited =====
--- 1.56/drivers/scsi/scsi_lib.c	Mon Jun 28 07:54:28 2004
+++ edited/drivers/scsi/scsi_lib.c	Tue Aug  3 15:15:40 2004
@@ -774,7 +774,7 @@
 	 * can choose a block to remap, etc.
 	 */
 	if (driver_byte(result) != 0) {
-		if ((cmd->sense_buffer[0] & 0x7f) == 0x70) {
+		if ((cmd->sense_buffer[0] & 0x70) == 0x70) {
 			/*
 			 * If the device is in the process of becoming ready,
 			 * retry.
===== drivers/scsi/sd.c 1.68 vs edited =====
--- 1.68/drivers/scsi/sd.c	Wed Jul 21 02:09:17 2004
+++ edited/drivers/scsi/sd.c	Tue Aug  3 15:15:48 2004
@@ -723,7 +723,7 @@
 
 	/* An error occurred */
 	if (driver_byte(result) != 0 && 	/* An error occurred */
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
+	    (SCpnt->sense_buffer[0] & 0x70) == 0x70) { /* Sense current */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
 			if (!(SCpnt->sense_buffer[0] & 0x80))
===== drivers/scsi/sg.c 1.66 vs edited =====
--- 1.66/drivers/scsi/sg.c	Sun Jul 18 07:46:31 2004
+++ edited/drivers/scsi/sg.c	Tue Aug  3 15:15:57 2004
@@ -1280,7 +1280,7 @@
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
 		if (driver_byte(SRpnt->sr_result) != 0
-		    && (SRpnt->sr_sense_buffer[0] & 0x7f) == 0x70
+		    && (SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
 		    && (SRpnt->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION
 		    && sdp->device->removable) {
 			/* Detected disc change. Set the bit - this may be used if */
===== drivers/scsi/sr.c 1.72 vs edited =====
--- 1.72/drivers/scsi/sr.c	Wed Jul 21 02:09:17 2004
+++ edited/drivers/scsi/sr.c	Tue Aug  3 15:16:05 2004
@@ -241,7 +241,7 @@
 	 * memcpy's that could be avoided.
 	 */
 	if (driver_byte(result) != 0 &&		/* An error occurred */
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
+	    (SCpnt->sense_buffer[0] & 0x70) == 0x70) { /* Sense current */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:

