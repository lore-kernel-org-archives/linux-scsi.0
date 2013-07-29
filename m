From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using xhci_hcd"
Date: Mon, 29 Jul 2013 11:06:22 -0400
Message-ID: <yq1ob9ljtht.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1307281505410.18237-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24161 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3G2PGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 11:06:42 -0400
In-Reply-To: <Pine.LNX.4.44L0.1307281505410.18237-100000@netrider.rowland.org>
	(Alan Stern's message of "Sun, 28 Jul 2013 15:28:52 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stuart Foster <smf.linux@ntlworld.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan,

Alan> It was introduced by commit 98dcc2946adb (SCSI: sd: Update WRITE
Alan> SAME heuristics).  This commit adds a call to scsi_get_vpd_page()
Alan> in sd_read_write_same() without first checking
Alan> sd_try_extended_inquiry().  As noted in the latter routine, VPD
Alan> inquiries will crash some devices.

Is REPORT SUPPORTED OPERATION CODES generally safe on USB devices?

The reason I didn't wrap the WRITE SAME heuristics in
sd_try_extended_inquiry() like I have done with most of the other VPDs
is that there are a ton of older SPI/SAS/FC devices that support WRITE
SAME just fine.


Alan> As far as the stable kernels are concerned, the best thing for now
Alan> may simply be to revert it.

No go. The above commit fixes issues for somebody else.

I could add an explicit check to the sd_read_write_same() function. But
how about we do the following instead?

-- 
Martin K. Petersen	Oracle Linux Engineering


SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

If a device has the skip_vpd_pages flag set we should simply fail the
scsi_get_vpd_page() call.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3b1ea34..eaa808e 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1031,6 +1031,9 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 {
 	int i, result;
 
+	if (sdev->skip_vpd_pages)
+		goto fail;
+
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result)
