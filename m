From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 09:57:39 -0600
Message-ID: <20090811155739.GC31442@parisc-linux.org>
References: <1250004438.4301.36.camel@mulgrave.site> <Pine.LNX.4.44L0.0908111136350.2562-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35024 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZHKP5j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 11:57:39 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908111136350.2562-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Aug 11, 2009 at 11:38:03AM -0400, Alan Stern wrote:
> Okay, then how about this?

Crap.  Try this instead.

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2de5f3a..e39d00a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -994,7 +994,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * all the existing users tried this hard.
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len + 4, NULL, 30 * HZ, 3, NULL);
+				  len, NULL, 30 * HZ, 3, NULL);
 	if (result)
 		return result;
 
@@ -1020,14 +1020,20 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
 {
 	int i, result;
-	unsigned int len;
-	unsigned char *buf = kmalloc(259, GFP_KERNEL);
+	unsigned int len, alloc;
+	unsigned char *buf;
+
+	/* SCSI-2 only permits 255 bytes of information to be provided */
+	alloc = 259;
+	if (sdev->scsi_level <= SCSI_2)
+		alloc = 255;
 
+	buf = kmalloc(alloc, GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
 	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
+	result = scsi_vpd_inquiry(sdev, buf, 0, alloc);
 	if (result)
 		goto fail;
 
@@ -1042,7 +1048,7 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
 	goto fail;
 
  found:
-	result = scsi_vpd_inquiry(sdev, buf, page, 255);
+	result = scsi_vpd_inquiry(sdev, buf, page, alloc);
 	if (result)
 		goto fail;
 
@@ -1050,12 +1056,12 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
 	 * Some pages are longer than 255 bytes.  The actual length of
 	 * the page is returned in the header.
 	 */
-	len = (buf[2] << 8) | buf[3];
-	if (len <= 255)
+	len = ((buf[2] << 8) | buf[3]) + 4;
+	if (len <= alloc)
 		return buf;
 
 	kfree(buf);
-	buf = kmalloc(len + 4, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL);
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
