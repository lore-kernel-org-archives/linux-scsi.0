From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2.6.24] bugfix for an overflow condition in usb storage &
 isd200.c
Date: Thu, 31 Jan 2008 21:37:13 +0200
Message-ID: <47A22369.80906@panasas.com>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org> <47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com> <47A2033D.2050502@panasas.com> <20080131180051.GA22341@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:42291 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbYAaTh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 14:37:56 -0500
In-Reply-To: <20080131180051.GA22341@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Mark Glines <mark@glines.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greg KH <greg@kroah.com> rote:
> As this is a regression and hits 2.6.24, can you send the final version
> of this patch to the stable@kernel.org address so we can get it into the
> 2.6.24.y tree?
> 
> thanks,
> 
> greg k-h

Mark - This is for you on top of vanila v2.6.24 kernel from Linus.

---

  scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
  volunteer 96 bytes of INQUIRY. This caused an overflow condition in
  protocol.c usb_stor_access_xfer_buf(). So first fix is to
  usb_stor_access_xfer_buf() to properly handle overflow/underflow conditions.
  Then usb_stor_set_xfer_buf() should report this condition as a negative
  resid. Should we also set cmnd->status in the overflow condition?

  Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
  the upper layer asked for.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c   |    7 +++++--
 drivers/usb/storage/protocol.c |   13 +++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 49ba6c0..8186e93 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1238,6 +1238,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	unsigned long lba;
 	unsigned long blockCount;
 	unsigned char senseData[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
+	unsigned xfer_len;
 
 	memset(ataCdb, 0, sizeof(union ata_cdb));
 
@@ -1247,8 +1248,9 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		US_DEBUGP("   ATA OUT - INQUIRY\n");
 
 		/* copy InquiryData */
+		xfer_len = min(sizeof(info->InquiryData), scsi_bufflen(srb));
 		usb_stor_set_xfer_buf((unsigned char *) &info->InquiryData,
-				sizeof(info->InquiryData), srb);
+					xfer_len, srb);
 		srb->result = SAM_STAT_GOOD;
 		sendToTransport = 0;
 		break;
@@ -1257,7 +1259,8 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		US_DEBUGP("   ATA OUT - SCSIOP_MODE_SENSE\n");
 
 		/* Initialize the return buffer */
-		usb_stor_set_xfer_buf(senseData, sizeof(senseData), srb);
+		xfer_len = min(sizeof(senseData), scsi_bufflen(srb));
+		usb_stor_set_xfer_buf(senseData, xfer_len, srb);
 
 		if (info->DeviceFlags & DF_MEDIA_STATUS_ENABLED)
 		{
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index 889622b..038a284 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -194,7 +194,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 		 * and the starting offset within the page, and update
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
-		while (cnt < buflen) {
+		while (cnt < buflen && sg) {
 			struct page *page = sg_page(sg) +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
@@ -248,9 +248,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
+	unsigned count;
 
-	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
+	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
-	if (buflen < srb->request_bufflen)
-		srb->resid = srb->request_bufflen - buflen;
+
+	/* Check for overflow */
+	if (buflen > scsi_bufflen(srb))
+		count = buflen;
+
+	scsi_set_resid(srb, scsi_bufflen(srb) - count);
 }
-- 
1.5.3.3


