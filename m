From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] sym53c8xx_2: Fix validation (Fix hotplug support).
Date: Mon, 18 Aug 2008 09:53:56 -0500
Message-ID: <1219071236.3261.23.camel@localhost.localdomain>
References: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>
	 <1219030321.3917.44.camel@localhost.localdomain> <48A95C12.9070304@nsn.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44978 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbYHROyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2008 10:54:04 -0400
In-Reply-To: <48A95C12.9070304@nsn.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Mon, 2008-08-18 at 14:25 +0300, Koskinen Aaro (NSN - FI/Helsinki)
wrote:
> James Bottomley wrote:
> > This seems to be a bug in sym_prepare_nego(), yes ... it should do
> > either a PPR or WDTR/SDTR sequence ... there is a case where it won't do
> > anything when asked.
> > 
> >> - The patch deletes code from sym_sir_task_recovery()/M_RESET branch. It's
> >> unnecessary to reset negotiation status there, since any reset eventually
> >> triggers S_CHECK_COND.
> > 
> > It looks like a reasonable safety feature against problem drives ... I'd
> > be hesitant to remove it.
> 
> To me, the code looked like it was added there to compensate the bug 
> mentioned above. Anyway, it probably does no harm to leave it there.

Sure.

> >> - It seems that the SPI "domain validation" consists solely of INQUIRY
> >> commands.
> > 
> > Actually, no.  DV uses Inquiry solely for non DT negotiations because of
> > potential echo buffer problems in certain drives but it uses the echo
> > buffer for DT verification.
> 
> Yes, you are correct.
> 
> >>  As a result, if (b) is followed, targets that support PPR would
> >> never get to the point of doing PPR transfers during domain validation
> >> (but immediately after on the next command following the dv), since each
> >> INQUIRY re-starts the negotiation cycle. This patch solves this by making
> >> it possible to do the negotiation cycle WIDE -> SYNC -> PPR during a
> >> single SCSI command.
> > 
> > I don't quite follow this.  The way SPI DV works is that we start out
> > fully async for the first INQUIRY, then move to wide async (to check no
> > bus width domain problems, which are the most common) then jump to the
> > highest speed supported by the device and transport.  i.e. we always do
> > 
> > async -> WDTR -> SDTR
> > 
> > or
> > 
> > async -> WDTR -> PPR
> > 
> > we never go
> > 
> > async -> WDTR -> SDTR -> PPR.
> > 
> > What's the actual problem you are seeing?
> 
> If you consider this patch, the WDTR message will be resent when the DV 
> jumps to the highest speed, and then, if you look at the code in 
> sym_wide_nego(), the driver will also send SDTR after the target 
> responds to WDTR since the goal offset is now set.

Actually, it only does this if the offset is non-zero (which is the
async signal).  We take care in SPI to try wide async after narrow
async, so the SDTR piece of this code is never excited.

Once we jump to the highest speed (assuming it exceeds SDTR goals), PPR
will be used exclusively.

> So what you will get 
> is WDTR -> SDTR -> PPR.
> 
> But now that I think of it, perhaps the code in sym_wide_nego() should 
> already check whether to send PPR instead of SDTR if the goals are 
> appropriate.

No ... these two are orthogonal.  Standards mandate either WDTR/STDR or
PPR negotiation.  Prudence (and a ton of drive problems) dictate you
always do WDTR/SDTR unless the goals can only be achieved via PPR.  So,
you should never be able to get into the sym_wide_nego() code unless
your goals are short of PPR (or the device sends an unsolicited WDTR).

James


