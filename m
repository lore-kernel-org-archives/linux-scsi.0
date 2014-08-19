From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Sym2 scsi hang on boot on sparc64
Date: Tue, 19 Aug 2014 22:30:55 +0200
Message-ID: <20140819203054.GA24325@ravnborg.org>
References: <alpine.SOC.1.00.1408191420150.4929@math.ut.ee>
 <1408451668.2645.2.camel@jarvis>
 <alpine.SOC.1.00.1408191736190.7767@math.ut.ee>
 <1408459655.3491.1.camel@jarvis>
 <20140819201748.GC4885@drone.musicnaut.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140819201748.GC4885@drone.musicnaut.iki.fi>
Sender: sparclinux-owner@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, linux-parisc@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 19, 2014 at 11:17:48PM +0300, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, Aug 19, 2014 at 09:47:35AM -0500, James Bottomley wrote:
> > On Tue, 2014-08-19 at 17:37 +0300, Meelis Roos wrote:
> > > > On Tue, 2014-08-19 at 14:25 +0300, Meelis Roos wrote:
> > > > > 3.16 scsi worked fine, 3.17-rc1 misbehaves on 3 of my sparc64 test 
> > > > > machines. E220R and E420R are with onboard 5c3875, V210 is with onboarc 
> > > > > 53c1010 and all behave the same. Any ideas whre to dig deeper? bisection 
> > > > > might be nontrivial, because of sparc64 changes that are OK on 3.17-rc1 
> > > > > again - but is possible if nothing else helps.
> > > > 
> > > > We've got a parisc with an 875 as a root SCSI bus ... I haven't got
> > > > around to building for it yet, but I might find time to try today.
> > > 
> > > Same on parisc:
> > > 
> > > sym0: <1010-66> rev 0x1 at pci 0000:20:01.0 irq 22
> > > sym0: PA-RISC Firmware, ID 7, Fast-80, LVD, parity checking
> > > sym0: SCSI BUS has been reset.
> > > scsi host0: sym-2.2.3
> > > random: nonblocking pool is initialized
> > > 
> > > and hangs here. So hopefully it is reproducible for you.
> > 
> > And also independent of the sparc changes.  The only other change in the
> > window you quote is 64 bit luns.
> 
> Bisection (on PA-RISC) points to:
> 
> 71e75c97f97a9645d25fbf3d8e4165a558f18747 is the first bad commit
> commit 71e75c97f97a9645d25fbf3d8e4165a558f18747
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Apr 11 19:07:01 2014 +0200
> 
>     scsi: convert device_busy to atomic_t

I guess you need this fix:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c44392..ce62e87 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue *q)
 	blk_requeue_request(q, req);
 	atomic_dec(&sdev->device_busy);
 out_delay:
-	if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
+	if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }


James already sent it to Linus.

	Sam
