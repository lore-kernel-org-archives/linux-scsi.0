From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Sun, 03 Jul 2011 00:16:23 -0500
Message-ID: <1309670184.2554.28.camel@mulgrave>
References: <1309563349.19567.26.camel@dwillia2-linux>
	 <1309646729.2554.17.camel@mulgrave>  <4E0FD74F.4000701@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33689 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab1GCFQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jul 2011 01:16:29 -0400
In-Reply-To: <4E0FD74F.4000701@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "hare@suse.de" <hare@suse.de>

On Sat, 2011-07-02 at 19:43 -0700, Dan Williams wrote:
> On 07/02/2011 03:45 PM, James Bottomley wrote:
> > Look, this tree is unacceptable because
> >
> > A. It's not bisectable.  This is what happens when I try a bisection:
> [..]
> > make[1]: *** [drivers/scsi/isci/init.o] Error 1
> 
> This was inadvertent, but breakage is breakage.

That's fine for a development tree.  When you submit a series of
patches, whether directly or via a git tree, they have to be bisectable.
This isn't negotiable because any old user has to be able to perform a
bisection.

This is why most submissions tend to be patches rather than git trees.
To submit a git tree, you really have to prove that you knew the rules
when you created and ran it (like no bisectability breaks etc.)

> > And B. It's got contaminated history like this:
> 
> This was on purpose.  We were in the position of stabilizing / 
> validating the driver while carrying out the cleanups.  To minimize back 
> merges I duplicated upstream fixes/enabling in these instances.  If this 
> is de-facto unacceptable I will adjust my tree management going forward. 

Yes, it is.

>   But I don't believe it is given occasions where two maintainers take 
> the same patch through their respective trees.

These aren't the same patches applied by different maintainers; it's a
cherry pick backport which shouldn't be there.

> > I need clean history and a bisectable tree ... By Sunday, since this has
> > to be in linux-next before the next kernel release, which will likely be
> > Monday.
> 
> I certainly can rebase this to address the compile breakage.  Although 
> this does throw away old commit ids which have seen validation both 
> inside and outside of Intel, but that's unavoidable at this point.
> 
> The value I see in maintaining the history (even with some re-written 
> ids) is:
> 
> 1/ The history is available in mainline and not a side tree.  Care went 
> into the commit changelogs.  They provide driver documentation and 
> contain notes about future cleanups and improvements.
> 
> 2/ Code reviewers are credited with Reported-by tags for the commits 
> they generated.
> 
> 3/ The history is instructive of the dangers of OS abstraction drivers.

The internal intel history is completely irrelevant.  I can see value to
maintaining the commit history after publication because several
non-intel people worked on it and it's nice to credit them.

> > Since the tree is huge, I don't think this is fixable in the timescale,
> > so just a single patch will do ... I can construct that, but I need the
> > change log from you, please.
> 
> I can go either way, but my preference is a rebase to clean up the 
> bisection.

I just stopped at the first failure ... please ensure that there aren't
any more ... as in test every bisection point in the tree, don't just
squash the commit I've flagged as failing.

The fact that there is a bisection failure tends to indicate you haven't
been careful to check each commit in the tree ... which does make it
suspect and will mean every commit in the reconstituted tree needs
checking for bisectability.

James


