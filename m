From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Sun, 30 Mar 2008 10:36:42 -0500
Message-ID: <1206891402.4224.35.camel@localhost.localdomain>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
	 <1206743704.3662.61.camel@localhost.localdomain>
	 <20080328154518.1a178afa.akpm@linux-foundation.org>
	 <1206886107.4224.12.camel@localhost.localdomain>
	 <20080330080748.5b40231d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48441 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbYC3Pgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 11:36:46 -0400
In-Reply-To: <20080330080748.5b40231d.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Sun, 2008-03-30 at 08:07 -0700, Andrew Morton wrote:
> On Sun, 30 Mar 2008 09:08:27 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > 
> > On Fri, 2008-03-28 at 15:45 -0700, Andrew Morton wrote:
> > > On Fri, 28 Mar 2008 17:35:04 -0500
> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > > On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > > > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > > > 
> > > > > __FUNCTION__ is gcc-specific, use __func__
> > > > 
> > > > I thought we basically agreed
> > > 
> > > No.
> > 
> > OK, so what are your reasons?  I've only heard the unpersuasive:
> > 
> > > 1) Currently there is a mix of __FUNCTION__ and __func__ in the
> > > kernel,
> > > and __func__ is ansi C (C99...)
> > > 
> > > 2) It's shorter
> > > 
> > > 3) When people look around to add new code, they will only see the one
> > > way the kernel does it.
> > > 
> > > None of which are very convincing, but there you go.
> > 
> 
> That's four reasons.

four unpersuasive reasons, yes.

> > 
> > > > there was no point to this since if it
> > > > ever became an issue you can do 
> > > > 
> > > > #define __FUNCTION__ __func__
> > > > 
> > > > inside the include/compiler-xxx.h file
> > > > 
> > > 
> > > It's better to get things right at the original code site, rather than
> > > adding crufty back-compatibility macros.
> > 
> > What do you mean "get things right"?  __FUNCTION__ isn't even deprecated
> > in gcc (the deprecation was __FUNCTION__ string concatenation) ...
> > there's no sign it will ever be wrong.  It's also stylistically far more
> > consonant with __FILE__ and __LINE__.
> 
> That's a bug.  __FILE__ and __LINE__ are preprocessor variables. 
> __FUNCTION__ is not.

So is the argument for this that using __func__ will discourage
preprocessor pasting, which is the bug?

> > > The patches are easy to prepare, easy to review and easy to merge.  There's
> > > no reason to not do so.
> > 
> > Except for the code churn in the drivers and the merge problems it
> > causes (The -mc tree already has this reverted in acpi to fix a merge
> > issue).  The greater issue is setting the bar too low for for mechanical
> > changes ... what's next?  C99 comments?  u32 -> uint32_t ... there are
> > tons of possible sweeping changes that could be justified on the above
> > grounds.
> 
> If merge problems are preventing scsi (and only scsi) from being able to
> handle trivial cleanups then _that_ is what should be fixed, rather than
> avoiding the cleanups.

No, my complaint isn't that we can't do this ... given an infinite
amount of time, everything can be done.  The problem is that time spent
on SCSI is a finite and quite precious resource ... I allocate it like
this:

     1. Bug fixes
     2. Driver Maintenance
     3. Feature Enhancments
     4. Trivial Cleanups

However, for 4. I do still require there to be some actual benefit to
the cleanup (remove a warning, eliminate dead code) etc which is what
I'm still struggling to find with the __FUNCTION__->__func__
transformation.

The other issue is that if the bar is too low for trivial changes with a
benefit, like warning silencing; we actually do it and forget it and
encourage others to behave likewise.  I need people who'll actually
think about the code, not simply apply a mechanically obvious patch to
shut gcc up.  If I can convert people who start with the obvious shut
gcc up to thinking about what the problem is and actually producing a
code fix, I'll happily place greater weight on trivial cleanups ... the
initio issue is a brilliant example of this: the warning was the tip of
the iceberg of the problems.  The initial patch would simply have made
it go away and be forgotten.  I'm hoping to actually get a real driver
fix out of it instead.

James


