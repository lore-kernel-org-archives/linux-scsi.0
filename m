From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 12:14:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111212010.2562-100000@iolanthe.rowland.org>
References: <1250006349.4301.46.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36700 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752890AbZHKQOY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 12:14:24 -0400
In-Reply-To: <1250006349.4301.46.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 11 Aug 2009, James Bottomley wrote:

> Sort of, but it's not really doing it properly.  Lets do it like this.
> This should also fix the > 255 length problem older devices might have.

Do you mind including also the residue check?

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
+	/* Sanity check that we got the header and the page we asked for */
+	if (resid > len - 4 || buffer[1] != page)
 		return -EIO;
 
 	return 0;
@@ -1021,13 +1022,14 @@ unsigned char *scsi_get_vpd_page(struct 
 {
 	int i, result;
 	unsigned int len;
-	unsigned char *buf = kmalloc(259, GFP_KERNEL);
+	const unsigned int init_vpd_len = 255;
+	unsigned char *buf = kmalloc(init_vpd_len, GFP_KERNEL);
 
 	if (!buf)
 		return NULL;
 
 	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
+	result = scsi_vpd_inquiry(sdev, buf, 0, init_vpd_len);
 	if (result)
 		goto fail;
 
@@ -1042,7 +1044,7 @@ unsigned char *scsi_get_vpd_page(struct 
 	goto fail;
 
  found:
-	result = scsi_vpd_inquiry(sdev, buf, page, 255);
+	result = scsi_vpd_inquiry(sdev, buf, page, init_vpd_len);
 	if (result)
 		goto fail;
 
@@ -1050,12 +1052,12 @@ unsigned char *scsi_get_vpd_page(struct 
 	 * Some pages are longer than 255 bytes.  The actual length of
 	 * the page is returned in the header.
 	 */
-	len = (buf[2] << 8) | buf[3];
-	if (len <= 255)
+	len = ((buf[2] << 8) | buf[3]) + 4;
+	if (len <= init_vpd_len)
 		return buf;
 
 	kfree(buf);
-	buf = kmalloc(len + 4, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL);
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;

