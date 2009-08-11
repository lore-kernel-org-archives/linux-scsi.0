From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 10:53:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111048570.2562-100000@iolanthe.rowland.org>
References: <4A8118BD.6080403@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54852 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754935AbZHKOxD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 10:53:03 -0400
In-Reply-To: <4A8118BD.6080403@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Tue, 11 Aug 2009, Boaz Harrosh wrote:

> This is certainly a bug. Otherwise I would get all my pages 4 bytes short
> and wonder why.
> 
> I wish the bug would explain that stupid USB device Martin was fixing.
> "I die if evpd page=0 is read" is a very brain dead thing. But there
> is no overflow in current code, only underflow.
> 
> If you are at it could you please fix all the bugs in this code: ;-)

The USB problem shouldn't affect anything thanks to Martin's other
changes (sd won't read VPD for devices with scsi_level <= SCSI_2).  So
how does this revised patch look?

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
@@ -980,7 +980,10 @@ static int scsi_vpd_inquiry(struct scsi_
 							u8 page, unsigned len)
 {
 	int result;
-	unsigned char cmd[16];
+	int resid;
+	unsigned char cmd[6];
+
+	len += 4;		/* Include room for the header bytes */
 
 	cmd[0] = INQUIRY;
 	cmd[1] = 1;		/* EVPD */
@@ -989,17 +992,19 @@ static int scsi_vpd_inquiry(struct scsi_
 	cmd[4] = len & 0xff;
 	cmd[5] = 0;		/* Control byte */
 
+	buffer[1] = ~page;
+
 	/*
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len + 4, NULL, 30 * HZ, 3, NULL);
+				  len, NULL, 30 * HZ, 3, &resid);
 	if (result)
 		return result;
 
-	/* Sanity check that we got the page back that we asked for */
-	if (buffer[1] != page)
+	/* Sanity check that we got the header and the page we asked for */
+	if (resid > len - 4 || buffer[1] != page)
 		return -EIO;
 
 	return 0;

