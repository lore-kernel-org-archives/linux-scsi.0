From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf] [TOPIC] scsi-queue tree past and future
Date: Fri, 06 Mar 2015 20:43:05 -0800
Message-ID: <1425703385.2154.66.camel@HansenPartnership.com>
References: <20150305133118.GA16575@lst.de>
	 <1425566888.2169.17.camel@HansenPartnership.com>
	 <1425702152.19505.106.camel@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40255 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbbCGEnH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 23:43:07 -0500
In-Reply-To: <1425702152.19505.106.camel@stgolabs.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Christoph Hellwig <hch@lst.de>, lsf@lists.linux-foundation.org, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, 2015-03-06 at 20:22 -0800, Davidlohr Bueso wrote:
> On Thu, 2015-03-05 at 06:48 -0800, James Bottomley wrote:
> > On Thu, 2015-03-05 at 14:31 +0100, Christoph Hellwig wrote:
> > > For about 8 month I've merged almost every scsi commit through the
> > > scsi-queue staging tree, and it seems to have worked out well enough.
> > > 
> > > I've been too busy for the next cycle, so 4.1 will probably have to live
> > > without it.  I'd like to get feedback on how the tree worked for contributors
> > > and driver maintainers, and brainstorm how to move forward with it, preferably
> > > some form of real team maintainance that avoids single points of failure.
> > 
> > I'd like to thank Christoph for doing this, it's been an enormous help.
> > 
> > Here's what we'll do for 4.1: I need all the current Maintainers to
> > collect the patches and reviews in their area and send them to the list
> > as a series.  We'll be adhering to the guidelines Christoph laid down
> > for inclusion:
> > 
> >  - the patch needs at least two positive reviews (non-author signoff,
> >    reviewed-by or acked-by tags).   In practice this means it had at
> >    least one and I added another one.
> >    As an exception I also take trivial and important fixes if they
> >    only have a Tested-by: instead of a second review.
> >  - the patch has no negative review on the mailing list
> >  - the patch applies cleanly
> >  - the patch compiles (drivers for architectures I can't test excluded)
> >  - for core the core branch: the patch survives a full xfstests run
> 
> This should be pretty standard in all subsystems, no?  And I know this
> has been discussed many times, but I see no reason not to also consider
> trinity -- which has a tendency of kicking you in the nuts when you
> least expect it to. At least in MM we are trying to be a bit more
> proactive about this, perhaps Sasha or Dave would disagree with me ;)
> But in general it would also help other subsystems.

Well, to clarify what's happening: I'm not running the tests, I asked
the 0 day kernel testing project to run them on all the patches in my
tree.  The 0 day project has a bunch of standard tests for all trees and
then some optional ones (like xfstests) which I asked Fengguang to turn
on in our case.

Trinity is part of the 0 day project tests, so I could ask for it to be
turned on too, but I'm not sure it would be so useful for SCSI: trinity
is a sys call fuzzing tool but the sys call exposure of SCSI is pretty
tiny.  xfstests, which exercise the filesystem data above us provide a
much wider range of testing.

James


