From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Thu, 31 Jan 2008 19:19:57 +0200
Message-ID: <47A2033D.2050502@panasas.com>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org>	<47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47A1E6A0.8050500-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


  scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
  volunteer 96 bytes of INQUIRY. This caused an underflow condition in
  protocol.c usb_stor_access_xfer_buf(). So first fix is to
  usb_stor_access_xfer_buf() to properly handle underflow conditions.
  Then usb_stor_set_xfer_buf() should report this condition as a negative
  resid. Should we also set cmnd->status in the underflow condition?

  Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
  the upper layer asked for.

Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
---
 drivers/usb/storage/isd200.c   |    7 +++++--
 drivers/usb/storage/protocol.c |   13 +++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 0db4886..4394930 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1261,6 +1261,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	unsigned long lba;
 	unsigned long blockCount;
 	unsigned char senseData[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
+	unsigned xfer_len;
 
 	memset(ataCdb, 0, sizeof(union ata_cdb));
 
@@ -1270,8 +1271,9 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		US_DEBUGP("   ATA OUT - INQUIRY\n");
 
 		/* copy InquiryData */
+		xfer_len = min(sizeof(info->InquiryData), scsi_bufflen(srb));
 		usb_stor_set_xfer_buf((unsigned char *) &info->InquiryData,
-				sizeof(info->InquiryData), srb);
+					xfer_len, srb);
 		srb->result = SAM_STAT_GOOD;
 		sendToTransport = 0;
 		break;
@@ -1280,7 +1282,8 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		US_DEBUGP("   ATA OUT - SCSIOP_MODE_SENSE\n");
 
 		/* Initialize the return buffer */
-		usb_stor_set_xfer_buf(senseData, sizeof(senseData), srb);
+		xfer_len = min(sizeof(senseData), scsi_bufflen(srb));
+		usb_stor_set_xfer_buf(senseData, xfer_len, srb);
 
 		if (info->DeviceFlags & DF_MEDIA_STATUS_ENABLED)
 		{
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index a41ce21..6200f62 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -175,7 +175,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 		* and the starting offset within the page, and update
 		* the *offset and **sgptr values for the next loop. */
 	cnt = 0;
-	while (cnt < buflen) {
+	while (cnt < buflen && sg) {
 		struct page *page = sg_page(sg) +
 				((sg->offset + *offset) >> PAGE_SHIFT);
 		unsigned int poff =
@@ -228,9 +228,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
 {
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
+	unsigned int count;
 
-	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
+	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
-	if (buflen < scsi_bufflen(srb))
-		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
+
+	/* Check for underflow */
+	if (buflen > scsi_bufflen(srb))
+		count = buflen;
+
+	scsi_set_resid(srb, scsi_bufflen(srb) - count);
 }
-- 
1.5.3.3
