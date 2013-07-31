From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using xhci_hcd"
Date: Tue, 30 Jul 2013 22:58:34 -0400
Message-ID: <yq1d2pzigf9.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1307301441510.893-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1307301441510.893-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 30 Jul 2013 14:44:23 -0400 (EDT)")
Sender: stable-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: Stuart Foster <smf.linux@ntlworld.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> On Mon, 29 Jul 2013, Stuart Foster wrote:
>> Hi Alan,
>> 
>> The patch is good for me.
>> 
>> thanks

Alan> There also have been positive reports from Marc Meledandri and
Alan> Philipp Dreimann.

Alan> Martin, please submit your patch for inclusion in the stable
Alan> kernels as soon as possible.

James?

[PATCH] SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

If a device has the skip_vpd_pages flag set we should simply fail the
scsi_get_vpd_page() call.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Stuart Foster <smf.linux@ntlworld.com>
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
