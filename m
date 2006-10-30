From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Mon, 30 Oct 2006 10:20:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0610301017020.6233-100000@iolanthe.rowland.org>
References: <20061027214343.GA1701@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:29966 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1030431AbWJ3PUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 10:20:31 -0500
In-Reply-To: <20061027214343.GA1701@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as810b) copies a minimum of 36 bytes of INQUIRY data,
even if the device claims that not all of them are valid.  Often badly
behaved devices put plausible data in the Vendor, Product, and Revision
strings but set the Additional Length byte to a small value.  Using
potentially valid data is certainly better than allocating a short
buffer and then reading beyond the end of it, which is what we do now.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

On Fri, 27 Oct 2006, Patrick Mansfield wrote:

> The comment is confusing, as it implies the device will modify data past
> the indicated length, but well behaved devices should not do that, and  
> with your patch should point to zero filled data.
  
> But definitely better to use possibly valid data for broken devices or
> NUL for well behaved devices rather than garbage values.

This version of the patch has an improved comment.  And it's superior in
another respect too:  It doesn't alter the value of sdev->inquiry_len.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -621,6 +621,8 @@ static int scsi_probe_lun(struct scsi_de
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		int *bflags)
 {
+	int copy_len;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -631,12 +633,23 @@ static int scsi_add_lun(struct scsi_devi
 	 * scanning run at their own risk, or supply a user level program
 	 * that can correctly scan.
 	 */
-	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_ATOMIC);
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
+	copy_len = max((int) sdev->inquiry_len, 36);
+	sdev->inquiry = kmalloc(copy_len, GFP_ATOMIC);
 	if (sdev->inquiry == NULL) {
 		return SCSI_SCAN_NO_RESPONSE;
 	}
 
-	memcpy(sdev->inquiry, inq_result, sdev->inquiry_len);
+	memcpy(sdev->inquiry, inq_result, copy_len);
 	sdev->vendor = (char *) (sdev->inquiry + 8);
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);

