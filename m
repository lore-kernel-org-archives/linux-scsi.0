From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Wed, 18 Jun 2008 15:40:38 -0500
Message-ID: <1213821638.3515.81.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213540781.3517.18.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
	 <1213648258.3420.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32838 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbYFRUkm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2008 16:40:42 -0400
In-Reply-To: <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Tue, 2008-06-17 at 15:31 +0200, Geert Uytterhoeven wrote:
> On Mon, 16 Jun 2008, James Bottomley wrote:
> > On Mon, 2008-06-16 at 17:05 +0200, Geert Uytterhoeven wrote:
> > > On Sun, 15 Jun 2008, James Bottomley wrote:
> > > > On Fri, 2008-06-13 at 13:57 +0200, Geert Uytterhoeven wrote:
> > > > > We've found another regression in 2.6.25 w.r.t. CD media change on PS3.
> > > > > 
> > > > > It can easily be reproduced by:
> > > > > 
> > > > >   1. Inserting an audio CD
> > > > >   2. Running the following command as soon as the blue CD/DVD/BD drive LED
> > > > >      stops blinking and is lit continuously:
> > > > >       
> > > > > 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> > > > > 
> > > > > On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
> > > > > insertion, or it will fail.
> > > > > On 2.6.24 and older, it just works immediately.
> > > > > 
> > > > > It does not matter whether
> > > > > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
> > > > > is applied or not.
> > > > > 
> > > > > We haven't bisected it yet.
> > > > 
> > > > There aren't that many commits affecting sr between 2.6.24 and 2.6.25,
> > > > so I'd bet on the previous culprits.
> > > > 
> > > > This time, the taxonomy looks like NOT_READY isn't being waited for
> > > > properly.  I'd still tend to blame
> > > > 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 it's just that this time I
> > > 
> > > Reverting that commit doesn't fix the problem.
> > 
> > That's a bit of a problem.  Particularly as:
> > 
> > > > suspect this to be the problem line:
> > > > 
> > > > 	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
> > > > 		return CDS_DISC_OK;
> > > > 
> > > > Previously the code would have returned CDS_NO_DISC for the not ready
> > > > case.  The CD would have tried to close the door but (and this is the
> > > > key) it would have waited for the door to close before trying again.
> > > 
> > > I tried the patch below.
> > > 
> > > Now the kernel spits out messages every 2 seconds:
> > > 
> > > | G: CDS_NO_DISC
> > > | G: CDS_NO_DISC
> > > 
> > > Insert CD-DA media
> > > 
> > > Reading from CD using cdparanioa fails
> > > 
> > > | F: CDS_DISC_OK
> > > | F: CDS_DISC_OK
> > > | F: CDS_DISC_OK
> > > | F: CDS_DISC_OK
> > > | F: CDS_DISC_OK
> > 
> > That's in the two lines I fingered as the source of the problem ...
> > however, if reversing the apparently bad commit (that introduces those
> > lines) doesn't work there's something else wrong.
> > 
> > Could you try altering your F: case to return CDS_DRIVE_NOT_READY, but
> > if that doesn't work, it's going to take a bit of bisection, I'm
> > afraid ...
> 
> Doesn't make any difference.
> 
> git-bisect taught me it was introduced by
> 
> commit 38582a62ecd337de4212004c7d4844899dc57890
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Wed Feb 6 13:01:58 2008 -0600
> 
>     [SCSI] sr: fix test unit ready responses
>     
>     Commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 updated sr.c to use
>     the scsi_test_unit_ready() function.  Unfortunately, this has the
>     wrong characteristic of eating NOT_READY returns which sr.c relies on
>     for tray status.
>     
>     Fix by rolling an internal sr_test_unit_ready() that doesn't do this.

OK, that basically just replaced scsi_test_unit_ready with
sr_test_unit_ready.  The only difference I can see is that
scsi_test_unit_ready treats NOT_READY as a media change event and the
new code doesn't.  This seems slightly wrong:  NOT_READY can indeed mean
I have no medium, which is obviously what it's looking for.  However, it
can also mean there's another command in progress.  If this is some type
of write or format, you don't necessarily want the cd treating it as a
disk change.

However, before we get into serious debugging, could you try this patch
(applies over the previous fix for the capacity problem)?  I think it
should restore the old not ready == medium change behaviour.

Thanks,

James

---
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c82df8b..a9acbc8 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -179,7 +179,8 @@ int sr_test_unit_ready(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
 					      0, sshdr, SR_TIMEOUT,
 					      retries--);
 		if (scsi_sense_valid(sshdr) &&
-		    sshdr->sense_key == UNIT_ATTENTION)
+		    (sshdr->sense_key == UNIT_ATTENTION ||
+		     sshdr->sense_key == NOT_READY))
 			sdev->changed = 1;
 
 	} while (retries > 0 &&



