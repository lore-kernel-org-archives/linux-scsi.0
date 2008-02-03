From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Sun, 03 Feb 2008 18:28:48 +0200
Message-ID: <47A5EBC0.3060401@panasas.com>
References: <Pine.LNX.4.44L0.0802031025180.12447-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56858 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYBCQ3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 11:29:25 -0500
In-Reply-To: <Pine.LNX.4.44L0.0802031025180.12447-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Glines <mark@glines.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Feb 03 2008 at 18:01 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> Sorry, I understood only about half of what you wrote -- maybe less!
> 
> On Sun, 3 Feb 2008, Boaz Harrosh wrote:
> 
>> On Thu, Jan 31 2008 at 22:56 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
>>> I still don't understand.  Can you explain exactly what an overflow 
>>> condition (negative residue) really means?
>> As far as the protocol it is an error condition. But it is an error
>> condition that should be handled and io should continue. What it usually means
>> is that either target or Initiator had, like you said, more data then
>> expected. Usually an encoding error of the different stages of transfer
>> like sum of R2Ts or DATA is bigger then CDB length and so on.
>> The important thing is that the system should continue, and that this
>> is not a check_condition error.
> 
> What is an R2T?
> 
> How does a negative residue differ from a Phase error?
> 
> What exactly do you mean by "more data then expected"?  The USB 
> mass-storage protocol specifies the length of a transfer in at least 
> three different places, and those places won't always agree:
> 
>     (1) For some commands, the device may have a specific amount
> 	of data it can supply or expect to receive.  For example,
> 	the device might have 90 bytes of INQUIRY data available.
> 
>     (2) Many CDBs include a field specifying how much data should
> 	be transferred (INQUIRY does).  The amount of data actually
> 	transferred is supposed to be the smaller of this value
> 	and the size in (1).
> 
>     (3) The USB Bulk-only transport includes fields in the CDB
> 	wrapper specifying the number of bytes the host expects to 
> 	transfer and the direction.
> 
> If (3) is different from (2) or if the direction disagrees with what
> the device expects, the device is supposed to return a Phase error.
> If (1) < (2) = (3) then it isn't an error; in this case the residue is
> given by (2) - (1).  If (1) > (2) = (3) then according to the USB
> protocol nothing special happens -- no error and residue = 0.  
> (Note however that the INQUIRY response data includes a field in which 
> the device can tell the host that more data is available.)
> 
> In no cases does this allow for a negative residue.
> 
>>> Does it mean that the device had more data available than the host
>>> asked for?  If it does, then you don't need to change the isd200 code
>>> at all.  The changes to protocol.c will be enough.
>> I do in the sense that the target should return correct information requested.
> 
> Doesn't the existing code in isd200 together with your changes to
> protocol.c do exactly that?
> 
>> overflow is still an error.
> 
> Once again: What exactly do you mean by "overflow"?  In what sense is 
> it an error?
> 
>> A recoverable but none-standard error. The INQUIRY
>> has 3 flavors based on requested size. The target should comply.
> 
> What 3 flavors are you talking about?  As far as I know there's only 
> one type of INQUIRY command.
> 
>>> However you should realize that usb-storage, as it stands, won't work
>>> properly with negative residues.  Look at usb_stor_Bulk_transport() in
>>> transport.c.  The residue variable is declared to be unsigned int.  
>>> There's also code later on in the routine which assumes the residue is
>>> never negative.
>>>
>>> Alan Stern
>>>
>>> -
>> I will change that, but if you don't mind with a FIXME: comment next
>> to it. I will set resid to 1 and set the cmnd->status.
> 
> Where will you change this?  Why set resid to 1?  That means the device 
> sent 1 byte less than the host expected.
> 
>> Setting of command
>> status is ineffective as it is, most probably, been set afterwards.
> 
> After what?
> 
>> Should I also put a WARN_ON()? I would say yes.
>> I'll send a patch.
> 
> Maybe this will be more clear once you do.  As it is, I'm totally in 
> the dark.
> 
> Alan Stern
> 
> -
below is what I have so far. It is for v2.6.24 if it's acceptable then
I'll also send a patch for head-of-line. Please comment.

Boaz

----
>From 3610cfa93c990bbbafb296134ac01ef6d426eb8d Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 31 Jan 2008 21:31:31 +0200
Subject: [PATCH] bugfix for an overflow condition in usb storage & isd200.c

  scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
  volunteer 96 bytes of INQUIRY. This caused an overflow condition in
  protocol.c usb_stor_access_xfer_buf(). So first fix is to
  usb_stor_access_xfer_buf() to properly handle overflow/underflow conditions.
  Then usb_stor_set_xfer_buf() should report this condition as cmnd->result ==
  (DID_BAD_TARGET << 16).

  Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
  the upper layer asked for.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c   |    7 +++++--
 drivers/usb/storage/protocol.c |   20 ++++++++++++++++----
 2 files changed, 21 insertions(+), 6 deletions(-)

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
index 889622b..f141819 100644
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
@@ -248,9 +248,21 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
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
+	if (buflen > scsi_bufflen(srb)) {
+		/* FIXME: we set resid to 0, and set status. but also put a
+		 * a WARN_ON. The status will most probably not reach upper 
+		 * layer and the WARN_ON is the only indication of this glitch.
+		 */
+		WARN_ON(1);
+		srb->result = (DID_BAD_TARGET << 16);
+		count = scsi_bufflen(srb);
+	}
+
+	scsi_set_resid(srb, scsi_bufflen(srb) - count);
 }
-- 
1.5.3.3



