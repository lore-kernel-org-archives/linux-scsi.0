From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Read errors on Flash Drive Transcend TS1GJF2A
Date: Mon, 26 Nov 2007 10:35:27 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711261034090.4250-100000@iolanthe.rowland.org>
References: <op.t2a0x7tige0nj0@smtp.mail.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40372 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751730AbXKZPf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2007 10:35:28 -0500
In-Reply-To: <op.t2a0x7tige0nj0@smtp.mail.yandex.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <ltuikov@yahoo.com>
Cc: RTE <raszilki@yandex.ru>, SCSI development list <linux-scsi@vger.kernel.org>

Not all devices correctly report the error-causing LBA in the
Information field of their sense data -- even when they set the Valid
bit.  This patch (as1019) makes sd much more cautious about accepting
the reported LBA.  If the value isn't within the range of blocks
accessed during the I/O operation it is rejected, and instead the
driver will try looking at the residue field (which currently it
ignores completely).

This fixes a data-corruption bug reported here:

	http://marc.info/?t=118745764700005&r=1&w=2

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Luben Tuikov <ltuikov@yahoo.com>

---

This patch should be considered for inclusion in 2.6.24.  The bug in
question has always existed, as far as I know, but before 2.6.18 it was
masked by a different bug.

This doesn't use the new SCSI accessors.  In the development trees
I've seen, those accessors haven't yet been imported into sd.c.  If
the patch needs to be rebased, please let me know where to find the
current sd source.

Presumably sr should use the same algorithm.  That's grist for another
patch.


Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -968,7 +968,17 @@ static int sd_done(struct scsi_cmnd *SCp
 		/* This computation should always be done in terms of
 		 * the resolution of the device's medium.
 		 */
-		good_bytes = (bad_lba - start_lba)*SCpnt->device->sector_size;
+		if (start_lba <= bad_lba && bad_lba < start_lba +
+				(xfer_size / SCpnt->device->sector_size))
+			good_bytes = SCpnt->device->sector_size *
+					(unsigned int) (bad_lba - start_lba);
+
+		/* If the bad_lba value is no good, maybe the residue value
+		 * is better.
+		 */
+		else if (SCpnt->resid > 0 && SCpnt->resid < xfer_size)
+			good_bytes = (xfer_size - SCpnt->resid) &
+					(- SCpnt->device->sector_size);
 		break;
 	case RECOVERED_ERROR:
 	case NO_SENSE:

