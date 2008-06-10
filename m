From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after
	media change and delay
Date: Tue, 10 Jun 2008 10:20:53 -0500
Message-ID: <1213111253.3440.5.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <1212765202.16182.5.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
	 <1213023916.3508.23.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091721040.22138@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46529 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbYFJPU5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 11:20:57 -0400
In-Reply-To: <Pine.LNX.4.64.0806091721040.22138@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

[resend, managed to drop linux-scsi first time around]

On Mon, 2008-06-09 at 17:27 +0200, Geert Uytterhoeven wrote:
> 	Hi James,
> 
> On Mon, 9 Jun 2008, James Bottomley wrote:
> > On Mon, 2008-06-09 at 15:54 +0200, Geert Uytterhoeven wrote:
> > > I managed to reproduce it on my laptop (Core 2 Duo, SATA DVD-RAM, running
> > > Ubuntu 8.04 for amd64), by booting Debian's 2.6.25 kernel into recovery mode.
> > > So the problem is not PS3-specific.
> > > 
> > > Worse, I never got an updated /sys/block/sr0/size for the second CD, not even
> > > when mounting it ASAP (which is ca. 15-20 seconds after inserting it).  It
> > > always stayed at the value for the first CD.
> > 
> > Well, we have the taxonomy.  It's something to do with the media change
> > trigger.  Could you try getting the output of this patch and correlate
> > the prints with your success and failure cases?
> 
> Sure!
> 
> Inserting first CD, mounting:
> 
> | +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 1
>                                 ^
> 				OK
> 
> | ISO 9660 Extensions: RRIP_1991A
> 
> Unmounting first CD:
> 
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 0
> 
> Ejecting first CD:
> 
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 0
> 
> Inserting second CD, mounting after 30 seconds:
> 
> | +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +1+ CDS_DISC_OK
> | +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
> | +11+ Return forcing update is 0
>                                 ^
> 				Not updated!
> | ISO 9660 Extensions: Microsoft Joliet Level 3
> | ISO 9660 Extensions: RRIP_1991A
> 
> => failed!

Great!  confirms the theory of the what but doesn't tell us how this is
happening.

My best guess is that it's something to do with eaten UNIT_ATTENTION
keys.  I theorise that in the successful case, they get processed in
scsi_io_completion which sets the changed bit.  In the delay case, the
unit attention is eaten by sr_test_unit_ready so the changed bit is
always kept at zero.  If this is the case, then the patch below should
fix it.  If not, we're back to more debugging ...

James

---

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..c82df8b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -178,6 +178,9 @@ int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
 		the_result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL,
 					      0, sshdr, SR_TIMEOUT,
 					      retries--);
+		if (scsi_sense_valid(sshdr) &&
+		    sshdr->sense_key == UNIT_ATTENTION)
+			sdev->changed = 1;
 
 	} while (retries > 0 &&
 		 (!scsi_status_is_good(the_result) ||


