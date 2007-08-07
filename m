From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 09:25:12 -0500
Message-ID: <1186496712.3414.17.camel@localhost.localdomain>
References: <1186248703.3439.20.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	 <1186458941.6637.44.camel@localhost.localdomain>
	 <20070807001429.f8cb3b22.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46527 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753881AbXHGOZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 10:25:14 -0400
In-Reply-To: <20070807001429.f8cb3b22.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2007-08-07 at 00:14 -0700, Andrew Morton wrote:
> On Mon, 06 Aug 2007 22:55:41 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > The real root cause of all of this is that there's no tree I can
> > persuade all the interested parties to test that includes all of these
> > features.  In spite of the fact they've all been incubating in -mm for
> > at least 3 months, no-one apparently tested all the features together
> > until 2.6.23-rc1 was released, so then we're scrambling to address the
> > issues as they arise.
> 
> I pulled git-scsi-misc on July 19 and there was no bsg code in there at
> all.  I pulled again on July 20 and all the bsg code was in mainline.  So
> it appears that the bsg code went mailing-list -> mainline in less than 24
> hours, so there wasn't a lot of opportunity for -mm testing there.

The initial bsg submit went via the block git tree ... which I believe
you have in -mm.  We only started taking the updates via the scsi tree
when it became evident that they were entangling both scsi and bsg too
deeply to be split between trees.

> A lot of the stupid it-doesn't-compile stuff would have been fixed in -mm,
> but more substantial problems might not have been picked up.  But one can
> say that about anything.

Actually, it was fixed ... just in a fashion I found to be unacceptable:
making SCSI built in if bsg was selected.

> > I really, *really* think we need a pre-release tree that consists of all
> > the upstream targetted features (i.e. all of the for the next merge
> > window git trees) and nothing else.
> 
> That *is* -mm.  The vast majority of -mm is the 75-odd subsystem trees. 
> What you're suggesting amounts to omitting some of those trees for test
> purposes (I think).  If so, which ones?

The problem is that there's too much other stuff in -mm.  Whenever
anyone asks where they can get scsi-misc (which is my tree for the next
merge window) from without constructing it themselves in git, I always
say use -mm.  Unfortunately, the attrition rate after telling them this
seems to be really high.

> Now it coud be argued that subsystem maintainers should run two trees in
> the last 2.6.x-rcN phase: one tree for 2.6.x+1 and one tree for 2.6.x+2. 
> Then someone could pull all that together as the "Linus tree in a month,
> minus insufficiently baked stuff" tree.  But frankly, I don't expect that
> people will want to do that, nor will they be able to do it reliably.

A sort of pre merge window freeze point?

> Plus, an *amazing* amount of stuff turns up in the git trees which was
> committed just a few days prior to the merge window opening, or even after
> it opening.  eg, bsg which was, afaict, first committed to the scsi tree
> eleven days after the 2.6.22 release.

Yes ... particularly in large trees like SCSI, there's the maintainer
"bugger if I don't mail it out now I don't get it in for another three
months" factor.

bsg had actually been sitting in the block tree since 2.6.21, so it had
followed the delayed merge rule ... it just seems that it didn't get
enough integration testing in that six months.  This is what I consider
the real problem to be.

> >  -mm doesn't really satisfy this,
> > because it has so much other stuff that the people I need to get testing
> > this don't trust it.
> 
> Right.  75-odd developers need to stop committing bugs to their devel
> trees.  Interesting project ;)
> 
> >  The lack of a tree like this that we could have
> > persuaded people to test for the last month is what's causing us to
> > scramble like this at the closure of the merge window.
> 
> Nope.  The scramble is caused by subsystem maintainers jamming stuff into
> mainline at the last minute so they don't have to sit on it for the next
> two months.
> 
> Look.  If we're serious about this then the rule needs to be something like
> 
>   If it wasn't committed to your tree *at least* two weeks prior to the
>   2.6.x merge window opening, it shouldn't go into 2.6.x.
> 
> People are not presently observing this sort of discipline by a metric
> mile.  And I'm not sure that we should, really.

I don't disagree; my point is that bsg did follow this rule (in fact it
tried to stabilise itself outside of mainline for far longer than this
rule implies)  the problem is that it didn't get sufficient integration
testing.

> I don't think it's terribly bad to whack half-baked things (bsg ;)) into

I wouldn't call bsg half baked ... it was very carefully matured.  There
were just a few integration issues.

> mainline during the merge window, as long as a) we're sure that we want the
> feature in Linux and b) we're confident that we can get it fixed up within
> a couple of months.  Two months is a long time.
> 
> But that's just me, and it is not the approach which Linus wants taken.

I agree with this approach too ... that's what I've been doing.  It
means that feature stabilisation must finish at around -rc3.  The
relative quiet from SCSI over the last two releases was because I didn't
have any new features.

I fully agree, and firmly believe that the current stabilisation works
incredibly well for shaking out bugs.  My problem is that it doesn't
work for stabilising features.  Either we have to get far more people
doing feature integration testing before the merge window, or we have to
accept feature updates after the merge window (for existing features
that are having stability issues).

James


