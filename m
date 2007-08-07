From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 7 Aug 2007 00:14:29 -0700
Message-ID: <20070807001429.f8cb3b22.akpm@linux-foundation.org>
References: <1186248703.3439.20.camel@localhost.localdomain>
	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	<1186458941.6637.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbXHGHOt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 03:14:49 -0400
In-Reply-To: <1186458941.6637.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 06 Aug 2007 22:55:41 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:

> The real root cause of all of this is that there's no tree I can
> persuade all the interested parties to test that includes all of these
> features.  In spite of the fact they've all been incubating in -mm for
> at least 3 months, no-one apparently tested all the features together
> until 2.6.23-rc1 was released, so then we're scrambling to address the
> issues as they arise.

I pulled git-scsi-misc on July 19 and there was no bsg code in there at
all.  I pulled again on July 20 and all the bsg code was in mainline.  So
it appears that the bsg code went mailing-list -> mainline in less than 24
hours, so there wasn't a lot of opportunity for -mm testing there.

A lot of the stupid it-doesn't-compile stuff would have been fixed in -mm,
but more substantial problems might not have been picked up.  But one can
say that about anything.

> I really, *really* think we need a pre-release tree that consists of all
> the upstream targetted features (i.e. all of the for the next merge
> window git trees) and nothing else.

That *is* -mm.  The vast majority of -mm is the 75-odd subsystem trees. 
What you're suggesting amounts to omitting some of those trees for test
purposes (I think).  If so, which ones?

Now it coud be argued that subsystem maintainers should run two trees in
the last 2.6.x-rcN phase: one tree for 2.6.x+1 and one tree for 2.6.x+2. 
Then someone could pull all that together as the "Linus tree in a month,
minus insufficiently baked stuff" tree.  But frankly, I don't expect that
people will want to do that, nor will they be able to do it reliably.

Plus, an *amazing* amount of stuff turns up in the git trees which was
committed just a few days prior to the merge window opening, or even after
it opening.  eg, bsg which was, afaict, first committed to the scsi tree
eleven days after the 2.6.22 release.

>  -mm doesn't really satisfy this,
> because it has so much other stuff that the people I need to get testing
> this don't trust it.

Right.  75-odd developers need to stop committing bugs to their devel
trees.  Interesting project ;)

>  The lack of a tree like this that we could have
> persuaded people to test for the last month is what's causing us to
> scramble like this at the closure of the merge window.

Nope.  The scramble is caused by subsystem maintainers jamming stuff into
mainline at the last minute so they don't have to sit on it for the next
two months.

Look.  If we're serious about this then the rule needs to be something like

  If it wasn't committed to your tree *at least* two weeks prior to the
  2.6.x merge window opening, it shouldn't go into 2.6.x.

People are not presently observing this sort of discipline by a metric
mile.  And I'm not sure that we should, really.


I don't think it's terribly bad to whack half-baked things (bsg ;)) into
mainline during the merge window, as long as a) we're sure that we want the
feature in Linux and b) we're confident that we can get it fixed up within
a couple of months.  Two months is a long time.

But that's just me, and it is not the approach which Linus wants taken.

