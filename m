From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 03/11] hpsa: add 5 second delay after doorbell reset
Date: Mon, 2 Dec 2013 17:24:42 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D1858A7@G6W2491.americas.hpqcorp.net>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
	 <20131107164540.3504.61950.stgit@beardog.cce.hp.com>
	 <527CEC69.6090408@redhat.com> <20131108144402.GK31390@beardog.cce.hp.com>
	 <527CFCFC.6000500@redhat.com> <20131108153128.GN31390@beardog.cce.hp.com>
	 <1385858522.1815.1.camel@dabdike>
	 <20131202171557.GA12400@beardog.cce.hp.com>
 <1386004999.2018.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:37200 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3LBR0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 12:26:01 -0500
In-Reply-To: <1386004999.2018.10.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, Tomas Henzl <thenzl@redhat.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Teel, Scott Stacy" <scott.stacy.teel@hp.com>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Monday, December 02, 2013 11:23 AM
> To: Miller, Mike (OS Dev)
> Cc: scameron@beardog.cce.hp.com; Tomas Henzl;
> stephenmcameron@gmail.com; linux-scsi@vger.kernel.org; Teel, Scott Stacy
> Subject: Re: [PATCH 03/11] hpsa: add 5 second delay after doorbell reset
> 
> On Mon, 2013-12-02 at 11:15 -0600, Mike Miller wrote:
> > On Sat, Nov 30, 2013 at 04:42:02PM -0800, James Bottomley wrote:
> > > On Fri, 2013-11-08 at 09:31 -0600, scameron@beardog.cce.hp.com wrote:
> > > > On Fri, Nov 08, 2013 at 04:02:20PM +0100, Tomas Henzl wrote:
> > > > > On 11/08/2013 03:44 PM, scameron@beardog.cce.hp.com wrote:
> > > > > > On Fri, Nov 08, 2013 at 02:51:37PM +0100, Tomas Henzl wrote:
> > > > > >> On 11/07/2013 05:45 PM, Stephen M. Cameron wrote:
> > > > > >>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > > > >>>
> > > > > >>> The hardware guys tell us that after initiating a software
> > > > > >>> reset via the doorbell register we need to wait 5 seconds
> > > > > >>> before attempting to talk to the board *at all*.  This means
> > > > > >>> that we cannot watch the board to verify it transitions from
> > > > > >>> "ready" to to "not ready" then back "ready", since this
> > > > > >>> transition will most likely happen during those 5 seconds
> > > > > >>> (though we can still verify the reset happens by watching
> > > > > >>> the "driver version" field get cleared.)
> > > > > >>>
> > > > > >>> Signed-off-by: Stephen M. Cameron
> > > > > >>> <scameron@beardog.cce.hp.com>
> > > > > >>> ---
> > > > > >>>  drivers/scsi/hpsa.c |   32 +++++++++++++++++++++++---------
> > > > > >>>  1 files changed, 23 insertions(+), 9 deletions(-)
> > > > > >>>
> > > > > >>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index
> > > > > >>> 20fc598..fff5fd3 100644
> > > > > >>> --- a/drivers/scsi/hpsa.c
> > > > > >>> +++ b/drivers/scsi/hpsa.c
> > > > > >>> @@ -3781,6 +3781,13 @@ static int
> hpsa_controller_hard_reset(struct pci_dev *pdev,
> > > > > >>>  		 */
> > > > > >>>  		dev_info(&pdev->dev, "using doorbell to reset
> controller\n");
> > > > > >>>  		writel(use_doorbell, vaddr + SA5_DOORBELL);
> > > > > >>> +
> > > > > >>> +		/* PMC hardware guys tell us we need a 5 second
> delay after
> > > > > >>> +		 * doorbell reset and before any attempt to talk to
> the board
> > > > > >>> +		 * at all to ensure that this actually works and doesn't
> fall
> > > > > >>> +		 * over in some weird corner cases.
> > > > > >>> +		 */
> > > > > >>> +		msleep(5000);
> > > > > >>>  	} else { /* Try to do it the PCI power state way */
> > > > > >>>
> > > > > >>>  		/* Quoting from the Open CISS Specification: "The
> Power
> > > > > >>> @@ -3977,15 +3984,22 @@ static int
> hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
> > > > > >>>  	   need a little pause here */
> > > > > >>>  	msleep(HPSA_POST_RESET_PAUSE_MSECS);
> > > > > >> I know it's complicated with a lot of different devices and
> > > > > >> fw versions, but here^ we wait for 3sec - isn't the method -
> > > > > >> wait for 3s then wait for board not ready a bit fragile, what if a
> board comes up faster?
> > > > > >> When the method "watching the "driver version"" works why
> > > > > >> don't you want to use it regardless of the reset method used?
> > > > > > The "watching the driver version" thing is only there to catch
> > > > > > if the firmware guys break things and turn the reset into a
> > > > > > no-op (which happened with the PCI power manaegment based
> > > > > > reset and we didn't catch it for a year or so because we
> > > > > > didn't have that check)
> > > > > >
> > > > > > We aren't supposed to look at the driver version field (or
> > > > > > anything) until we first verify the scratch pad register says
> > > > > > the firmware is ready.  In the case of those boards that use
> > > > > > the "doorbell" reset, we aren't supposed to look at *anything* for
> the first five seconds.
> > > > > >
> > > > > > I have been bugging the firmware/hardware guys for a sane
> > > > > > reset procedure that actually works reliably for years with no luck.
> > > > > >
> > > > > > For the SCSI over PCIe driver, being tired of this crap, I
> > > > > > simply unconditionally reset the device on driver load every
> > > > > > single time, and did this from the beginning.  This kind of
> > > > > > forced the firmware and hardware guys to make the reset on
> > > > > > that thing work reliably and quickly, and since I did that
> > > > > > from the earliest days, they didn't have a chance to screw it up
> without it being caught immediately.
> > > > > > For Smart Array, obviously it's too late for that approach.
> > > > >
> > > > > OK, my question was more or less if this:
> > > > > msleep(HPSA_POST_RESET_PAUSE_MSECS);
> > > > > just before waiting for the board to enter BOARD_NOT_READY state
> > > > > isn't dangerous - when the board enters a ready state in the
> > > > > first 3sec it will wait indefinitely for the not_ready state
> > > > > thus whether the test for not ready state shouldn't be removed.
> > > > > The mechanism now works somehow and maybe it's better not to
> > > > > touch it, I just wanted to draw your attention to that potential
> > > > > problem.
> > > >
> > > > Oh ok, I see.  Thanks, yes that does look questionable.  So you
> > > > are suggesting to skip the check for transition from NOT READY to
> > > > READY in the scratch pad register in all cases, since we have all
> > > > these ridiculous delay requirements preventing us from watching
> > > > the board closely enough and so that may mean that we would miss
> > > > such a transition.
> > > >
> > > > Let me talk it over with Mike Miller, but it seems reasonable.
> > >
> > > Is there a resolution on this?  It's holding up the patch series.
> > >
> > > James
> > >
> > James,
> > Let's omit the check for board ready/not ready. With these arbitrary
> > delays already in place we're likely to miss the transition.
> >
> > Do you need me to resubmit the patch set?
> 
> No; you want 1-2;4-11 of the current one ... I can do that.
> 
> James
> 

Yes. Thank you.

-- mikem
> 

