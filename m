From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Mon, 12 Oct 2009 16:54:53 +0200
Message-ID: <20091012145453.GD4565@elte.hu>
References: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain> <1255031298.4187.260.camel@mulgrave.site> <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain> <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain> <20091008210737.GD29181@mit.edu> <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain> <20091009091538.GA4154@elte.hu> <1255097287.2934.21.camel@localhost.localdomain> <20091012130652.GB25464@elte.hu> <1255357148.2850.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:50686 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbZJLOzh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2009 10:55:37 -0400
Content-Disposition: inline
In-Reply-To: <1255357148.2850.91.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>


* James Bottomley <James.Bottomley@suse.de> wrote:

> > > To me, the matter of staging versus actual tree isn't a quality 
> > > issue (otherwise we'd be shifting ~75% of SCSI drivers to staging, 
> > > depending on whose view of "quality" was being used). [...]
> > 
> > I think you need to update your notion of what goes into 
> > drivers/staging/ - these days it's primarily about 
> > code/implementation quality (Greg please correct me if i'm wrong 
> > about that).
> > 
> > Driver ABIs are distinctly down the priority list.
> 
> Not for me they're not.  We worked hard to unify exposed ABIs for 
> drivers, so this is the most important user visible feature.  We can 
> clean up code in the drivers tree, that's easy.  We can't break the 
> user visible ABI of a supported driver without causing a lot of pain 
> to its user community.

I think you are interpreting what should go into drivers/staging/ _very_ 
narrowly.

Basically if you skip the drivers/staging/ step for unclean drivers you 
_remove_ an incentive of driver authors to fix up crap. If it's upstream 
already without cleanups then why bother cleaning it up fully?

Staging should be for drivers that arent clean enough for mainline as-is 
(having a messy ABI can be one of the reasons that makes a driver 
unclean), but which are still important enough and have active 
maintainers/developers who care about them.

It's basically an optimistic multi-step trust algorithm for drivers 
whose lack would otherwise be a "cannot use upstream" showstopper for a 
significant class of Linux users - but which are not yet clean enough 
for upstream inclusion. The 4 steps of:

 - out of tree
 - in Greg's staging tree
 - upstream in drivers/staging/
 - upstream in drivers/

Offer various degrees of incentives and walking that path expresses it 
both to driver authors and to kernel maintainers that all parties 
involved can be trusted to produce clean code.

Everyone wins from that:

 - users get faster hw-enablement

 - driver authors get reinforcement that their stuff is moving forward 
   (which they can communicate back to their employers)

 - maintainers get patches that they can build trust upon and the danger 
   of release-and-forget drivers is lessened.

 - even if authors orphan a driver, actual real users have the ability 
   to move things themselves.

 - [ if none of that happens then sure the driver wasnt all that 
     important to begin with and can be dropped - nobody loses. ]

I think your interpretation is arbitrary - where did you get that ABI 
rule from? I'm sure it cannot be from any of the drivers/staging/ 
discussions on lkml, i've followed them quite closely. If 'has a messy 
ABI' was the only requirement for drivers/staging/ then we could move 
90% of drivers/staging/ into drivers/ straight away - and that would be 
counter-productive IMHO.

Sidenote, in fact i think we should expand on that: drivers/staging/ 
should be used in the _other_ direction as well - to un-upstream stale 
drivers that are abandoned and unused, in a gradual fashion. 'git mv' is 
cheap.

Basically, drivers/staging/ gives us an excellent opportunity to 
_increase_ the quality of drivers by applying stronger upstream 
inclusion filters, without having to hurt users/developers in the 
process. We just have to start using it that way as well.

	Ingo
