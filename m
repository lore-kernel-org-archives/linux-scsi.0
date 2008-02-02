From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Sat, 02 Feb 2008 16:06:23 -0600
Message-ID: <1201989983.3187.55.camel@localhost.localdomain>
References: <47A350DF.5020404@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39904 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbYBBWG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 17:06:27 -0500
In-Reply-To: <47A350DF.5020404@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Luben Tuikov <ltuikov@yahoo.com>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>


On Fri, 2008-02-01 at 12:03 -0500, Tony Battersby wrote:
> This patch fixes a problem with some out-of-spec SCSI disks that report
> hardware or medium errors incorrectly.  Without the patch, the kernel
> may silently ignore a failed write command or return corrupted data on a
> failed read command.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> 
> This is a simplified version of the original patch that fixes just the
> problem at hand, without trying to handle other theoretical out-of-spec
> cases.

Actually, to restore the original check, this is what we want, isn't it?
Ok, so I also made the sector division logic futureproof for the day we
have > 4096 sector devices ...

James

---

>From 5ae2e4a8ff095aab5997f17068d3e4212c33f039 Mon Sep 17 00:00:00 2001
From: Tony Battersby <tonyb@cybernetics.com>
Date: Fri, 1 Feb 2008 12:03:27 -0500
Subject: [SCSI] sd: make error handling more robust

This patch fixes a problem with some out-of-spec SCSI disks that report
hardware or medium errors incorrectly.  Without the patch, the kernel
may silently ignore a failed write command or return corrupted data on a
failed read command.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Stable Tree <stable@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

Index: BUILD-2.6/drivers/scsi/sd.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sd.c	2008-02-02 15:43:20.000000000 -0600
+++ BUILD-2.6/drivers/scsi/sd.c	2008-02-02 16:01:24.000000000 -0600
@@ -929,6 +929,7 @@
 	unsigned int xfer_size = scsi_bufflen(SCpnt);
  	unsigned int good_bytes = result ? 0 : xfer_size;
  	u64 start_lba = SCpnt->request->sector;
+	u64 end_lba = SCpnt->request->sector + (xfer_size / 512);
  	u64 bad_lba;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
@@ -967,26 +968,23 @@
 			goto out;
 		if (xfer_size <= SCpnt->device->sector_size)
 			goto out;
-		switch (SCpnt->device->sector_size) {
-		case 256:
+		if (SCpnt->device->sector_size < 512) {
+			/* only legitimate sector_size here is 256 */
 			start_lba <<= 1;
-			break;
-		case 512:
-			break;
-		case 1024:
-			start_lba >>= 1;
-			break;
-		case 2048:
-			start_lba >>= 2;
-			break;
-		case 4096:
-			start_lba >>= 3;
-			break;
-		default:
-			/* Print something here with limiting frequency. */
-			goto out;
-			break;
+			end_lba <<= 1;
+		} else {
+			/* be careful ... don't want any overflows */
+			u64 factor = SCpnt->device->sector_size / 512;
+			do_div(start_lba, factor);
+			do_div(end_lba, factor);
 		}
+
+		if (bad_lba < start_lba  || bad_lba >= end_lba)
+			/* the bad lba was reported incorrectly, we have
+			 * no idea where the error is
+			 */
+			goto out;
+
 		/* This computation should always be done in terms of
 		 * the resolution of the device's medium.
 		 */



