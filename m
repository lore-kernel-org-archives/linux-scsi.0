From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 03/11] hpsa: add 5 second delay after doorbell reset
Date: Fri, 8 Nov 2013 09:31:28 -0600
Message-ID: <20131108153128.GN31390@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com> <20131107164540.3504.61950.stgit@beardog.cce.hp.com> <527CEC69.6090408@redhat.com> <20131108144402.GK31390@beardog.cce.hp.com> <527CFCFC.6000500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:51797 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3KHPnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2013 10:43:04 -0500
Received: from g5t0007.atlanta.hp.com (g5t0007.atlanta.hp.com [15.192.0.44])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 6F7AD61AD0
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2013 15:32:35 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <527CFCFC.6000500@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com, scameron@beardog.cce.hp.com

On Fri, Nov 08, 2013 at 04:02:20PM +0100, Tomas Henzl wrote:
> On 11/08/2013 03:44 PM, scameron@beardog.cce.hp.com wrote:
> > On Fri, Nov 08, 2013 at 02:51:37PM +0100, Tomas Henzl wrote:
> >> On 11/07/2013 05:45 PM, Stephen M. Cameron wrote:
> >>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >>>
> >>> The hardware guys tell us that after initiating a software
> >>> reset via the doorbell register we need to wait 5 seconds before
> >>> attempting to talk to the board *at all*.  This means that we
> >>> cannot watch the board to verify it transitions from "ready" to
> >>> to "not ready" then back "ready", since this transition will
> >>> most likely happen during those 5 seconds (though we can still
> >>> verify the reset happens by watching the "driver version" field
> >>> get cleared.)
> >>>
> >>> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >>> ---
> >>>  drivers/scsi/hpsa.c |   32 +++++++++++++++++++++++---------
> >>>  1 files changed, 23 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> >>> index 20fc598..fff5fd3 100644
> >>> --- a/drivers/scsi/hpsa.c
> >>> +++ b/drivers/scsi/hpsa.c
> >>> @@ -3781,6 +3781,13 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
> >>>  		 */
> >>>  		dev_info(&pdev->dev, "using doorbell to reset controller\n");
> >>>  		writel(use_doorbell, vaddr + SA5_DOORBELL);
> >>> +
> >>> +		/* PMC hardware guys tell us we need a 5 second delay after
> >>> +		 * doorbell reset and before any attempt to talk to the board
> >>> +		 * at all to ensure that this actually works and doesn't fall
> >>> +		 * over in some weird corner cases.
> >>> +		 */
> >>> +		msleep(5000);
> >>>  	} else { /* Try to do it the PCI power state way */
> >>>  
> >>>  		/* Quoting from the Open CISS Specification: "The Power
> >>> @@ -3977,15 +3984,22 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
> >>>  	   need a little pause here */
> >>>  	msleep(HPSA_POST_RESET_PAUSE_MSECS);
> >> I know it's complicated with a lot of different devices and fw versions,
> >> but here^ we wait for 3sec - isn't the method - wait for 3s then wait for board not ready
> >> a bit fragile, what if a board comes up faster?
> >> When the method "watching the "driver version"" works why don't you want to use it  
> >> regardless of the reset method used?
> > The "watching the driver version" thing is only there to catch if
> > the firmware guys break things and turn the reset into a no-op
> > (which happened with the PCI power manaegment based reset and we
> > didn't catch it for a year or so because we didn't have that check)
> >
> > We aren't supposed to look at the driver version field (or anything)
> > until we first verify the scratch pad register says the firmware is
> > ready.  In the case of those boards that use the "doorbell" reset,
> > we aren't supposed to look at *anything* for the first five seconds.
> >
> > I have been bugging the firmware/hardware guys for a sane reset
> > procedure that actually works reliably for years with no luck.
> >
> > For the SCSI over PCIe driver, being tired of this crap, I simply
> > unconditionally reset the device on driver load every single time,
> > and did this from the beginning.  This kind of forced the firmware
> > and hardware guys to make the reset on that thing work reliably
> > and quickly, and since I did that from the earliest days, they didn't
> > have a chance to screw it up without it being caught immediately.
> > For Smart Array, obviously it's too late for that approach.
> 
> OK, my question was more or less if this:
> msleep(HPSA_POST_RESET_PAUSE_MSECS);
> just before waiting for the board to enter BOARD_NOT_READY state
> isn't dangerous - when the board enters a ready state in the first 3sec
> it will wait indefinitely for the not_ready state
> thus whether the test for not ready state shouldn't be removed.
> The mechanism now works somehow and maybe it's better
> not to touch it, I just wanted to draw your attention to that
> potential problem.

Oh ok, I see.  Thanks, yes that does look questionable.  So you
are suggesting to skip the check for transition from NOT READY to 
READY in the scratch pad register in all cases, since we have all
these ridiculous delay requirements preventing us from watching the
board closely enough and so that may mean that we would miss such a
transition.

Let me talk it over with Mike Miller, but it seems reasonable.

-- steve

> 
> 
> >
> > -- steve
> >
> >>>  
> >>> -	/* Wait for board to become not ready, then ready. */
> >>> -	dev_info(&pdev->dev, "Waiting for board to reset.\n");
> >>> -	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
> >>> -	if (rc) {
> >>> -		dev_warn(&pdev->dev,
> >>> -			"failed waiting for board to reset."
> >>> -			" Will try soft reset.\n");
> >>> -		rc = -ENOTSUPP; /* Not expected, but try soft reset later */
> >>> -		goto unmap_cfgtable;
> >>> +	if (!use_doorbell) {
> >>> +		/* Wait for board to become not ready, then ready.
> >>> +		 * (if we used the doorbell, then we already waited 5 secs
> >>> +		 * so the "not ready" state is already gone by so we
> >>> +		 * won't catch it.)
> >>> +		 */
> >>> +		dev_info(&pdev->dev, "Waiting for board to reset.\n");
> >>> +		rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
> >>> +		if (rc) {
> >>> +			dev_warn(&pdev->dev,
> >>> +				"failed waiting for board to reset."
> >>> +				" Will try soft reset.\n");
> >>> +			/* Not expected, but try soft reset later */
> >>> +			rc = -ENOTSUPP;
> >>> +			goto unmap_cfgtable;
> >>> +		}
> >>>  	}
> >>>  	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_READY);
> >>>  	if (rc) {
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
