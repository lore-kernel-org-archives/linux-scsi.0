From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: removable device: can't detect disk changes
Date: Mon, 18 Aug 2008 15:58:14 -0500
Message-ID: <1219093095.3261.68.camel@localhost.localdomain>
References: <20080812150814.a2fd58cd.pochini@shiny.it>
	 <20080818215257.e1d7700c.pochini@shiny.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45439 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYHRU6U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2008 16:58:20 -0400
In-Reply-To: <20080818215257.e1d7700c.pochini@shiny.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuliano Pochini <pochini@shiny.it>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-08-18 at 21:52 +0200, Giuliano Pochini wrote:
> On Tue, 12 Aug 2008 15:08:14 +0200
> Giuliano Pochini <pochini@shiny.it> wrote:
> 
> > 
> > Fujitsu magneto-optical drive, Adaptec 29160 and 
> > Linux Jay 2.6.26 #7 SMP Sun Aug 10 18:34:22 CEST 2008 ppc 7455, altivec supported PowerMac3,6 GNU/Linux
> > 
> > When I insert a disk and I mount it, scsi_test_unit_ready() is called and
> > the do-while loop gets sshdr->sense_key == UNIT_ATTENTION in the first
> > cycle and 0 in the second one. So the if below misses the UNIT_ATTENTION
> > and sdev->changed = 1 is not executed. At this point bad things can
> > happen... I'm not sure how to fix this. Any clue ?
> 
> Ok... what about this patch ?  The while() condition also checks for
> NOT_READY. For removable devices sdev->changed is set when not_ready is
> detected (not only if it occurs in the last cycle).
> If works fine here, but since I don't know the SCSI subsystem this patch
> may be wrong.

Well done! Almost ... apparently what needs to happen is what we're
currently doing in sr_test_unit_ready.  There's no need to keep checking
for NOT_READY ... that isn't a volatile condition like UNIT ATTENTION
and driver_byte(result) & DRIVER_SENSE is equivalent to
scsi_sense_valid(sshdr) in most cases.  Also, the while loop should exit
on a non-UNIT ATTENTION condition (like NOT READY).

Does this work?

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..f2b03b7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2022,22 +2022,22 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
 					  timeout, retries);
-	} while ((driver_byte(result) & DRIVER_SENSE) &&
-		 sshdr && sshdr->sense_key == UNIT_ATTENTION &&
+		if (sdev->removable && sshdr && scsi_sense_valid(sshdr) &&
+		    sshdr->sense_key == UNIT_ATTENTION)
+			sdev->changed = 1;
+	} while (sshdr && scsi_sense_valid(sshdr) &&
+		 sshdr->sense_key == UNIT_ATTENTION &&
 		 --retries);
 
 	if (!sshdr)
 		/* could not allocate sense buffer, so can't process it */
 		return result;
 
-	if ((driver_byte(result) & DRIVER_SENSE) && sdev->removable) {
-
-		if ((scsi_sense_valid(sshdr)) &&
-		    ((sshdr->sense_key == UNIT_ATTENTION) ||
-		     (sshdr->sense_key == NOT_READY))) {
-			sdev->changed = 1;
-			result = 0;
-		}
+	if (sdev->removable && scsi_sense_valid(sshdr) &&
+	    (sshdr->sense_key == UNIT_ATTENTION ||
+	     sshdr->sense_key == NOT_READY)) {
+		sdev->changed = 1;
+		result = 0;
 	}
 	if (!sshdr_external)
 		kfree(sshdr);




