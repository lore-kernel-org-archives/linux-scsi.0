From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Mon, 12 Oct 2009 10:25:48 -0500
Message-ID: <1255361148.2850.298.camel@localhost.localdomain>
References: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
	 <1255031298.4187.260.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
	 <20091008210737.GD29181@mit.edu>
	 <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
	 <20091009091538.GA4154@elte.hu>
	 <1255097287.2934.21.camel@localhost.localdomain>
	 <20091012130652.GB25464@elte.hu>
	 <1255357148.2850.91.camel@localhost.localdomain>
	 <20091012145453.GD4565@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZJLP0c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2009 11:26:32 -0400
In-Reply-To: <20091012145453.GD4565@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>

On Mon, 2009-10-12 at 16:54 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > > > To me, the matter of staging versus actual tree isn't a quality 
> > > > issue (otherwise we'd be shifting ~75% of SCSI drivers to staging, 
> > > > depending on whose view of "quality" was being used). [...]
> > > 
> > > I think you need to update your notion of what goes into 
> > > drivers/staging/ - these days it's primarily about 
> > > code/implementation quality (Greg please correct me if i'm wrong 
> > > about that).
> > > 
> > > Driver ABIs are distinctly down the priority list.
> > 
> > Not for me they're not.  We worked hard to unify exposed ABIs for 
> > drivers, so this is the most important user visible feature.  We can 
> > clean up code in the drivers tree, that's easy.  We can't break the 
> > user visible ABI of a supported driver without causing a lot of pain 
> > to its user community.
> 
> I think you are interpreting what should go into drivers/staging/ _very_ 
> narrowly.

As it is my right to do.

> Basically if you skip the drivers/staging/ step for unclean drivers you 
> _remove_ an incentive of driver authors to fix up crap. If it's upstream 
> already without cleanups then why bother cleaning it up fully?

There's cleanup and there's cleanup.  Most of the remaining problems
with the bfa driver won't be found by checkpatch and they're not obvious
to a non-storage expert ... but also these aren't major; I just want it
where I can see it to make sure forward progress is being made.

The major area of change for this driver is interfacing it to libfc ...
that's not a staging tree function.  Assuming we can make it work, this
driver will become the first non fcoe consumer of libfc. Likely both
libfc and this driver will have to change as we try this.  Again, it's
not something just anyone can do (in fact, I intend to leave it to the
experts and just referee from the sidelines).

> Staging should be for drivers that arent clean enough for mainline as-is 
> (having a messy ABI can be one of the reasons that makes a driver 
> unclean), but which are still important enough and have active 
> maintainers/developers who care about them.
> 
> It's basically an optimistic multi-step trust algorithm for drivers 
> whose lack would otherwise be a "cannot use upstream" showstopper for a 
> significant class of Linux users - but which are not yet clean enough 
> for upstream inclusion. The 4 steps of:
> 
>  - out of tree
>  - in Greg's staging tree
>  - upstream in drivers/staging/
>  - upstream in drivers/
> 
> Offer various degrees of incentives and walking that path expresses it 
> both to driver authors and to kernel maintainers that all parties 
> involved can be trusted to produce clean code.
> 
> Everyone wins from that:
> 
>  - users get faster hw-enablement
> 
>  - driver authors get reinforcement that their stuff is moving forward 
>    (which they can communicate back to their employers)
> 
>  - maintainers get patches that they can build trust upon and the danger 
>    of release-and-forget drivers is lessened.
> 
>  - even if authors orphan a driver, actual real users have the ability 
>    to move things themselves.
> 
>  - [ if none of that happens then sure the driver wasnt all that 
>      important to begin with and can be dropped - nobody loses. ]

Well, the choir appreciates the sermon.

> I think your interpretation is arbitrary - where did you get that ABI 
> rule from? I'm sure it cannot be from any of the drivers/staging/ 
> discussions on lkml, i've followed them quite closely. If 'has a messy 
> ABI' was the only requirement for drivers/staging/ then we could move 
> 90% of drivers/staging/ into drivers/ straight away - and that would be 
> counter-productive IMHO.

It's called making an external process serve my purposes.  I'm not
asking anyone else to do this.  However, having a halfway house for
incorrect ABI drivers is a useful additional function which we were
lacking before.

Putting a driver that needs expert cleanup into someone else's tree
seems counter productive to me because it's separating the community of
experts from the driver updates.  I mean, fine for whitespace stuff, and
also fine if we actually have documentation; less so if only the authors
understand the hardware and their patches need monitoring.

Having the SCSI tree update drivers/staging is an OK solution.  However,
at this stage, I don't think the bfa driver is bad enough to be tagged
with the staging taint flag.

James

> Sidenote, in fact i think we should expand on that: drivers/staging/ 
> should be used in the _other_ direction as well - to un-upstream stale 
> drivers that are abandoned and unused, in a gradual fashion. 'git mv' is 
> cheap.
> 
> Basically, drivers/staging/ gives us an excellent opportunity to 
> _increase_ the quality of drivers by applying stronger upstream 
> inclusion filters, without having to hurt users/developers in the 
> process. We just have to start using it that way as well.
> 
> 	Ingo

