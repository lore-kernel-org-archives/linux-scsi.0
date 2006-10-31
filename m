From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Tue, 31 Oct 2006 16:26:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0610311623260.5679-100000@iolanthe.rowland.org>
References: <45462910.1090409@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:20235 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1946025AbWJaV1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 16:27:00 -0500
In-Reply-To: <45462910.1090409@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as810c) copies a minimum of 36 bytes of INQUIRY data,
even if the device claims that not all of them are valid.  Often badly
behaved devices put plausible data in the Vendor, Product, and Revision
strings but set the Additional Length byte to a small value.  Using
potentially valid data is certainly better than allocating a short
buffer and then reading beyond the end of it, which is what we do now.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

On Mon, 30 Oct 2006, Stefan Richter wrote:

> > +   sdev->inquiry = kmalloc(copy_len, GFP_ATOMIC);

> ...
> > +   memcpy(sdev->inquiry, inq_result, copy_len);
> ...
>    
> Can be written slightly more concise:
> 
>       sdev->inquiry = kmemdup(inq_result,
>                               max_t(size_t, sdev->inquiry_len, 36),
>                               GFP_ATOMIC);
>       if (sdev->inquiry == NULL)
>               return SCSI_SCAN_NO_RESPONSE;
>               
> This is untested. kmemdup is only available since 2.6.19-rc1.

It seems to work, so I hereby submit it.  Thanks.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -631,12 +631,22 @@ static int scsi_add_lun(struct scsi_devi
 	 * scanning run at their own risk, or supply a user level program
 	 * that can correctly scan.
 	 */
-	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_ATOMIC);
-	if (sdev->inquiry == NULL) {
+
+	/*
+	 * Copy at least 36 bytes of INQUIRY data, so that we don't
+	 * dereference unallocated memory when accessing the Vendor,
+	 * Product, and Revision strings.  Badly behaved devices may set
+	 * the INQUIRY Additional Length byte to a small value, indicating
+	 * these strings are invalid, but often they contain plausible data
+	 * nonetheless.  It doesn't matter if the device sent < 36 bytes
+	 * total, since scsi_probe_lun() initializes inq_result with 0s.
+	 */
+	sdev->inquiry = kmemdup(inq_result,
+				max_t(size_t, sdev->inquiry_len, 36),
+				GFP_ATOMIC);
+	if (sdev->inquiry == NULL)
 		return SCSI_SCAN_NO_RESPONSE;
-	}
 
-	memcpy(sdev->inquiry, inq_result, sdev->inquiry_len);
 	sdev->vendor = (char *) (sdev->inquiry + 8);
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);

