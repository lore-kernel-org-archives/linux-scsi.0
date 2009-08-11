From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 11:38:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111136350.2562-100000@iolanthe.rowland.org>
References: <1250004438.4301.36.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751976AbZHKPiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 11:38:03 -0400
In-Reply-To: <1250004438.4301.36.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 11 Aug 2009, James Bottomley wrote:

> > > This is pointless and dangerous:  Some architectures will invalidate
> > > caches for DMA not flush them, so it might not do what you think it
> > > does.
> > > 
> > 
> > Then you can't do that "after check" either. It's a simple minefield.
> > What do you suggest?
> 
> Well, nothing really, like the original code.  Byzantine checking is
> never a good idea.  You always assume that if a device told you it did
> what you told it, it actually did.  If we find devices that fail this
> simple premise, then we get into blacklists and other forms of
> nastiness.

Okay, then how about this?

Alan Stern



Index: usb-2.6/drivers/scsi/scsi.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi.c
+++ usb-2.6/drivers/scsi/scsi.c
@@ -980,7 +980,8 @@ static int scsi_vpd_inquiry(struct scsi_
 							u8 page, unsigned len)
 {
 	int result;
-	unsigned char cmd[16];
+	int resid;
+	unsigned char cmd[6];
 
 	cmd[0] = INQUIRY;
 	cmd[1] = 1;		/* EVPD */
@@ -994,12 +995,12 @@ static int scsi_vpd_inquiry(struct scsi_
 	 * all the existing users tried this hard.
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len + 4, NULL, 30 * HZ, 3, NULL);
+				  len, NULL, 30 * HZ, 3, &resid);
 	if (result)
 		return result;
 
-	/* Sanity check that we got the page back that we asked for */
-	if (buffer[1] != page)
+	/* Sanity check that we at least got the header */
+	if (resid > len - 4)
 		return -EIO;
 
 	return 0;
@@ -1027,7 +1028,7 @@ unsigned char *scsi_get_vpd_page(struct 
 		return NULL;
 
 	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
+	result = scsi_vpd_inquiry(sdev, buf, 0, 255 + 4);
 	if (result)
 		goto fail;
 
@@ -1042,7 +1043,7 @@ unsigned char *scsi_get_vpd_page(struct 
 	goto fail;
 
  found:
-	result = scsi_vpd_inquiry(sdev, buf, page, 255);
+	result = scsi_vpd_inquiry(sdev, buf, page, 255 + 4);
 	if (result)
 		goto fail;
 
@@ -1056,7 +1057,7 @@ unsigned char *scsi_get_vpd_page(struct 
 
 	kfree(buf);
 	buf = kmalloc(len + 4, GFP_KERNEL);
-	result = scsi_vpd_inquiry(sdev, buf, page, len);
+	result = scsi_vpd_inquiry(sdev, buf, page, len + 4);
 	if (result)
 		goto fail;
 

