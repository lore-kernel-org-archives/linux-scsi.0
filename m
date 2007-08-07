From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 06 Aug 2007 22:55:41 -0500
Message-ID: <1186458941.6637.44.camel@localhost.localdomain>
References: <1186248703.3439.20.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52316 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765797AbXHGDzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 23:55:44 -0400
In-Reply-To: <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2007-08-06 at 17:51 -0700, Linus Torvalds wrote:
> 
> On Sat, 4 Aug 2007, James Bottomley wrote:
> >
> > This is mainly bug fixes ... there's one or two features completions
> > that have been delayed pending ack and review to do with bsg (headers
> > and passthrough) but these are really required to complete already
> > upstream code.
> 
> James, this is the last time *ever* I apply patches from you after -rc1.
> 
> You used to have serious problems with the merge window, but for a few 
> releases you then seemed to "get it" and got on with the program.
> 
> But now it's back to "anythign goes", apparently. And I'm going to take a 
> hard-line approach with you now. 
> 
> For SCSI merges, if I don't get the first pull request in the FIRST week 
> of the merge window, don't bother sending one later, unless it's pure 
> fixes and regressions.

Confused ... you did get the first pull request in the first week.  That
was this:

                           Subject: 
[GIT PATCH] first SCSI merge for
2.6.22
                              Date: 
        Sun, 15 Jul 2007 10:24:17
-0500
190 files changed, 21725 insertions(+), 26337 deletions(-)

Then there was the last piece before the merge window closed:

                           Subject: 
[GIT PATCH] final piece of the SCSI
merge for 2.6.22
                              Date: 
        Sun, 22 Jul 2007 13:28:53
-0500
74 files changed, 3649 insertions(+), 1295 deletions(-)



> And after -rc1, I don't want to see crap like this:
> 
> 	 46 files changed, 2837 insertions(+), 2050 deletions(-)
> 
> because that simply is *not* appropriate after -rc1, much less -rc2.
> 
> So I pulled, but I wanted to make it very clear that I'm very unhappy with 
> you right now, and you're on my shit-list for the next few releases. Get 
> the changes in before -rc1, or just *wait*. If they aren't ready before 
> the merge window opens, they simply shouldn't be merged at all.

OK ... that's arguable.  This one is larger than I like because of the
lpfc bug fix patch ... I accept I need to do a better job getting these
into the merge window via the scsi-misc tree.  So I will accept the "too
big" criticism and try to manage the driver maintainers better.

However, I won't accept the "not bug fixes only" criticism at -rc1.  The
problem is that we're trying to stabilise a new feature: bsg.
Unfortunately, the closure of the merge window was really the first time
anyone got to play with all of these features together.  The non-bug fix
changes around bsg have been trying to achieve stability.  The problem
is that there were a few fairly problematic pieces: dependence on
non-modular SCSI; SG header layout and driver implementation.  What we
really don't want is to have a problematic API baked in stone because we
can't do anything other than bug fix updates once the merge window
closes.

The real root cause of all of this is that there's no tree I can
persuade all the interested parties to test that includes all of these
features.  In spite of the fact they've all been incubating in -mm for
at least 3 months, no-one apparently tested all the features together
until 2.6.23-rc1 was released, so then we're scrambling to address the
issues as they arise.

I really, *really* think we need a pre-release tree that consists of all
the upstream targetted features (i.e. all of the for the next merge
window git trees) and nothing else.  -mm doesn't really satisfy this,
because it has so much other stuff that the people I need to get testing
this don't trust it.  The lack of a tree like this that we could have
persuaded people to test for the last month is what's causing us to
scramble like this at the closure of the merge window.

James


