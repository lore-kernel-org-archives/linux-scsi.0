From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Comments about the __scsi_mode_sense() routine
Date: Thu, 17 Jul 2003 15:51:25 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307171549470.1251-100000@ida.rowland.org>
References: <1058456873.2647.55.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20484 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268736AbTGQTgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 15:36:32 -0400
In-Reply-To: <1058456873.2647.55.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

James:

I'm not sure if you're interested in getting a patch, or if this patch 
does exactly the right thing.  But here it is anyway.

Alan Stern


===== scsi_lib.c 1.41 vs edited =====
--- 1.41/drivers/scsi/scsi_lib.c	Tue Jul  1 07:51:39 2003
+++ edited/drivers/scsi/scsi_lib.c	Thu Jul 17 15:48:17 2003
@@ -1356,7 +1356,8 @@
  *	__scsi_mode_sense - issue a mode sense, falling back from 10 to 
  *		six bytes if necessary.
  *	@sreq:	SCSI request to fill in with the MODE_SENSE
- *	@dbd:	set if mode sense will allow block descriptors to be returned
+ *	@dbd:	set the 0x08 bit if mode sense will not allow block
+ *		descriptors to be returned
  *	@modepage: mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
@@ -1364,9 +1365,7 @@
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
  *
- *	Returns zero if unsuccessful, or the header offset (either 4
- *	or 8 depending on whether a six or ten byte command was
- *	issued) if successful.
+ *	Returns the result code from the completed request.
  **/
 int
 __scsi_mode_sense(struct scsi_request *sreq, int dbd, int modepage,
@@ -1425,15 +1424,15 @@
 
 	if(scsi_status_is_good(sreq->sr_result)) {
 		data->header_length = header_length;
-		if(use_10_for_ms) {
-			data->length = buffer[0]*256 + buffer[1];
+		if (use_10_for_ms) {
+			data->length = buffer[0]*256 + buffer[1] + 2;
 			data->medium_type = buffer[2];
 			data->device_specific = buffer[3];
 			data->longlba = buffer[4] & 0x01;
 			data->block_descriptor_length = buffer[6]*256
 				+ buffer[7];
 		} else {
-			data->length = buffer[0];
+			data->length = buffer[0] + 1;
 			data->medium_type = buffer[1];
 			data->device_specific = buffer[3];
 			data->block_descriptor_length = buffer[4];

