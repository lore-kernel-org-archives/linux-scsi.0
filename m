From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
Date: Wed, 30 Jul 2008 17:00:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807301656030.2322-100000@iolanthe.rowland.org>
References: <4890C5EC.70305@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51695 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754763AbYG3VAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:00:11 -0400
In-Reply-To: <4890C5EC.70305@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Matthew Frost <artusemrys@yahoo.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matt Frost <artusemrys@sbcglobal.net>

On Wed, 30 Jul 2008, Douglas Gilbert wrote:

> James Bottomley wrote:
> > On Wed, 2008-07-30 at 10:17 -0400, Alan Stern wrote:
> >> On Tue, 29 Jul 2008, Matthew Dharm wrote:
> >>
> >>> Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
> >>> just become a sysfs parameter which defaults to the 'ignore' state...
> >> We have to be careful; there definitely are devices out there which 
> >> need to use the Residue.
> > 
> > This is sort of a tradeoff ... there was one complaint I saw where a
> > device turned read only without the fix idenitifed in this report.
> > Devices broken by the fix are definitely crawling out of the woodwork
> > now.  Either this patch needs to be reverted or a new fix needs to be
> > applied soon (and to stable).
> 
> The patches to fix this that I have tried do not apply
> cleanly to lk 2.6.26 (and break during compile if forced:
> "us->fflags" is not defined).
> 
> Is there a lk 2.6.26 patch available?

Sorry about that; my patches are against the USB development tree and
I tend to forget to redo them against the vanilla kernel.  Below is a
patch against 2.6.26.  Or you can just edit the original patch and
change the occurrences of "fflags" to "flags".

Alan Stern


Index: 2.6.26/drivers/usb/storage/transport.c
===================================================================
--- 2.6.26.orig/drivers/usb/storage/transport.c
+++ 2.6.26/drivers/usb/storage/transport.c
@@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
 
 	/* try to compute the actual residue, based on how much data
 	 * was really transferred and what the device tells us */
-	if (residue) {
-		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
+	if (residue && !(us->flags & US_FL_IGNORE_RESIDUE)) {
+
+		/* Heuristically detect devices that generate bogus residues
+		 * by seeing what happens with INQUIRY and READ CAPACITY
+		 * commands.
+		 */
+		if (bcs->Status == US_BULK_STAT_OK &&
+				scsi_get_resid(srb) == 0 &&
+					((srb->cmnd[0] == INQUIRY &&
+						transfer_length == 36) ||
+					(srb->cmnd[0] == READ_CAPACITY &&
+						transfer_length == 8))) {
+			us->flags |= US_FL_IGNORE_RESIDUE;
+
+		} else {
 			residue = min(residue, transfer_length);
 			scsi_set_resid(srb, max(scsi_get_resid(srb),
 			                                       (int) residue));

