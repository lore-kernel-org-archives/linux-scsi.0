From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Mon, 04 Feb 2008 11:05:54 +0200
Message-ID: <47A6D572.5020906@panasas.com>
References: <Pine.LNX.4.44L0.0802031025180.12447-100000@netrider.rowland.org> <47A5EBC0.3060401@panasas.com> <20080203192316.GF27785@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:46339 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYBDJG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 04:06:26 -0500
In-Reply-To: <20080203192316.GF27785@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Alan Stern <stern@rowland.harvard.edu>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.k>

On Sun, Feb 03 2008 at 21:23 +0200, Matthew Dharm <mdharm-scsi@one-eyed-alien.net> wrote:
> On Sun, Feb 03, 2008 at 06:28:48PM +0200, Boaz Harrosh wrote:
>> >From 3610cfa93c990bbbafb296134ac01ef6d426eb8d Mon Sep 17 00:00:00 2001
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Thu, 31 Jan 2008 21:31:31 +0200
>> Subject: [PATCH] bugfix for an overflow condition in usb storage & isd200.c
>>
>>   scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
>>   volunteer 96 bytes of INQUIRY. This caused an overflow condition in
>>   protocol.c usb_stor_access_xfer_buf(). So first fix is to
>>   usb_stor_access_xfer_buf() to properly handle overflow/underflow conditions.
>>   Then usb_stor_set_xfer_buf() should report this condition as cmnd->result ==
>>   (DID_BAD_TARGET << 16).
>>
>>   Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
>>   the upper layer asked for.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/usb/storage/isd200.c   |    7 +++++--
>>  drivers/usb/storage/protocol.c |   20 ++++++++++++++++----
>>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> Looking at this again, I think I see Alan's point.  The modifications to
> ISD200 code aren't really needed.
> 
> Or, put another way, if you're going to modify the ISD200 code, you should
> fix up all the other users of usb_stor_access_xfer_buf() -- there are over
> a dozen or so, and it looks like none of them have sanity checks for length
> (but the happen to work right now).
> 
> But, the modifications to usb_stor_access_xfer_buf() look good -- no
> request from a sub-driver should be allowed to scribble into memory.  The
> current code does make the implicit assumption that there is enough
> storage, and will walk right off the end of the sg list if there isn't.
> 
> I'm not sure I like the mods to usb_stor_set_xfer_buf().  Any place we set
> a status that we know is going to be thrown away is an invitation for a
> problem later if someone changes the code to preserve that status.  It's a
> jack-in-the-box, waiting to spring open in our face later.  The limit check
> (which mirrors the usb_stor_access_xfer_buf modification) and WARN_ON() are
> probably good.
> 
If you want the WARN_ON() then isd200 code modification must stay, other 
wise the WARN_ON will trigger regularly.
You will find that most other places are naturally bound by other factors
and will not overflow. I think that those places that can, like INQUIRY,
should be fixed, and the WARN_ON should stay. If you don't fix them the
WARN_ON must go.

> In a strictly technical sense, the change to protocol.c are sufficient.
> That is, they will prevent a serious error.  There is a justification tho
> to fix all of the users of usb_stor_access_buf() to not attempt to use more
> SCSI buffer than exists.
> 
> My opinion is this:  Let's make the protocol.c mods (modulo my comments
> about setting useless status bits) now.  Then, let's decide if we're going
> to patch all the other users of the usb_stor_*_xfer_buf() functions as a
> separate discussion.
> 
> Matt
> 
I'm removing the set of result. I don't see any danger in it but it's your
code. But if the WARN_ON stays then so is the isd200 fixes.

Boaz

---
>From cd66d4d4a4a239e580714e926e9635f3426dd7fd Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 31 Jan 2008 21:31:31 +0200
Subject: [PATCH] bugfix for an overflow condition in usb storage & isd200.c

  scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
  volunteer 96 bytes of INQUIRY. This caused an overflow condition in
  protocol.c usb_stor_access_xfer_buf(). So first fix is to
  usb_stor_access_xfer_buf() to properly handle overflow/underflow conditions.
  Then put a WARN_ON in usb_stor_set_xfer_buf().

  isd200.c is fixed to only return the type of INQUIRY && SENSE
  the upper layer asked for.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c   |    7 +++++--
 drivers/usb/storage/protocol.c |   12 ++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

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
index 889622b..a3d1d8e 100644
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
@@ -248,9 +248,13 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
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
+	WARN_ON(buflen > scsi_bufflen(srb));
+
+	scsi_set_resid(srb, scsi_bufflen(srb) - count);
 }
-- 
1.5.3.3

