From: Alan Stern <stern@rowland.harvard.edu>
Subject: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 10:41:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101027160.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39187 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752145AbZHJOln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 10:41:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Martin and Matthew:

Since you guys added scsi_vpd_inquiry() and scsi_get_vpd_page() plus
sd_read_block_limits() and sd_read_block_characteristics(), I'm
directing these questions to you.

Is there some reason for not accounting for the 4 header bytes in the 
allocation length value stored in the CDB?  Or is this simply a bug?

Were you aware that SCSI-2 defines the allocation length to be a single 
byte?  cmd[3] is specified as "Reserved" in the spec.  Hence the value 
of "len" should be capped at 255 if sdev->scsi_level <= SCSI_2, right?

Why does scsi_get_vpd_page() retrieve page 0 first, rather than 
directly asking for the page in question?  Is this some sort of 
play-it-safe approach, to avoid sending devices commands they may not 
support?

Have you considered that plenty of low-budget USB mass-storage devices
don't implement VPD properly?  I've got a flash drive right here which
totally ignores the "page" byte in the INQUIRY command; it always
responds with the normal INQUIRY data.  Thus expecting the response
data always to be accurate may not be a good idea.  I'm considering
adding a "restrict_to_MS_usb" flag to the host template, to indicate
that commands shouldn't be sent unless some version of Windows uses
them when talking to USB devices -- do you think that could work?

Finally, what's your opinion on the proposed patch below?

Alan Stern



Index: usb-2.6/drivers/scsi/scsi.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi.c
+++ usb-2.6/drivers/scsi/scsi.c
@@ -969,7 +969,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
  * @sdev: The device to ask
  * @buffer: Where to put the result
  * @page: Which Vital Product Data to return
- * @len: The length of the buffer
+ * @len: The length of the data (= buffer length - 4)
  *
  * This is an internal helper function.  You probably want to use
  * scsi_get_vpd_page instead.
@@ -982,6 +982,12 @@ static int scsi_vpd_inquiry(struct scsi_
 	int result;
 	unsigned char cmd[16];
 
+	len += 4;		/* Include room for the header bytes */
+
+	/* SCSI-2 and earlier allow only 1 byte for the allocation length */
+	if (sdev->scsi_level <= SCSI_2)
+		len = min(len, 255u);
+
 	cmd[0] = INQUIRY;
 	cmd[1] = 1;		/* EVPD */
 	cmd[2] = page;
@@ -994,7 +1000,7 @@ static int scsi_vpd_inquiry(struct scsi_
 	 * all the existing users tried this hard.
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len + 4, NULL, 30 * HZ, 3, NULL);
+				  len, NULL, 30 * HZ, 3, NULL);
 	if (result)
 		return result;
 

