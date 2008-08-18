From: Giuliano Pochini <pochini@shiny.it>
Subject: Re: removable device: can't detect disk changes
Date: Mon, 18 Aug 2008 21:52:57 +0200
Message-ID: <20080818215257.e1d7700c.pochini@shiny.it>
References: <20080812150814.a2fd58cd.pochini@shiny.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:2833 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbYHRT6F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2008 15:58:05 -0400
In-Reply-To: <20080812150814.a2fd58cd.pochini@shiny.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, 12 Aug 2008 15:08:14 +0200
Giuliano Pochini <pochini@shiny.it> wrote:

> 
> Fujitsu magneto-optical drive, Adaptec 29160 and 
> Linux Jay 2.6.26 #7 SMP Sun Aug 10 18:34:22 CEST 2008 ppc 7455, altivec supported PowerMac3,6 GNU/Linux
> 
> When I insert a disk and I mount it, scsi_test_unit_ready() is called and
> the do-while loop gets sshdr->sense_key == UNIT_ATTENTION in the first
> cycle and 0 in the second one. So the if below misses the UNIT_ATTENTION
> and sdev->changed = 1 is not executed. At this point bad things can
> happen... I'm not sure how to fix this. Any clue ?

Ok... what about this patch ?  The while() condition also checks for
NOT_READY. For removable devices sdev->changed is set when not_ready is
detected (not only if it occurs in the last cycle).
If works fine here, but since I don't know the SCSI subsystem this patch
may be wrong.


Signed-off-by: Giuliano Pochini <pochini@shiny.it>

--- scsi_lib.c__orig	2008-08-18 21:11:45.000000000 +0200
+++ scsi_lib.c	2008-08-18 21:26:56.000000000 +0200
@@ -1961,7 +1961,7 @@ scsi_test_unit_ready(struct scsi_device 
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
 	struct scsi_sense_hdr *sshdr;
-	int result;
+	int result, not_ready;
 
 	if (!sshdr_external)
 		sshdr = kzalloc(sizeof(*sshdr), GFP_KERNEL);
@@ -1972,23 +1972,19 @@ scsi_test_unit_ready(struct scsi_device 
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
 					  timeout, retries);
-	} while ((driver_byte(result) & DRIVER_SENSE) &&
-		 sshdr && sshdr->sense_key == UNIT_ATTENTION &&
-		 --retries);
+		not_ready = (driver_byte(result) & DRIVER_SENSE) && sshdr &&
+			    ((sshdr->sense_key == UNIT_ATTENTION) ||
+			     (sshdr->sense_key == NOT_READY));
+		if (not_ready && scsi_sense_valid(sshdr) && sdev->removable)
+			sdev->changed = 1;
+	} while (not_ready && --retries);
 
 	if (!sshdr)
 		/* could not allocate sense buffer, so can't process it */
 		return result;
 
-	if ((driver_byte(result) & DRIVER_SENSE) && sdev->removable) {
-
-		if ((scsi_sense_valid(sshdr)) &&
-		    ((sshdr->sense_key == UNIT_ATTENTION) ||
-		     (sshdr->sense_key == NOT_READY))) {
-			sdev->changed = 1;
+	if (not_ready && scsi_sense_valid(sshdr) && sdev->removable)
 			result = 0;
-		}
-	}
 	if (!sshdr_external)
 		kfree(sshdr);
 	return result;


--
Giuliano.
